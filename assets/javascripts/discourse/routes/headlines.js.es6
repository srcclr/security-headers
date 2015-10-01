export default Discourse.Route.extend({
  beforeModel() { return this.redirectIfLoginRequired(); },

  setupController(controller, model) {
    this.controllerFor('application').set('showFooter', true);
  },

  actions: {
    loading() {
      this.controllerFor("headlines").set("loading", true);
      return true;
    },

    didTransition() {
      this.controllerFor("headlines").set("loading", false);
      return true;
    }
  }
})
