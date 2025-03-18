import '../model/provider_dto.dart';

class ProviderHelper {
  ProviderDto showShouldCanceled(
      {required ProviderDto provider,
      required DateTime end,
      required DateTime current}) {
    int? notice = provider.notice;

    int dateDifference = end.difference(current).inDays ~/ 30;

    bool isCanceled = provider.canceled ?? false;

    if (notice != null && (dateDifference - notice) == 1 && !isCanceled) {
      provider.showShouldCanceled = true;
    }

    return provider;
  }
}
