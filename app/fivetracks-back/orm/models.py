import datetime
from sqlalchemy import or_, Column, Integer, String, Float, Boolean, DateTime, Table, ForeignKey, UniqueConstraint, Text, ForeignKeyConstraint, func
from sqlalchemy.orm import relationship
from sqlalchemy.orm.collections import InstrumentedList
from sqlalchemy.ext.associationproxy import association_proxy
from sqlalchemy.ext.declarative import declarative_base
from sqlalchemy.ext.hybrid import hybrid_property
from sqlalchemy.inspection import inspect

# initialize DeclarativeBase for the models
Base = declarative_base()

### Serialize result
class Serializer(object):
    __public__ = None
    
    def serialize(self):
        dict = {}
        dict = {public_key: getattr(self, public_key) 
                if (not type(getattr(self, public_key)) == InstrumentedList)
                and (not issubclass(type(getattr(self, public_key)), Base)) 
                else 
                  Serializer.serialize_list(getattr(self, public_key))
                if type(getattr(self, public_key)) == InstrumentedList
                else
                  Serializer.serialize(getattr(self, public_key))
                if issubclass(type(getattr(self, public_key)), Base)
                else
                str(type(getattr(self, public_key))) for public_key in self.__public__ }
        return dict
    
    @staticmethod
    def serialize_list(l):
        return [m.serialize() for m in l]

class FiveTracksModel(object):
  def serialize(self):
    d = Serializer.serialize(self)
    return d
  
  def serialize_list(l):
    return [m.serialize() for m in l]

artist_groups = Table('group_member', Base.metadata,
                      Column("group_artist_id", Integer, ForeignKey('artist.id'), primary_key=True),
                      Column("member_artist_id", Integer, ForeignKey('artist.id'), primary_key=True)
                      )

class Artist(Base, FiveTracksModel):
  __tablename__ = 'artist'
  __public__ = ['id', 'name', 'realname']
  
  id = Column(Integer, primary_key=True)
  name = Column(String)
  realname = Column(String)
  aliases = relationship("ArtistAlias")
  name_variations = relationship("ArtistNameVariation")
  urls = relationship("ArtistUrl")
  releases = relationship("Release", secondary="release_artist")
  groups = relationship("Artist", 
                        secondary=artist_groups,
                        primaryjoin=id==artist_groups.c.member_artist_id,
                        secondaryjoin=id==artist_groups.c.group_artist_id,
                        backref='group_artists')
  
  labels = relationship("Label", 
                        primaryjoin="and_(Artist.id == remote(ReleaseArtist.artist_id), foreign(ReleaseArtist.release_id) == ReleaseLabel.release_id, foreign(Label.id)==ReleaseLabel.label_id)",
                        viewonly=True)
  
  @hybrid_property
  def tracks(self):
    return([r.tracks for r in self.releases])
  
  def __repr__(self):
      return "<Artist(id = '%s', name='%s', realname='%s')>" % \
             (self.id, self.name, self.realname)
             
class ArtistAlias(Base, FiveTracksModel):
  __tablename__ = 'artist_alias'
  __public__ = ['artist_id', 'alias_name']
  
  id = Column(Integer, primary_key=True)
  artist_id = Column(Integer, ForeignKey('artist.id'))
  alias_name = Column(String)
  artist = relationship("Artist", back_populates="aliases")
  
  # @hybrid_property
  # def id(self):
  #   return "{} {}".format(self.artist_id, self.alias_name)
  
  def __repr__(self):
      return "<ArtistAlias(name = '%s', artist_name = '%s')>" % \
             (self.alias_name, self.artist.name)
  
class ArtistNameVariation(Base, FiveTracksModel):
  __tablename__ = 'artist_namevariation'
  __public__ = ['id', 'artist_id', 'name']
  
  id = Column(Integer, primary_key=True)
  artist_id = Column(Integer, ForeignKey('artist.id'))
  name = Column(String)
  artist = relationship("Artist", back_populates="name_variations")
  def __repr__(self):
      return "<ArtistNameVariation(id = '%s', variation='%s', artist_name='%s')>" % \
             (self.id, self.name, self.artist.name)
  
  
