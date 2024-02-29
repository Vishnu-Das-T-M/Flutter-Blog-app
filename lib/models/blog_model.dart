class Blog {
  final String id;
  final String title;
  final String content;

  Blog({required this.id, required this.title, required this.content});

  factory Blog.fromJson(Map<String, dynamic> json) {
    return Blog(
        id: json['id'] as String,
        title: json['title'] as String,
        content: json['content'] as String);
  }
  Map<String, dynamic> toJson() {
    return {'id': id, 'title': title, 'content': content};
  }
}
