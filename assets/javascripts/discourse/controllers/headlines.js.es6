export default Discourse.HeadlinesController = Discourse.Controller.extend({
  actions: {
    switchChartType: function() {
      return this.set('showMosaicChart', !this.get('showMosaicChart'));
    }
  },
  industries: [
    { index: 1, name: 'Industry Name 1', excellent: '60%', poor: '22%', bad: '18%' },
    { index: 2, name: 'Industry Name 2', excellent: '60%', poor: '22%', bad: '18%' },
    { index: 3, name: 'Industry Name 3', excellent: '60%', poor: '22%', bad: '18%' }
  ],
  issueTypes: [ 'all', 'hsts', 'x_xss', 'x_content_type', 'x_frame_options', 'x_content_security_options' ],
  ratings: [ 'excellent', 'bad', 'poor' ]
});
