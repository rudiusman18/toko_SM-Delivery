import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:toko_sm_delivery/Models/detail_delivery_model.dart';
import 'package:toko_sm_delivery/Providers/auth_provider.dart';
import 'package:toko_sm_delivery/Providers/shipping_state_provider.dart';
import 'package:toko_sm_delivery/Utils/theme.dart';

class DeliveryDetailPage extends StatefulWidget {
  final String resiId;
  const DeliveryDetailPage({super.key, required this.resiId});

  @override
  State<DeliveryDetailPage> createState() => _DeliveryDetailPageState();
}

class _DeliveryDetailPageState extends State<DeliveryDetailPage> {
  Map<String, List<bool>> mapGolongan = {};

  @override
  void initState() {
    // TODO: implement initState
    super.initState();

    print(widget.resiId);
    _getDetailDelivery();
  }

  void _getDetailDelivery() async {
    final shippingProvider =
        Provider.of<ShippingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (await shippingProvider.getDetailDeliveryData(
      id: widget.resiId,
      token: authProvider.user.token.toString(),
    )) {
      print(
          "Get data success ${shippingProvider.detailDeliveryData!.data?.golongan.toString()}");

      for (var data in shippingProvider.detailDeliveryData!.data!.golongan!) {
        print("Golongan : ${data.label}");
        print("Golongan : ${data.data}");
      }
    } else {
      print("Data gagal");
    }
  }

