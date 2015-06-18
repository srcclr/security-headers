Ember.Handlebars.registerBoundHelper('localeInterpolation', function(staticLocale, interpolate) {
  return I18n.t(`${staticLocale}.${interpolate}`);
});
