import 'dart:typed_data';

import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart';
import 'package:store_manager/utils/utils.dart';

import '../utils/objects.dart';

Future<Uint8List> makePdf(
    {required String workerName,
    required String date,
    required String outSidePersonnel,
    required String totalPrice,
    required List<ShowObject> listShowObjectMainTable}) async {
  final pdf = Document();
  pdf.addPage(
    Page(
      build: (context) {
        return Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("Date: $date")),
                    Text("Attention to: $outSidePersonnel"),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
                Column(
                  children: [
                    Padding(
                        padding: const EdgeInsets.only(bottom: 10),
                        child: Text("Company name",
                            style: TextStyle(fontWeight: FontWeight.bold))),
                    Text("Adress",
                        style: TextStyle(fontWeight: FontWeight.bold)),
                  ],
                  crossAxisAlignment: CrossAxisAlignment.start,
                ),
              ],
            ),
            Container(height: 50),
            Table(
              border: TableBorder.symmetric(
                  outside: BorderSide(width: 0.5, color: PdfColors.black)),
              children: [
                TableRow(
                  decoration: const BoxDecoration(color: PdfColors.grey100),
                  children: [
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Expanded(
                          child: PaddedText(
                            "Item",
                            style: Theme.of(context).header4,
                          ),
                          flex: 1,
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Expanded(
                          child: PaddedText(
                            "Number",
                            style: Theme.of(context).header4,
                          ),
                          flex: 1,
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Expanded(
                          child: PaddedText(
                            "Price",
                            style: Theme.of(context).header4,
                          ),
                          flex: 1,
                        )),
                    Padding(
                        padding: EdgeInsets.all(10),
                        child: Expanded(
                          child: PaddedText(
                            "Total price",
                            style: Theme.of(context).header4,
                          ),
                          flex: 1,
                        )),
                  ],
                ),
                ...listShowObjectMainTable.map(
                  (e) => TableRow(
                    children: [
                      Expanded(
                        child: PaddedText(e.value0),
                        flex: 1,
                      ),
                      Expanded(
                        child: PaddedText(e.value1),
                        flex: 1,
                      ),
                      Expanded(
                        child: PaddedText("\$${e.value3}"),
                        flex: 1,
                      ),
                      Expanded(
                        child: PaddedText("\$${e.value5}"),
                        flex: 1,
                      )
                    ],
                  ),
                ),
                TableRow(
                  decoration: const BoxDecoration(color: PdfColors.grey100),
                  children: [
                    PaddedText('', align: TextAlign.right),
                    PaddedText('', align: TextAlign.right),
                    PaddedText('TAX', align: TextAlign.right),
                    PaddedText('\$${double.parse(totalPrice) * 0.1}'),
                  ],
                ),
                TableRow(
                  decoration: const BoxDecoration(color: PdfColors.grey200),
                  children: [
                    PaddedText('', align: TextAlign.right),
                    PaddedText('', align: TextAlign.right),
                    PaddedText('TOTAL', align: TextAlign.right),
                    PaddedText('\$$totalPrice')
                  ],
                )
              ],
            ),
          ],
        );
      },
    ),
  );
  return pdf.save();
}

Widget PaddedText(final String text,
        {final TextAlign align = TextAlign.left, TextStyle? style}) =>
    Center(
        child: Padding(
      padding: EdgeInsets.all(10),
      child: Text(text, textAlign: align, style: style),
    ));
