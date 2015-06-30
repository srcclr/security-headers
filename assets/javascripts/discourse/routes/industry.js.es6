import Industry from '../models/industry';
import Domain from '../models/domain';

export default Discourse.Route.extend({
  model(params) {
    return PreloadStore.getAndRemove('industry', () => {
      return Discourse.ajax('/headlines/industries/' + params.id).then((industry) => {
        return Industry.create({
          id: industry.id,
          name: industry.name,
          domains: _.map(industry.industry_ranked_domains, (domain) => {
            return Domain.create({
              id: domain.id,
              name: domain.name,
              country: domain.country,
              scanResults: domain.scan_results
            });
          })
        });
      })
    });
  },

  setupController(controller, model) {
    controller.set('model', model);
  }
})
