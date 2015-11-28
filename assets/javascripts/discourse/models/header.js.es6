import { iconForScore, iconForRating } from '../../lib/score'

let Header = Discourse.Model.extend({
  isHsts: Em.computed.equal("name", "strict-transport-security"),

  label: Em.computed(function() {
    return I18n.t("headlines.tests." + this.get('name') + ".label");
  }),

  title: Em.computed(function() {
    return I18n.t("headlines.tests." + this.get('name') + ".title");
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
    let rating = this.get('rating'),
        score = this.get('score');

    if (rating != undefined) {
      return iconForRating(rating);
    } else {
      return iconForScore(score);
    }
  })
})

export default Header
