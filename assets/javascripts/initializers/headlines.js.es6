var PREFIX = 'discourse/plugins/headlines/discourse/';

export default {
  name: 'apply-headlines',

  initialize: function(container) {
    window.Headlines = {};

    Headlines.Domain = require(PREFIX + 'models/domain').default;

    require(PREFIX + 'routes/domains').default;
  }
};
