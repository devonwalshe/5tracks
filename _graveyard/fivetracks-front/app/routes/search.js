import Route from '@ember/routing/route';

export default Route.extend({
  // queryParams: {
  //   q: {
  //     // refreshModel: true
  //   }
  // },
  model(params){
    if(params.q){
      return this.get('store').query("search-track", {"q": params.q})
    }
  },
  // afterModel(model, transition){
  //   return Ember.RSVP.hash({
  //     // release: model.get('release'),
  //     // mainReleaseArtists: model.getEach('artist')
  //   })
  // },
  actions:{
    submit: function(){
      this.refresh();
    }
  }
});
