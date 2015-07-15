export default {
  domainNameSearch: '',
  domainNameFilter: Em.computed('domainNameSearch', function() {
    return "&domain_name=" + this.get('domainNameSearch');
  })
}
