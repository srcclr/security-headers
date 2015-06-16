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

  domainStatus: Em.computed(function() {
    if (this.get('domainScore') > 66) {
      return 'Excellent';
    } else if (this.get('domainScore') < 33) {
      return 'Bad';
    } else {
      return 'Poor';
    }
  }),

  test1Score: Em.computed(function() {
    return this.get('strict_transport_security');
  }),

  test2Score: Em.computed(function() {
    return (this.get('strict_transport_security') + this.get('x_frame_options')) / 2;
  }),

  test3Score: Em.computed(function() {
    return (this.get('x_xss_protection') + this.get('x_content_type_options') + this.get('content_security_policy')) / 3;
  }),

  test1Result: Em.computed(function() {
    if (this.get('test1Score') > 66) {
      return 'Excellent';
    } else if (this.get('test1Score') < 33) {
      return 'Bad';
    } else {
      return 'Poor';
    }
  }),

  test2Result: Em.computed(function() {
    if (this.get('test2Score') > 66) {
      return 'Excellent';
    } else if (this.get('test2Score') < 33) {
      return 'Bad';
    } else {
      return 'Poor';
    }
  }),

  test3Result: Em.computed(function() {
    if (this.get('test3Score') > 66) {
      return 'Excellent';
    } else if (this.get('test3Score') < 33) {
      return 'Bad';
    } else {
      return 'Poor';
    }
  })
})
