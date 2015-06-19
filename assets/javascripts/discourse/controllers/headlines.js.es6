import Industry from '../models/industry'

export default Discourse.HeadlinesController = Discourse.Controller.extend({
  chartType: 'pie',

  showMosaicChart: function() {
    return this.get('chartType') == 'mosaic';
  }.property('chartType'),

  industries: [],

  issueTypes: [ 'all', 'hsts', 'x_xss', 'x_content_type', 'x_frame_options', 'x_content_security_options' ],
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
