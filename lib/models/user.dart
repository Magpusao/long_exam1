class User {
  final int id;
  final String firstName;
  final String lastName;
  final String email;
  final String image;
  final String username;
  final String accessToken;
  final String refreshToken;

  const User({
    required this.id,
    required this.firstName,
    required this.lastName,
    required this.email,
    required this.image,
    this.username = '',
    this.accessToken = '',
    this.refreshToken = '',
  });

  String get fullName => '$firstName $lastName'.trim();

  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] ?? 0,
      firstName: json['firstName'] ?? json['first_name'] ?? '',
      lastName: json['lastName'] ?? json['last_name'] ?? '',
      email: json['email'] ?? '',
      image: json['image'] ?? '',
      username: json['username'] ?? '',
      accessToken: json['accessToken'] ?? '',
      refreshToken: json['refreshToken'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'image': image,
      'username': username,
      'accessToken': accessToken,
      'refreshToken': refreshToken,
    };
  }
}
