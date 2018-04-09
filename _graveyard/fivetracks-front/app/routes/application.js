import Route from '@ember/routing/route';
import ApplicationRouteMixin from 'ember-simple-auth/mixins/application-route-mixin';

const {service} = Ember.inject;

export default Route.extend(ApplicationRouteMixin,{
  session: service('session'),
  currentUser: service('current-user'),

  beforeModel(){
    return this._loadCurrentUser();
  },
  
  sessionAuthenticated(){
    this._loadCurrentUser().then(() => {
      this.transitionTo('/');
    }).catch(() => this.get('session').invalidate());
  },
  
  _loadCurrentUser(){
    return this.get('currentUser').loadCurrentUser();
  },
  
  actions: {
    logout() {
      this.get('session').invalidate();
    }
  }
});
