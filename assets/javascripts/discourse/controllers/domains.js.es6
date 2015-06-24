import { scoreIs, statusIs } from '../../lib/score';

export default Ember.Controller.extend({
  domainStatus: Em.computed(function() {
    return statusIs(this.get('model.score'));
  }),

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
