export default Discourse.Model.extend({
  scanResults: {},

  headers: function() {
    return Object.keys(this.get('scanResults'));
  }.property('scanResults'),

  score: function() {
    let sum = 0;

    this.get('headers').forEach((header) => {
      sum += this.get('scanResults')[header] || 0;
    });

    return (sum / this.get('headers').length) || 0;
  }.property('scanResults')
})
