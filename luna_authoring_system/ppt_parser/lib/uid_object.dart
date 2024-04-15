// This could be TextToken instead? Has a lot of potential !!!
  // UIDObject can be renamed later and can potentially store all translation mappings
class UIDObject {
  late int _uid;
  late String? _text;

  UIDObject(int id, String? text) {
    _uid = id;
    _text = text;
  }

  int getUID() {
    return _uid;
  }

  void setUID(int newID) {
    _uid = newID;
  }

  String? getText() {
    return _text;
  }

  void setText(String text) {
    _text = text;
  }
  @override
  String toString() {
    return '${getUID()} : ${getText()}'; 
  }
}

