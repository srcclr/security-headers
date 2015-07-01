import Industry from '../models/industry';
import Domain from '../models/domain';

export default Discourse.Route.extend({
  model(params) {
    return PreloadStore.getAndRemove('domain', function() {
      return Discourse.ajax('/headlines/industries/' + params.industry_id+ '/domains/' + params.id).then(function(result) {
        return Domain.create({
          id: result.id,
          name: result.name,
          country: result.country,
          scanResults: result.scan_results,
          vulnerabilitiesReport: result.vulnerabilities_report,
          industry: Industry.create(result.industry)
        });
      })
    });
  },

  setupController(controller, model) {
    controller.set('model', model);
  }
})
