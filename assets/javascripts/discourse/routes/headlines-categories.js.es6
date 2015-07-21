import Category from '../models/category'

function fetchModels(query) {
  return () => { return Discourse.ajax(Discourse.getURL("/headlines/categories?" + query)); };
}

function wrapInModels(models) {
  models = models['categories'] || models;

  return _.map(models, (model) => {
    return Category.createFromJson(model);
  });
}

export default Discourse.Route.extend({
  beforeModel() { return this.redirectIfLoginRequired(); },

  model(params) {
    let headlinesController = this.controllerFor('headlines'),
        query = headlinesController.get('countryFilter') + headlinesController.get('issueFilter');

    return PreloadStore.getAndRemove('categories', fetchModels(query)).then(wrapInModels);
  }
})
