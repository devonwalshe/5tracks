import Route from '@ember/routing/route';

export default Route.extend({
  queryParams:{
    artistsPage:{
      refreshModel: true
    }, 
    releasesPage:{
      refreshModel: true
    },
    artistsSize:{
      refreshModel: true
    },
    releasesSize:{
      refreshModel: true
    }
  },
  model(params){
    return Ember.RSVP.hash({
      label: this.store.findRecord('label', params.id),
      artists: this.store.query('artist', {'filter[label_id]': params.id, 
                                           'page[number]': params.artistsPage, 
                                            'page[size]': params.artistsSize,
                                          }),
      releases: this.store.query('release', {'filter[label_id]': params.id, 
                                           'page[number]': params.releasesPage, 
                                            'page[size]': params.releasesSize,
                                        }),
  
    });
  },

});
