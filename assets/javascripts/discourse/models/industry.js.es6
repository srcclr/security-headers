export default Discourse.Model.extend({

  excellent: 60,
  poor: 22,
  bad: 18,

  scores: function() {
    return [this.excellent, this.poor, this.bad];
  },

  domainScores: function() {
    var scores = [];

    for(let i = 100; i > 0; i--) {
      scores.push(Math.floor((Math.random() * 3)));
    }

    return scores;
  }
})
