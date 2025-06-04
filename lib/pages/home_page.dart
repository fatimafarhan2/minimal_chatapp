import 'package:firebase_auth/firebase_auth.dart';
import 'package:flutter/material.dart';
import 'package:minimal_chatapp/auth/auth_service.dart';
import 'package:minimal_chatapp/components/my_drawer.dart';
import 'package:minimal_chatapp/components/user_tile.dart';
import 'package:minimal_chatapp/pages/chat_page.dart';
import 'package:minimal_chatapp/services/chat_services/chat_services.dart';

class HomePage extends StatefulWidget {
  HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final Chatservice _chatservice = Chatservice();
  final AuthService _authService = AuthService();
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: Text(
          'Home',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Theme.of(context).colorScheme.primary,
      ),
      body: Column(
        children: [
          // Search Bar fixed at top
          Padding(
            padding:
                const EdgeInsets.symmetric(horizontal: 16.0, vertical: 8.0),
            child: TextField(
              controller: _searchController,
              onChanged: (value) {
                setState(() {
                  _searchQuery = value.toLowerCase();
                });
              },
              decoration: InputDecoration(
                hintText: 'Search users...',
                hintStyle: TextStyle(color: Colors.black54),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(30.0),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.white, // Solid background color
                prefixIcon: Icon(
                  Icons.search,
                  color: Colors.black,
                ),
                suffixIcon: _searchQuery.isNotEmpty
                    ? IconButton(
                        icon: Icon(Icons.clear, color: Colors.black),
                        onPressed: () {
                          setState(() {
                            _searchController.clear();
                            _searchQuery = '';
                          });
                        },
                      )
                    : null,
                contentPadding: EdgeInsets.symmetric(vertical: 12.0),
              ),
              style: TextStyle(color: Colors.black), // Input text color
            ),
          ),

          // List of users
          Expanded(child: _buildUserList()),
        ],
      ),
      drawer: MyDrawer(),
    );
  }

  Widget _buildUserList() {
    return StreamBuilder(
      stream: _chatservice.getUsersStream(),
      builder: (context, snapshot) {
        if (snapshot.hasError) {
          return const Text('Error');
        }

        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Text("Loading...");
        }

        // Filter the users based on the search query
        var filteredUsers = snapshot.data!
            .where((userData) => userData['email']
                .toString()
                .toLowerCase()
                .contains(_searchQuery))
            .toList();

        return ListView(
          children: filteredUsers
              .map<Widget>(
                (userData) => _buildUserListItem(userData, context),
              )
              .toList(),
        );
      },
    );
  }

  Widget _buildUserListItem(
      Map<String, dynamic> userData, BuildContext context) {
    // Display all users except the current user
    if (userData['email'] != _authService.getcurrentuser()!.email) {
      return UserTile(
        text: userData['email'],
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ChatPage(
                receiverEmail: userData['email'],
                recieverId: userData['uid'],
              ),
            ),
          );
        },
      );
    } else {
      return Container();
    }
  }
}
