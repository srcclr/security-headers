import Industry from '../models/industry'

export default Discourse.HeadlinesController = Discourse.Controller.extend({
  chartType: 'pie',

  showMosaicChart: function() {
    return this.get('chartType') == 'mosaic';
  }.property('chartType'),

  industries: [],

  issueTypes: ['all',
               'strict_transport_security',
               'x_xss_protection',
               'x_content_type_options',
               'x_frame_options',
               'content_security_policy'],

  ratings: [ 'excellent', 'bad', 'poor' ],

  actions: {
    showMosaic: function() {
      this.set('chartType', 'mosaic');
    },

    showPie: function() {
      this.set('chartType', 'pie');
    }
  }
});
