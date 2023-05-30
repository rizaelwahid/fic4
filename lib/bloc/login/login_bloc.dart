import 'package:bloc/bloc.dart';
import 'package:fic4_flutter_auth_bloc/data/localsources/auth_local_storage.dart';
import 'package:meta/meta.dart';

import 'package:fic4_flutter_auth_bloc/data/datasources/auth_datasources.dart';
import 'package:fic4_flutter_auth_bloc/data/models/request/login_model.dart';
import 'package:fic4_flutter_auth_bloc/data/models/response/login_response_model.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  final AuthDatasource authDatasource;

  LoginBloc(this.authDatasource) : super(LoginInitial()) {
    on<DoLoginEvent>(
      (event, emit) async {
        emit(LoginLoading());

        final result = await authDatasource.login(event.loginModel);
        result.fold(
          (error) {
            emit(LoginError(message: error));
          },
          (data) async {
            await AuthLocalStorage().saveToken(data.accessToken);
            emit(LoginLoaded(loginResponseModel: data));
          },
        );
      },
    );
  }
}
