var PREFIX = 'discourse/plugins/headlines/discourse/';

export default {
  name: 'apply-headlines',

  initialize: function(container) {
    window.Headlines = {};

    require(PREFIX + 'views/headlines').default;
  }
}
