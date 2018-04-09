import psycopg2
import psycopg2.extras
from elasticsearch import helpers as es_helpers
from tqdm import tqdm
import os
import re
from init import es

class EsIndexer(object):
  """
  Iterates through db tables and builds and index in elasticsearch
  """
  def __init__(self, table_name, arraysize=200, itersize=200, row_limit=None, table_size=None, es_batch=3000):
    self.conn = self.connect()
    self.row_limit = row_limit
    self.arraysize=arraysize
    self.itersize=itersize
    self.table_size = table_size
    self.table_name=table_name
    self.es_batch = es_batch
    self.cursor_name = "es_index_cursor"
    self.table_query = '''
                       SELECT {} FROM {} ts 
                       WHERE NOT EXISTS
                         (SELECT * FROM indexed_tracks it WHERE ts.track_id = it.track_id)
                       '''
    self.index_query = '''
                       INSERT INTO indexed_tracks(track_id) VALUES {}
                       '''
  
  def get_table_size(self):
    cur = self.conn.cursor()
    print("Fetching remaining table size - this may take a while...")
    query = self.table_query.format("count(*)", self.table_name)
    cur.execute(query)
    self.table_size = cur.fetchone()[0]
    return(self.table_size)
   
  def connect(self):
    self.conn = psycopg2.connect("dbname=discovery user=azymuth")
    return(self.conn)
    
  def disconnect(self):
    self.conn.close()
    return(self.conn)
    
  def table_cursor(self, connection=None):
    if not connection:
      connection = self.conn
    cursor = connection.cursor(self.cursor_name, cursor_factory=psycopg2.extras.RealDictCursor)
    cursor.itersize = self.itersize
    cursor.arraysize = self.arraysize
    return(cursor)
  
  def index_cursor(self, connection=None):
    if not connection:
      connection = self.conn
    return(connection.cursor())
  
    
  def index(self):
    table_cursor = self.table_cursor()

    if self.row_limit:
      if not re.findall('limit \d', self.table_query):
        self.table_query = "{} limit {}".format(self.table_query, self.row_limit)
      self.table_size = self.row_limit
    else:
      self.get_table_size()
      
    table_cursor.execute(self.table_query.format("*", self.table_name))
    
    
    with tqdm(total=self.table_size) as pbar:
      rows = []
      while True:
        rows += table_cursor.fetchmany()
        
        if rows:
          if len(rows) >= self.es_batch:
            
            body = [{"_index":"5tracks","_type":"search_document", "_id":i['track_id'] ,"_source":i} for i in rows]
            es_helpers.bulk(es, body)
            # add list of indexed ids into db
            i_conn = self.connect()
            indexer = self.index_cursor(i_conn)
            track_ids = tuple(i['track_id'] for i in rows)
            track_vals = ",".join("({})".format(str(i))for i in track_ids)
            indexer.execute(self.index_query.format(track_vals))
            i_conn.commit()
            # Reset batch
            rows = []
            pbar.update(self.es_batch)
        else:
          print('its all over!')
          break
    
    