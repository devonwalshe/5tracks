import Controller from '@ember/controller';

export default Controller.extend({
  queryParams: ['labelsPage', 'labelsSize', 'releasesPage', 'releasesSize'],
  labelsPage: 1,
  labelsSize: 10,
  releasesPage: 1,
  releasesSize: 10,
  actions:{
    paginate(model, direction){
      console.log(model, direction)
      switch(model){
        case 'label':
          var param = "labelsPage";
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
