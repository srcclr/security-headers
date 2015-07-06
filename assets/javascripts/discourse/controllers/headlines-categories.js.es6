import Category from '../models/category'

export default Discourse.Controller.extend({
  needs: ['headlines'],
  chartType: 'pie',

  showMosaicChart: function() {
    return this.get('chartType') == 'mosaic';
  }.property('chartType'),

  issueTypes: Em.computed.alias('controllers.headlines.issueTypes'),
  ratings: Em.computed.alias('controllers.headlines.ratings'),

  actions: {
    showMosaic: function() {
      this.set('chartType', 'mosaic');
    },

    showPie: function() {
      this.set('chartType', 'pie');
    }
  }
});
