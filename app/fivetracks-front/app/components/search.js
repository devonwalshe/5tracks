import Component from '@ember/component';

export default Component.extend({
  clicked: false,
  actions: {
    toggleClicked(){
      this.toggleProperty('clicked')
      console.log("clicked")
    }
  }
});
