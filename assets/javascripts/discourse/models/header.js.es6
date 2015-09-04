let Header = Discourse.Model.extend({
  label: Em.computed(function() {
    return I18n.t("headlines.tests." + this.get('name') + ".label");
  }),

  title: Em.computed(function() {
    return I18n.t("headlines.tests." + this.get('name') + ".title");
  }),

  description: Em.computed(function() {
    return I18n.t("headlines.tests." + this.get('name') + ".score" + this.get('score'));
  })
})

export default Header
