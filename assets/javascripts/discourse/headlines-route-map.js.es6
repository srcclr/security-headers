export default function() {
  this.resource('headlines', function() {

    this.resource('categories', { path: '/' }, function() {
      this.route('show', { path: '/:id' });
    });

    this.resource('domains', { path: 'headlines/:category_id/domains/:id' });
  });
}
