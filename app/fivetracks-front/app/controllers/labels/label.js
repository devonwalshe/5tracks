import Controller from '@ember/controller';

export default Controller.extend({
  queryParams: ['artistsPage', 'artistsSize', 'releasesPage', 'releasesSize'],
  artistsPage: 1,
  releasesPage: 1,
  artistsSize: 10,
  releasesSize: 10,
  actions:{
    paginate(model, direction){
      console.log(model, direction)
      switch(model){
        case 'artist':
          var param = "artistsPage";
          break;
        case 'release':
          var param = "releasesPage";
          break;
      }
      if(direction == 'forward'){
        this.incrementProperty(param)
        // this.modelFor('labels.label').reload();
      }else if (direction == 'back'){
        this.decrementProperty(param)
        // this.modelFor('labels.label').reload();
      }
      
    }
  }

});
