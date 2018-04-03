import Route from '@ember/routing/route';

export default Route.extend({
  queryParams:{
    labelsPage:{
      refreshModel: true
    }, 
    labelsSize:{
      refreshModel: true
    },
    releasesPage:{
      refreshModel: true
    },
    releasesSize:{
      refreshModel: true
    }
  },
  model(params){
    return Ember.RSVP.hash({
      // Artist
      artist: this.get('store').findRecord('artist', params.id),
      // Labels
      labels: this.get('store').query('label', {'filter[artist_id]': params.id, 
                                                'page[number]': params.labelsPage, 
                                                'page[size]': params.labelsSize,
                                                }),
      // Releases
      releases: this.get('store').query('release', {'filter[artist_id]': params.id, 
                                                    'page[number]': params.releasesPage, 
                                                    'page[size]': params.releasesSize,
                                                    }),
    })
  }
});
