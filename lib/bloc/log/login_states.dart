abstract class LoginStates {}

class InitialState extends LoginStates {}

//log in states
class LoginStateSuccess extends LoginStates {}

class LoginStateError extends LoginStates {
  final String error;

  LoginStateError(this.error);
}

class LoginStateLoading extends LoginStates {}
//save user data

class SaveUserDataSuccess extends LoginStates {}

class SaveUserDataError extends LoginStates {
  final String error;

  SaveUserDataError(this.error);
}

//log out
class LogoutStateSuccess extends LoginStates {}

class UpdateUserSuccess extends LoginStates {}

class UpdateUserError extends LoginStates {}
