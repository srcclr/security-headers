import FavoriteDomain from "../models/favorite-domain";
import BufferedContent from "discourse/mixins/buffered-content";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Ember.Controller.extend(BufferedContent, {
  addMode: false,

  actions: {
    addDomain() {
      this.set('addMode', true);
    },

    save() {
      let attrs = this.get("buffered").getProperties("url");

      return Discourse.ajax("/security-headers/favorite_domains", {
        type: "POST",
        data: { favorite_domain: attrs }
      }).then((result) => {
        this.get("model").pushObject(FavoriteDomain.createFromJson(result.favorite_domain));
        this.set("addMode", false);
        this.commitBuffer();
      }).catch(popupAjaxError);
    },

    cancel() {
      this.rollbackBuffer();
      this.set("addMode", false);
    }
  }
})
