import DS from 'ember-data';

export default DS.Model.extend({
  name: DS.attr(),
  contactInfo: DS.attr(),
  profile: DS.attr(),
  parent: DS.belongsTo('label', {inverse: 'sublabels'}),
  sublabels: DS.hasMany('label', {inverse: 'parent'}),
  dataQuality: DS.attr(),
  releases: DS.hasMany('release'),
  artists: DS.hasMany('artist'),

});
