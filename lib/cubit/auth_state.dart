abstract class AuthState{}

class Initializer extends AuthState{}
class LoginSuccess extends AuthState{}
class LoginLoading extends AuthState{}
class LoginFailed extends AuthState{
  String? message;
  LoginFailed(String m){
    message=m;
  }
}
