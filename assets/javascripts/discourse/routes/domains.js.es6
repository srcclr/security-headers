export default Discourse.Route.extend({
  model(params) {
    return Headlines.Domain.find(params.id);
  }
})
