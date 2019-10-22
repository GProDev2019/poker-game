class LocalStore {
  int onlinePlayerIndex;
  bool waitingInRoom = false;
  bool onlineTurnEnded = false;
  bool coverCards = true;
  int currentOnlineRoom;
  String playerName = '';

  bool isOnlineGame() {
    return onlinePlayerIndex != null;
  }
}
