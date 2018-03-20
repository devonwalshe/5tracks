import { moduleForModel, test } from 'ember-qunit';

moduleForModel('artist/artist-name-variation', 'Unit | Model | artist/artist name variation', {
  // Specify the other units that are required for this test.
  needs: []
});

test('it exists', function(assert) {
  let model = this.subject();
  // let store = this.store();
  assert.ok(!!model);
});
