from flask import Flask, request
from search import Search
from flask import jsonify
from flask_restful import reqparse
from flask_cors import CORS
from init import session
from orm.models import *
from orm.schemas import *

# App
app = Flask(__name__)
CORS(app)

api = Api(app)
api.route(ArtistList, 'artist_list', '/artists')
api.route(ArtistDetail, 'artist_detail', '/artists/<int:id>')
# api.route(ArtistAlias, 'artist_alia')

# ### ARTIST ###
# @app.route('/artist/<int:artist_id>', methods=['GET'])
# def artist(artist_id):
#   artist = Artist.query.filter(Artist.id == artist_id).first()
#   artist_dict = artist.serialize()
#   artist_dict['releases'] = [r.serialize() for r in artist.releases]
#   artist_dict['labels'] = [l.serialize() for l in artist.labels]
#   return jsonify(artist_dict)
#
#
# ### LABEL ###
# @app.route('/label/<int:label_id>', methods=['GET'])
# def label(label_id):
#   label = Label.query.filter(Label.id == label_id).first()
#   label_dict = label.serialize()
#   label_dict['releases'] = [r.serialize() for r in label.releases]
#   label_dict['artists'] = [a.serialize() for a in label.artists]
#   label_dict['parent_labels'] = [l.serialize() for l in label.parent_labels]
#   label_dict['sub_labels'] = [l.serialize() for l in label.sub_labels]
#   return jsonify(label_dict)
#
# ### Release ###
# @app.route('/release/<int:release_id>', methods=['GET'])
# def release(release_id):
#   release=Release.query.filter(Release.id==release_id).first()
#   release_dict = release.serialize()
#   release_dict['release_artists'] = [a.serialize() for a in release.all_artists]
#   release_dict['tracks'] = [t.serialize() for t in release.tracks]
#   release_dict['videos'] = [v.serialize() for v in release.videos]
#   return jsonify(release_dict)
  
@app.route('/search', methods=['GET'])
def search():
    s = Search()
    # arguments = request.args
    # (q, search_type, artist_id, label_id,
    # fields, boost_factor, boost_fields) = get_args(arguments)
    # 
    args = get_search_args()
    if not args["size"]:
      args['size'] = 10
    
    if args['search_type']:
      if args['search_type'] == 'artist_labels' and args['artist_id']:
        r = s.artist_labels(args['artist_id'])
      elif args['search_type'] == 'label_artists' and args['label_id']:
        r = s.label_artists(args['label_id'])
      elif args['search_type'] == 'label_tracks' and args['label_id']:
        r = s.label_tracks(args['label_id'])
      elif args['search_type'] == 'boost_search' and args['q']:
        r = s.boost_search(query=args['q'], fields=args['fields'], boost_fields=args['boost_fields'], boost_factor=args['boost_factor'], size=args['size'])
        r = r.hits()
      else:
        r = {'errors':"Not enough arguments"}
        return jsonify(r)
    elif args['q']:
      print(args['size'])
      r = s.multisearch(args['q'])
      r = es_to_jsonapi(r.stats())
    else:
      return('no search query or not enough params')
    
    return jsonify(r)
    

def get_search_args():
  parser = reqparse.RequestParser()
  parser.add_argument('q')
  parser.add_argument('size', type=int)
  parser.add_argument('search_type')
  parser.add_argument('artist_id', type=int)
  parser.add_argument('label_id', type=int)
  parser.add_argument('field', action='append', dest='fields')
  parser.add_argument('boost_field', action='append', dest='boost_fields')
  parser.add_argument('boost_factor', type=int)
  print(parser.parse_args())
  return(parser.parse_args())
  
def es_to_jsonapi(es_payload):
  results = {"data":[]}
  for result in es_payload['hits']:
    artist_data = []
    for artist_id in result['_source']['artist_ids']:
      artist_data.append({
        "id": artist_id,
        "type": "artist"
      })
    results["data"].append(
      {'id': result['_id'],
       'type': "search",
       'attributes': {
         "track": result['_source']['song'],
         'artist': result['_source']['artists'],
         'release': result['_source']['release'],
         'score': result['_score']
       },
       "links":{
         "self": '/tracks/{}'.format(result['_id'])
       },
       "relationships":{
         "artists": {
           "data": artist_data,
           "links": {
             "related": "/tracks/{}/artists".format(result["_id"]),
             "self": "/tracks/{}/relationships/artists".format(result["_id"])
           }
         }
       }
      }
    )
  return(results)