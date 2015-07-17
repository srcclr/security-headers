import Category from '../models/category'

function fetchModels() {
  return () => { return Discourse.ajax(Discourse.getURL("/headlines/categories")); };
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
    return PreloadStore.getAndRemove('categories', fetchModels()).then(wrapInModels);
  }
})
