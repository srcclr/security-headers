Headlines.Domain = Discourse.Model.extend({});

Headlines.Domain.reopenClass({
  find(id) {
    return Discourse.ajax('/headlines/domains/' + id).then(function(result) {
      return Headlines.Domain.create(result);
    })
  }
});

export default Headlines.Domain;
