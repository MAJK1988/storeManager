import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../dataBase/search_column.dart';
import '../utils/utils.dart';

class BillUniqStoreIn extends StatefulWidget {
  const BillUniqStoreIn({super.key});

  @override
  State<BillUniqStoreIn> createState() => _BillUniqStoreInState();
}

class _BillUniqStoreInState extends State<BillUniqStoreIn> {
  final String tag = "BillUniqStoreIn";
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.bill_receipt),
          centerTitle: true,
        ),
        body: SingleChildScrollView(
            child: Wrap(children: <Widget>[
          Center(
            child: SizedBox(
              width: size.width * 0.95,
              child: Padding(
                padding: const EdgeInsets.only(top: 40, bottom: 30),
                child: Card(
                    child: SearchColumnSTF(
                  size: size,
                  getElement: (value) {
                    Log(tag: tag, message: "value: $value");
                  },
                )),
              ),
            ),
          ),
        ])));
  }
}
