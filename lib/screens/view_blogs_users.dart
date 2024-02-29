import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../models/blog_model.dart';

class ViewBlogsUsers extends StatefulWidget {
  const ViewBlogsUsers({Key? key}) : super(key: key);

  @override
  State<ViewBlogsUsers> createState() => _ViewBlogsUsersState();
}

class _ViewBlogsUsersState extends State<ViewBlogsUsers> {
  List<Blog> _loadedBlogs = [];
  final _storage = FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    const apiUrl = 'https://demo-blog.mashupstack.com/api/user/posts';
    String? authToken = await _storage.read(key: 'token');

    try {
      if (authToken == null) {
        throw Exception('No token found');
      }

      final headers = {
        'Authorization': 'Bearer $authToken',
      };

      final response = await http.get(Uri.parse(apiUrl), headers: headers);

      if (response.statusCode == 200) {
        final data = json.decode(response.body) as List<dynamic>;
        setState(() {
          _loadedBlogs = data.map((item) => Blog.fromJson(item)).toList();
        });
      } else {
        print('Failed to fetch posts: ${response.statusCode}');
      }
    } catch (e) {
      print('Error: $e');
    }
  }

  Future<void> _logout() async {
    String? authToken = await _storage.read(key: 'token');

    final headers = {
      'Authorization': 'Bearer $authToken',
    };
    final response = await http.post(
      Uri.parse('https://demo-blog.mashupstack.com/api/logout'),
      headers: headers,
    );

    if (response.statusCode == 200) {
      await _storage.deleteAll();
      Navigator.pushReplacementNamed(context, '/login');
    } else {
      print('Failed to logout: ${response.statusCode}');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blogs'),
        centerTitle: true,
        backgroundColor: Colors.cyan,
        actions: [
          IconButton(onPressed: _logout, icon: const Icon(Icons.exit_to_app))
        ],
      ),
      body: SafeArea(
        child: ListView.builder(
          itemCount: _loadedBlogs.length,
          itemBuilder: (BuildContext ctx, index) {
            var blog = _loadedBlogs[index];
            return Card(
              margin: const EdgeInsets.all(14.0),
              elevation: 4.0,
              child: Padding(
                padding: const EdgeInsets.all(2.0),
                child: ListTile(
                  title: Text(blog.title),
                  trailing: Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      IconButton(
                        icon: const Icon(Icons.remove_red_eye),
                        onPressed: () {
                          Navigator.of(context)
                              .pushNamed('/view', arguments: {'id': blog.id});
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.edit),
                        onPressed: () async {
                          final updatedBlog = await Navigator.pushNamed(
                            context,
                            '/update',
                            arguments: {'blog': blog},
                          );

                          if (updatedBlog != null && updatedBlog is Blog) {
                            setState(() {
                              // Find the index of the updated blog in _loadedBlogs
                              final index = _loadedBlogs
                                  .indexWhere((b) => b.id == updatedBlog.id);
                              if (index != -1) {
                                // Replace the old blog with the updated one
                                _loadedBlogs[index] = updatedBlog;
                              }
                            });
                          }
                        },
                      ),
                      IconButton(
                        icon: const Icon(Icons.delete),
                        onPressed: () async {
                          final confirmed = await showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: const Text('Confirm Delete'),
                                content: const Text(
                                    'Are you sure you want to delete this blog?'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(false);
                                    },
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () {
                                      Navigator.of(context).pop(true);
                                    },
                                    child: const Text('Delete'),
                                  ),
                                ],
                              );
                            },
                          );

                          if (confirmed == true) {
                            final apiUrl =
                                'https://demo-blog.mashupstack.com/api/posts/${blog.id}';
                            try {
                              final response =
                                  await http.delete(Uri.parse(apiUrl));
                              if (response.statusCode == 200) {
                                // Remove the deleted blog from the list
                                setState(() {
                                  _loadedBlogs
                                      .removeWhere((b) => b.id == blog.id);
                                });
                                ScaffoldMessenger.of(context).showSnackBar(
                                  const SnackBar(
                                    content: Text('Blog deleted successfully.'),
                                  ),
                                );
                              } else {
                                print(
                                    'Failed to delete Blog. Error code: ${response.statusCode}');
                                print('Error response: ${response.body}');
                              }
                            } catch (e) {
                              print('Error: $e');
                            }
                          }
                        },
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).pushNamed(
            '/create',
          );
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
