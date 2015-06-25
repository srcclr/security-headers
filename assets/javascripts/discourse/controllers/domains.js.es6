import { statusIs } from '../../lib/score';

export default Ember.Controller.extend({
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
