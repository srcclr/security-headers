export default function() {
  this.resource('headlines');
  this.resource('headlines-site', { path: 'headlines/domains/:id' });
}
