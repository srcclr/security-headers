import Domain from '../models/domain'

function scanDomain(name) {
  return () => { return Discourse.ajax(Discourse.getURL('/projects/security-headers/scans?url=' + name)); };
}

function wrapDomain(domain) {
  return Domain.createFromJson(domain);
}

export default Discourse.Route.extend({
  queryParams: {
    url: {
      refreshModel: true
    }
  },

  model(params) {
    return PreloadStore.getAndRemove('domain_scan', scanDomain(params.url)).then(wrapDomain);
  },

  setupController(controller, model) {
    controller.set('model', model);
    this.controllerFor('application').set('showFooter', true);
  }
})
