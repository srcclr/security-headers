import Category from '../models/category'

export default Discourse.Controller.extend({
  needs: ['headlines'],
  chartType: 'pie',

  issueTypes: Em.computed.alias('controllers.headlines.issueTypes'),
  issueFilter: Em.computed.alias('controllers.headlines.issueFilter'),

  countries: Em.computed.alias('controllers.headlines.countries'),
  country: Em.computed.alias('controllers.headlines.country'),
  countryFilter: Em.computed.alias('controllers.headlines.countryFilter'),

  showMosaicChart: Em.computed('chartType', function() {
    return this.get('chartType') == 'mosaic';
  }),

  searchParams: Em.computed('countryFilter', 'issueFilter', function() {
    return "?" + this.get('countryFilter') + this.get('issueFilter');
  }),

  searchNeeded: Em.observer('country', 'issueTypes.@each.selected', function() {
    this.set('loading', true);

    Em.run.debounce(this, () => {
      return Discourse.ajax(Discourse.getURL(this.get('searchParams'))).then((data) => {
        this.set('model', _.map(data['categories'], (category) => {
          return Category.createFromJson(category);
        }));
        this.set('loading', false);
      });
    }, 500);
  }),

  actions: {
    showMosaic() {
      this.set('chartType', 'mosaic');
    },

    showPie() {
      this.set('chartType', 'pie');
    },

    viewAllSites(category) {
      PreloadStore.store('categories', this.get('model'));
      this.transitionToRoute('headlines.categories-show', category);
    }
  }
})
