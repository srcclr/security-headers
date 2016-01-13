let FavouriteDomain = Discourse.Model.extend({
  destroy() {
    return Discourse.ajax("/security-headers/favourite_domains/" + this.get("id"), { type: "DELETE" });
  },
});

FavouriteDomain.reopenClass({
  createFromJson(json) {
    return this.create({
      id: json.id,
      name: json.name
    });
  },

  createList(json) {
    return _.map(json, (domain) => { return this.createFromJson(domain); });
  }
});

export default FavouriteDomain;
