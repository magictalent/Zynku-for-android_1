import 'package:flutter/material.dart';
import 'Pages/ProfilePage.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Profile Test',
      home: Scaffold(
        appBar: AppBar(title: Text('Profile Test')),
        body: Center(
          child: ElevatedButton(
            onPressed: () {
              Navigator.push(
                context,
                MaterialPageRoute(builder: (context) => UserdetailsWidget()),
              );
            },
            child: Text('Open Profile'),
          ),
        ),
      ),
    );
  }
}
