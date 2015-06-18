import Industry from '../models/industry';

function industries() {
  return Discourse.ajax(Discourse.getURL("/headlines"))
                  .then((industries) => { return industries; });
}

function wrappedIndustries(industries) {
  return _.map(industries, (industry) => { return Industry.create(industry); })
}

export default Discourse.Route.reopen({
  beforeModel: function() { return this.redirectIfLoginRequired(); },

  model: function() {
    return PreloadStore.getAndRemove('industries', () => { return industries() });
  },

  setupController: function(controller, model) {
    controller.set('industries', wrappedIndustries(model.industries))
  }
})
