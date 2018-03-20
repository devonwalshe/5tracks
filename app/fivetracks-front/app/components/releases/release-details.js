import Component from '@ember/component';

export default Component.extend({
  store: Ember.inject.service(),
  actions:{
    queueSave(track, release, queue){
      this.sendAction('queueSave', track, release, queue)
    }
  }
});
