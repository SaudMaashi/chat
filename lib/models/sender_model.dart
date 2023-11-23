class SenderModel {
  SenderModel({
    required this.email,
    required this.password,
  });
  String email;
  String password;

  void setEmail(String email) {
    this.email = email;
  }

  void setPassword(String password) {
    this.password = password;
  }
}
