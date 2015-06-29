import Domain from '../models/domain';

export default Discourse.Controller.extend({
  subIndustriesHide: true,

  hideIndustries: function() {
    return this.get('subIndustriesHide') == true;
  }.property('subIndustriesHide'),

  loadMore() {
    let model = this.get("model");

    if (model.get("allLoaded")) { return Ember.RSVP.resolve(); }

    return Discourse.ajax(model.id + ".json?offset=" + model.domains.length).then((data) => {
      if (data.length === 0) {
        model.set("allLoaded", true);
      }
      model.domains.addObjects(_.map(data.industry_ranked_domains, (domain) => {
        return Domain.create({
          id: domain.id,
          name: domain.name,
          country: domain.country,
          scanResults: domain.scan_results
        });
      }));
    });
  },

  actions: {
    subIndustriesToggle: function() {
      var state = this.get('subIndustriesHide');
      this.set('subIndustriesHide', !state);
    }
  }
})
