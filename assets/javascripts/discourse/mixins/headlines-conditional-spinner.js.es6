export default {
  actions: {
    loading: function() {
      this.controllerFor('headlines').set('loading', true)
    },

    didTransition: function() {
      this.controllerFor('headlines').set('loading', false)
    }
  }
}
