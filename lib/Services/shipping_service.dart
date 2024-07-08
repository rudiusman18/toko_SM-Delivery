import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:toko_sm_delivery/Models/delivery_data_model.dart';
import 'package:toko_sm_delivery/Models/detail_delivery_model.dart';
import 'package:toko_sm_delivery/Models/detail_transaction_model.dart';
import 'package:toko_sm_delivery/Models/shipping_state_model.dart';
import 'package:toko_sm_delivery/Models/transaction_data_model.dart';

class ShippingService {
  String baseURL = 'http://103.127.132.116/api/v1/';

  Future<ShippingStateModel> getStateDataByTime(
      {required String time, required String token}) async {
    var url = Uri.parse("${baseURL}pengiriman/stat?time=$time");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("State Data By Time: ${url}");
    print("State Data By Time: ${response.body}");
    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      ShippingStateModel storeLocateModel = ShippingStateModel.fromJson(data);
      return storeLocateModel;
    } else {
      throw Exception("Gagal Mendapatkan History");
    }
  }

  Future<TransationDataModel> getTransactionData(
      {required String query,
      required String date,
      required String token}) async {
    var url =
        Uri.parse("${baseURL}pengiriman/transaksi?q=$query&tanggal=$date");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("State Data By Time: ${url}");
    print("State Data By Time: ${response.body}");
    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      TransationDataModel storeLocateModel = TransationDataModel.fromJson(data);
      return storeLocateModel;
    } else {
      throw Exception("Gagal Mendapatkan Data Transaksi");
    }
  }

  Future<DeliveryDataModel> getDeliveryData(
      {required String query,
      required String page,
      required String date,
      required String token}) async {
    var url = Uri.parse(
        "${baseURL}pengiriman/data?q=$query&limit=&page=$page&tanggal=$date");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("State Data By Time: ${url}");
    print("State Data By Time: ${response.body}");
    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      DeliveryDataModel storeLocateModel = DeliveryDataModel.fromJson(data);
      return storeLocateModel;
    } else {
      throw Exception("Gagal Mendapatkan Data Delivery");
    }
  }

  Future<DetailDeliveryModel> getDetailDeliveryData(
      {required String id, required String token}) async {
    var url = Uri.parse("${baseURL}pengiriman/detail/${id}");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("State Data By Time: ${url}");
    print("State Data By Time: ${response.body}");
    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      DetailDeliveryModel storeLocateModel = DetailDeliveryModel.fromJson(data);
      return storeLocateModel;
    } else {
      throw Exception("Gagal Mendapatkan Data Delivery");
    }
  }

  Future<DetailTransactionModel> getDetailTransaction(
      {required String id, required String token}) async {
    var url = Uri.parse("${baseURL}transaksi/detail/$id");
    var header = {
      'Authorization': 'Bearer $token',
      'Content-Type': 'application/json'
    };
    var response = await http.get(url, headers: header);
    // ignore: avoid_print
    print("State Data By Time: ${url}");
    print("State Data By Time: ${response.body}");
    // **success melakukan login
    if (response.statusCode >= 200 && response.statusCode <= 299) {
      var data = jsonDecode(response.body);
      DetailTransactionModel storeLocateModel =
          DetailTransactionModel.fromJson(data);
      return storeLocateModel;
    } else {
      throw Exception("Gagal Mendapatkan Data Delivery");
    }
  }
}
