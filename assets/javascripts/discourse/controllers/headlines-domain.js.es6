function testResult(score) {
  if (score > 66) {
    return 'excellent';
  } else if (score < 33) {
    return 'bad';
  } else {
    return 'poor';
  }
};

export default Ember.Controller.extend({
  domainStatus: Em.computed(function() {
    return testResult(this.get('model.score'));
  }),

  spyingCommunicationsTest: Em.computed(function() {
    return testResult(this.get('model.spyingTest'));
  }),

  ensuresSiteTest: Em.computed(function() {
    return testResult(this.get('model.ensuresSiteTest'));
  }),

  launchMalwareTest: Em.computed(function() {
    return testResult(this.get('model.launchMalwareTest'));
  })
});
