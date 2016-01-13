import FavouriteDomain from "../models/favourite-domain";
import RedirectIfNotLoggedIn from "../mixins/redirect-if-not-logged-in";

export default Discourse.Route.extend(RedirectIfNotLoggedIn, {
  redirect() { return this.redirectIfNotLoggedIn("/projects/security-headers"); },

  model() {
    return PreloadStore.getAndRemove('favourite_domains', () => {
      return Discourse.ajax(Discourse.getURL("/security-headers/favourite_domains"));
    }).then((data) => {
      return FavouriteDomain.createList(data.favourite_domains);
    });
  },

  setupController(controller, model) {
    controller.set("model", model);
    this.controllerFor("application").set("showFooter", true);
  }
})
