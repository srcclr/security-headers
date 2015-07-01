import LoadMore from "discourse/mixins/load-more";

export default Discourse.View.extend(LoadMore, {
  eyelineSelector: '.topic-list-item',
  loading: false,

  actions: {
    loadMore() {
      if (this.get("loading") || this.get("model.allLoaded")) { return; }

      this.set("loading", true);

      this.get("controller").loadMore().then(() => {
        this.set("loading", false);
      });
    }
  }
});
