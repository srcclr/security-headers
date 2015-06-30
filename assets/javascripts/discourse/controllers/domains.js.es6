import { statusIs } from '../../lib/score';

export default Ember.Controller.extend({
  spyingTestHide: true,
  ensuresTestHide: true,
  launchMalwareTestHide: true,

  actions: {
    testToggle: function(testName) {
      var state = this.get(testName);
      this.set(testName, !state);
    }
  },

  spyingCommunicationsTest: Em.computed(function() {
    return statusIs(this.get('model.spyingTest'));
  }),

  ensuresSiteTest: Em.computed(function() {
    return statusIs(this.get('model.ensuresSiteTest'));
  }),

  launchMalwareTest: Em.computed(function() {
    return statusIs(this.get('model.launchMalwareTest'));
  })
});
