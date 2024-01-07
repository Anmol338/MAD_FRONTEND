import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:paila_kicks/data/models/user/user_model.dart';
import 'package:paila_kicks/logic/cubits/user_cubit/user_state.dart';
import 'package:paila_kicks/logic/services/preferences.dart';
import '../../../data/repositories/user_repository.dart';

class UserCubit extends Cubit<UserState> {
  UserCubit() : super(UserInitialState()){
    _initialize();
  }
  final UserRepository _userRepository = UserRepository();

  void _initialize() async{
    final userDetails = await Preferences.fetchUserDetails();
    String? email = userDetails["email"];
    String? password = userDetails["password"];

    if(email == null || password == null){
      emit( UserLoggedOutState() );
    }
    else {
      signIn(email: email, password: password);
    }
  }

  // Function to store the user data into shared preference before LoggInState
  void _emitLoggedInState(
      {required UserModel userModel,
      required String email,
      required String password}) async {
    // Save the user details into the local storage for automatic login.
    await Preferences.saveUserDetails(email, password);
    emit(UserLoggedInState(userModel));
  }

  void signIn({required String email, required String password}) async {
    emit(UserLoadingState());
    try {
      UserModel userModel =
          await _userRepository.signIn(email: email, password: password);
      
      _emitLoggedInState(userModel: userModel, email: email, password: password);
    } catch (ex) {
      emit(UserErrorState(ex.toString()));
    }
  }

  void createAccount({required String email, required String password}) async {
    emit(UserLoadingState());
    try {
      UserModel userModel =
          await _userRepository.createAccount(email: email, password: password);

      _emitLoggedInState(userModel: userModel, email: email, password: password);
    } catch (ex) {
      emit(UserErrorState(ex.toString()));
    }
  }

  Future<bool> updateUser(UserModel userModel) async {
    emit( UserLoadingState() );

    try{
      UserModel updateduser = await _userRepository.updateUser(userModel);
      emit( UserLoggedInState(updateduser) );

      return true;
    }
    catch(ex) {
      emit( UserErrorState(ex.toString()));
      return false;
    }
  }

  void signOut() async{
    await Preferences.clear();
    emit( UserLoggedOutState() );
  }

}
