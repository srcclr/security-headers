import Domain from '../models/domain';
import DomainNameFilter from '../mixins/domain-name-filter';
import { ratings } from '../../lib/score';

const FILTERS = ['countryFilter', 'ratingFilter', 'issueFilter', 'offsetFilter', 'domainNameFilter']
const TIME_TO_WAIT_BEFORE_UPDATE_RESULTS = 500;

export default Discourse.Controller.extend(DomainNameFilter, {
  needs: ['headlines'],
  ratings: ratings,
  hideSubCategories: true,

  issueTypes: Em.computed.alias('controllers.headlines.issueTypes'),
  issueFilter: Em.computed.alias('controllers.headlines.issueFilter'),

  countries: Em.computed.alias('controllers.headlines.countries'),

  hideCategories: Em.computed.alias('hideSubCategories'),
  anyCagetories: Em.computed.gt('categoriesLength', 0),

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

  countryFilter: Em.computed('country', function() {
    if (this.get('country')) {
      return "&country=" + this.get('country');
    }

    return "";
  }),

  selectedRatings: Em.computed.filterBy('ratings', 'selected', true),
  selectedRatingsRanges: Em.computed.mapBy('selectedRatings', 'scoreRange'),

  ratingFilter: Em.computed('ratings.@each.selected', function() {
    if (this.get('selectedRatings').length <= 0) {
      return "";
    }

    let range = _.union(_.flatten(this.get('selectedRatingsRanges'))),
        lowerBound = _.min(range),
        higherBound = _.max(range);

    return this.queryFromBounds(lowerBound, higherBound);
  }),

  queryFromBounds(lowerBound, higherBound) {
    let query = "";

    if (lowerBound == 0 && higherBound == 100 && this.get('selectedRatings').length == 2) {
      let poorScoreRange = this.get('ratings')[1].scoreRange;
      lowerBound = poorScoreRange[0];
      higherBound = poorScoreRange[1];
      query += "&exclusion_range=true";
    }

    return query + "&score_range[]=" + lowerBound + "&score_range[]=" + higherBound;
  },

  offsetFilter: Em.computed('model.domains.@each', function() {
    return "&offset=" + this.get('model.domains').length;
  }),

  searchParams() {
    return "?" + FILTERS.map((name) => { return this.get(name) }).join('');
  },

  loadMore() {
    let model = this.get("model");

    if (model.get("allLoaded")) { return Ember.RSVP.resolve(); }

    this.set('loading', true);

    return Discourse.ajax(Discourse.getURL(model.id + this.searchParams())).then((data) => {
      if (data.domains.length === 0) {
        model.set("allLoaded", true);
      }
      model.domains.addObjects(_.map(data.domains, (domain) => {
        return Domain.create({
          id: domain.id,
          name: domain.name,
          country: domain.country,
          scanResults: domain.scan_results,
          score: domain.score
        });
      }));
      this.set('loading', false);
    });
  },

  actions: {
    subCategoriesToggle() {
      var state = this.get('hideSubCategories');
      this.set('hideSubCategories', !state);
    }
  }
})
