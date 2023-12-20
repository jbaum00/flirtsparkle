class Chatlog {
  const Chatlog(
      {required this.id,
      required this.blockid,
      required this.sender,
      required this.message,
      required this.breakpoint});
  final int id;
  final int blockid;
  final int sender;
  final String message;
  final int breakpoint;
}
