import { moduleForComponent, test } from 'ember-qunit';
import hbs from 'htmlbars-inline-precompile';

moduleForComponent('labels/label-releases', 'Integration | Component | labels/label releases', {
  integration: true
});

test('it renders', function(assert) {
  // Set any properties with this.set('myProperty', 'value');
  // Handle any actions with this.on('myAction', function(val) { ... });

  this.render(hbs`{{labels/label-releases}}`);

  assert.equal(this.$().text().trim(), '');

  // Template block usage:
  this.render(hbs`
    {{#labels/label-releases}}
      template block text
    {{/labels/label-releases}}
  `);

  assert.equal(this.$().text().trim(), 'template block text');
});
