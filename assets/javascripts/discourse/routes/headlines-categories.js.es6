import Category from '../models/category';
import Domain from '../models/domain';

function fetchModels() {
  return Discourse.ajax(Discourse.getURL("/headlines/categories"));
}

function wrapDomains(domains) {
  return _.map(domains, (domain) => {
    return Domain.create({
      id: domain.id,
      name: domain.name,
      rank: domain.rank,
      scanResults: domain.scan_results || {}
    });
  });
}

function wrapInModels(models) {
  return _.map(models['categories'], (model) => {
    return Category.create({
      id: model.id,
      title: model.name,
      domains: wrapDomains(model.domains)
    });
  });
}

export default Discourse.Route.reopen({
  beforeModel() { return this.redirectIfLoginRequired(); },

  model() {
    if (PreloadStore.get('categories')) {
      return PreloadStore.get('categories').then(wrapInModels);
    } else {
      return fetchModels().then(wrapInModels);
    }
  }
})
