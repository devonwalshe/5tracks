import DS from 'ember-data';
import EmberObject, { computed } from '@ember/object';

export default DS.Model.extend({
  title: DS.attr(),
  duration: DS.attr(),
  sequence: DS.attr(),
  artistCount: DS.attr(),
  artists: DS.hasMany('artist'),
  release: DS.belongsTo('release'),
  releaseTrackArtists: DS.hasMany('artist'),
  mainReleaseArtists: DS.hasMany('artist'),
  label: DS.belongsTo('label'),
  queued: DS.attr(),
  releaseId: DS.attr(),
  onQueue: DS.attr(),
  position: DS.attr(),
  // isQueued: computed("id", function(){
  //   this.store.query('queue-track', {
  //     filter: {
  //       releaseTrackId: this.get('id')
  //     }
  //   }).then(function(results){
  //     if(results){
  //       console.log(results)
  //       return true
  //     }else{
  //       console.log(false)
  //       return false
  //     }
  //   });
  // })
});
