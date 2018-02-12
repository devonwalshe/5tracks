from init import es, pg_connection_string
from pg import PgConn

class Search(object):
  '''
    Base class for search functions
  '''
  def __init__(self, index='5tracks', size=15):
    self.index = index
    self.size = size
  
  def multisearch(self, query="", size=None):
    '''
    Basic seach of all fields
    '''
    if not size:
      print(self.size)
      size = self.size
    body = {"query": {
                      "query_string": {
                      "query": query
                      }
                  }
            }
            
    results = es.search(self.index, body=body, size=self.size)
    return(Results(results))
    
  def boostsearch(self, query="", fields = ['song', 'artist'], boost_fields = ['song'], boost_factor=2, size=None):
    ''' 
    Boosts specific fields for search relevance
    '''
    if not size:
      size = self.size
    
    boost_list = [x+"^"+str(boost_factor) if x in boost_fields else x for x in fields]
    body= {"query": {
                  "multi_match": {
                    "query": query,
                    "fields": boost_list
                  }
                }}
    results = es.search(self.index, body=body, size=size)
    return(Results(results))
    
  def artist_tracks(self, artist_id):
    query = '''
            SELECT *
            FROM release_track rt
            LEFT JOIN release_artist ra ON rt.release_id = ra.release_id
            LEFT JOIN artist a ON ra.artist_id = a.id
            WHERE ra.artist_id = {}
            GROUP BY 
            '''  
  

  def label_artists(self, label_id):
    query = '''
            SELECT a.name artist, a.id artist_id, count(r.id) release_count
            FROM artist a
            LEFT JOIN release_artist ra ON ra.artist_id = a.id
            LEFT JOIN release_label rl ON rl.release_id = ra.release_id
            LEFT JOIN release r ON r.id = ra.release_id
            WHERE rl.label_id = {}
            GROUP BY a.id
            ORDER BY release_count DESC;
            '''.format(hit["_source"]['release_id'])
    cursor = PgConn(pg_connection_string).named_cursor('labelcursor')
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    return(results)
  
  def artist_labels(self, artist_id):
    query = '''
            SELECT * FROM 
              (SELECT l.name label_name, l.id label_id, count(r.id) release_count FROM release r
              INNER JOIN release_artist ra ON r.id = ra.release_id
              INNER JOIN release_label rl ON r.id = rl.release_id
              INNER JOIN label l ON rl.label_id = l.id
              INNER JOIN artist a ON ra.artist_id = a.id
              WHERE a.id = {}
              GROUP BY l.id) releases
            WHERE releases.release_count > 1
            ORDER BY releases.release_count desc;
            '''.format(artist_id)
    cursor = PgConn(pg_connection_string).named_cursor('labelcursor')
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    return(results)
    
  def label_artists(self, label_id):
    query = '''
            SELECT a.name artist, count(r.id) release_count
            FROM artist a
            LEFT JOIN release_artist ra ON ra.artist_id = a.id
            LEFT JOIN release_label rl ON rl.release_id = ra.release_id
            LEFT JOIN release r ON r.id = ra.release_id
            WHERE rl.label_id = {}
            GROUP BY a.id
            ORDER BY release_count DESC;
            '''.format(label_id)
    cursor = PgConn(pg_connection_string).named_cursor('labelcursor')
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    return(results)
  
  def label_tracks(self, label_id):
    query = '''
            SELECT  min(l.name) as label, rt.release_id, rt.id as track_id, string_agg(distinct a.name, ', ') release_artists, string_agg(distinct aa.name, ', ') track_artists, rt.title track_title
            FROM release_track rt
            LEFT JOIN release_label rl USING(release_id)
            LEFT JOIN label l ON rl.label_id = l.id
            LEFT JOIN release_track_artist rta ON rt.id = rta.release_track_id
            LEFT JOIN release_artist ra ON rt.release_id=ra.release_id
            LEFT JOIN artist a ON ra.artist_id = a.id 
            LEFT JOIN artist aa ON rta.artist_id = aa.id
            WHERE l.id = {}
            GROUP BY track_id;
            '''.format(label_id)
    cursor = PgConn(pg_connection_string).named_cursor('labelcursor')
    cursor.execute(query)
    results = cursor.fetchall()
    cursor.close()
    return(results)


class Results(object):
  '''
  
  '''
  def __init__(self, results = {}):
    self.results = results
  
  def stats(self):
    stats = {k:v for k,v in self.results['hits'].items() if k != ["hits"]}
    stats['took'] = self.results['took']
    return(stats)
  
  def hits(self):
    return(self.results['hits']['hits'])

  
# # Count
# es.count('discovery')
#
# # Delete
# es.delete_by_query('discovery', {"query":{"match_all": {}}})