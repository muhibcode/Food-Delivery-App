class FoodTypes {
  String id;

  String title;

  // FoodTypes({this.id, this.title});

  FoodTypes.fromJson(Map<String, dynamic> data) {
    id = data['_id'];
    title = data['title'];
  }
}
