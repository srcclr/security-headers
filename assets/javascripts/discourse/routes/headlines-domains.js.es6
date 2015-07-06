import Category from '../models/category';
import Domain from '../models/domain';

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
    scanResults: domain.scan_results,
    vulnerabilitiesReport: domain.vulnerabilities_report,
    category: Category.create(domain.category)
  });
}

export default Discourse.Route.extend({
  model(params) {
    return PreloadStore.getAndRemove(
      'domain_scan',
      fetchModel(params.category_id, params.id)
    ).then(wrapDomain);
  }
})
