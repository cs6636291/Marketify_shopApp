class Review {
  final String username;
  final int rating;
  final String comment;
  final String createdAt;

  Review({
    required this.username,
    required this.rating,
    required this.comment,
    required this.createdAt,
  });

  factory Review.fromJson(Map<String, dynamic> json) {
    return Review(
      username: json['username'] ?? 'Anonymous',
      rating: int.parse(json['rating'].toString()),
      comment: json['comment'] ?? '',
      createdAt: json['created_at'] ?? '',
    );
  }
}