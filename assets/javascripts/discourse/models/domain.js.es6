import { statusIs } from '../../lib/score';

let Domain = Discourse.Model.extend({
  spyingTestHeaders: ['strict-transport-security'],
  ensuresSiteTestHeaders: ['strict-transport-security', 'x-frame-options'],
  launchMalwareTestHeaders: ['x-xss-protection', 'x-content-type-options', 'content-security-policy'],

  headers: Em.computed(function() {
    return Object.keys(this.get('scanResults'));
  }),

  testScore(headers) {
    let sum = 0;

    if (!this.get('scanResults')) { return 0; }

    headers.forEach((header) => {
      sum += parseInt(this.get('scanResults')[header]) || 0;
    });

    return Math.ceil((sum / headers.length) || 0);
  },

  status: Em.computed(function() {
    return statusIs(this.get('score'));
  }),

  spyingTestScore: Em.computed(function() {
    return this.testScore(this.get('spyingTestHeaders'));
  }),

  ensuresSiteTestScore: Em.computed(function() {
    return this.testScore(this.get('ensuresSiteTestHeaders'));
  }),

  launchMalwareTestScore: Em.computed(function() {
    return this.testScore(this.get('launchMalwareTestHeaders'));
  }),

  spyingCommunicationsTest: Em.computed(function() {
    return statusIs(this.get('spyingTestScore'));
  }),

  ensuresSiteTest: Em.computed(function() {
    return statusIs(this.get('ensuresSiteTestScore'));
  }),

  launchMalwareTest: Em.computed(function() {
    return statusIs(this.get('launchMalwareTestScore'));
  })
});

Domain.reopenClass({
  createFromJson(json) {
    return this.create({
      id: json.id,
      name: json.name,
      rank: json.rank,
      country: json.country,
      score: json.score,
      scanResults: json.scan_results
    })
  }
})

export default Domain;
