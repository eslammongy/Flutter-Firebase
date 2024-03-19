import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/errors/auth_exceptions_handler.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';
import 'package:flutter_firebase/features/profile/data/repos/profile_info_repo.dart';

part 'profile_info_states.dart';

class ProfileInfoCubit extends Cubit<ProfileInfoStates> {
  ProfileInfoCubit({required this.profileInfoRepo})
      : super(ProfileInfoInitialState());
  final ProfileInfoRepo profileInfoRepo;
  UserModel? userModel;
  static ProfileInfoCubit get(context) => BlocProvider.of(context);

  Future<void> createNewUserProfile({required UserModel user}) async {
    emit(ProfileInfoLoadingState());
    var result = await profileInfoRepo.createNewUserProfile(userModel: user);
    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(ProfileInfoFailureState(errorMsg: errorMsg));
    }, (userModel) {
      this.userModel = user = userModel;
      emit(ProfileInfoCreatedState(userModel: userModel));
    });
  }

  Future<void> fetchUserProfileInfo() async {
    emit(ProfileInfoLoadingState());
    var result = await profileInfoRepo.fetchUserProfileInfo();
    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(ProfileInfoFailureState(errorMsg: errorMsg));
    }, (userModel) {
      this.userModel = userModel;
      emit(ProfileInfoFetchedState(userModel: userModel));
    });
  }
}
