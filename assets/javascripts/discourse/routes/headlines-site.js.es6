export default Discourse.Route.extend({
  model(params) {
    return Headlines.Site.find(params.industry_id, params.id);
  }
})
