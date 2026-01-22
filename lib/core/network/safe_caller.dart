import 'package:fpdart/fpdart.dart';
import 'package:quick_doodle/core/error/app_failure.dart';
import 'package:quick_doodle/core/error/error_mapper.dart';
import 'package:quick_doodle/core/network/network_info.dart';

class SafeCaller {
  SafeCaller(this._networkInfo, this._errorMapper);

  final NetworkInfo _networkInfo;
  final ErrorMapper _errorMapper;

  Future<Either<AppFailure, T>> call<T>(Future<T> Function() action) async {
    try {
      final hasInternet = await _networkInfo.hasInternet;
      if (!hasInternet) return left(const NoInternetFailure());

      final result = await action();
      return right(result);
    } catch (e, st) {
      final failure = e is AppFailure ? e : _errorMapper.map(e, st);
      return left(failure);
    }
  }
}
