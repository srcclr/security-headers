import ChartPie from '../../lib/chart-pie'
import ChartMosaic from '../../lib/chart-mosaic'

export default Ember.Component.extend({
  tagName: 'canvas',
  classNames:  ['category-canvas'],
  attributeBindings: ['width', 'height'],
  width: 280,
  height: 90,

  draw: function() {
    this.set('pie', new ChartPie(this.get('element'), { percents: this.model.get('scores') }));
    this.set('mosaic', new ChartMosaic(this.get('element'), { cells: this.model.get('domainScores') }));

    this.drawChart();
  }.on('didInsertElement'),

  drawChart: function() {
    let type = this.get('type');
    if (type) { this.get(type).draw(); }
  }.observes('type')
})
