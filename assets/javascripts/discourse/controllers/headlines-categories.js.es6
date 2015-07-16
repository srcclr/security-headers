import Domain from '../models/domain';
import Category from '../models/category';

export default Discourse.Controller.extend({
  needs: ['headlines'],
  chartType: 'pie',

  issueTypes: Em.computed.alias('controllers.headlines.issueTypes'),
  issueFilter: Em.computed.alias('controllers.headlines.issueFilter'),

  countries: Em.computed.alias('controllers.headlines.countries'),

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
    return "?" + this.get('countryFilter') + this.get('issueFilter');
  },

  searchNeeded: Em.observer('country', 'issueTypes.@each.selected', function() {
    this.set('loading', true);

    return Discourse.ajax(Discourse.getURL(this.searchParams())).then((data) => {
      this.set('model', _.map(data['categories'], (category) => {
        return Category.create({
          id: category.id,
          title: category.title,
          domains: _.map(category.domains, (domain) => {
            return Domain.create({
              id: domain.id,
              name: domain.name,
              rank: domain.rank,
              scanResults: domain.scan_results || {},
              score: domain.score
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