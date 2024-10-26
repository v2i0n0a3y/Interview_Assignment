
import 'dart:convert';
import 'package:http/http.dart'as http;
import 'package:flutter/material.dart';
import 'InterviewModel.dart';

class HomeScreen extends StatefulWidget {
  @override
  _HomeScreenState createState() => _HomeScreenState();
}


class _HomeScreenState extends State<HomeScreen> {
  List<User> users = [];

  List<User> filteredUsers = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchUsers();
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('https://gorest.co.in/public-api/users');
    final response = await http.get(url);

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData['data'];
      setState(() {
        users = data.map((item) => User.fromJson(item)).toList();
        filteredUsers = users;
        isLoading = false;
      });
    } else {
      setState(() {
        isLoading = false;
      });
      print('Faied to load data');
    }
  }

  void filterUsers(String query) {
    List<User> results = [];
    if (query.isEmpty) {
      results = users;
    } else {
      results = users
          .where((user) => user.name.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }

    setState(() {
      filteredUsers = results;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blueAccent,
        title: Container(
          color: Colors.white,
          child: TextField(
            controller: searchController,
            onChanged: (query) => filterUsers(query),
            decoration: InputDecoration(
              hintText: 'Search by name',
              border: InputBorder.none,
              hintStyle: TextStyle(color: Colors.black54),
            ),
            style: TextStyle(color: Colors.black54, fontSize: 18),
          ),
        ),
      ),
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : ListView.builder(
        itemCount: filteredUsers.length,
        itemBuilder: (context, index) {
          final user = filteredUsers[index];
          return Padding(
            padding: const EdgeInsets.all(8.0),
            child: Card(
              color: Colors.blue,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(user.name,style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),

                    Text(user.email,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                    Text(user.gender,
                      style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                    Text(user.status,style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}













