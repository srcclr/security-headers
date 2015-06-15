export default Discourse.HeadlinesController = Discourse.Controller.extend({
  actions: {
    changeChartType: function(type) {
      $('.switch-control').removeClass('active-switch');
      $(`#switch-${type}`).addClass('active-switch');
      $('.chart-cards').addClass('hidden');
      $(`#${type}`).removeClass('hidden');
    }
  }
});
