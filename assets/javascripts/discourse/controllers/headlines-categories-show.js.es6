import Domain from '../models/domain';

export default Discourse.Controller.extend({
  needs: ['headlines'],
  hideSubCategories: true,

  issueTypes: Em.computed.alias('controllers.headlines.issueTypes'),
  countries: Em.computed.alias('controllers.headlines.countries'),
  ratings: Em.computed.alias('controllers.headlines.ratings'),

  hideCategories: Em.computed('hideSubCategories', function() {
    return this.get('hideSubCategories');
  }),

  anyCagetories: Em.computed('categoriesLength', function() {
    return this.get('categoriesLength') > 0;
  }),

  categoriesLength: Em.computed('model.categories', function() {
    return this.get('model.categories').length;
  }),

  parentCategoryId: Em.computed('model.parent.id', 'model.id', function() {
    return this.get('model.parent.id') || this.get('model.id');
  }),

  searchNeeded: Em.observer('country', function() {
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

  offsetFilter: Em.computed('model.domains.@each', function() {
    return "&offset=" + this.get('model.domains').length;
  }),

  searchParams() {
    return "?" + this.get('countryFilter') + this.get('offsetFilter');
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
          scanResults: domain.scan_results
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
