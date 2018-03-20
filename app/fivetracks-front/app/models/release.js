import DS from 'ember-data';

export default DS.Model.extend({
  title: DS.attr(),
  released: DS.attr(),
  country: DS.attr(),
  notes: DS.attr(),
  masterId: DS.attr(),
  artistCount: DS.attr(),
  releaseTracks: DS.hasMany('release-track'),
  artists: DS.hasMany(),
  mainArtists: DS.hasMany('artist'),
  tracksToQueue(){
    let modelName = this.constructor.modelName;
    let adapter = this.store.adapterFor(modelName);
    return adapter.tracksToQueue(this.get('id'), this.serialize());
  }
});
