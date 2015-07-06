import Domain from '../models/domain';

export default Discourse.Controller.extend({
  needs: ['headlines'],

  hideSubCategories: true,

  hideCatgegories: Em.computed('hideSubCategories', 'categoriesLength', function() {
   return this.get('categoriesLength') <= 0 || this.get('hideSubCategories');
  }),

  categoriesLength: Em.computed('model.categories', function() {
  return this.get('model.categories').length;
  }),

  loadMore() {
    let model = this.get("model");

    if (model.get("allLoaded")) { return Ember.RSVP.resolve(); }

    return Discourse.ajax(model.id + ".json?offset=" + model.domains.length).then((data) => {
      if (data.length === 0) {
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
    });
  },

  actions: {
    subCategoriesToggle() {
      var state = this.get('hideSubCategories');
      this.set('hideSubCategories', !state);
    }
  }
})
