import 'package:http/http.dart' as http;

import 'package:music_chat/models/usuario.dart';
import 'package:music_chat/models/usuarios_response.dart';
import 'package:music_chat/global/environment.dart';

import 'package:music_chat/services/auth_service.dart';

class UsuariosService {
  Future<List<Usuario>> getUsuarios() async {
    try {
      final resp = await http.get('${Environment.apiUrl}/usuarios', headers: {
        'Content-Type': 'application/json',
        'x-token': await AuthService.getToken()
      });

      final usuariosResponse = usuariosResponseFromJson(resp.body);
      return usuariosResponse.usuarios;
    } catch (e) {
      return [];
    }
  }
}
