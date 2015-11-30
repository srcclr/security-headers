import { gradeIs } from '../../lib/score'
import Header from './header'
import CspHeader from './csp-header'

let Domain = Discourse.Model.extend({
  http_grade: Em.computed(function() {
    return gradeIs(this.get('http_score'));
  }),

  csp_grade: Em.computed(function() {
    return gradeIs(this.get('csp_score'));
  }),

  status: Em.computed(function() {
    return gradeIs(this.get('score'));
  })
})

Domain.reopenClass({
  createFromJson(json) {
    return this.create({
      id: json.id,
      name: json.name,
      rank: json.rank,
      country: json.country,
      sslEnabled: json.ssl_enabled,
      score: json.score,
      http_score: json.http_score,
      csp_score: json.csp_score,
      lastScanDate: json.last_scan_date,
      error: json.error,
      httpHeaders: _.map(json.http_headers, (header) => { return Header.create(header); }),
      cspHeader: CspHeader.createFromJson(json.csp_header || {})
    })
  }
})

export default Domain