class ArtistUrl(Base, FiveTracksModel):
  __tablename__ = 'artist_url'
  __public__ = ['id', 'artist_id', 'url']
  
  id = Column(Integer, primary_key=True)
  artist_id = Column(Integer, ForeignKey('artist.id'))
  url = Column(String)
  artist = relationship("Artist", back_populates="urls")
  def __repr__(self):
      return "<ArtistUrl(id = '%s', artist='%s', url='%s')>" % \
             (self.id, self.artist.name, self.url)
  
  

class Label(Base, FiveTracksModel):
  __tablename__ = 'label'
  __public__ = ['id', 'name', 'contact_info', 'profile', 'urls', 'release_count']
  
  id = Column(Integer, primary_key=True)
  name = Column(String, ForeignKey('label.parent_name'))
  contact_info = Column(String)
  profile = Column(Text)
  parent_id = Column(Integer)
  parent_name = Column(Integer, ForeignKey('label.name'))
  data_quality = Column(String)
  urls = relationship("LabelUrl")
  releases = relationship("Release",
                          secondary='release_label')
  artists = relationship("Artist",
                         primaryjoin='and_(Label.id == remote(ReleaseLabel.label_id), foreign(ReleaseArtist.release_id) == ReleaseLabel.release_id, foreign(Artist.id) == ReleaseArtist.artist_id, foreign(ReleaseArtist.extra)==0)',
                         viewonly=True)
  parent_labels = relationship("Label", foreign_keys=name)
  sub_labels = relationship("Label", foreign_keys=parent_name)
  # sub_labels = relationship("label", primaryjoin="Label.")

  @hybrid_property
  def tracks_json(self):
    return([rt.serialize() for sublist in [r.tracks for r in self.releases] for rt in sublist])

  @hybrid_property
  def releases_json(self):
    return([r.serialize() for r in self.releases])

  @hybrid_property
  def release_count(self):
    return(len(self.releases))
  
  def __repr__(self):
      return "<Label(id = '%s', name='%s')>" % \
             (self.id, self.name)
  
class LabelUrl(Base, FiveTracksModel):
  __tablename__ = 'label_url'
  __public__ = ['id', 'label_id', 'url']
  
  id = Column(Integer, primary_key=True)
  label_id = Column(Integer, ForeignKey('label.id'))
  url = Column(String)
  label = relationship("Label", back_populates="urls")
  
  def __repr__(self):
      return "<LabelUrl(id = '%s', url='%s')>" % \
             (self.id, self.url)
  
class Master(Base, FiveTracksModel):
  __tablename__ = 'master'
  __public__ = ['id', 'title', 'year', 'main_release', 'data_quality', 'artists', 'genres', 'styles']
  id = Column(Integer, primary_key=True)
  title = Column(String)
  year = Column(String)
  main_release = Column(Integer, ForeignKey('release.id'))
  data_quality = Column(String)
  artists = relationship("MasterArtist")
  genres = relationship("MasterGenre")
  styles = relationship("MasterStyle")
  releases = relationship("Release", foreign_keys="Release.master_id")
  release = relationship("Release", foreign_keys=main_release)
  videos = relationship("MasterVideo", foreign_keys='MasterVideo.master_id')
  
  def __repr__(self):
      return "<Master(id = '%s', year='%s', title='%s')>" % \
             (self.id, self.year, self.title)
    
class MasterArtist(Base, FiveTracksModel):
  __tablename__ = 'master_artist'
  __public__ = ['master_id', 'artist_id', 'anv', 'join_string', 'role']
  
  master_id = Column(Integer, ForeignKey('master.id'), primary_key=True)
  artist_id = Column(Integer, ForeignKey('artist.id'), primary_key=True)
  anv = Column(String)
  join_string = Column(String)
  role = Column(String)
  master = relationship("Master", back_populates='artists')
  artist = relationship("Artist", foreign_keys=artist_id)
  
  @hybrid_property
  def id(self):
    return "{} {}".format(self.master_id, self.artist_id)
  
  def __repr__(self):
      return "<MasterArtist(master = '%s', artist='%s', anv='%s', join_string='%s', role='%s')>" % \
             (self.master.title, self.artist.name, self.anv, self.join_string, self.role)
  
