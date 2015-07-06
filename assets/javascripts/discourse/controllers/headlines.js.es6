import Domain from '../models/domain';

export default Discourse.Controller.extend({
  scanUrlPlaceholder: function() {
    return I18n.t('headlines.check_form.field');
  }.property(),

  issueTypes: ['all',
               'strict-transport-security',
               'x-xss-protection',
               'x-content-type-options',
               'x-frame-options',
               'content-security-policy'],

  ratings: [ 'all', 'excellent', 'poor', 'bad' ],

  actions: {
    scanUrl() {
      this.transitionToRoute('scans', { queryParams: { url: this.get('url') } });
    }
  }
})
