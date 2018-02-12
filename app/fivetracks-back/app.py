from flask import Flask, request
from search import Search
app = Flask(__name__)
from flask import jsonify

#
@app.route('/search', methods=['GET'])
def search():
    s = Search()
    arguments = request.args
    (q, search_type, artist_id, label_id) = get_args(arguments)
    if search_type:
      if search_type == 'multi' and q:
        r = s.multisearch(q)
        r = r.hits()
      elif search_type == 'artist_labels' and artist_id:
        artist_id = arguments.get('artist_id')
        r = s.artist_labels(artist_id)
      elif search_type == 'label_artists' and label_id:
        r = s.label_artists(label_id)
      elif search_type == 'label_tracks' and label_id:
        r = s.label_tracks(label_id)
      else:
        return("not enough arguments")
    elif q:
      r = s.multisearch(q)
      r = r.hits()
    else:
      return('no search query or not enough params')
    
    return jsonify(r)
    

def get_args(arguments):
  q = arguments.get('q')
  search_type = arguments.get('search_type')
  artist_id = arguments.get('artist_id')
  label_id = arguments.get('label_id')

  return(q, search_type, artist_id, label_id)