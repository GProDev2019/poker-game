class LocalStore {
  int onlinePlayerIndex;
  bool waitingInRoom = false;
  bool onlineTurnEnded = false;
  int currentOnlineRoom;

  bool isOnlineGame() {
    return onlinePlayerIndex != null;
  }
}
