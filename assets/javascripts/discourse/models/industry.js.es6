function scoreIs(score) {
  if (score > 0 && score < 20) {
    return 0;
  } else if (score > 20 && score < 70) {
    return 1;
  }

  return 2;
}

export default Discourse.Model.extend({
  excellent: function() {
    return this.get('scores')[0];
  }.property('scores'),

  poor: function() {
    return this.get('scores')[1];
  }.property('scores'),

  bad: function() {
    return this.get('scores')[2];
  }.property('scores'),

  scores: function() {
    let stats = [0, 0, 0];
    let domains = this.get('domains');
    let incrementOn = (1 / domains.length) * 100;

    domains.forEach((domain) => {
      stats[scoreIs(domain.get('score'))] += incrementOn;
    });

    let [excellent, poor, bad] = stats;

    return [excellent, poor, bad];
  }.property('domains'),

  domainScores: function() {
    return _.map(this.get('domains'), (domain) => {
      return scoreIs(domain.get('score'));
    });
  }.property('domains')
})