class MasterGenre(Base, FiveTracksModel):
  __tablename__ = 'master_genre'
  __public__ = ['master_id', 'genre']
  
  master_id = Column(Integer, ForeignKey('master.id'), primary_key=True)
  genre = Column(String, primary_key=True)
  master = relationship("Master", back_populates='genres')
  def __repr__(self):
      return "<MasterGenre(master = '%s', genre='%s')>" % \
             (self.master.title, self.genre)
  
class MasterStyle(Base, FiveTracksModel):
  __tablename__ = 'master_style'
  __public__ = ['master_id', 'style']
  
  master_id = Column(Integer, ForeignKey('master.id'), primary_key=True)
  style = Column(String, primary_key=True)
  master = relationship("Master", back_populates='styles')
  def __repr__(self):
      return "<MasterStyle(master = '%s', style='%s'>)" % \
             (self.master.title, self.style)

class MasterVideo(Base, FiveTracksModel):
  __tablename__ = 'master_video'
  __public__ = ['master_id', 'title', 'url']
  id = Column(Integer, primary_key=True)
  master_id = Column(Integer, ForeignKey('master.id'))
  duration = Column(Integer)
  title = Column(String)
  description = Column(String)
  uri = Column(String)
  master = relationship("Master", back_populates='videos')

class QueueTrack(Base, FiveTracksModel):
  __tablename__ = 'queue_tracks'
  __public__ = ['track_id', 'release_id', 'queue', 'in_library', 'total_rating', 'release', 'track']
  
  id = Column(Integer, primary_key=True)
  track_id = Column(Integer, ForeignKey('release_track.id'))
  release_id = Column(Integer, ForeignKey('release.id'))
  queue = Column(String, default="scrub")
  in_library = Column(Boolean)
  popularity_rating = Column(Float)
  underground_rating = Column(Float)
  similarity_rating = Column(Float)
  total_rating = Column(Float)
  release = relationship("Release", foreign_keys=release_id)
  track = relationship("ReleaseTrack", foreign_keys=track_id)
  
  @hybrid_property
  def artists(self):
    artists = self.track.main_artist
    if not artists:
      artists = self.release.main_artist
    return artists
  
  def __repr__(self):
      return "<QueueTrack(id = '%s', track='%s', release='%s', queue='%s', in_library='%s', total_rating='%s')>" % \
             (self.id, self.track.title, self.release.title, self.queue, self.in_library, self.total_rating)
  
  
class Release(Base, FiveTracksModel):
  __tablename__ = 'release'
  __public__ = ['id', 'title', 'released', 'country', 'notes','data_quality']
  id = Column(Integer, primary_key=True)
  title = Column(String)
  released = Column(String)
  country = Column(String)
  notes = Column(Text)
  data_quality = Column(Text)
  master_id = Column(Integer, ForeignKey('master.id'))
  master = relationship("Master", back_populates="releases", foreign_keys=master_id)
  main_artists = relationship('Artist', secondary='release_artist', primaryjoin='and_(Release.id==ReleaseArtist.release_id, ReleaseArtist.extra==0)')
  extra_artists = relationship('ReleaseArtist', primaryjoin='and_(Release.id==ReleaseArtist.release_id, ReleaseArtist.extra==1)')
  all_artists = relationship('ReleaseArtist')
  companies = relationship('ReleaseCompany')
  formats = relationship('ReleaseFormat')
  genres = relationship('ReleaseGenre')
  label = relationship('Label', secondary="release_label")
  styles = relationship('ReleaseStyle')
  tracks = relationship('ReleaseTrack')
  videos = relationship('ReleaseVideo')
  identifiers = relationship("ReleaseIdentifier")
  
  def __repr__(self):
      return "<Release(id = '%s', title='%s', released='%s', country='%s')>" % \
             (self.id, self.title, self.released, self.country)
  
