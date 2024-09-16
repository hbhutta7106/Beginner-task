import 'dart:io';
import 'dart:typed_data';

import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pos_app/Models/bill.dart';

class PdfService {
  final headersList = [
    "Item Name",
    "Item Price",
    "Item Quantity",
    "Item Total"
  ];
  Future<Uint8List> createThePdfFile(Bill bill, double discountAmount) async {
    double totalAmount = 0.0;
    final itemsData = bill.billItems
        .map((eachItem) => [
              eachItem.item.name,
              eachItem.billItemPrice.toString(),
              eachItem.billItemQuantity.toString(),
              (eachItem.billItemQuantity * eachItem.billItemPrice).toString()
            ])
        .toList();
    for (int i = 0; i < bill.billItems.length; i++) {
      totalAmount += (bill.billItems[i].billItemPrice) *
          (bill.billItems[i].billItemQuantity);
    }
    final pdf = pw.Document();
    pdf.addPage(
      pw.Page(
        pageFormat: PdfPageFormat.standard,
        build: (pw.Context context) {
          return pw.Column(children: [
            pw.SizedBox(height: 20),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Bill Number",
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.Text(bill.billNumber.toString()),
                ]),
            pw.SizedBox(height: 30),
            pw.TableHelper.fromTextArray(
                headerStyle: pw.TextStyle(fontWeight: pw.FontWeight.bold),
                headers: headersList,
                data: itemsData),
            pw.SizedBox(height: 20),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Before Discount Amount",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(" $totalAmount Rs"),
                ]),
            pw.SizedBox(height: 20),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text(
                    "Discount Amount",
                    style: pw.TextStyle(
                      fontSize: 15,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.Text(" ${discountAmount.toString()} Rs"),
                ]),
            pw.SizedBox(height: 20),
            pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Text("Total Amount",
                      style: pw.TextStyle(
                        fontSize: 20,
                        fontWeight: pw.FontWeight.bold,
                      )),
                  pw.SizedBox(width: 20),
                  pw.Text(" ${bill.totalBillAmount.toString()} Rs"),
                ]),
          ]);
        },
      ),
    );
    return pdf.save();
  }

  Future<void> saveTheFileInTheDevice(
      int number, Uint8List generatedPdf) async {
    final directory = await getDownloadsDirectory();
    final filePath = "${directory!.path}/BillNumber-$number.pdf";
    final file = File(filePath);
    await file.writeAsBytes(generatedPdf);
    print(filePath);
    OpenFile.open(filePath);
  }
}
