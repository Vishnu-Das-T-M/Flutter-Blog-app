import 'package:blog_crud/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class CreateBlogScreen extends StatefulWidget {
  const CreateBlogScreen({Key? key});

  @override
  State<CreateBlogScreen> createState() => _CreateBlogScreenState();
}

class _CreateBlogScreenState extends State<CreateBlogScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController();
    _contentController = TextEditingController();
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a title';
    }
    return null;
  }

  String? _validateContent(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter a content';
    }
    return null;
  }

  Future<void> _postBlogData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    const apiUrl = 'https://demo-blog.mashupstack.com/api/posts';

    final blog = Blog(
      id: '', // Leave ID empty for creating a new blog
      title: _titleController.text,
      content: _contentController.text,
    );

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(blog.toJson()),
      );

      if (response.statusCode == 200) {
        Navigator.pop(context);
        Navigator.pushReplacementNamed(context, '/home');
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Blog added successfully.'),
          ),
        );
      } else {
        print('Failed to post blog data. Error code: ${response.statusCode}');
        print('Error response: ${response.body}');
        // Show error message to user
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Failed to add blog. Please try again.'),
          ),
        );
      }
    } catch (e) {
      print('Error: $e');
      // Show error message to user
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occurred. Please try again later.'),
        ),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Blog'),
        centerTitle: true,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              TextFormField(
                controller: _titleController,
                decoration: const InputDecoration(labelText: 'Blog Title'),
                validator: _validateTitle,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Blog Content'),
                validator: _validateContent,
                maxLines: 4,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _postBlogData,
                child: const Text('Add Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
