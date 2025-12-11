import 'dart:async';
import 'dart:convert';
import 'package:hive_ce_flutter/hive_flutter.dart';

import 'package:agent_digital_banking/env/env.dart';
import 'package:agent_digital_banking/logger.dart';

class Database {
  static late Box<dynamic> box;

  static Future<void> init() async {
    try {
      final encryptionKeyUint8List = base64Url.decode(Env.loki);
      Database.box = await Hive.openBox('umb-db.box', encryptionCipher: HiveAesCipher(encryptionKeyUint8List));
      // Database.box.clear();
    } catch (ex) {
      logger.e(ex);
    }
  }

  Future<void> deleteAll() async {
    Database.box.clear();
  }

  Future<void> delete(String key) async {
    await Database.box.delete(key);
  }

  Future<void> checkBeforeOperation() async {
    if (!Database.box.isOpen) {
      await Database.init();
    }
  }

  Future<void> add({required String key, required dynamic payload}) async {
    try {
      await checkBeforeOperation();

      final data = json.encode(payload);
      await Database.box.put(key, data);
    } catch (ex) {
      logger.e(ex);
    }
  }

  Future<Map<String, dynamic>?> read(String key) async {
    try {
      await checkBeforeOperation();

      final raw = await Database.box.get(key);
      if (raw == null) {
        return null;
      }

      return json.decode(raw) as Map<String, dynamic>;
    } catch (ex) {
      logger.e(ex);
      return null;
    }
  }

  Future<String?> readRaw(String key) async {
    try {
      await checkBeforeOperation();
      final record = await Database.box.get(key) as String?;
      return record;
    } catch (ex) {
      return null;
    }
  }
}
