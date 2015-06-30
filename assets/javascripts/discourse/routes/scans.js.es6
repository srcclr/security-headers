import Domain from '../models/domain';

export default Discourse.Route.extend({
  queryParams: {
    url: {
      refreshModel: true
    }
  },

  model(params) {
    return PreloadStore.getAndRemove('url_scan', () => {
      return Discourse.ajax(Discourse.getURL('/headlines/scans?url=' + params.url)).then((result) => {
        return Domain.create({
          name: result.name,
          scanResults: result.scan_results
        });
      })
    })
  },

  setupController(controller, model) {
    controller.set('model', model);
  }
})
