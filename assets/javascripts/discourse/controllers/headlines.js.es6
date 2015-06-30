import Domain from '../models/domain';

export default Discourse.Controller.extend({
  scanUrlPlaceholder: function() {
    return I18n.t('headlines.check_form.field');
  }.property(),

  actions: {
    scanUrl() {
      this.transitionToRoute('scans', { queryParams: { url: this.get('url') } });
    }
  }
})
