import CspTest from './csp-test'

let CspHeader = Discourse.Model.extend({ })

CspHeader.reopenClass({
  createFromJson(json) {
    return this.create({
      name: json.name,
      value: json.value,
      directives: json.value && _.map(json.value.split('; '), (directive) => {
        var idx = directive.indexOf(' ');
        var name = directive.substr(0, idx);
        var value = directive.substr(idx + 1, directive.length - idx - 1);
        return { name: name, value: value }
      }),
      score: json.score,
      tests: _.map(json.tests, (test) => { return CspTest.create(test) })
    })
  }
})

export default CspHeader
