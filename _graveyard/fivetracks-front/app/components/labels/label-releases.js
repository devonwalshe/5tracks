import Component from '@ember/component';

export default Component.extend({
  actions: {
    paginate(model, direction){
      this.sendAction("paginate", model, direction)
    }
  }
});
