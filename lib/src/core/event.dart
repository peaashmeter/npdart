///Parent class for events, that may be emitted after some user input.
sealed class NovelInputEvent {}

///An event that is emitted when there are no choices and the user taps the screen.
class RequestNextEvent extends NovelInputEvent {}

///An event that is emitted when the user picks an option. Contains the result of its callback.
class DialogOptionEvent extends NovelInputEvent {
  final dynamic result;

  DialogOptionEvent({required this.result});
}
