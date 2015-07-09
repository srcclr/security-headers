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

  countries: Em.computed(() => {
    return _.map(Discourse.SiteSettings.countries.split('|'), function(country) {
      return { name: country };
    });
  }),

  actions: {
    scanUrl() {
      this.transitionToRoute('scans', { queryParams: { url: this.get('url') } });
    }
  }
})
