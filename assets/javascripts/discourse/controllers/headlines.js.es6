import Domain from '../models/domain';
import { issueTypes } from '../../lib/score';

export default Discourse.Controller.extend({
  scanUrlPlaceholder: function() {
    return I18n.t('headlines.check_form.field');
  }.property(),

  issueTypes: issueTypes,

  issueFilter: Em.computed('issueTypes.@each.selected', function() {
    let selectedIssues = _.filter(this.get('issueTypes'), (issue) => { return issue.selected; }),
        query = "";

    selectedIssues.forEach((issue) => { query += "&issues[]=" + issue.name });

    return query;
  }),

  countries: Em.computed(() => {
    return _.map(Discourse.SiteSettings.countries.split('|'), function(country) {
      return { name: country };
    });
  }),

  countryFilter: Em.computed('country', function() {
    if (this.get('country')) {
      return "&country=" + this.get('country');
    }

    return "";
  }),

  actions: {
    scanUrl() {
      this.transitionToRoute('scans', { queryParams: { url: this.get('url') } });
    }
  }
})
