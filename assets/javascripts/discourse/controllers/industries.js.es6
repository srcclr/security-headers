import Industry from '../models/industry'

export default Discourse.HeadlinesController = Discourse.Controller.extend({
  needs: ['headlines'],
  chartType: 'pie',

  showMosaicChart: function() {
    return this.get('chartType') == 'mosaic';
  }.property('chartType'),

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
