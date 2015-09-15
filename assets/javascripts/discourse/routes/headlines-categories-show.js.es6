import Category from '../models/category'

function fetchModel(category_id, query) {
  return () => { return Discourse.ajax(Discourse.getURL("/projects/security-headers/categories/" + category_id + "?" + query)); };
}

function wrapModel(model) {
  return Category.createFromJson(model);
}

export default Discourse.Route.extend({
  model(params) {
    let headlinesController = this.controllerFor('headlines'),
        controller = this.controllerFor('headlines.categories-show'),
        query = headlinesController.get('countryFilter') + headlinesController.get('headerFilter') + controller.get('ratingFilter');

    return PreloadStore.getAndRemove('category', fetchModel(params.id, query)).then(wrapModel);
  },

  setupController(controller, model) {
    controller.set('model', model);
    this.controllerFor('application').set('showFooter', true);
  },

  actions: {
    willTransition() {
      this.set('controller.domainNameSearch', '');
    }
  }
})
