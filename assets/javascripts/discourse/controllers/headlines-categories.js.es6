import Category from '../models/category'

export default Em.Controller.extend({
  needs: ['headlines'],
  chartType: 'mosaic',

  headerTypes: Em.computed.alias('controllers.headlines.headerTypes'),
  headerFilter: Em.computed.alias('controllers.headlines.headerFilter'),

  countries: Em.computed.alias('controllers.headlines.countries'),
  country: Em.computed.alias('controllers.headlines.country'),
  countryFilter: Em.computed.alias('controllers.headlines.countryFilter'),

  domainsEmpty: Em.computed('model.categories.@each.domains', function() {
    return _.every(this.get('model.categories'), (category) => { return _.isEmpty(category.domains); });
  }),

  showMosaicChart: Em.computed('chartType', function() {
    return this.get('chartType') == 'mosaic';
  }),

  searchParams: Em.computed('countryFilter', 'headerFilter', function() {
    return "?" + this.get('countryFilter') + this.get('headerFilter');
  }),

  searchNeeded: Em.observer('country', 'headerTypes.@each.selected', function() {
    Em.run.debounce(this, this.loadMore(), 500);
  }),

  loadMore() {
    return () => {
      this.set('loading', true);
      return Discourse.ajax(Discourse.getURL(this.get('searchParams'))).then((data) => {
        this.set('model.categories', _.map(data['categories'], (category) => { return Category.createFromJson(category); }));
        this.set('loading', false);
      });
    }
  },

  actions: {
    showMosaic() {
      this.set('chartType', 'mosaic');
    },

    showPie() {
      this.set('chartType', 'pie');
    }
  }
})
