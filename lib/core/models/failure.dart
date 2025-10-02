abstract class Failure<T> {
  final T? value;
  const Failure([this.value]);
}

class NetworkFailure extends Failure<String> {
  const NetworkFailure([super.message = 'Network error occurred']);
}

class DatabaseFaliure extends Failure<String> {
  const DatabaseFaliure([super.message = 'Database error occured']);
}
