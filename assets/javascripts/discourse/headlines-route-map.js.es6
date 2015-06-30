export default function() {
  this.resource('headlines', function() {
    this.resource('industries');
    this.route('industry', { path: 'industries/:id' });
    this.resource('domains', { path: 'industries/:industry_id/domains/:id' });
    this.resource('scans');
  });
}
