import Controller from '@ember/controller';
const { inject: { service }} = Ember;

export default Controller.extend({
  session: service('session'),
  currentUser: service('current-user')
});
