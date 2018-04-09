import Route from '@ember/routing/route';

export default Route.extend({
  model(params){
    return this.get('store').findRecord('release', params.id);
  },
  actions: {
    refreshPage(){
      var model = this.modelFor('releases.release').hasMany('releaseTracks')
      model.reload().then(function(model){
        //pass
      })
      this.refresh();
      // this.controller.get('model').reload().then(function(model){
      //   console.log(model)
      //   console.log("reloaded the model")
      // })
      // console.log('has it reloaded?')
      // this.refresh();
    },
    queueSave(track,release,queue){
      // console.log({track:track, release:release, queue:queue})
      let r = this;
      let queueTrack = this.get('store').createRecord('queue-track', {
        release: release,
        queue: queue,
        releaseTrack: track
      });
      queueTrack.save().then(function(){
        console.log("Saved")
        r.send('refreshPage');
      }, function(error){
      }).catch(console.log("Hasn't saved yet"));
    },
    allQueueSave(release){
      let r = this;
      let model = this.modelFor('releases.release')
      console.log(model)
      model.tracksToQueue().then(function(){
        //Success
        console.log('ran function')
        r.send('refreshPage')

      }, function(error){
        // Error handling
      })
    }
  }
});
