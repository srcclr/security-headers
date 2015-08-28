import Category from '../models/category';
import Domain from '../models/domain';
import Header from '../models/header'
import CspTest from '../models/csp-test'

function fetchModel(category_id, domain_id) {
  return () => {
    return Discourse.ajax('/headlines/categories/' + category_id + '/domains/' + domain_id);
  };
}

function wrapDomain(domain) {
  return Domain.create({
    id: domain.id,
    name: domain.name,
    country: domain.country,
    score: domain.score,
    http_score: domain.http_score,
    csp_score: domain.csp_score,
    category: Category.create(domain.category),
    httpHeaders: _.map(domain.http_headers, (header) => { return Header.create(header); }),
    cspTests: _.map(domain.csp_header.tests, (test) => { return CspTest.create(test); })
  });
}

export default Discourse.Route.extend({
  model(params) {
    return PreloadStore.getAndRemove('domain_scan', fetchModel(params.category_id, params.id)).then(wrapDomain);
  }
})
