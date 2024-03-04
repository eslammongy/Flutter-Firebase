part of 'user_info_cubit.dart';

@immutable
abstract class UserInfoState {}

class UserInfoInitial extends UserInfoState {}

class UserInfoLoadingState extends UserInfoState {}

class UserInfoSuccessfulState extends UserInfoState {
  final UserModel userModel;

  UserInfoSuccessfulState({required this.userModel});
}

class UserInfoFailureState extends UserInfoState {
  final String errorMsg;

  UserInfoFailureState({required this.errorMsg});
}
