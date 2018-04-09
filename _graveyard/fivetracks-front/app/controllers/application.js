import Controller from '@ember/controller';

export default Controller.extend({
  session: Ember.inject.service('session'),
  currentUser: Ember.inject.service('current-user')
});
