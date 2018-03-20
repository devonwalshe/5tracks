from orm.models import *
from orm.orm import create_session
from flask_rest_jsonapi import Api, ResourceDetail, ResourceList, ResourceRelationship
from flask_rest_jsonapi.exceptions import ObjectNotFound
from marshmallow_jsonapi.flask import Schema, Relationship
from marshmallow_jsonapi import fields

session = create_session(Base)

# Schemas
class ArtistSchema(Schema):
  class Meta:
    type_ = 'artist'
    self_view = 'artist_detail'
    self_view_kwargs = {'id': '<id>'}
    self_view_many = 'artist_list'
  
  id = fields.Integer(as_string=True, dump_only=True)
  name = fields.Str(required=True)
  realname = fields.Str()
  # aliases = Relationship(self_view='artist_aliases',
  #                        self_view_kwargs = {'id': '<id>'},
  #                        related_view='alias_list',
  #                        related_view_kwargs={'id': '<id>'},
  #                        many=True,
  #                        schema='ArtistAliasSchema',
  #                        type_='artist_alias')

class ArtistAliasSchema(Schema):
  class Meta:
    type_ = 'artist_alias'
    self_view = 'artist_alias_detail'
    self_view_kwargs = {'id': '<id>'}

  id = fields.Function(lambda obj: "{} {}".format(obj.artist_id, obj.alias_name))
  artist_id = fields.Integer(load_only=True)
  alias_name = fields.String(load_only=True)
  artist = Relationship(attribute='artist',
                        self_view='alias_artist',
                        self_view_kwargs = {'id': '<id>'},
                        related_view='artist_detail',
                        related_view_kwargs={'artist_alias_id': '<id>'},
                        schema='ArtistSchema',
                        type_='artist')

# Resource Managers
class ArtistList(ResourceList):
  schema = ArtistSchema
  data_layer = {'session': session,
                'model': Artist}

class ArtistDetail(ResourceDetail):
  # def before_get_object(self, view_kwargs):
#     if view_kwargs.get('artist_alias_id') is not None:
#       try:
#         aliases = self.session.query(ArtistAlias).filter_by(id=view_kwargs['artist_alias_id']).all()
#       except NoResultFound:
#         raise ObjectNotFound({"parameter": 'artist_alias_id'},
#                               "ArtistAlias: {} not found".format(view_kwargs['artist_alias_id']))
#     else:
#       if aliases.artist is not None:
#         view_kwargs['id'] = aliases[0].artist.id
#       else:
#         view_kwargs['id'] = None
  schema = ArtistSchema
  data_layer = {"session": session,
                "model": Artist}
  
# class ArtistsRelationship(ResourceRelationship):
#   schema = ArtistSchema
#   data_layer = {'session': session,
#                 'model': Artist} 
  
# class ArtistAliasList(ResourceList):
#   def query(self, view_kwargs):
#     query = self.session.query(ArtistAlias)
#     if view_kwargs.get('id') is not None:
#       try:
#         self.session.query(Artist).filter_by(id=view_kwargs['id']).one()
#       except:
#         raise ObjectNotFound({'paremeter':"id"}, "Artist: {} not found".format(view_kwargs['id']))
#     else:
#       query_ = query_.join(Artist).filter(Artist.id == view_kwargs['id'])
#     return query_
#
#   def before_create_object(self, data, view_kwargs):
#     if view_kwargs.get('id') is not None:
#       artist = self.session(Artist).filter_by(id=view_kwargs['id']).one()
#       data['artist_id'] = artist.id
#
#   schema = ArtistAliasSchema
#   data_layer = {'session': session,
#                 'model': ArtistAlias,
#                 'methods': {'query': query,
#                             'before_create_object': before_create_object}}
#
# class ArtistAliasDetail(ResourceDetail):
#   schema = ArtistAliasSchema
#   data_layer = {'session': session,
#                 'model': ArtistAlias}
#
# class ArtistAliasRelationship(ResourceRelationship):
#   schema = ArtistAliasSchema
#   data_layer = {'session': session,
#                 'model': ArtistAlias}
            
