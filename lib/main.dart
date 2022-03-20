import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:jsonn/model/user_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({Key? key}) : super(key: key);

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  List<Data> users = [];
  var url = 'https://reqres.in/api/users?page=2';

   fetchData() async {
    var res = await http.get(Uri.parse(url));
    if (res.statusCode == 200) {
      var jsonBody = jsonDecode(res.body);

      var data = jsonBody["data"] as List;

      users = data.map((map) => Data.fromJson(map)).toList();

      for(var i in users){
        print(i.firstName);
      }

      return users;
    }
  }

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Scaffold(
        appBar: AppBar(
          title: Text('Json Api'),
          centerTitle: true,
          backgroundColor: Colors.amber,
        ),
        body: FutureBuilder(
          future: fetchData(),
          builder:(context, snapshot){
            if(snapshot.hasData){
              return ListView.builder(
                itemCount: users.length,
                itemBuilder: (context, index) {
                return ListTile(
                title: Text(
                    '${users[index].firstName} ${users[index].lastName}'),
                subtitle: Text('${users[index].email}'),
                leading: CircleAvatar(
                    backgroundImage: NetworkImage(users[index].avatar!)),
              );
            });
            }else{
              return Center(
                child: Text('error'),
              );
            }
          }
      ),
    )
    );
  }
}
