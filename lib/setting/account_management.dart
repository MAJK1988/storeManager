import 'package:flutter/material.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:overlay_loading_progress/overlay_loading_progress.dart';
import 'package:store_manager/dataBase/sql_object.dart';
import 'package:store_manager/utils/objects.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '../utils/utils.dart';
import 'add_account.dart';

class AccountManagement extends StatefulWidget {
  const AccountManagement({super.key});

  @override
  State<AccountManagement> createState() => _AccountManagementState();
}

class _AccountManagementState extends State<AccountManagement> {
  late List<Worker> listUser = [];
  Map<int, String> positionMap = {};
  late bool isPopMenuVisible = false;
  int selectedIndex = 0;
  final String tag = "AccountManagement";

  initUI({bool isInit = false}) async {
    Log(tag: tag, message: "initUI activated");
    if (!isInit) {
      OverlayLoadingProgress.start(context);
    }
    var workersRes =
        await DBProvider.db.getAllObjects(tableName: workerTableName);
    if (workersRes.isNotEmpty) {
      for (var jsonWorker in workersRes) {
        Worker worker = Worker.fromJson(jsonWorker);
        if (worker.userIndex != 0) {
          setState(() {
            listUser.add(worker);
          });
        }
      }
    }
    if (!isInit) {
      OverlayLoadingProgress.stop();
    }
    if (isInit) {
      setState(() {
        positionMap = {
          0: AppLocalizations.of(context)!.worker,
          1: AppLocalizations.of(context)!.director,
          2: AppLocalizations.of(context)!.assistant,
          3: AppLocalizations.of(context)!.seller
        };
      });
    }
  }

  @override
  void initState() {
    super.initState();
    () async {
      await initUI(isInit: true);
    }();
    // TODO: implement initState
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
        appBar: AppBar(
          title: Text(AppLocalizations.of(context)!.add_account),
          actions: [
            Visibility(visible: isPopMenuVisible, child: popMenuAction())
          ],
        ),
        body: SingleChildScrollView(
          child: Center(
            child: SizedBox(
              width: size.width * 0.95,
              height: size.height * 0.95,
              child: ListView.builder(
                  itemCount: listUser.length,
                  itemBuilder: (context, index) {
                    String position = positionMap[listUser[index].userIndex]!;
                    return Card(
                        child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: ListTile(
                        title: Text(
                            '${AppLocalizations.of(context)!.name}: ${listUser[index].name}'),
                        subtitle: Wrap(
                          children: [
                            Text(
                                '${AppLocalizations.of(context)!.email}: ${listUser[index].email}'),
                            const Text(' <=> '),
                            Text(
                                '${AppLocalizations.of(context)!.password}: ${listUser[index].password}'),
                          ],
                        ),
                        trailing: Text(
                            '${AppLocalizations.of(context)!.position}: $position'),
                        onLongPress: () {
                          setState(() {
                            selectedIndex = index;
                            isPopMenuVisible = true;
                          });
                        },
                      ),
                    ));
                  }),
            ),
          ),
        ));
  }

  PopupMenuButton popMenuAction() {
    return PopupMenuButton(
      // add icon, by default "3 dot" icon
      // icon: Icon(Icons.book)
      itemBuilder: (context) {
        return [
          PopupMenuItem<int>(
            value: 1,
            child: Center(
              child: IconButton(
                  color: Colors.blue,
                  iconSize: 20,
                  icon: const Icon(Icons.delete),
                  onPressed: () {
                    setState(() {
                      isPopMenuVisible = false;
                    });
                    Worker worker = listUser[selectedIndex];
                    if (worker.userIndex != 1) {
                      show_Dialog(
                          context: context,
                          title: AppLocalizations.of(context)!.delete,
                          message: AppLocalizations.of(context)!.delete_message,
                          response: ((value) async {
                            if (value) {
                              OverlayLoadingProgress.start(context);
                              worker.userIndex = 0;
                              await DBProvider.db.updateObject(
                                  v: worker,
                                  tableName: workerTableName,
                                  id: worker.Id);

                              Log(tag: tag, message: "Delete user");

                              OverlayLoadingProgress.stop();
                              initUI();
                            }
                          }));
                    } else {
                      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                          content: Text(
                        // ignore: use_build_context_synchronously
                        AppLocalizations.of(context)!.manager_error_message,
                      )));
                    }
                  }),
            ),
          ),
          PopupMenuItem<int>(
            value: 1,
            child: Center(
              child: IconButton(
                  color: Colors.blue,
                  iconSize: 20,
                  icon: const Icon(Icons.edit),
                  onPressed: () {
                    setState(() {
                      isPopMenuVisible = false;
                    });
                    Navigator.of(context).push(
                      MaterialPageRoute(
                          builder: (context) => const AddAccount()),
                    );
                  }),
            ),
          ),
        ];
      },
    );
  }
}
