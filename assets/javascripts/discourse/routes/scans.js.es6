import Domain from '../models/domain'
import Spinner from '../mixins/headlines-conditional-spinner'

function scanDomain(name) {
  return Discourse.ajax(Discourse.getURL('/headlines/scans?url=' + name));
}

function wrapDomain(domain) {
  return Domain.create({
    name: domain.name,
    score: domain.score,
    scanResults: domain.scan_results
  });
}

export default Discourse.Route.extend(Spinner, {
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
  }
})
