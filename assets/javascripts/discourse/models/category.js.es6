import { scoreIs } from '../../lib/score';

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

    return _.map([excellent, poor, bad], (value) => { return Math.floor(value) });
  }.property('domains'),

  domainScores: function() {
    return _.map(this.get('domains'), (domain) => {
      return scoreIs(domain.get('score'));
    });
  }.property('domains'),

  categories: function() {
    return [
      { title: 'Sub Industry Name 1', id: 1 },
      { title: 'Sub Industry Name 2', id: 2 },
      { title: 'Sub Industry Name 3', id: 3 },
      { title: 'Sub Industry Name 4', id: 4 }
    ];
  }.property()
})
