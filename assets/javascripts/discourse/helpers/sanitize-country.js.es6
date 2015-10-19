Ember.Handlebars.registerBoundHelper('sanitizeCountry', function(country) {
  if (country == "United Kingdom of Great Britain and Northern Ireland") {
    return "United Kingdom";
  } else {
    return country;
  }
});
