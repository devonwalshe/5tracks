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
  // releases
  this.route('releases', function() {
    this.route('show', {path: '/:release_id'});
  });
  // artists
  this.route('artists', function() {
    this.route('show', {path: '/:artist_id'});
  });
  // labels
  this.route('labels', function() {
    this.route('show', {path: '/:label_id'});
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
