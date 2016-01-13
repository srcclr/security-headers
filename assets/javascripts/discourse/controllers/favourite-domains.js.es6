import FavouriteDomain from "../models/favourite-domain";
import BufferedContent from "discourse/mixins/buffered-content";
import { popupAjaxError } from "discourse/lib/ajax-error";

export default Ember.Controller.extend(BufferedContent, {
  addMode: false,

  actions: {
    addDomain() {
      this.set('addMode', true);
    },

    save() {
      let attrs = this.get("buffered").getProperties("name");

      return Discourse.ajax("/security-headers/favourite_domains", {
        type: "POST",
        data: { favourite_domain: attrs }
      }).then((result) => {
        this.get("model").pushObject(FavouriteDomain.createFromJson(result.favourite_domain));
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
