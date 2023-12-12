class Profile {
  const Profile({
    required this.id,
    required this.name,
    required this.bio,
    required this.attribute,
    required this.profileimagepath,
    required this.matched,
    required this.finished,
  });
  final int id;
  final String name;
  final String bio;
  final String attribute;
  final String profileimagepath;
  final int matched;
  final int finished;
}
