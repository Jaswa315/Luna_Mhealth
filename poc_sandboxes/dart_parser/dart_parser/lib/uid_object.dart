// This could be TextToken instead? Has a lot of potential !!!
  // UIDObject can be renamed later and can potentially store all translation mappings
class UIDObject {
  late int uid;

  UIDObject(int id) {
    uid = id;
  }

  int getUID() {
    return uid;
  }

  void setUID(int newID) {
    uid = newID;
  }

  @override
  String toString() {
    return 'UIDObject(uid: ${getUID()})'; 
  }
}

