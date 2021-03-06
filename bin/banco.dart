import 'dart:convert';

import 'package:mongo_dart/mongo_dart.dart';

class MongoDB {
  String loginDb = '';
  String senhaDb = '';
  String hostDb = '';
  String clusterDb = '';
  String formatDb = '';
  late Db db;

  Future<void> inicia() async {
    db = await Db.create("$formatDb://$loginDb:$senhaDb@$hostDb/$clusterDb?retryWrites=true&w=majority");
    await db.open();
  }

  Future<dynamic> insertUpdate({required Map<String, dynamic> objeto, required String tabela}) async {
    try {
      var collection = db.collection(tabela);
      var auxi = await collection.count();
      if (objeto['_id'] == null) {
        if (auxi == 0) {
          objeto['_id'] = 1;
        } else {
          var i = await collection.find(where.sortBy('_id', descending: true)).first;
          objeto['_id'] = i['_id'] + 1;
        }
        await collection.insert(objeto);
      } else {
        await collection.save(objeto);
      }
      return objeto;
    } catch (e) {
      return null;
    }
  }

  Future<bool> delete({Map<String, dynamic>? objeto, required String tabela}) async {
    try {
      var collection = db.collection(tabela);
      await collection.remove(objeto);
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<List<dynamic>> getData({Map<String, dynamic>? selector, required String tabela}) async {
    //{'_id': data.id} selector
    DateTime.now().toString();
    try {
      List<dynamic> data = [];
      var collection = db.collection(tabela);
      await collection.find(selector).forEach((element) {
        Map<String, dynamic> auxi = <String, dynamic>{};
        element.keys.forEach((xx) {
          if (element[xx] is String || element[xx] is bool || element[xx] is int || element[xx] is double) {
            auxi[xx] = element[xx];
          } else {
            element[xx] != null ? auxi[xx] = element[xx].toString() : auxi[xx] = element[xx];
          }
        });
        data.add(auxi);
      });
      return data;
    } catch (e) {
      print(e);
      return [];
    }
  }
}
