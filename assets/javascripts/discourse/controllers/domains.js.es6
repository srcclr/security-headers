export default Discourse.Controller.extend({
  spyingTestHide: true,
  ensuresTestHide: true,
  launchMalwareTestHide: true,

  actions: {
    testToggle: function(testName) {
      var state = this.get(testName);
      this.set(testName, !state);
    }
  }
});
