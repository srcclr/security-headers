import Spinner from '../mixins/headlines-conditional-spinner'

export default Discourse.Route.extend(Spinner, {
  beforeModel() { return this.redirectIfLoginRequired(); }
})
