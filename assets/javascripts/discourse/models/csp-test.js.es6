let CspTest = Discourse.Model.extend({
  title: Em.computed(function() {
    return I18n.t("headlines.tests.content-security-policy." + this.get('name') + ".title");
  }),

  description: Em.computed(function() {
    return I18n.t("headlines.tests.content-security-policy." + this.get('name') + ".description");
  })
})

export default CspTest
