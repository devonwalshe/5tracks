import DS from 'ember-data';

export default DS.JSONSerializer.extend({
  normalizeResponse(store, primaryModelClass, payload, id, requestType){
    payload = {
      id: payload.id,
      type: "users",
      data: {
        attributes: {
          email: payload.email
        }
      }
    }
    // payload.data.attributes.email = payload.email;
    // payload.data.id = payload.id;
    // delete payload.authentication_token;
    // delete payload.created_at;
    // delete payload.updated_at;
    return this._super(...arguments)
  }
});
