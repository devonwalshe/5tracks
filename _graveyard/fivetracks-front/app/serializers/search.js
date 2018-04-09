// import DS from 'ember-data';
//
// export default DS.JSONAPISerializer.extend({
//   // primaryKey: '_id',
//   // normalizePayload: function(type, payload){
//   //   return(search: payload);
//   // },
//
//   // normalizeResponse(store, primaryModelClass, payload, id, requestType){
//   //   payload.data = payload.data.map((item) => ({
//   //     id: item._id,
//   //     type: 'search',
//   //     attributes: {
//   //       track: item._source.song,
//   //       release: item._source.release,
//   //       artists: item._source.artists,
//   //       artistIds: item._source.artist_ids.map((artistId) => ({
//   //         id: artistId
//   //       })),
//   //       releaseId: item._source.release_id,
//   //       score: item._score
//   //     }
//   //   }));
//   //   return payload
//   // return this._super(store, primaryModelClass, payload.results, id, requestType)}
// });