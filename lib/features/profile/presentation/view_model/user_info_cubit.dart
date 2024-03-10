import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_firebase/core/errors/auth_exceptions_handler.dart';
import 'package:flutter_firebase/features/profile/data/models/user_model.dart';
import 'package:flutter_firebase/features/profile/data/repos/user_info_repo.dart';

part 'user_info_state.dart';

class UserInfoCubit extends Cubit<UserInfoState> {
  UserInfoCubit({required this.userInfoRepo}) : super(UserInfoInitialState());
  final UserInfoRepo userInfoRepo;
  UserModel? userModel;
  static UserInfoCubit get(context) => BlocProvider.of(context);

  Future<void> createNewUser({required UserModel user}) async {
    emit(UserInfoLoadingState());
    var result = await userInfoRepo.createNewUser(userModel: user);
    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(UserInfoFailureState(errorMsg: errorMsg));
    }, (userModel) {
      this.userModel = user = userModel;
      emit(UserInfoSuccessfulState(userModel: userModel));
    });
  }

  getUserLocalInfo() {
    emit(UserInfoSuccessfulState(userModel: UserModel()));
  }

  Future<void> getUserInfo() async {
    emit(UserInfoLoadingState());
    var result = await userInfoRepo.retrieveUserInfoFromRemote();
    result.fold((errorStatus) {
      var errorMsg = AuthExceptionHandler.generateExceptionMessage(errorStatus);
      emit(UserInfoFailureState(errorMsg: errorMsg));
    }, (userModel) {
      this.userModel = userModel;
      emit(UserInfoSuccessfulState(userModel: userModel));
    });
  }
}
