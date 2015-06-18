function testResult(score) {
  if (score > 66) {
    return 'excellent';
  } else if (score < 33) {
    return 'bad';
  } else {
    return 'poor';
  }
};

function testScore() {
  var i, sum = 0;
  for (i = 0; i < arguments.length; i++) {
      sum += arguments[i];
  }
  return sum / arguments.length;
};

export default Ember.Controller.extend({
  strict_transport_security: Em.computed('model.scan.results', function() {
    return parseInt(this.get('model.scan.results.strict-transport-security')) || 0;
  }),

  x_xss_protection: Em.computed('model.scan.results', function() {
    return parseInt(this.get('model.scan.results.x-xss-protection')) || 0;
  }),

  x_content_type_options: Em.computed('model.scan.results', function() {
    return parseInt(this.get('model.scan.results.x-content-type-options')) || 0;
  }),

  x_frame_options: Em.computed('model.scan.results', function() {
    return parseInt(this.get('model.scan.results.x-frame-options')) || 0;
  }),

  content_security_policy: Em.computed('model.scan.results', function() {
    return parseInt(this.get('model.scan.results.content-security-policy')) || 0;
  }),

  scores: Ember.computed('model.scan.results', function() {
    return _.map(this.get('model.scan.results'), function(score) {
      return parseInt(score);
    })
  }),

  totalTests: 5,
  totalScore: Em.computed.sum('scores'),

  domainScore: Em.computed(function() {
    return this.get('totalScore') / this.get('totalTests');
  }),

  domainStatus: Em.computed('domainScore', function() {
    return testResult(this.get('domainScore'));
  }),

  spyingCommunicationsTestScore: Em.computed(function() {
    return testScore(this.get('strict_transport_security'));
  }),

  ensuresSiteTestScore: Em.computed(function() {
    return testScore(this.get('strict_transport_security'), this.get('x_frame_options'));
  }),

  launchMalwareTestScore: Em.computed(function() {
    return testScore(this.get('x_xss_protection'), this.get('x_content_type_options'), this.get('content_security_policy'));
  }),

  spyingCommunicationsTest: Em.computed('spyingCommunicationsTestScore', function() {
    return testResult(this.get('spyingCommunicationsTestScore'));
  }),

  ensuresSiteTest: Em.computed('ensuresSiteTestScore', function() {
    return testResult(this.get('ensuresSiteTestScore'));
  }),

  launchMalwareTest: Em.computed('launchMalwareTestScore', function() {
    return testResult(this.get('launchMalwareTestScore'));
  })
});
