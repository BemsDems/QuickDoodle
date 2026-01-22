import 'package:internet_connection_checker_plus/internet_connection_checker_plus.dart';

class NetworkInfo {
  NetworkInfo(this._connection);

  final InternetConnection _connection;

  Future<bool> get hasInternet => _connection.hasInternetAccess;
}
