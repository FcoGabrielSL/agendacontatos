import 'package:agendacontatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();
  List<Contact> _contacts = List();

  String _search;
  // variavel para armazenar a palavra de busca

  int _offset = 0;

  void _getContacts(String _search) {
    if (_search != null) {
      helper.searchContact(_search).then((list) {
        setState(() {
          _contacts = list;
        });
      });
    } else {
      //retorna os gifs da palavra armazenada na vareavel de busca (search)
    }
  }

  void _getAllContacts() {
    helper.getAllContacts().then((list) {
      setState(() {
        _contacts = list;
      });
    });
  }

  @override
  void initState() {
    super.initState();
    //Contact c = Contact();
    //c.name = "Maria";
    //c.email = "m@g.com";
    //c.phone = "113";
    //c.img = "m.png";
    //helper.saveContact(c).then((contact) {
    // print(contact);
    // });
    _getAllContacts();
  }

  Widget _contactCard(BuildContext context, int index) {
    var contact = _contacts[index];
    return GestureDetector(
      child: Card(
        child: Padding(
          padding: EdgeInsets.all(10.0),
          child: Row(
            children: [
              Container(
                width: 80.0,
                height: 80.0,
                decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    image: DecorationImage(
                        image: //contact.img != null
                            //? FileImage(File(contact.img)) :
                            AssetImage("images/person.png"),
                        fit: BoxFit.cover)),
              ),
              Padding(
                padding: EdgeInsets.only(left: 10.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      contact.name ?? "",
                      style: TextStyle(
                          fontSize: 22.0, fontWeight: FontWeight.bold),
                    ),
                    Text(
                      contact.phone ?? "",
                      style: TextStyle(fontSize: 22.0),
                    ),
                    Text(
                      contact.email ?? "",
                      style: TextStyle(fontSize: 22.0),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
      onTap: () {
        _showOptions(context, contact);
      },
    );
  }

  void _showOptions(BuildContext context, Contact contact) {
    showModalBottomSheet(
        context: context,
        builder: (context) {
          return BottomSheet(
            builder: (context) {
              return Container(
                padding: EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    FlatButton(
                      child: Text(
                        "Ligar",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                      onPressed: () {
                        launch("tel:${contact.phone}");
                        Navigator.pop(context);

                        //launch("tel:${contact.phone}");
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Editar",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                      onPressed: () {
                        Navigator.pop(context);
                        _showContactPage(contact: contact);
                      },
                    ),
                    FlatButton(
                      child: Text(
                        "Remover",
                        style: TextStyle(color: Colors.red, fontSize: 20.0),
                      ),
                      onPressed: () {
                        helper.deleteContact(contact.id).then((value) {
                          Navigator.pop(context);
                          _getAllContacts();
                        });
                      },
                    ),
                  ],
                ),
              );
            },
            onClosing: () {},
          );
        });
  }

  void _showContactPage({Contact contact}) {
    print("Contact Page");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Contatos"),
        backgroundColor: Colors.red,
        centerTitle: true,
      ),
      backgroundColor: Colors.white,
      floatingActionButton: FloatingActionButton(
        child: Icon(Icons.add),
        backgroundColor: Colors.red,
        onPressed: () {
          _showContactPage();
        },
      ),
      body: Column(
        children: <Widget>[
          Padding(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              decoration: InputDecoration(
                  labelText: 'Pesquise Aqui!',
                  labelStyle: TextStyle(color: Colors.white),
                  focusedBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 3.0),
                  ),
                  enabledBorder: const OutlineInputBorder(
                    borderSide: const BorderSide(color: Colors.red, width: 0.0),
                  ),
                  border: OutlineInputBorder()),
              style: TextStyle(color: Colors.black, fontSize: 18.0),
              textAlign: TextAlign.center,
              onSubmitted: (text) {
                _getContacts(text);
              },
            ),
          ),
          Expanded(
            child: ListView.builder(
              padding: EdgeInsets.all(10.0),
              itemCount: _contacts.length,
              itemBuilder: (context, index) {
                return _contactCard(context, index);
              },
            ),
          )
        ],
      ),
    );
  }
}
