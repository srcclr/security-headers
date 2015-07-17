import Category from '../models/category'

function fetchModel(category_id) {
  return () => { return Discourse.ajax(Discourse.getURL("/headlines/categories/" + category_id)); };
}

function wrapModel(model) {
  return Category.createFromJson(model);
}

export default Discourse.Route.extend({
  beforeModel() { return this.redirectIfLoginRequired(); },

  model(params) {
    return PreloadStore.getAndRemove('category', fetchModel(params.id)).then(wrapModel);
  },

  actions: {
    willTransition() {
      this.set('controller.domainNameSearch', '')
    }
  }
})
