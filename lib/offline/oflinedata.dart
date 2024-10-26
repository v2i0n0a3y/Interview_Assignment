import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import '../InterviewModel.dart';


class OfflineUserListScreen extends StatefulWidget {
  @override
  _OfflineUserListScreenState createState() => _OfflineUserListScreenState();
}

class _OfflineUserListScreenState extends State<OfflineUserListScreen> {
  List<User> users = [];

  List<User> filteredUsers = [];
  bool isLoading = true;

  TextEditingController searchController = TextEditingController();


  @override
  void initState() {
    super.initState();
    loadData();
  }

  Future<void> loadData() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String? cachedData = prefs.getString('userList');

    if (cachedData != null) {
      List<dynamic> data = json.decode(cachedData);
      setState(() {
        users = data.map((item) => User.fromJson(item)).toList();
        filteredUsers = users;
        isLoading = false;
      });
    } else {
      fetchUsers();
    }
  }

  Future<void> fetchUsers() async {
    final url = Uri.parse('https://gorest.co.in/public-api/users');
    try {
      final response = await http.get(url);

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData['data'];

        setState(() {
          users = data.map((item) => User.fromJson(item)).toList();
          filteredUsers = users;
          isLoading = false;
        });

        SharedPreferences prefs = await SharedPreferences.getInstance();
        prefs.setString('userList', json.encode(data));
      } else {
        setState(() {
          isLoading = false;
        });
        print('Failed to load data: ${response.statusCode}');
      }
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      print('Error fetching data');
    }
  }

  void filterUsers(String query) {
    List<User> results = [];
    if (query.isEmpty) {
      results = users;
    } else {
      results = users
          .where((user) => user.email.toLowerCase().contains(query.toLowerCase()) || user.name.toLowerCase().contains(query.toLowerCase()))
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
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Container(
            color: Colors.orange.withOpacity(.2),
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
              color: Colors.green,
              child: Container(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Text(user.name,style: TextStyle(fontSize: 16, )),

                    Text(user.email,
                        style: TextStyle(fontSize: 16, )),
                    Text(user.gender,style: TextStyle(fontSize: 16, )),
                    Text(user.status,
                        style: TextStyle(fontSize: 16,)),
                  ],
                ),
              ),),
          );
        },),
    );}
}
