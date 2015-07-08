import Domain from '../models/domain';
import { ratings } from '../../lib/score';

export default Discourse.Controller.extend({
  needs: ['headlines'],
  ratings: ratings,
  hideSubCategories: true,

  issueTypes: Em.computed.alias('controllers.headlines.issueTypes'),
  countries: Em.computed.alias('controllers.headlines.countries'),

  hideCategories: Em.computed('hideSubCategories', 'categoriesLength', function() {
    return this.get('categoriesLength') <= 0 || this.get('hideSubCategories');
  }),

  categoriesLength: Em.computed('model.categories', function() {
    return this.get('model.categories').length;
  }),

  searchNeeded: Em.observer('country', 'ratingFilter', function() {
    this.set('model.domains', []);
    this.set('model.allLoaded', false);
    this.loadMore();
  }),

  countryFilter: Em.computed('country', function() {
    if (this.get('country')) {
      return "&country=" + this.get('country');
    }

    return "";
  }),

  selectedRatings: Em.computed.filterBy('ratings', 'selected', true),
  selectedRatingsRanges: Em.computed.mapBy('selectedRatings', 'scoreRange'),

  ratingFilter: Em.computed('ratings.@each.selected', function() {
    let query = "";

    if (this.get('selectedRatings').length > 0) {
      let range = _.union(_.flatten(this.get('selectedRatingsRanges'))),
          lowerBound = _.min(range),
          higherBound = _.max(range);

      query = "&score_range=[" + lowerBound + "," + higherBound + "]";

      if (lowerBound == 0 && higherBound == 100 && this.get('selectedRatings').length == 2) {
        query = "&score_range=[" + this.get('ratings')[1].scoreRange + "]&exclusion_range=true";
      }
    }

    return query;
  }),

  offsetFilter: Em.computed('model.domains.@each', function() {
    return "&offset=" + this.get('model.domains').length;
  }),

  searchParams() {
    return "?" + this.get('countryFilter') + this.get('ratingFilter') + this.get('offsetFilter');
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
