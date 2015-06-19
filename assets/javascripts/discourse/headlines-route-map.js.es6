export default function() {
  this.resource('headlines');
  this.resource('headlines-domain', { path: 'headlines/industries/:industry_id/domains/:id' });
}
