import Category from '../models/category'

function fetchModel(category_id, query) {
  return () => { return Discourse.ajax(Discourse.getURL("/headlines/categories/" + category_id + "?" + query)); };
}

function wrapModel(model) {
  return Category.createFromJson(model);
}

export default Discourse.Route.extend({
  beforeModel() { return this.redirectIfLoginRequired(); },

  model(params) {
    let headlinesController = this.controllerFor('headlines'),
        query = headlinesController.get('countryFilter') + headlinesController.get('issueFilter');

    return PreloadStore.getAndRemove('category' + params.id, fetchModel(params.id, query)).then(wrapModel);
  },

  actions: {
    willTransition() {
      this.set('controller.domainNameSearch', '')
    }
  }
})
