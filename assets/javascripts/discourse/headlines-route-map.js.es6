export default function() {
  this.resource('headlines');
  this.resource('headlines-site', { path: 'headlines/industries/:industry_id/domains/:id' });
}
