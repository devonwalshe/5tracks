import Controller from '@ember/controller';
const {service} = Ember.inject;

export default Controller.extend({
  session: service('session'),
  currentUser: service('current-user'),
});
