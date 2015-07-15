export default {
  domainNameSearch: '',
  domainNameFilter: Em.computed('domainNameSearch', function() {
    if (this.get('domainNameSearch').length == 0) { return ''; }

    return "&domain_name=" + this.get('domainNameSearch');
  })
}
