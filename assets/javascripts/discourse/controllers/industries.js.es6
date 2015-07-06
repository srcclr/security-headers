import Industry from '../models/industry';
import Domain from '../models/domain';

export default Discourse.HeadlinesController = Discourse.Controller.extend({
  needs: ['headlines'],
  chartType: 'pie',

  countries: Em.computed.alias('controllers.headlines.countries'),
  issueTypes: Em.computed.alias('controllers.headlines.issueTypes'),

  showMosaicChart: Em.computed('chartType', function() {
    return this.get('chartType') == 'mosaic';
  }),

  countryFilter: Em.computed('country', function() {
    if (this.get('country')) {
      return "&country=" + this.get('country');
    }

    return "";
  }),

  searchParams() {
    return "?" + this.get('countryFilter');
  },

  searchNeeded: Em.observer('country', function() {
    this.set('loading', true);

    return Discourse.ajax(Discourse.getURL(this.searchParams())).then((data) => {
      this.set('model', _.map(data['industries'], (industry) => {
        return Industry.create({
          id: industry.id,
          name: industry.name,
          domains: _.map(industry.industry_ranked_domains, (domain) => {
            return Domain.create({
              id: domain.id,
              name: domain.name,
              rank: domain.rank,
              scanResults: domain.scan_results || {}
            });
          })
        });
      }));
      this.set('loading', false);
    });
  }),

  actions: {
    showMosaic() {
      this.set('chartType', 'mosaic');
    },

    showPie() {
      this.set('chartType', 'pie');
    }
  }
});
