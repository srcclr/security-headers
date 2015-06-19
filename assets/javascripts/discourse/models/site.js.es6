Headlines.Domain = Discourse.Model.extend({});

Headlines.Domain.reopenClass({
  find(industry_id, id) {
    return Discourse.ajax('/headlines/industries/' + industry_id+ '/domains/' + id).then(function(result) {
      return Headlines.Domain.create(result);
    })
  }
});

export default Headlines.Domain;
