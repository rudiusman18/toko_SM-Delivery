import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:toko_sm_delivery/Utils/theme.dart';

class TransactionDetailPage extends StatefulWidget {
  const TransactionDetailPage({super.key});

  @override
  State<TransactionDetailPage> createState() => _TransactionDetailPageState();
}

class _TransactionDetailPageState extends State<TransactionDetailPage> {
  var lsitSelectedItem = ["COD", "Hutang"];
  var selecteditem = "COD";

  @override
  Widget build(BuildContext context) {
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
      required String productName,
      required String price,
      required String totalProduct,
    }) {
      var listTotalProduct = totalProduct.split("/");
      return Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Expanded(
                child: Text(
                  productName,
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
          for (var i = 0; i < listTotalProduct.length; i++)
            Text(
              listTotalProduct[i],
              style: urbanist.copyWith(
                fontSize: 12,
                color: Colors.grey,
              ),
            ),
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
                    "3",
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
            for (var i = 0; i < 2; i++) ...{
              productItem(
                productName: "PlayStation 5",
                price: "47000000",
                totalProduct: "1 pak/1 pcs",
              ),
              i == 1
                  ? const SizedBox()
                  : const Divider(
                      color: Colors.grey,
                    ),
            }
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
            Text(
              "Metode Pembayaran",
              style: urbanist.copyWith(
                color: Colors.grey,
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Container(
              width: double.infinity, // Set the desired width here
              padding: const EdgeInsets.symmetric(
                horizontal: 12,
              ), // Optional padding for better appearance
              decoration: BoxDecoration(
                border: Border.all(
                    color: Colors.grey.withAlpha(90),
                    width: 1), // Optional border styling
                borderRadius:
                    BorderRadius.circular(5), // Optional border radius
              ),
              child: DropdownButton<String>(
                value: selecteditem, // Current selected item
                isExpanded:
                    true, // Make the dropdown expand to the width of the container
                hint: Text(
                    'Select an item'), // Hint text when no item is selected
                items: lsitSelectedItem.map((String item) {
                  return DropdownMenuItem<String>(
                    value: item,
                    child: Text(
                      item,
                      style: urbanist,
                    ),
                  );
                }).toList(),
                onChanged: (String? newValue) {
                  setState(() {
                    selecteditem = newValue ?? ""; // Update the selected item
                  });
                },
                underline: SizedBox(), // Remove the default underline
              ),
            ),
            const SizedBox(
              height: 10,
            ),
            Row(
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
                    onPressed: () {},
                    child: Text(
                      "Retur",
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
                    onPressed: () {},
                    child: Text(
                      "Simpan",
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
