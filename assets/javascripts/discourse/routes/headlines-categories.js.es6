import Category from '../models/category'

function fetchModels(query) {
  return () => { return Discourse.ajax(Discourse.getURL("/security-headers/categories?" + query)); };
}

function wrapInModels(models) {
  models = models['categories'] || models;

  return _.map(models, (model) => {
    return Category.createFromJson(model);
  });
}

export default Discourse.Route.extend({
  model(params) {
    let headlinesController = this.controllerFor('headlines'),
        query = headlinesController.get('countryFilter') + headlinesController.get('headerFilter');

    return PreloadStore.getAndRemove('categories', fetchModels(query)).then(wrapInModels);
  },

  setupController(controller, model) {
    controller.set('model', model);
    this.controllerFor('application').set('showFooter', true);
  }
})
