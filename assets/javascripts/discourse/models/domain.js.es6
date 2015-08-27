import { gradeIs } from '../../lib/score'
import Header from './header'
import CspTest from './csp-test'

let Domain = Discourse.Model.extend({
  http_grade: Em.computed(function() {
    return gradeIs(this.get('http_score'));
  }),

  csp_grade: Em.computed(function() {
    return gradeIs(this.get('csp_score'));
  }),

  status: Em.computed(function() {
    return gradeIs(this.get('score'));
  }),

  cspTests: Em.computed(function() {
    return [
      CspTest.create({ name: 'restrictive_default_settings', result: true }),
      CspTest.create({ name: 'allows_unsecured_http', result: false }),
      CspTest.create({ name: 'allows_unsecured_http2', result: true }),
      CspTest.create({ name: 'permissive_default_settings', result: false }),
      CspTest.create({ name: 'scripts_from_any_host', result: true }),
      CspTest.create({ name: 'styles_from_any_host', result: false })
    ];
  })
})

Domain.reopenClass({
  createFromJson(json) {
    return this.create({
      id: json.id,
      name: json.name,
      rank: json.rank,
      country: json.country,
      score: json.score,
      http_score: json.http_score,
      csp_score: json.csp_score,
      lastScanDate: json.last_scan_date,
      httpHeaders: _.map(json.http_headers, (header) => { return Header.create(header); })
    })
  }
})

export default Domain
