import 'dart:convert';
import 'dart:io';
import 'package:shelf/shelf.dart';
import 'package:shelf/shelf_io.dart' as shelf_io;
import 'package:shelf_router/shelf_router.dart' as shelf_router;
import 'package:shelf_static/shelf_static.dart' as shelf_static;

import 'banco.dart';

Future main() async {
  final port = int.parse(Platform.environment['PORT'] ?? '8080');
  final cascade = Cascade().add(_staticHandler).add(_router);

  final pipeline = Pipeline().addMiddleware(logRequests()).addHandler(cascade.handler);

  await shelf_io.serve(
    pipeline,
    InternetAddress.anyIPv4,
    port,
  );
}

final _staticHandler = shelf_static.createStaticHandler('public', defaultDocument: 'index.html');

final _router = shelf_router.Router()
  ..get('/getData', getData)
  ..post('/insertUpdate', insertUpdate)
  ..delete('/delete', delete);

Future<Response> getData(Request request) async {
  if (request.headers['login'] == 'lucascardo12' && request.headers['senha'] == 'lucas2021') {
    try {
      Map<String, dynamic> selector = Map<String, dynamic>();
      MongoDB banco = MongoDB();
      banco.senhaDb = request.headers['senhaDb']!;
      banco.clusterDb = request.headers['clusterDb']!;
      banco.formatDb = request.headers['formatDb']!;
      banco.hostDb = request.headers['hostDb']!;
      banco.loginDb = request.headers['loginDb']!;
      await banco.inicia();
      if (request.headers['selector'] != null) {
        selector = jsonDecode(request.headers['selector']!);
      }

      var retorno = await banco.getData(
        tabela: request.headers['tabela']!,
        selector: selector,
      );
      banco.db.close();
      return Response.ok(
        JsonEncoder.withIndent(' ').convert(
          {"data": retorno},
        ),
      );
    } catch (e) {
      return Response.ok({"data": e.toString()});
    }
  } else {
    return Response.ok(
      JsonEncoder.withIndent(' ').convert(
        {"erro": "sem acesso"},
      ),
    );
  }
}

Future<Response> insertUpdate(Request request) async {
  if (request.headers['login'] == 'lucascardo12' && request.headers['senha'] == 'lucas2021') {
    try {
      Map<String, dynamic> data = jsonDecode(await request.readAsString());
      MongoDB banco = MongoDB();
      banco.senhaDb = request.headers['senhaDb']!;
      banco.clusterDb = request.headers['clusterDb']!;
      banco.formatDb = request.headers['formatDb']!;
      banco.hostDb = request.headers['hostDb']!;
      banco.loginDb = request.headers['loginDb']!;
      await banco.inicia();
      var retorno = await banco.insertUpdate(
        tabela: request.headers['tabela']!,
        objeto: data,
      );
      banco.db.close();
      return Response.ok(
        JsonEncoder.withIndent(' ').convert(
          {"data": retorno},
        ),
      );
    } catch (e) {
      return Response.ok({"data": e.toString()});
    }
  } else {
    return Response.ok(
      JsonEncoder.withIndent(' ').convert(
        {"erro": "sem acesso"},
      ),
    );
  }
}

Future<Response> delete(Request request) async {
  Map<String, dynamic> selector = Map<String, dynamic>();
  MongoDB banco = MongoDB();
  if (request.headers['login'] == 'lucascardo12' && request.headers['senha'] == 'lucas2021') {
    try {
      banco.senhaDb = request.headers['senhaDb']!;
      banco.clusterDb = request.headers['clusterDb']!;
      banco.formatDb = request.headers['formatDb']!;
      banco.hostDb = request.headers['hostDb']!;
      banco.loginDb = request.headers['loginDb']!;
      await banco.inicia();
      if (request.headers['selector'] != null) {
        selector = jsonDecode(request.headers['selector']!);
      }

      var retorno = await banco.delete(
        tabela: request.headers['tabela']!,
        objeto: selector,
      );
      banco.db.close();
      return Response.ok(
        JsonEncoder.withIndent(' ').convert(
          {"data": retorno},
        ),
      );
    } catch (e) {
      banco.db.close();
      return Response.ok({"data": e.toString()});
    }
  } else {
    return Response.ok(
      JsonEncoder.withIndent(' ').convert(
        {"erro": "sem acesso"},
      ),
    );
  }
}
