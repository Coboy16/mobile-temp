import 'dart:async';
import 'package:chopper/chopper.dart' as chopperLib;

class FunctionalAsBaseInterceptor implements chopperLib.Interceptor {
  final FutureOr<chopperLib.Request> Function(chopperLib.Request request)
  requestModifier;

  FunctionalAsBaseInterceptor(this.requestModifier);

  @override
  FutureOr<chopperLib.Response<BodyType>> intercept<BodyType>(
    chopperLib.Chain<BodyType> chain,
  ) async {
    chopperLib.Request request = chain.request;
    chopperLib.Request modifiedRequest;
    final result = requestModifier(request);
    if (result is Future) {
      modifiedRequest = await result;
    } else {
      modifiedRequest = result;
    }
    return chain.proceed(modifiedRequest);
  }
}
