Headlines.Domain = Discourse.Model.extend({});

Headlines.Domain.reopenClass({
  find(id) {
    return Discourse.ajax('/headlines/domains/' + id).then(function(result) {
      return Headlines.Domain.create({
        name: result.name,
        country: result.country,
        results: result.scan.results
      });
    })
  }
});

export default Headlines.Domain;
