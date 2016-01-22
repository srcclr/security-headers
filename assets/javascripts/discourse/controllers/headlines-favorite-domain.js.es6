import { popupAjaxError } from "discourse/lib/ajax-error";

export default Ember.Controller.extend({
  isNever: Em.computed.equal("model.notificationType", "never"),
  isDaily: Em.computed.equal("model.notificationType", "daily"),
  isWeekly: Em.computed.equal("model.notificationType", "weekly"),
  isMonthly: Em.computed.equal("model.notificationType", "monthly"),

  actions: {
    destroy() {
      this.get("model").destroy().then(() => {
        this.get("parentController.model").removeObject(this.get("model"))
      }).catch(popupAjaxError);
    },

    setNotificationType(type) {
      let model = this.get("model");

      model.updateNotification(type).then((result) => {
        model.set("notificationType", result.notification_type);
      }).catch(popupAjaxError);
    }
  }
})
