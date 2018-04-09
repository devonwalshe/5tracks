import DS from 'ember-data';

export default DS.Model.extend({
  queue: DS.attr(),
  inLibrary: DS.attr(),
  popularityRating: DS.attr(),
  similarityRating: DS.attr(),
  undergroundRating: DS.attr(),
  totalRating: DS.attr(),
  releaseTrackId: DS.attr(),
  releaseId: DS.attr(),
  release: DS.belongsTo('release'),
  releaseTrack: DS.belongsTo('release-track'),
  user: DS.belongsTo('user'),
  trackTitle: DS.attr(),
  releaseTitle: DS.attr(),

});
