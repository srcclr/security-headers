import { iconForRating } from '../../lib/score'

let Header = Discourse.Model.extend({
  isHsts: Em.computed.equal("name", "strict-transport-security"),

  label: Em.computed(function() {
    return I18n.t("headlines.tests." + this.get('name') + ".label");
  }),

  title: Em.computed(function() {
    return I18n.t("headlines.tests." + this.get('name') + ".title") + ": " + this.get("value");
  }),

  missingTitle: Em.computed(function() {
    return I18n.t("headlines.header_missing") + " " + I18n.t("headlines.tests." + this.get('name') + ".title");
  }),

  description: Em.computed(function() {
    return I18n.t("headlines.tests." + this.get('name') + ".score" + this.get('score'));
  }),

  scorePositive: Em.computed(function() {
    return this.get('score') > 0;
  }),

  icon: Em.computed(function() {
    let rating = this.get('rating');
    return iconForRating(rating);
  })
})

export default Header
