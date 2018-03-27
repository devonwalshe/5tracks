import EmberRouter from '@ember/routing/router';
import config from './config/environment';

const Router = EmberRouter.extend({
  location: config.locationType,
  rootURL: config.rootURL
});

Router.map(function() {
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
    this.route('show', {path: '/:track_id'});
  });

  this.route('queue', function() {
    this.route('scrub');
    this.route('listen');
    this.route('weekly');
  });
});

export default Router;
