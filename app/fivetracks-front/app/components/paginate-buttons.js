import Component from '@ember/component';

export default Component.extend({ 
  actions: {
    paginate(model, direction, param) {
      this.attrs.paginate(model, direction)
    }
  }
});
