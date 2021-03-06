import EmberRouter from '@ember/routing/router';
import config from './config/environment';

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
  this.route('login');

  // search
  this.route('search');
  // queueTracks
  this.route('queue-tracks');

  // labels
  this.route('labels', function() {
    this.route('label', {path: '/:id'});
  });

  // artists
  this.route('artists', function() {
    this.route('artist', {path: '/:id'});
  });
  // releases
  this.route('releases', function() {
    this.route('release', {path: '/:id'});
  });
  // releaseTracks
  this.route('tracks', function() {
    this.route('track', {path: '/:id'});
  });
  // Queues
  this.route('queue', function() {
    this.route('scrub');
    this.route('listen');
    this.route('weekly');
  });
  this.route('users', function() {
    this.route('new');
  });
  this.route('dashboard');
});

export default Router;
