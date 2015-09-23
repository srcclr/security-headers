import { iconForScore } from '../../lib/score'

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
    return iconForScore(score);
  })
})

export default CspTest
