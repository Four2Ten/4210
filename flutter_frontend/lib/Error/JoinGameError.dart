class JoinGameError extends Error {
  String errorMessage;

  JoinGameError(String errorMessage) {
    this.errorMessage = errorMessage;
  }
}