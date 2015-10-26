import CspTest from './csp-test'

let CspHeader = Discourse.Model.extend({ })

CspHeader.reopenClass({
  createFromJson(json) {
    return this.create({
      name: json.name,
      value: json.value,
      directives: _(json.value.split(';')).map(String.trim).compact().value(),
      score: json.score,
      tests: _.map(json.tests, (test) => { return CspTest.create(test) })
    })
  }
})

export default CspHeader
