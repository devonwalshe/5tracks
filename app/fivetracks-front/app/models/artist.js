import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  realname: DS.attr(),
  profile: DS.attr(),
  groupCount: DS.attr(),
  memberCount: DS.attr(),
  releases: DS.hasMany('release', {inverse: null}),
  releaseTracks: DS.hasMany('release-track', {inverse: null}),
  artistAliases: DS.hasMany('artist-alias'),
  groups: DS.hasMany('group'),
  members: DS.hasMany('member'),
  ArtistUrls: DS.hasMany('artist-url'),
  labels: DS.hasMany('label')
  
  
});
