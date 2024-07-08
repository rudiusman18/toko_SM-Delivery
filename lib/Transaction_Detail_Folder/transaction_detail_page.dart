import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:solar_icons/solar_icons.dart';
import 'package:toko_sm_delivery/Providers/auth_provider.dart';
import 'package:toko_sm_delivery/Providers/shipping_state_provider.dart';
import 'package:toko_sm_delivery/Utils/theme.dart';

class TransactionDetailPage extends StatefulWidget {
  final String resiId;
  const TransactionDetailPage({super.key, required this.resiId});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  var lsitSelectedItem = ["COD", "Hutang"];
  var selecteditem = "COD";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    print("transact id : ${widget.resiId}");

    _getDetailDelivery();
  }

  void _getDetailDelivery() async {
    final shippingProvider =
        Provider.of<ShippingProvider>(context, listen: false);
    final authProvider = Provider.of<AuthProvider>(context, listen: false);

    if (await shippingProvider.getDetailTransactionData(
      id: widget.resiId,
      token: authProvider.user.token.toString(),
    )) {
      print(
          "Get data success ${shippingProvider.shippingState?.data.toString()}");
    } else {
      print("Data gagal");
    }
  }

  @override
  Widget build(BuildContext context) {
    ShippingProvider shippingProvider = Provider.of<ShippingProvider>(context);

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
              text: messages.replaceFirst("Diterima?", ""),
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
              onPressed: () {},
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
                "Detail Transaksi",
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

    Widget productItem({
      required String? productName,
      required String price,
      required List<int>? totalProduct,
      required List<String?> multiSatuan,
    }) {
      // var listTotalProduct = totalProduct.split("/");
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  productName.toString(),
                  style: urbanist,
                ),
              ),
              Text(
                "Rp $price",
                style: urbanist.copyWith(
                  color: Colors.grey,
                ),
              ),
            ],
          ),
          if (multiSatuan.isNotEmpty && totalProduct!.isEmpty) ...[
            for (var i = 0; i < multiSatuan.length; i++) ...[
              Text(
                "${totalProduct[i]} ${multiSatuan[i]}",
                style: urbanist.copyWith(
                  fontSize: 12,
                  color: Colors.grey,
                ),
              ),
            ]
          ],

          // for (var i = 0; i < listTotalProduct.length; i++)
          //   Text(
          //     listTotalProduct[i],
          //     style: urbanist.copyWith(
          //       fontSize: 12,
          //       color: Colors.grey,
          //     ),
          //   ),
        ],
      );
    }

    Widget content() {
      return Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: ListView(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Text(
                  "Produk",
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
                    (shippingProvider
                                .detailTransactionData?.data?.produk?.length ??
                            0)
                        .toString(),
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
                    (shippingProvider.detailTransactionData?.data?.produk ?? [])
                        .length;
                i++) ...[
              productItem(
                productName: shippingProvider
                    .detailTransactionData?.data?.produk![i].namaProduk
                    .toString(),
                price:
                    "${shippingProvider.detailTransactionData?.data?.produk![i].totalHarga.toString()}",
                totalProduct: shippingProvider.detailTransactionData?.data
                    ?.produk![i].jumlahMultisatuan, //1 pak/1 pcs
                multiSatuan: shippingProvider.detailTransactionData?.data
                        ?.produk![i].multisatuanUnit ??
                    [],
              ),
              i == 1
                  ? const SizedBox()
                  : const Divider(
                      color: Colors.grey,
                    ),
            ],
          ],
        ),
      );
    }

    Widget bottomContent() {
      return Container(
        margin: const EdgeInsets.symmetric(
          horizontal: 24,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Divider(
              color: Colors.grey.withAlpha(90),
              height: 10,
            ),
            const SizedBox(
              height: 10,
            ),
            // Text(
            //   "Metode Pembayaran",
            //   style: urbanist.copyWith(
            //     color: Colors.grey,
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            // Container(
            //   width: double.infinity, // Set the desired width here
            //   padding: const EdgeInsets.symmetric(
            //     horizontal: 12,
            //   ), // Optional padding for better appearance
            //   decoration: BoxDecoration(
            //     border: Border.all(
            //         color: Colors.grey.withAlpha(90),
            //         width: 1), // Optional border styling
            //     borderRadius:
            //         BorderRadius.circular(5), // Optional border radius
            //   ),
            //   child: DropdownButton<String>(
            //     value: selecteditem, // Current selected item
            //     isExpanded:
            //         true, // Make the dropdown expand to the width of the container
            //     hint: Text(
            //         'Select an item'), // Hint text when no item is selected
            //     items: lsitSelectedItem.map((String item) {
            //       return DropdownMenuItem<String>(
            //         value: item,
            //         child: Text(
            //           item,
            //           style: urbanist,
            //         ),
            //       );
            //     }).toList(),
            //     onChanged: (String? newValue) {
            //       setState(() {
            //         selecteditem = newValue ?? ""; // Update the selected item
            //       });
            //     },
            //     underline: SizedBox(), // Remove the default underline
            //   ),
            // ),
            // const SizedBox(
            //   height: 10,
            // ),
            Row(
              children: [
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    side: BorderSide(
                      color: green,
                      width: 1,
                    ), // Border color
                    backgroundColor: Colors.transparent,
                    shadowColor: Colors.transparent,
                  ),
                  onPressed: () {},
                  child: Icon(
                    SolarIconsBold.menuDots,
                    color: green,
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
                      _modalDialog(
                        title: "Konfirmasi Status",
                        messages:
                            "Anda yakin ingin mengubah status pesanan menjadi Diterima?",
                      );
                    },
                    child: Text(
                      "Pesanan Diterima",
                      style: urbanist.copyWith(
                        fontWeight: semiBold,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(
              height: 20,
            ),
          ],
        ),
      );
    }

    return SafeArea(
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            header(),
            Expanded(
              child: content(),
            ),
            bottomContent(),
          ],
        ),
      ),
    );
  }
}
