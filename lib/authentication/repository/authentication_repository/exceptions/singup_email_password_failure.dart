

class SingUpWithEmailAndPasswordFailure {
  final String message;

  const SingUpWithEmailAndPasswordFailure([this.message = "An Unknown error occured"]);

  factory SingUpWithEmailAndPasswordFailure.code(String code){
    switch(code){
      case 'weak-password' : 
      return const SingUpWithEmailAndPasswordFailure('Please enter a stronger password');
      case 'invalid-email' :
        return const SingUpWithEmailAndPasswordFailure('Email is invalid');
      case 'email-already-in-use':
        return const SingUpWithEmailAndPasswordFailure('An account already exists for that email');
      case 'operation-not-allowed' :
        return const SingUpWithEmailAndPasswordFailure('This user has been disabled. Please contact support for help');
      default:
        return const SingUpWithEmailAndPasswordFailure();
    }
  }
}