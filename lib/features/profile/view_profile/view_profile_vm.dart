import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/utils/extensions.dart';

import 'view_profile_model.dart';

class ViewProfileVm extends BaseProvider {
  ViewProfileModel details = const ViewProfileModel();

  Future<({bool success, String? message})> get() async {
    setBusy(true);
    try {
      final cfg = RequestConfig<ViewProfileModel>(
        endpoint: '/user/view-profile',
        fromJson: ViewProfileModel.fromJson,
      );
      final res = await client.get(cfg);
      if (res.success) {
        details = res.data!;
        return (success: true, message: null);
      }
      return (success: false, message: res.message);
    } finally {
      setBusy(false);
    }
  }
}

