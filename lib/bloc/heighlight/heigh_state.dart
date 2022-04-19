abstract class HeighState {}

class InistalState extends HeighState {}

class ChangeDrop extends HeighState {}

class GetSuccess extends HeighState {}

/// update data
class UpdateSuccess extends HeighState {}

class UpdateError extends HeighState {}

/// delete data

class DeletedSuccess extends HeighState {}

class DeletedError extends HeighState {}
