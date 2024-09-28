//Game Context is the temporary class to mimic JSON input into the system.

///
class GameContext {
  ///
  GameContext({required this.categories}) {}
  ///
  List<Category> categories = [];

  ///
  factory GameContext.fromJson(Map<String, dynamic> json) {
    if (json['categories'] == null) {
      throw FormatException(
          'Expected a "categories" field with an array value.');
    }

    final categories = (json['categories'] as List<dynamic>)
        .map((slideJson) => Category.fromJson(slideJson))
        .toList();

    return GameContext(
      categories: categories,
    );
  }
}

///
class Category {
  ///
  Category({required this.categoryName, required this.members}) {}

  ///
  void addToCategory(CategoryMember member) {
    members.add(member);
  }

  ///
  String categoryName;
  ///
  List<CategoryMember> members = [];

  ///
  factory Category.fromJson(Map<String, dynamic> json) {
    if (json['members'] == null) {
      throw FormatException('Expected a "members" field with an array value.');
    }

    final members = (json['members'] as List<dynamic>)
        .map((slideJson) => CategoryMember.fromJson(slideJson))
        .toList();

    return Category(
      categoryName: json['category_name'] as String,
      members: members,
    );
  }
}

///
class CategoryMember {
  ///
  String imagePath;

  ///
  CategoryMember({required this.imagePath}) {}

  ///
  factory CategoryMember.fromJson(Map<String, dynamic> json) {
    String imagePath = json['member_image_path'];
    return CategoryMember(imagePath: imagePath);
  }
}
