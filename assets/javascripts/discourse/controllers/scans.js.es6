export default Em.Controller.extend({
  queryParams: ['url'],
  url: null,

  hasResults: Em.computed('model.score', function() {
    return this.get('model.score') != undefined;
  })
})
