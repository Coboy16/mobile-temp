class Employee {
  final String id;
  final String name;
  final String role;
  final String department;

  const Employee({
    required this.id,
    required this.name,
    required this.role,
    required this.department,
  });

  @override
  String toString() {
    return name;
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is Employee && runtimeType == other.runtimeType && id == other.id;

  @override
  int get hashCode => id.hashCode;
}
