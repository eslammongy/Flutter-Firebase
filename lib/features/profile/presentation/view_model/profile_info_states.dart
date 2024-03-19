part of 'profile_info_cubit.dart';

abstract class ProfileInfoStates {}

class ProfileInfoInitialState extends ProfileInfoStates {}

class ProfileInfoLoadingState extends ProfileInfoStates {}

class ProfileInfoCreatedState extends ProfileInfoStates {
  final UserModel userModel;

  ProfileInfoCreatedState({required this.userModel});
}

class ProfileInfoFetchedState extends ProfileInfoStates {
  final UserModel userModel;

  ProfileInfoFetchedState({required this.userModel});
}

class ProfileInfoFailureState extends ProfileInfoStates {
  final String errorMsg;

  ProfileInfoFailureState({required this.errorMsg});
}