  @override
  Widget build(BuildContext context) {
    ShippingProvider shippingProvider = Provider.of<ShippingProvider>(context);
    AuthProvider authProvider = Provider.of<AuthProvider>(context);

    // ignore: no_leading_underscores_for_local_identifiers
    _modalDialog({required String title, required String messages}) {
      showDialog(
        context: context,
        builder: (BuildContext context) => AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(
              10,
            ),
          ),
          title: Text(
            title,
            style: urbanist.copyWith(
              fontWeight: bold,
            ),
          ),
          content: RichText(
            text: TextSpan(
              text: messages.replaceFirst("Dikirim?", ""),
              style: urbanist.copyWith(
                color: Colors.black,
              ),
              children: <TextSpan>[
                TextSpan(
                  text: messages.split(" ").last.split("?").first,
                  style: urbanist.copyWith(
                    color: Colors.black,
                    fontWeight: bold,
                  ),
                ),
                TextSpan(
                  text: "?",
                  style: urbanist.copyWith(
                    color: Colors.black,
                  ),
                ),
              ],
            ),
          ),
          actions: [
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.grey,
              ),
              onPressed: () => Navigator.pop(context, 'Cancel'),
              child: const Text('Batal'),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: green,
              ),
              onPressed: () async {
                await shippingProvider.postDeliveryData(
                  token: authProvider.user.token ?? "",
                  noResi:
                      shippingProvider.detailDeliveryData?.data?.noResi ?? "",
                  status: 1,
                  golongan: mapGolongan,
                );
                Navigator.pop(context);
                Navigator.pop(context);
              },
              child: const Text('OK'),
            ),
          ],
        ),
      );
    }

    Widget header() {
      return Container(
        color: Colors.white,
        padding: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
        child: Stack(
          children: [
            Center(
              child: Text(
                "Detail pengiriman",
                style: urbanist.copyWith(
                  color: Colors.black,
                  fontWeight: semiBold,
                  fontSize: 18,
                ),
              ),
            ),
            InkWell(
              onTap: () {
                Navigator.pop(context);
              },
              child: const Icon(
                Icons.arrow_back,
              ),
            ),
          ],
        ),
      );
    }

    Widget transactionItem({
      required String transactionName,
      required String date,
      required String invoiceNumber,
      required String totalProduct,
      required int index,
    }) {
      return Container(
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  transactionName,
                  style: urbanist.copyWith(
                    fontWeight: light,
                  ),
                ),
                Text(
                  date,
                  style: urbanist.copyWith(
                    fontWeight: light,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  invoiceNumber,
                  style: urbanist.copyWith(
                    fontWeight: light,
                    color: Colors.grey,
                  ),
                ),
                Text(
                  "$totalProduct produk",
                  style: urbanist.copyWith(
                    fontWeight: light,
                    color: Colors.grey,
                  ),
                ),
              ],
            ),
          ],
        ),
      );
    }

    Widget golonganItem({
      required String golongan,
      required List<GolData>? product,
    }) {
      // if (mapGolongan.isEmpty) {
      if (mapGolongan.keys.length !=
          (shippingProvider.detailDeliveryData?.data?.golongan ?? []).length) {
        mapGolongan[golongan] = [
          for (var i = 0; i < (product?.length ?? 0); i++)
            product?[i].checked ?? false,
        ];
      }

      // }

      return Container(
        margin: const EdgeInsets.only(
          bottom: 20,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  golongan,
                  style: urbanist.copyWith(
                    fontSize: 18,
                    fontWeight: semiBold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: yellow,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "${product?.length}",
                    style: urbanist.copyWith(
                      fontWeight: semiBold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 10,
            ),
            for (var i = 0; i < (product?.length ?? 0); i++) ...{
              InkWell(
                onTap: () {
                  setState(() {
                    product[i].checked = !product[i].checked!;
                    mapGolongan[golongan]?[i] = product[i].checked ?? false;

                    print(
                        "isi mapgolongan njing: ${mapGolongan} dengan golongan $golongan");
                    print("isi produk nya adalah: ${product[i].checked}");
                    print("isi produk nya adalah: ${product[i].toJson()}");
                  });
                },
                child: Container(
                  color: Colors.white,
                  child: Row(
                    children: [
                      Expanded(
                        child: Text(
                          "${product?[i].namaProduk}",
                          style: urbanist,
                        ),
                      ),
                      Text(
                        "${product?[i].jumlah} Pcs",
                        style: urbanist,
                      ),
                      const SizedBox(
                        width: 10,
                      ),
                      InkWell(
                        onTap: () {
                          setState(() {
                            product[i].checked = !product[i].checked!;
                            mapGolongan[golongan]?[i] =
                                product[i].checked ?? false;

                            print("isi mapgolongan njing: ${mapGolongan}");
                            print(
                                "isi produk nya adalah: ${product[i].checked}");
                            print(
                                "isi produk nya adalah: ${product[i].toJson()}");
                          });
                        },
                        child: Container(
                          width: 20,
                          height: 20,
                          decoration: BoxDecoration(
                            color: product![i].checked!
                                ? green
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(5),
                            border: Border.all(
                              width: 1,
                              color: !product[i].checked!
                                  ? Colors.grey
                                  : Colors.transparent,
                            ),
                          ),
                          child: const FittedBox(
                            fit: BoxFit.cover,
                            child: Icon(
                              Icons.check,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(
                height: 10,
              ),
            },
          ],
        ),
      );
    }

    Widget content() {
      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Transaksi",
                  style: urbanist.copyWith(
                    fontSize: 18,
                    fontWeight: semiBold,
                  ),
                ),
                Container(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: yellow,
                    borderRadius: BorderRadius.circular(5),
                  ),
                  child: Text(
                    "${shippingProvider.detailDeliveryData?.data?.transaksi!.length.toString()}",
                    style: urbanist.copyWith(
                      fontWeight: semiBold,
                      color: Colors.white,
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            const SizedBox(
              height: 20,
            ),
            for (var i = 0;
                i <
                    (shippingProvider.detailDeliveryData?.data?.transaksi! ??
                            [])
                        .length;
                i++) ...[
              transactionItem(
                transactionName:
                    "${shippingProvider.detailDeliveryData?.data?.transaksi?[i].namaPelanggan}",
                date:
                    "${shippingProvider.detailDeliveryData?.data?.transaksi?[i].date}",
                invoiceNumber:
                    "${shippingProvider.detailDeliveryData?.data?.transaksi?[i].noInvoice}",
                totalProduct:
                    "${shippingProvider.detailDeliveryData?.data?.transaksi?[i].jumlahProduk}",
                index: i,
              ),
            ],
            if (shippingProvider.detailDeliveryData != null) ...[
              for (var data
                  in (shippingProvider.detailDeliveryData?.data?.golongan ??
                      [])) ...[
                golonganItem(
                  golongan: "${data.label}",
                  product: data.data,
                ),
              ],
            ],
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            header(),
            Expanded(
              child: content(),
            ),
            Container(
              margin: const EdgeInsets.symmetric(horizontal: 24),
              child: Row(
                children: [
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        side: BorderSide(
                          color: green,
                          width: 1,
                        ), // Border color
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () async {
                        await shippingProvider.postDeliveryData(
                          token: authProvider.user.token ?? "",
                          noResi: shippingProvider
                                  .detailDeliveryData?.data?.noResi ??
                              "",
                          status: 0,
                          golongan: mapGolongan,
                        );
                        Navigator.pop(context);
                      },
                      child: Text(
                        "Simpan Checklist",
                        style: urbanist.copyWith(
                          color: green,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: ElevatedButton(
                      style: ElevatedButton.styleFrom(
                        backgroundColor: green,
                        shadowColor: Colors.transparent,
                      ),
                      onPressed: () {
                        print("proses dikirim ditekan");
                        _modalDialog(
                          title: "Konfirmasi Status",
                          messages:
                              "Anda yakin ingin mengubah status menjadi Dikirim?",
                        );
                      },
                      child: Text(
                        "Proses Untuk Dikirim",
                        style: urbanist.copyWith(
                          color: Colors.white,
                          fontWeight: semiBold,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      ),
    );
  }
}

class ProductGolonganItem {
  String productName = "";
  String totalProduct = "";
  bool isChecked = false;

  ProductGolonganItem({
    this.productName = "",
    this.totalProduct = "",
    this.isChecked = false,
  });
}
