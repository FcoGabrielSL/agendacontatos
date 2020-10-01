import 'package:sqflite/sqflite.dart';
import 'package:path/path.dart';

class ContactHelper {
  //Singleton
  static final ContactHelper _instance = ContactHelper.internal();
  factory ContactHelper() => _instance;
  final String _tableName = "tbcontacts";

  ContactHelper.internal();

  Database _db;
  Future<Database> get db async {
    if (_db == null) {
      //Instanciar o banco de dados
      _db = await initDB();
    }
    return _db;
  }

  Future<Database> initDB() async {
    //pegar o caminho do banco
    final databasePath = await getDatabasesPath();
    final path = join(databasePath, "tbcontacts.db");
    //abre o banco de Dados, cria a tabela contacts
    return await openDatabase(path, version: 1,
        onCreate: (Database db, int newVersion) async {
      await db.execute(
          "CREATE TABLE $_tableName(id INTEGER PRIMARY KEY, name TEXT, email TEXT, phone TEXT, img TEXT)");
    });
  }

  Future<Contact> saveContact(Contact contact) async {
    Database dbContact = await db;
    contact.id = await dbContact.insert(_tableName, contact.toMap());
    return contact;
  }

  Future<Contact> getContact(int id) async {
    Database dbContact = await db;
    List<Map> maps = await dbContact.query(_tableName,
        columns: ["id", "name", "email", "phone", "img"],
        where: "id = ?",
        whereArgs: [id]);
    if (maps.length > 0) {
      return Contact.fromMap(maps.first);
    } else {
      return null;
    }
  }

  Future<List> searchContact(String q) async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery(
        "SELECT * FROM $_tableName WHERE (name LIKE '%$q%') OR (email LIKE '%$q%') OR (phone LIKE '%$q%')");
    List<Contact> listContacts = List();
    for (Map m in listMap) {
      listContacts.add(Contact.fromMap(m));
    }
    return listContacts;
  }

  Future<int> updateContact(Contact contact) async {
    Database dbContact = await db;
    return await dbContact.update(_tableName, contact.toMap(),
        where: "id = ?", whereArgs: [contact.id]);
  }

  Future<int> deleteContact(int id) async {
    Database dbContact = await db;
    return await dbContact.delete(_tableName, where: "id = ?", whereArgs: [id]);
  }

  Future<List> getAllContacts() async {
    Database dbContact = await db;
    List listMap = await dbContact.rawQuery("SELECT * FROM $_tableName");
    List<Contact> listContacts = List();
    for (Map m in listMap) {
      listContacts.add(Contact.fromMap(m));
    }
    return listContacts;
  }

  Future close() async {
    Database dbContact = await db;
    await dbContact.close();
  }
}

class Contact {
  int id;
  String name;
  String email;
  String phone;
  String img;

  Contact();

  Contact.fromMap(Map map) {
    id = map["id"];
    name = map["name"];
    email = map["email"];
    phone = map["phone"];
    img = map["img"];
  }

  Map toMap() {
    Map<String, dynamic> map = {
      "name": name,
      "email": email,
      "phone": phone,
      "img": img,
    };

    if (id != null) {
      map["id"] = id;
    }
    return map;
  }

  @override
  String toString() {
    return "Contact(id: $id, name: $name, email: $email, phone: $phone, img: $img)";
  }
}
