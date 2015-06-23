export default function() {
  this.resource('headlines', function() {
    this.resource('industries');
    this.resource('domains', { path: 'industries/:industry_id/domains/:id' });
  });
}
