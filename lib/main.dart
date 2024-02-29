import 'package:blog_crud/screens/create_blog_screen.dart';
import 'package:blog_crud/screens/home_screen.dart';
import 'package:blog_crud/screens/login_screen.dart';
import 'package:blog_crud/screens/register_screen.dart';
import 'package:blog_crud/screens/update_blog_screen.dart';
import 'package:blog_crud/screens/view_blog_screen.dart';
import 'package:blog_crud/screens/view_blogs_users.dart';
import 'package:flutter/material.dart';
import 'models/blog_model.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Blog App',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.blue),
        useMaterial3: true,
      ),
      home: const LoginScreen(),
      onGenerateRoute: (settings) {
        if (settings.name == '/home') {
          return MaterialPageRoute(
            builder: (context) => const HomeScreen(),
          );
        } else if (settings.name == '/view_auth') {
          return MaterialPageRoute(
            builder: (context) => const ViewBlogsUsers(),
          );
        } else if (settings.name == '/register') {
          return MaterialPageRoute(
            builder: (context) => const RegisterScreen(),
          );
        } else if (settings.name == '/login') {
          return MaterialPageRoute(
            builder: (context) => const LoginScreen(),
          );
        } else if (settings.name == '/view') {
          final args = settings.arguments as Map<String, dynamic>? ?? {};
          if (args.containsKey('id')) {
            final id = args['id'];
            return MaterialPageRoute(
              builder: (context) => ViewBlogScreen(id: id),
            );
          }
        } else if (settings.name == '/create') {
          return MaterialPageRoute(
            builder: (context) => const CreateBlogScreen(),
          );
        } else if (settings.name == '/update') {
          final args = settings.arguments;
          if (args != null &&
              args is Map<String, dynamic> &&
              args.containsKey('blog')) {
            final blog = args['blog']
                as Blog; // Ensure the type is explicitly cast to Blog
            return MaterialPageRoute(
              builder: (context) => UpdateBlogScreen(blog: blog),
            );
          }
        }

        return null;
        // Handle other routes here
      },
    );
  }
}
