class User {
  final int id;
  final String lastname;
  final String fsname;
  final String imageURL;

  User({
    this.id,
    this.lastname,
    this.fsname,
    this.imageURL
  });

  factory User.fromJson(Map<String, dynamic> json){
    return User(
        id: int.parse(json['id'].toString()),
        lastname: json['lastname'] as String,
        fsname: json['fsname'] as String,
      );
  }

  factory User.fromMap(Map<String, dynamic> json) => new User(
        id: json['id'],
        fsname: json['fsname'],
        lastname: json['lastname'],
      );

}
