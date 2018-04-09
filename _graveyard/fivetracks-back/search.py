from init import es, pg_connection_string

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
    
  def boost_search(self, query="", fields = ['song', 'artist'], boost_fields = ['song'], boost_factor=2, size=None):
    ''' 
    Boosts specific fields for search relevance
    '''
    if not size:
      size = self.size
    if not boost_fields:
      boost_fields = []
    boost_list = [x+"^"+str(boost_factor) if x in boost_fields else x for x in fields]
    body= {"size": size,
            "query": {
                  "multi_match": {
                    "query": query,
                    "fields": boost_list
                  }
                }}
    results = es.search(self.index, body=body, size=size)
    return(Results(results))
    
  def artist_tracks(self, artist_id):
    query = '''
            SELECT MAX(rt.title), rt.release_id
            FROM release_track rt
            LEFT JOIN release_artist ra ON rt.release_id = ra.release_id
            LEFT JOIN artist a ON ra.artist_id = a.id
            WHERE ra.artist_id = 2390933
            GROUP BY rt.id
            '''  # currently will not work need specific 
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