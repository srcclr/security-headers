var PREFIX = 'discourse/plugins/headlines/discourse/';

export default {
  name: 'apply-headlines',

  initialize: function(container) {
    window.Headlines = {};

    Headlines.Site = require(PREFIX + 'models/site').default;

    require(PREFIX + 'routes/headlines-site').default;
  }
};
