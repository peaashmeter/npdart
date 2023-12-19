///An option which the user can pick when prompted.
///The [label] is a text displayed to the user.
///The [callback] is called once the option is selected.
class Choice {
  final String label;
  final Function callback;

  Choice({required this.label, required this.callback});
}
