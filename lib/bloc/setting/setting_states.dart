abstract class SettingStates {}

class InitailState extends SettingStates {}

class ChangeLang extends SettingStates {}

///get user
class GetUserSuccess extends SettingStates {}

class GetUserLoading extends SettingStates {}

class GetUserError extends SettingStates {}

///update user
class UpdateUserSuccess extends SettingStates {}

class UpdateUserError extends SettingStates {}

///ThemeMode
class DarkMode extends SettingStates {}

class LightMode extends SettingStates {}

class SystemMode extends SettingStates {}
