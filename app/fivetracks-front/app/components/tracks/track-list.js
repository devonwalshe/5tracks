import Component from '@ember/component';

export default Component.extend({
  actions: {
    showTrack(track) {
      console.log(track.id)
    },
    queueSave(track, release, queue){
      // console.log({track: track, release: release, queue: queue})
      this.sendAction('queueSave', track, release, queue)
    },
    allQueueSave(release){
      this.sendAction('allQueueSave', release)
    }
  }
});