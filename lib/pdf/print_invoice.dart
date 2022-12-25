import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:printing/printing.dart';
import 'package:store_manager/utils/objects.dart';

import 'make_pdf_utile.dart';

class PrintInvoice extends StatefulWidget {
  final String workerName;
  final String date;
  final String outSidePersonnel;
  final String totalPrice;
  final List<ShowObject> listShowObjectMainTable;
  const PrintInvoice(
      {super.key,
      required this.workerName,
      required this.date,
      required this.outSidePersonnel,
      required this.listShowObjectMainTable,
      required this.totalPrice});

  @override
  State<PrintInvoice> createState() => _PrintInvoiceState();
}

class _PrintInvoiceState extends State<PrintInvoice> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('PDF Preview'),
      ),
      body: PdfPreview(
        build: (context) => makePdf(
            totalPrice: widget.totalPrice,
            workerName: widget.workerName,
            date: widget.date,
            outSidePersonnel: widget.outSidePersonnel,
            listShowObjectMainTable: widget.listShowObjectMainTable),
      ),
    );
  }
}
