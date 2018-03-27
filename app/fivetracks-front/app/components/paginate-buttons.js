import Component from '@ember/component';

export default Component.extend({ 
  param: "stuff",
  actions: {
    paginate(model, direction, param) {
      this.attrs.paginate(model, direction, param)
    }
  }
});
