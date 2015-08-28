import Domain from '../models/domain'
import Header from '../models/header'
import CspTest from '../models/csp-test'

function scanDomain(name) {
  return () => { return Discourse.ajax(Discourse.getURL('/headlines/scans?url=' + name)); };
}

function wrapDomain(domain) {
  return Domain.create({
    name: domain.name,
    score: domain.score,
    http_score: domain.http_score,
    csp_score: domain.csp_score,
    httpHeaders: _.map(domain.http_headers, (header) => { return Header.create(header); }),
    cspTests: _.map(domain.csp_header.tests, (test) => { return CspTest.create(test); })
  });
}

export default Discourse.Route.extend({
  queryParams: {
    url: {
      refreshModel: true
    }
  },

  model(params) {
    return PreloadStore.getAndRemove('domain_scan', scanDomain(params.url)).then(wrapDomain);
  }
})
