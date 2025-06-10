class Category {
  String id;
  String name;
  String slug;

  Category({required this.id, required this.name, required this.slug});

  factory Category.fromJson(Map<String, dynamic> json) {
    return Category(id: json["id"], name: json["name"], slug: json["slug"]);
  }
}
