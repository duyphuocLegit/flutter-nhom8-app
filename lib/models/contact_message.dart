class ContactMessage {
  final String id;
  final String name;
  final String email;
  final String message;
  final DateTime timestamp;
  final String? userId; // Optional - if user is logged in
  final String status; // 'pending', 'read', 'replied'

  ContactMessage({
    required this.id,
    required this.name,
    required this.email,
    required this.message,
    required this.timestamp,
    this.userId,
    this.status = 'pending',
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'email': email,
      'message': message,
      'timestamp': timestamp.toIso8601String(),
      'userId': userId,
      'status': status,
    };
  }

  factory ContactMessage.fromMap(Map<String, dynamic> map) {
    return ContactMessage(
      id: map['id'] ?? '',
      name: map['name'] ?? '',
      email: map['email'] ?? '',
      message: map['message'] ?? '',
      timestamp: DateTime.parse(map['timestamp']),
      userId: map['userId'],
      status: map['status'] ?? 'pending',
    );
  }

  ContactMessage copyWith({
    String? id,
    String? name,
    String? email,
    String? message,
    DateTime? timestamp,
    String? userId,
    String? status,
  }) {
    return ContactMessage(
      id: id ?? this.id,
      name: name ?? this.name,
      email: email ?? this.email,
      message: message ?? this.message,
      timestamp: timestamp ?? this.timestamp,
      userId: userId ?? this.userId,
      status: status ?? this.status,
    );
  }
}
