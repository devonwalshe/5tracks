import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('tracks/queue-list', 'Integration | Component | tracks/queue list', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{tracks/queue-list}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#tracks/queue-list}}
      template block text
    {{/tracks/queue-list}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
