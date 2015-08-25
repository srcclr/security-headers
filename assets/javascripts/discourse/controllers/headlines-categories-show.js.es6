import Domain from '../models/domain'
import DomainNameFilter from '../mixins/domain-name-filter'
import { ratings } from '../../lib/score'

const FILTERS = ['countryFilter', 'ratingFilter', 'issueFilter', 'offsetFilter', 'domainNameFilter']
const TIME_TO_WAIT_BEFORE_UPDATE_RESULTS = 500;

export default Em.Controller.extend(DomainNameFilter, {
  needs: ['headlines'],
  ratings: ratings,
  hideSubCategories: true,
  noResults: false,

  issueTypes: Em.computed.alias('controllers.headlines.issueTypes'),
  issueFilter: Em.computed.alias('controllers.headlines.issueFilter'),

  countries: Em.computed.alias('controllers.headlines.countries'),
  country: Em.computed.alias('controllers.headlines.country'),
  countryFilter: Em.computed.alias('controllers.headlines.countryFilter'),

  hideCategories: Em.computed.alias('hideSubCategories'),
  anyCagetories: Em.computed.gt('categoriesLength', 0),

  lastScanDate: Em.computed('model.domains.@each', function() {
    let domains = this.get('model.domains');
    if (_.isEmpty(domains)) { return; }

    return domains[0].get('lastScanDate');
  }),

  categoriesLength: Em.computed('model.categories', function() {
    return this.get('model.categories').length;
  }),

  parentCategoryId: Em.computed('model.parent.id', 'model.id', function() {
    return this.get('model.parent.id') || this.get('model.id');
  }),

  searchNeeded: Em.observer(
    'country',
    'ratings.@each.selected',
    'issueTypes.@each.selected',
    'domainNameSearch',
    function() {
      Em.run.debounce(this, this.searchResults, TIME_TO_WAIT_BEFORE_UPDATE_RESULTS);
    }
  ),

  searchResults() {
    this.set('model.domains', []);
    this.set('model.allLoaded', false);
    this.loadMore();
  },

  selectedRatings: Em.computed.filterBy('ratings', 'selected', true),

  ratingFilter: Em.computed('ratings.@each.selected', function() {
    if (this.get('selectedRatings').length <= 0) { return ""; }

    let ratings = _.pluck(this.get('selectedRatings'), 'score');

    return "&ratings[]=" + ratings.join("&ratings[]=");
  }),

  offsetFilter: Em.computed('model.domains.@each', function() {
    return "&offset=" + this.get('model.domains').length;
  }),

  searchParams() {
    return "?" + FILTERS.map((name) => { return this.get(name) }).join('');
  },

  loadMore() {
    let model = this.get("model");

    if (model.get("allLoaded")) { return Ember.RSVP.resolve(); }

    this.setProperties({ noResults: false, loading: true });

    return Discourse.ajax(Discourse.getURL("/headlines/categories/" + model.id + this.searchParams())).then((data) => {
      if (data.domains.length === 0) {
        model.set("allLoaded", true);
      }
      model.domains.addObjects(_.map(data.domains, (domain) => { return Domain.createFromJson(domain); }));
      this.setProperties({ noResults: _.isEmpty(model.domains), loading: false });
    });
  },

  actions: {
    subCategoriesToggle() {
      var state = this.get('hideSubCategories');
      this.set('hideSubCategories', !state);
    }
  }
})
