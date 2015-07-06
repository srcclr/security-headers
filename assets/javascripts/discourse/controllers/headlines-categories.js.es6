import Category from '../models/category'

export default Discourse.Controller.extend({
  needs: ['headlines'],
  chartType: 'pie',

  showMosaicChart: function() {
    return this.get('chartType') == 'mosaic';
  }.property('chartType'),

  issueTypes: ['all',
               'strict-transport-security',
               'x-xss-protection',
               'x-content-type-options',
               'x-frame-options',
               'content-security-policy'],

  ratings: [ 'excellent', 'bad', 'poor' ],

  issueTypes: Em.computed.alias('controllers.headlines.issueTypes'),

  actions: {
    showMosaic: function() {
      this.set('chartType', 'mosaic');
    },

    showPie: function() {
      this.set('chartType', 'pie');
    }
  }
});
