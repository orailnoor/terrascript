import 'dart:convert';
import 'dart:developer';

import 'package:http/http.dart' as http;

class APIRequest {
  Future getPexelImages(String search) async {
    try {
      var headers = {
        'Authorization':
            'I1zCa6hRbuvGUo08IVDtQgEks8hF9cOmevKQCyGqIM0VtXX3Ubj3SYHi',
        'Cookie':
            '__cf_bm=wDCuN8qc8vv1t5px1gccX0IFuQyWf6X7XTWh5e_52nM-1714199506-1.0.1.1-OLZDuEu_ob9Vrk1_zyVfpxtzRn9vwE3oG.S2PXbdMl60Dl1zpWapG8qIJigXdrayuL.gr_ODwMoF1P132mdcag'
      };
      var request = http.Request(
          'GET',
          Uri.parse(
              'https://api.pexels.com/v1/search?query=$search&per_page=80'));

      request.headers.addAll(headers);

      http.StreamedResponse response = await request.send();

      var res = await http.Response.fromStream(response);
      log('Request: ${res.body}');
      if (response.statusCode == 200) {
        var jsonresponse = jsonDecode(res.body);
        return jsonresponse;
      } else {
        return null;
      }
    } catch (e) {
      print('Error occurred: $e');
      return null;
    }
  }
}
