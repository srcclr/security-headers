export default function() {
  this.resource('headlines');
  this.resource('domains', { path: 'headlines/domains/:id' });
}
