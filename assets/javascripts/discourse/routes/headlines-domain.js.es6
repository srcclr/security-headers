import Domain from '../models/domain';

export default Discourse.Route.extend({
  model(params) {
    return PreloadStore.getAndRemove('domain_scan', function() {
      return Discourse.ajax('/headlines/industries/' + params.industry_id+ '/domains/' + params.id).then(function(result) {
        return Domain.create(result);
    })
    });
  }
})
