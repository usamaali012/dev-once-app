abstract interface class Either<L, R> {
  T fold<T>(T Function(L left) leftFn, T Function(R right) rightFn);
}

final class Left<L, R> implements Either<L, R> {
  final L value;

  const Left(this.value);

  @override
  T fold<T>(T Function(L left) leftFn, T Function(R right) rightFn) {
    return leftFn(value);
  }
}

final class Right<L, R> implements Either<L, R> {
  final R value;

  const Right(this.value);

  @override
  T fold<T>(T Function(L left) leftFn, T Function(R right) rightFn) {
    return rightFn(value);
  }
}
