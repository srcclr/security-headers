export default {
  redirectIfNotLoggedIn(to) {
    const app = this.controllerFor('application');
    if (!app.get('currentUser')) {
      this.replaceWith(to);
    }
  }
}
