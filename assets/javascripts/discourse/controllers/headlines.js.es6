import Domain from '../models/domain';
import { headerTypes } from '../../lib/score';

export default Em.Controller.extend({
  scanUrlPlaceholder: function() {
    return I18n.t('headlines.check_form.field');
  }.property(),

  headerTypes: headerTypes,
  country: '',

  headerFilter: Em.computed('headerTypes.@each.selected', function() {
    let selectedHeaders = _.filter(this.get('headerTypes'), (header) => { return header.selected; }),
        query = "";

    selectedHeaders.forEach((header) => { query += "&headers[]=" + header.name });

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
