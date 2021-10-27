class FriendsMessage {
  final String name;
  final String profileImageUrl;
  final String latestMessage;
  final String latestMessageTime;
  final bool isActive;

  const FriendsMessage(this.name, this.profileImageUrl, this.latestMessage,
      this.latestMessageTime, this.isActive);
}
