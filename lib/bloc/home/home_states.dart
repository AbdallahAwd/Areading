abstract class HomeStates {}

class InitialState extends HomeStates {}

class ChangeFloatIndex extends HomeStates {}

class ChangeDrop extends HomeStates {}

///text recognization
class TextRecognizationLoading extends HomeStates {}

class TextRecognizationSuccess extends HomeStates {}

class TextRecognizationError extends HomeStates {}

/// get books
class GetBooksSuccess extends HomeStates {}

class GetBooksError extends HomeStates {}

class GetBooksLoading extends HomeStates {}

/// get heighlights
//add heighlight
class AddError extends HomeStates {}

class AddLoading extends HomeStates {}

class AddSuccess extends HomeStates {}

///ThemeMode
class DarkMode extends HomeStates {}

class LightMode extends HomeStates {}

class SystemMode extends HomeStates {}
