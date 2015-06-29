import Industry from '../models/industry'

export default Discourse.HeadlinesController = Discourse.Controller.extend({
  chartType: 'pie',
  subIndustriesHide: true,

  showMosaicChart: function() {
    return this.get('chartType') == 'mosaic';
  }.property('chartType'),

  hideIndustries: function() {
    return this.get('subIndustriesHide') == true;
  }.property('subIndustriesHide'),

  industries: [],

  issueTypes: ['all',
               'strict-transport-security',
               'x-xss-protection',
               'x-content-type-options',
               'x-frame-options',
               'content-security-policy'],

  ratings: [ 'excellent', 'bad', 'poor' ],

  actions: {
    showMosaic: function() {
      this.set('chartType', 'mosaic');
    },

    showPie: function() {
      this.set('chartType', 'pie');
    },

    subIndustriesToggle: function() {
      var state = this.get('subIndustriesHide');
      this.set('subIndustriesHide', !state);
    }
  }
});
