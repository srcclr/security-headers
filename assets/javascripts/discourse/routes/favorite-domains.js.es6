import FavoriteDomain from "../models/favorite-domain";
import RedirectIfNotLoggedIn from "../mixins/redirect-if-not-logged-in";

export default Discourse.Route.extend(RedirectIfNotLoggedIn, {
  redirect() { return this.redirectIfNotLoggedIn("/projects/security-headers"); },

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
