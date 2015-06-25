import Domain from '../models/domain';

export default Discourse.Controller.extend({
  loadMore() {
    let model = this.get("model");

    if (model.get("allLoaded")) { return Ember.RSVP.resolve(); }

    return Discourse.ajax(model.id + ".json?offset=" + model.industry_ranked_domains.length).then((data) => {
      if (data.length === 0) {
        model.set("allLoaded", true);
      }
      model.industry_ranked_domains.addObjects(_.map(data.industry_ranked_domains, (domain) => {
        return Domain.create({
          id: domain.id,
          name: domain.name,
          country: domain.country,
          scanResults: domain.scan_results
        });
      }));
    });
  }
})
