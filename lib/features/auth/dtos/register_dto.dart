class RegisterDto {
  final String username;
  final String password;

  const RegisterDto({
    required this.username,
    required this.password,
  });

  Map<String, dynamic> toJson() => {
        "email": username,
        "password": password,
      };
}
