// This could be TextToken instead? Has a lot of potential !!!
  // UIDObject can be renamed later and can potentially store all translation mappings
class UIDObject {
  late int _uid;

  UIDObject(int id) {
    _uid = id;
  }

  int getUID() {
    return _uid;
  }

  void setUID(int newID) {
    _uid = newID;
  }

  @override
  String toString() {
    return 'UIDObject(uid: ${getUID()})'; 
  }
}

