var PREFIX = 'discourse/plugins/headlines/discourse/';

export default {
  name: 'apply-headlines',

  initialize: function(container) {
    window.Headlines = {};

    Headlines.Domain = require(PREFIX + 'models/domain').default;
    Headlines.ScanResult = require(PREFIX + 'models/scan').default;

    require(PREFIX + 'routes/domains').default;
  }
};
