function testResult(score) {
  if (score > 66) {
    return 'Excellent';
  } else if (score < 33) {
    return 'Bad';
  } else {
    return 'Poor';
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
  strict_transport_security: Em.computed('model.results', function() {
    return parseInt(this.get('model.results.strict-transport-security')) || 0;
  }),

  x_xss_protection: Em.computed('model.results', function() {
    return parseInt(this.get('model.results.x-xss-protection')) || 0;
  }),

  x_content_type_options: Em.computed('model.results', function() {
    return parseInt(this.get('model.results.x-content-type-options')) || 0;
  }),

  x_frame_options: Em.computed('model.results', function() {
    return parseInt(this.get('model.results.x-frame-options')) || 0;
  }),

  content_security_policy: Em.computed('model.results', function() {
    return parseInt(this.get('model.results.content-security-policy')) || 0;
  }),

  scores: Ember.computed('model.results', function() {
    return _.map(this.get('model.results'), function(score) {
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
