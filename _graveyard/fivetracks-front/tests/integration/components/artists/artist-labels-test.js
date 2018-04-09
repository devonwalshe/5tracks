import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('artists/artist-labels', 'Integration | Component | artists/artist labels', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{artists/artist-labels}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#artists/artist-labels}}
      template block text
    {{/artists/artist-labels}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
