import 'package:dio/dio.dart';
import 'package:yinzo/Users/Provider/auth_provider.dart';

class DioService {
  static const String _baseUrl = "http://192.168.73.146:8000/api/";
  static const int _connectTimeout = 15000;
  static const int _receiveTimeout = 15000;

  static String get baseUrl => _baseUrl;

  static Dio getDioInstanceWithBaseUrl() {
    return Dio(
      BaseOptions(
        baseUrl: _baseUrl,
        connectTimeout: const Duration(milliseconds: _connectTimeout),
        receiveTimeout: const Duration(milliseconds: _receiveTimeout),
        headers: {
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        validateStatus: (status) {
          // Autoriser les statuts 2xx et 3xx, mais pas les erreurs 5xx
          return status! < 500;
        },
      ),
    );
  }
}

class TokenRefreshInterceptor extends Interceptor {
  final AuthProvider authProvider;
  final _retryQueue = <RequestOptions>[];
  bool _isRefreshing = false;

  TokenRefreshInterceptor(this.authProvider);

  @override
  Future<void> onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    // Je n'ajoute pas le token pour les endpoints publics.
    if (_isPublicEndpoint(options.path)) {
      return handler.next(options);
    }

    final token = await authProvider.getValidToken();
    if (token != null) {
      options.headers['Authorization'] = 'Bearer $token';
    }

    return handler.next(options);
  }

  @override
  Future<void> onError(
    DioException err,
    ErrorInterceptorHandler handler,
  ) async {
    // Gestion uniquement pour les erreurs 401
    // et les requêtes non publiques.
    if (err.response?.statusCode != 401 ||
        _isPublicEndpoint(err.requestOptions.path)) {
      return handler.next(err);
    }

    // Mise de la requête en file d'attente
    // pour réessayer après le rafraîchissement du token.
    _retryQueue.add(err.requestOptions);

    if (!_isRefreshing) {
      _isRefreshing = true;
      try {
        // Tentative de rafraîchissement du token
        await authProvider.refresh();

        // Réessayer toutes les requêtes en attente
        final dio = DioService.getDioInstanceWithBaseUrl();
        for (RequestOptions options in _retryQueue) {
          try {
            final response = await dio.fetch(
              options
                ..headers['Authorization'] =
                    'Bearer ${authProvider.accessToken}',
            );
            handler.resolve(response);
          } catch (e) {
            handler.reject(e as DioException);
          }
        }
      } catch (e) {
        // En cas d'échec, je déconnecte et vide la file d'attente.
        await authProvider.logout();
        _retryQueue.clear();
        handler.next(
          DioException(
            requestOptions: err.requestOptions,
            error: 'Votre session est expirée. Veuillez vous reconnecter',
          ),
        );
      } finally {
        _isRefreshing = false;
        _retryQueue.clear();
      }
    }

    return;
  }

  bool _isPublicEndpoint(String path) {
    const List<String> publicEndpoints = [
      'account/login/',
      'account/signup/',
      'account/token/refresh/',
      'logement/publish/',
      'user/logements/',
      'user/logement/<str:pk>/delete',
      'conversations/',
      'load/messages/<str:receiver_id>/',
      'comment/post/',
      'comment/<str:pk>/edit/',
      'comment/<str:pk>/delete/',
      'rate/logement/',
      'schedule_visit/',
      'fetch/scheduled_visit/',
      'recycle-bin/',
      'recycle-bin/logement/<str:pk>/delete/',
      'recycle-bin/logement/<str:pk>/restore/',
      'user/recycle-bin/',
    ];
    return publicEndpoints.any((endpoint) => path.contains(endpoint));
  }
}
