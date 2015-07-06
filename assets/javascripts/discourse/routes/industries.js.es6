import Industry from '../models/industry';
import Domain from '../models/domain';

function industries() {
  return Discourse.ajax(Discourse.getURL("/headlines/industries"))
                  .then((industries) => { return industries; });
}

function industryDomains(industry) {
  return _.map(industry.industry_ranked_domains, (domain) => {
    return Domain.create({
      id: domain.id,
      name: domain.name,
      rank: domain.rank,
      scanResults: domain.scan_results || {}
    });
  })
}

function wrappedIndustries(industries) {
  return _.map(industries['industries'], (industry) => {
    return Industry.create({
      id: industry.id,
      name: industry.name,
      domains: industryDomains(industry)
    });
  });
}

export default Discourse.Route.reopen({
  beforeModel: function() { return this.redirectIfLoginRequired(); },

  model: function() {
    return PreloadStore.getAndRemove('industries', industries).then(wrappedIndustries);
  }
})
