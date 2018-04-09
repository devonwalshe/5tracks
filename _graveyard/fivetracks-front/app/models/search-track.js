import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr(),
  score: DS.attr(),
  artistNames: DS.attr(),
  releaseTitle: DS.attr(),
  artistsNames: DS.attr(),
  release: DS.belongsTo('release'),
  mainReleaseArtists: DS.hasMany('artist'),
  artists: DS.hasMany('artist')
});