class ReleaseArtist(Base, FiveTracksModel):
  __tablename__ = 'release_artist'
  __public__ = ['release_id', 'artist_id', 'extra', 'anv', 'join_string','role', 'artist']
  
  release_id = Column(Integer, ForeignKey('release.id'), primary_key=True)
  artist_id = Column(Integer, ForeignKey('artist.id'), primary_key=True)
  extra = Column(Boolean)
  anv = Column(String)
  join_string = Column(String)
  role = Column(String)
  release = relationship("Release", foreign_keys=release_id)
  artist = relationship("Artist", foreign_keys=artist_id)
  
  def __repr__(self):
      return "<ReleaseArtist(release_id = '%s', artist_id='%s', join_string = '%s', role='%s')>" % \
             (self.release_id, self.artist_id, self.join_string, self.role)
  
class ReleaseCompany(Base, FiveTracksModel):
  __tablename__ = 'release_company'
  __public__ = ['release_id', 'company_id', 'company_name', 'entity_type', 'entity_type_name']
  release_id = Column(Integer, ForeignKey('release.id'), primary_key=True)
  company_id = Column(Integer, ForeignKey('label.id'), primary_key=True)
  company_name = Column(String)
  entity_type = Column(Integer)
  entity_type_name = Column(String)
  uri = Column(String)
  release = relationship("Release", foreign_keys=release_id)
  company = relationship("Label", foreign_keys=company_id)
  def __repr__(self):
      return "<ReleaseCompany(release = '%s', company='%s', role = '%s')>" % \
             (self.release.title, self.company.name, self.entity_type_name)
  
class ReleaseFormat(Base, FiveTracksModel):
  __tablename__ = 'release_format'
  __public__ = ['release_id', 'name', 'qty', 'text_string', 'descriptions']
  release_id = Column(Integer, ForeignKey('release.id'), primary_key=True)
  name = Column(String, primary_key=True)
  qty = Column(Float)
  text_string = Column(String)
  descriptions = Column(String)
  release = relationship("Release", foreign_keys=release_id)
  def __repr__(self):
      return "<ReleaseFormat(release = '%s', format='%s', quantity='%s', description='%s')>" % \
             (self.release.title, self.name, self.qty, self.descriptions)
  
class ReleaseGenre(Base, FiveTracksModel):
  __tablename__ = 'release_genre'
  __public__ = ['release_id', 'genre']
  release_id = Column(Integer, ForeignKey('release.id'), primary_key=True)
  genre = Column(String, primary_key=True)
  release = relationship("Release", foreign_keys=release_id)
  def __repr__(self):
      return "<ReleaseGenre(release = '%s', genre='%s')>" % \
             (self.release.title, self.genre)
  
  
class ReleaseIdentifier(Base, FiveTracksModel):
  __tablename__ = 'release_identifier'
  __public__ = ['release_id', 'description', 'type', 'value']
  release_id = Column(Integer, ForeignKey('release.id'), primary_key=True)
  description = Column(String, primary_key=True)
  type = Column(String)
  value = Column(String)
  release = relationship("Release", foreign_keys=release_id)
  def __repr__(self):
      return "<ReleaseIdentifier(release = '%s', description='%s', type='%s', value='%s')>" % \
             (self.release.title, self.description, self.type, self.value)
  
class ReleaseLabel(Base, FiveTracksModel):
  __tablename__ = 'release_label'
  __public__ = ['release_id', 'label_id', 'catno']
  
  release_id = Column(Integer, ForeignKey('release.id'), primary_key=True)
  label_id = Column(Integer, ForeignKey('label.id'), primary_key=True)
  label_name = Column(String)
  catno = Column(String)
  release = relationship("Release", foreign_keys=release_id)
  label = relationship("Label", foreign_keys=label_id)
  def __repr__(self):
      return "<ReleaseLabel(release = '%s', label='%s', catno='%s')>" % \
             (self.release.title, self.label.name, self.catno)
  
