function scoreIs(score) {
  if (score > 0 && score < 20) {
    return 'bad';
  } else if (score > 20 && score < 70) {
    return 'poor';
  }

  return 'excellent';
}

export default Discourse.Model.extend({
  scores: function() {
    let stats = { excellent: 0, poor: 0, bad: 0 };
    let domains = this.get('domains');
    let incrementOn = (1 / domains.size) * 100;

    domains.forEach((domain) => {
      stats[scoreIs(domain.score)] += incrementOn;
    });

    return [stats.excellent, stats.poor, stats.bad];
  }.property('domains'),

  domainScores: function() {
    return _.map(this.get('domains'), (domain) => {
      return domain.score
    }).property('domains')
  }
})
