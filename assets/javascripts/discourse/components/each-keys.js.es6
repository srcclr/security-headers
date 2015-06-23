export default Ember.Component.extend({
  items: Ember.computed('object', function() {
    var object = Ember.get(this, 'object');

    var keys = Ember.keys(object);

    return keys.map(function(key) {
      return { key: key, value: object[key] };
    })
  })
})
