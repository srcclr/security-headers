let CspTest = Discourse.Model.extend({
  title: Em.computed(function() {
    return I18n.t("headlines.tests.content-security-policy." + this.get('name') + ".title");
  }),

  description: Em.computed(function() {
    return I18n.t("headlines.tests.content-security-policy." + this.get('name') + ".description");
  }),

  isApplicable: Em.computed(function() {
    return this.get('score') != 0;
  }),

  icon: Em.computed(function() {
    let score = this.get('score');

    if (score > 0) {
      return 'fa-check-circle';
    } else if (score < 0) {
      return 'fa-times-circle';
    }

    return 'fa-minus-circle';
  })
})

export default CspTest
