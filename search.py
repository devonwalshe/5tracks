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
  
class TrackSearch(Search):
  '''
  Performs elasticsearch and DB lookups
  '''
    
  def labelmates(self, hit):
    query = '''
            SELECT * FROM artist a
            INNER JOIN release_artist ra on a.id=ra.artist_id
            INNER JOIN release_label rl on rl.release_id=ra.release_id
            INNER JOIN label l on rl.label_id=l.id
            where l.id = 
              (SELECT l.id FROM label l
               JOIN release_label rl on rl.label_id=l.id 
               JOIN release_track rt on rt.release_id=rl.release_id
               WHERE rt.id = {});
            '''.format(hit["_ource"])
    cursor = PgConn(pg_connection_string).named_cursor('labelcursor')
  

  
# # Count
# es.count('discovery')
#
# # Delete
# es.delete_by_query('discovery', {"query":{"match_all": {}}})