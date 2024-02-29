import 'package:blog_crud/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class ViewBlogScreen extends StatefulWidget {
  final String id;
  const ViewBlogScreen({super.key, required this.id});

  @override
  State<ViewBlogScreen> createState() => _ViewBlogScreenState();
}

class _ViewBlogScreenState extends State<ViewBlogScreen> {
  Blog? _loadedBlog; // Use a single Blog object instead of a list
  final baseUrl = 'https://demo-blog.mashupstack.com/api/posts';

  Future<void> _fetchData() async {
    final id = widget.id;
    final apiUrl = '$baseUrl/$id';
    final response = await http.get(Uri.parse(apiUrl));
    if (response.statusCode == 200) {
      final data =
          json.decode(response.body) as Map<String, dynamic>; // Decode as Map
      setState(() {
        _loadedBlog = Blog.fromJson(data); // Assign the decoded object directly
      });
    } else {
      print('failed to fetch post: ${response.statusCode}');
    }
  }

  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Blog'),
        backgroundColor: Colors.cyan,
        centerTitle: true,
      ),
      body: SafeArea(
        child: _loadedBlog != null
            ? SingleChildScrollView(
                physics: const BouncingScrollPhysics(),
                child: Padding(
                    padding: const EdgeInsets.all(15.0),
                    child: Column(
                      children: [
                        SizedBox(height: 10,),
                        Center(
                          child: Text(
                            _loadedBlog!.title,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w600,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        ),
                        const SizedBox(
                          height: 10,
                        ),
                        Center(
                          child: Text(
                            _loadedBlog!.content,
                            style: const TextStyle(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                              letterSpacing: 0.3,
                            ),
                            textAlign: TextAlign.justify,
                          ),
                        )
                      ],
                    )),
              )
            : const Center(child: CircularProgressIndicator()),
      ),
    );
  }
}
