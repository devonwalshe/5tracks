import DS from 'ember-data';
import HasManyQuery from 'ember-data-has-many-query';
import DataAdapterMixin from 'ember-simple-auth/mixins/data-adapter-mixin';

export default DS.JSONAPIAdapter.extend(DataAdapterMixin, HasManyQuery.RESTAdapterMixin, {
  host: 'http://localhost:3000',
  authorizer: 'authorizer:devise'
});
