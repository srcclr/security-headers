import { iconForScore } from '../../lib/score'

let Header = Discourse.Model.extend({
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

  scoreZero: Em.computed(function() {
    return this.get('score') === 0;
  }),

  scoreNegative: Em.computed(function() {
    return this.get('score') === -1;
  }),

  icon: Em.computed(function() {
    let score = this.get('score');
    return iconForScore(score);
  })
})

export default Header
