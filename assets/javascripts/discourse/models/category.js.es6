import Domain from './domain'
import { scoreIs } from '../../lib/score'

let Category = Discourse.Model.extend({
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

    return _.map([excellent, poor, bad], (value) => { return Math.round(value) });
  }.property('domains'),

  domainScores: function() {
    return _.map(this.get('domains'), (domain) => {
      return scoreIs(domain.get('score'));
    });
  }.property('domains')
})


Category.reopenClass({
  createFromJson(json) {
    return this.create({
      id: json.id,
      title: json.title,
      parent: json.parent,
      categories: json.categories,
      parents: json.parents,
      domains: _.map(json.domains, (domain) => {
        return Domain.createFromJson(domain);
      })
    });
  }
})

export default Category
