export default function() {
  this.resource('headlines', { path: 'projects/security-headers' }, function() {
    this.route('categories', { path: '/' })
    this.route('categories-show', { path: '/categories/:id' });
    this.route('domains', { path: '/categories/:category_id/domains/:id' });
    this.resource('scans');
  });
}
