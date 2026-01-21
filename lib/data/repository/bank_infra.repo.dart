import '../../constants/status.const.dart';
import '../database/db.dart';
import '../models/infra/bank_infra.dart';
import '../models/response.modal.dart';
import '../remote/main.remote.dart';

class BankInfraRepo {
  final _db = Database();
  final _fbl = MainRemote();

  Future<List<InfraType>?> getStoredInfraTypes() async {
    final result = await _db.read('infra-types');

    if (result == null || result['list'] == null) {
      return null;
    }

    final List<InfraType> list = result['list'] != null
        ? (result['list'] as List<dynamic>).map((e) => InfraType.fromMap(e)).toList()
        : [];
    return list;
  }

  Future<List<Locators>?> getStoredLocators() async {
    final result = await _db.read('locators');

    if (result == null || result['list'] == null) {
      return null;
    }

    final List<Locators> list = result['list'] != null
        ? (result['list'] as List<dynamic>).map((e) => Locators.fromMap(e)).toList()
        : [];
    return list;
  }

  Future<Response<List<InfraType>>> loadBankInfraTypes() async {
    final response = await _fbl.post(path: 'Locator/getTypes', body: {});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = (response.data['list'] as List<dynamic>).map((e) => InfraType.fromMap(e)).toList();
    _db.add(key: 'infra-types', payload: {'list': response.data['list']});

    return Response(
      code: response.code,
      status: response.status,
      message: response.message,
      data: data,
    );
  }

  Future<Response<BankInfra>> loadBankInfra(String typeId) async {
    final response = await _fbl.post(path: 'Locator/getAll/$typeId', body: {});

    if (response.status != StatusConstants.success) {
      return Future.error(response);
    }

    final data = BankInfra.fromMap(response.data);
    return Response(
      code: response.code,
      status: response.status,
      message: response.message,
      data: data,
    );
  }

  Future<void> saveLocations(List<Locators> locators) async {
    await _db.add(key: 'locators', payload: {'list': locators.map((e) => e.toMap()).toList()});
  }
}