class ReleaseStyle(Base, FiveTracksModel):
  __tablename__ = 'release_style'
  __public__ = ['release_id', 'style']
  release_id = Column(Integer, ForeignKey('release.id'), primary_key=True)
  style = Column(String, primary_key=True)
  release = relationship("Release", foreign_keys=release_id)
  
  def __repr__(self):
      return "<ReleaseStyle(release = '%s', style='%s')>" % \
             (self.release.title, self.style)
  
class ReleaseTrack(Base, FiveTracksModel):
  __tablename__ = 'release_track'
  __public__ = ['id', 'release_id', 'sequence', 'position', 'parent', 'title', 'duration']
  
  id = Column(Integer, primary_key=True)
  release_id = Column(Integer, ForeignKey('release.id'))
  sequence = Column(Integer)
  position = Column(String)
  parent = Column(Integer)
  title = Column(String)
  duration = Column(String)
  release = relationship('Release', back_populates='tracks')
  all_artists = relationship('Artist',
                          secondary="release_track_artist")
  main_artists = relationship('Artist', 
                              secondary='release_track_artist',
                              primaryjoin='and_(ReleaseTrack.release_id == ReleaseTrackArtist.release_id, ReleaseTrack.sequence==ReleaseTrackArtist.track_sequence, ReleaseTrackArtist.extra==False)')
  extra_artists = relationship('ReleaseTrackArtist', 
                                primaryjoin='and_(ReleaseTrack.release_id == ReleaseTrackArtist.release_id, ReleaseTrack.sequence==ReleaseTrackArtist.track_sequence, ReleaseTrackArtist.extra==True)')
  
  def __repr__(self):
      return "<ReleaseTrack(id = '%s', release = '%s', track='%s', release_id='%s', sequence = '%s', )>" % \
             (self.id, self.release.title, self.title, self.release_id, self.sequence)                        

  
class ReleaseTrackArtist(Base, FiveTracksModel):
  __tablename__ = 'release_track_artist'
  __public__ = ['release_id', 'track_sequence', 'artist_id', 'extra', 'anv', 'join_string', 'role']
  
  release_id = Column(Integer, ForeignKey('release.id'), primary_key=True)
  track_sequence = Column(Integer, primary_key=True)
  artist_id = Column(Integer, ForeignKey('artist.id'))
  extra = Column(Boolean)
  anv = Column(String)
  join_string = Column(String)
  role = Column(String)
  release = relationship("Release", foreign_keys=release_id)
  artist = relationship("Artist", foreign_keys=artist_id)
  __table_args__ = (ForeignKeyConstraint([release_id, track_sequence],
                                             [ReleaseTrack.release_id, ReleaseTrack.sequence]),
                        {})
  
  def __repr__(self):
      return "<ReleaseTrackArtist(release = '%s', track_sequence='%s', extra='%s', join_string='%s', role='%s')>" % \
             (self.release.title, self.artist.name, self.track_sequence, self.extra, self.join_string, self.role)
             
class ReleaseVideo(Base, FiveTracksModel):
  __tablename__ = 'release_video'
  __public__ = ['release_id', 'duration', 'title', 'description', 'uri']
  
  release_id = Column(Integer, ForeignKey('release.id'), primary_key=True)
  duration = Column(Integer)
  title = Column(String)
  description = Column(String)
  uri = Column(String, primary_key=True)
  release = relationship("Release", foreign_keys=release_id)
  def __repr__(self):
      return "<ReleaseLabel(release = '%s', uro='%s')>" % \
             (self.release.title, self.uri)


### Get or create object
def get_or_create(session, model, **kwargs):
    instance = session.query(model).filter_by(**kwargs).first()
    if instance:
        return instance
    else:
        instance = model(**kwargs)
        session.add(instance)
        session.commit()
        return instance
