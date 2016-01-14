let FavoriteDomain = Discourse.Model.extend({
  baseUrl: Em.computed("id", function() {
    return "/security-headers/favorite_domains/" + this.get("id");
  }),

  destroy() {
    return Discourse.ajax(this.get("baseUrl"), { type: "DELETE" });
  },

  updateNotification(type) {
    return Discourse.ajax(this.get("baseUrl") + "/email_notifications", { type: "PATCH", data: { notification_type: type } })
  }
});

FavoriteDomain.reopenClass({
  createFromJson(json) {
    return this.create({
      id: json.id,
      url: json.url,
      notificationType: json.notification_type
    });
  },

  createList(json) {
    return _.map(json, (domain) => { return this.createFromJson(domain); });
  }
});

export default FavoriteDomain;
