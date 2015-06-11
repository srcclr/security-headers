export default Discourse.Route.reopen({
  beforeModel: function() { return this.redirectIfLoginRequired(); }
})
