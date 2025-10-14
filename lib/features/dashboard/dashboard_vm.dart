import 'package:dev_once_app/core/models/base_provider.dart';
import 'package:dev_once_app/core/models/request_config.dart';
import 'package:dev_once_app/core/utils/extensions.dart';

import 'dashboard_model.dart';

class DashboardVm extends BaseProvider {
  DashboardModel data = const DashboardModel();

  Future<({bool success, String? message})> get() async {
    setBusy(true);
    try {
      final cfg = RequestConfig<DashboardModel>(
        endpoint: '/dashboard/customer-dashboard',
        fromJson: DashboardModel.fromJson,
      );
      final res = await client.get(cfg);
      if (res.success) {
        data = res.data!;
        return (success: true, message: null);
      }
      return (success: false, message: res.message);
    } finally {
      setBusy(false);
    }
  }
}

