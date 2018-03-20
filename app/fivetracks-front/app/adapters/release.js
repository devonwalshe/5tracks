import ApplicationAdapter from './application';

export default ApplicationAdapter.extend({
  tracksToQueue(id, serializedData){
    return this.ajax(this.urlForTracksToQueue(id), "POST", {data: serializedData});
  },
  
  urlForTracksToQueue(id){
    return `${this.buildURL('release', id)}/tracks_to_queue`
  }
});
