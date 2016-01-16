export default function() {
  this.resource("headlines", { path: "security-headers" }, function() {
    this.route("categories", { path: "/" })
    this.route("categories-show", { path: "/categories/:id" });
    this.route("domains", { path: "/categories/:category_id/domains/:id" });
    this.resource("scans");
  });
  this.route("favorite-domains", { path: "security-headers/favorite-domains" });
}
