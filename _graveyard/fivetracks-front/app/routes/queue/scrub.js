import Route from '@ember/routing/route';
const {inject: {service}} = Ember;

export default Route.extend({
  session: service('session'),
  currentUser: service('current-user'),
  model(){
    let userId = this.get('currentUser.user.id')
    return this.store.query('queue-track', {filter: {
      userId: userId,
      queue: 'scrub'
    }});
  },
});
