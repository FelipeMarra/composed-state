///To create a state machine just instanciate this class passing the [id]
///and the [states] that it will have, you also need to set
///what state will be the [initial] one
class StateMachine {
  ///[StateMachine]'s id, a name that identifies the machine
  final String name;

  ///The list of [State]s that make up this [StateMachine]
  final List<State> states;

  ///The [State] that will be automatically activated when the [StateMachine] is
  ///instantiated
  final String initialStateId;

  ///The [State] the [StateMachine] was in previously
  State? _lastState;
  State? get lastState => _lastState;

  ///The [State] the [StateMachine] is currently in
  State? _currentState;
  State? get currentState => _currentState;

  //TODO listen to state changes

  StateMachine({
    required this.name,
    required this.states,
    required this.initialStateId,
  }) {
    _start();
  }

  _start() async {
    //Set the current and last states as the initial one and enter it
    _currentState = states.firstWhere(
      (State state) => state.id == initialStateId,
    );
    _lastState = _currentState;
    await _currentState?.onEnter();
  }

  transitionTo(State next_state) async {
    //check if transition is valid
    if (!_currentState!.transitions.contains(next_state)) {
      throw Exception(
          """Invalid transition from ${currentState!.id} to ${next_state.id}
      The state ${currentState!.id} can only transition to:
      ${_currentState!.transitions}
      """);
    }

    //leave last state
    await _lastState?.onLeave();

    //Update last and current sates
    _lastState = _currentState;
    _currentState = next_state;

    //enter sate
    await next_state.onEnter();
  }
}

///A state for the [StateMachine]
///To create a [State] the only required param is it's [id], other params may be:
///[onEnter]: a function that is executed on enter the state.
///[onLeave]: a function that is executed on leave the state
///i.e. when making a transition from state A to state B, state A will run its
///onLeave function and after that state B will run its onEnter function
///[transitions]: if your state can go to another one than it must have a
///[Transition] to this other state inside this list
///
class State {
  final String id;
  final Function onEnter;
  final Function onLeave;

  ///The list of [Transition]s that make up this [StateMachine]
  final List<Transition> transitions;

  State({
    required this.id,
    required this.onEnter,
    required this.onLeave,
    required this.transitions,
  });

}

///This class represents the possible [Transition]s between [States]
///from the state where this transition where instanciated [to] the next one
class Transition {
  final String id;
  final String to;

  Transition({
    required this.id,
    required this.to,
  });

  @override
  String toString() {
    return "Transition id: $id, to: $to";
  }
}
