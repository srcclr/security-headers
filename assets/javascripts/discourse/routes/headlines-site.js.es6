export default Discourse.Route.extend({
  model(params) {
    return Headlines.Site.find(params.id);
  }
})
