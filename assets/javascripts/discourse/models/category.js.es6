import Domain from './domain'

let Category = Discourse.Model.extend({
  gradeD: function() {
    return this.get('scores')[0];
  }.property('scores'),

  gradeC: function() {
    return this.get('scores')[1];
  }.property('scores'),

  gradeB: function() {
    return this.get('scores')[2];
  }.property('scores'),

  gradeA: function() {
    return this.get('scores')[3];
  }.property('scores'),

  scores: function() {
    let stats = [0, 0, 0, 0];
    let domains = this.get('domains');
    let incrementOn = (1 / domains.length) * 100;

    domains.forEach((domain) => {
      stats[domain.get('score')] += incrementOn;
    });

    let [gradeD, gradeC, gradeB, gradeA] = stats;

    return _.map([gradeD, gradeC, gradeB, gradeA], (value) => { return Math.round(value) });
  }.property('domains'),

  domainScores: function() {
    return _.map(this.get('domains'), (domain) => {
      return domain.get('score');
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
