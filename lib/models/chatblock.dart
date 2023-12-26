class ChatBlock {
  final List<String> messages;
  final List<String> answers;
  final List<String> responses;
  final int breakpoint;
  final int delay;

  ChatBlock(
      this.messages, this.answers, this.responses, this.breakpoint, this.delay);
}
