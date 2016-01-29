import FavoriteDomain from "../models/favorite-domain";

export default Discourse.Route.extend({
  model() {
    return PreloadStore.getAndRemove('favorite_domains', () => {
      return Discourse.ajax(Discourse.getURL("/security-headers/favorite_domains"));
    }).then((data) => {
      return FavoriteDomain.createList(data.favorite_domains);
    });
  },

  setupController(controller, model) {
    controller.set("model", model);
    this.controllerFor("application").set("showFooter", true);
  }
})
