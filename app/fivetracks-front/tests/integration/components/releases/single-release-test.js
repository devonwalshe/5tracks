import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('releases/single-release', 'Integration | Component | releases/single release', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{releases/single-release}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#releases/single-release}}
      template block text
    {{/releases/single-release}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
