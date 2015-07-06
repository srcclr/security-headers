import Domain from '../models/domain';

function scanDomain(name) {
  return Discourse.ajax(Discourse.getURL('/headlines/scans?url=' + name));
}

function wrapDomain(domain) {
  return Domain.create({
    name: domain.name,
    scanResults: domain.scan_results
  });
}

export default Discourse.Route.extend({
  queryParams: {
    url: {
      refreshModel: true
    }
  },

  model(params) {
    return PreloadStore.getAndRemove('domain_scan', () => {
      return scanDomain(params.url);
    }).then((domain) => {
      return wrapDomain(domain);
    });
  },

  setupController(controller, model) {
    controller.set('model', model);
  }
})
