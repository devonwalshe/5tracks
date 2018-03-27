import Component from '@ember/component';

export default Component.extend({
  actions:{
    queueSave(track, release, queue){
      this.sendAction('queueSave', track, release, queue);
    }
  }
});
