//Game Context is the temporary class to mimic JSON input into the system.

import 'dart:collection';

import 'package:flutter/foundation.dart';

class GameContext {
  GameContext() {
  }

  List<Category> categories = [];

  void addCategory(Category category) {
    categories.add(category);
  }

  void populateWithSampleData() {
    Category healthy = Category(name: "Healthy");
    healthy.AddToCategory(CategoryMember(image: "apple"));
    healthy.AddToCategory(CategoryMember(image: "brocolli"));
    healthy.AddToCategory(CategoryMember(image: "grapes"));
    healthy.AddToCategory(CategoryMember(image: "kiwi"));
    healthy.AddToCategory(CategoryMember(image: "lettuce"));
    healthy.AddToCategory(CategoryMember(image: "orange"));
    healthy.AddToCategory(CategoryMember(image: "pear"));
    healthy.AddToCategory(CategoryMember(image: "salad"));
    healthy.AddToCategory(CategoryMember(image: "yogurt"));

    
    Category unhealthy = Category(name: "Unhealthy");
    unhealthy.AddToCategory(CategoryMember(image: "chips"));
    unhealthy.AddToCategory(CategoryMember(image: "burger"));
    unhealthy.AddToCategory(CategoryMember(image: "hotdog"));
    unhealthy.AddToCategory(CategoryMember(image: "pizza"));

    categories.add(healthy);
    categories.add(unhealthy);
  }

}

class Category {
  Category({required this.name}) {

  }

  void AddToCategory(CategoryMember member) {
    members.add(member);
  }

  String name;
  List<CategoryMember> members = [];

}


class CategoryMember {

  String image;

  CategoryMember({required this.image}) {

  }
}