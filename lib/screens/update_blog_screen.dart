import 'package:blog_crud/models/blog_model.dart';
import 'package:flutter/material.dart';
import 'dart:convert';
import 'package:http/http.dart' as http;

class UpdateBlogScreen extends StatefulWidget {
  final Blog blog;

  const UpdateBlogScreen({super.key, required this.blog});

  @override
  State<UpdateBlogScreen> createState() => _UpdateBlogScreenState();
}

class _UpdateBlogScreenState extends State<UpdateBlogScreen> {
  late TextEditingController _titleController;
  late TextEditingController _contentController;
  final _formKey = GlobalKey<FormState>();

  @override
  void initState() {
    super.initState();
    _titleController = TextEditingController(text: widget.blog.title);
    _contentController = TextEditingController(text: widget.blog.content);
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String? _validateTitle(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter title';
    }
    return null;
  }

  String? _validateContent(String? value) {
    if (value == null || value.isEmpty) {
      return 'Please enter content';
    }
    return null;
  }

  void _updateBlogData() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    final String apiUrl =
        'https://demo-blog.mashupstack.com/api/posts/${widget.blog.id}';

    Blog updatedBlog = Blog(
      id: widget.blog.id,
      title: _titleController.text,
      content: _contentController.text,
    );

    try {
      final response = await http.post(
        Uri.parse(apiUrl),
        body: jsonEncode(updatedBlog.toJson()),
      );

      if (response.statusCode == 200) {
        // Request successful.

        Navigator.pop(context, updatedBlog);
        ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text('Blog updated successfully.'),
        )); // Navigate back to the previous screen
      } else {
        // Request failed.
        print('Failed to update Blog. Error code: ${response.statusCode}');
        print('Error response: ${response.body}');
      }
    } catch (e) {
      // Handle the error here
      print('Error: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Update Blog'),
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
                decoration: const InputDecoration(labelText: 'Blog title'),
                validator: _validateTitle,
              ),
              TextFormField(
                controller: _contentController,
                decoration: const InputDecoration(labelText: 'Blog content'),
                validator: _validateContent,
                maxLines: 5,
              ),
              const SizedBox(height: 20),
              ElevatedButton(
                onPressed: _updateBlogData,
                child: const Text('Update Blog'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
