import 'package:agendacontatos/helpers/contact_helper.dart';
import 'package:flutter/material.dart';

class HomePage extends StatefulWidget {
  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  ContactHelper helper = ContactHelper();

  @override
  void initState() {
    super.initState();

    //Contact c = Contact();
    //c.name = "Lucas Leonardo";
    //c.email = "lucasleonardo@gmail.com";
    // c.phone = "121212";
    //c.img = "ftLucLeo";
    //helper.saveContact(c).then((contact) {
    //  print(contact);
    //});

    //helper.getContact(2).then((c) {
    //  c.email = "joao@joao.com";
    //  helper.updateContact(c);
    // });

    helper.getAllContacts().then((list) {
      print(list);
    });

    helper.searchContact("Leonardo").then((list) {
      print(list);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
