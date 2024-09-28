import 'package:flutter/material.dart';
import 'package:inghub_pomo/classes/result_class.dart';
import 'package:inghub_pomo/components/comp_navbar.dart';
import 'package:inghub_pomo/managers/dialog_manager.dart';
import 'package:inghub_pomo/providers/file_provider.dart';
import 'package:provider/provider.dart';

class HomePage extends StatelessWidget {
  const HomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Home Page"),
        centerTitle: true,
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            const Text("Home Page"),
            Consumer<FileProvider>(
              builder: (context, fileProvider, _) => TextButton(
                onPressed: () async {
                  Result<String> result = await fileProvider.readJsonFile(
                    directoryPath: fileProvider.localPath ?? "",
                    fileName: "test.json",
                  );
                  DialogManager().showAlertDialog(
                    AlertDialog(
                      title: const Text("Result"),
                      content: Text(result.isSuccess
                          ? "Success"
                          : result.isError
                              ? "Error: ${result.error}"
                              : "Unknown error"),
                      actions: [
                        TextButton(
                          onPressed: () {
                            Navigator.of(context).pop();
                          },
                          child: const Text("Close"),
                        ),
                      ],
                    ),
                  );
                },
                child: const Text("PUSH"),
              ),
            ),
          ],
        ),
      ),
      bottomNavigationBar: const CompNavbar(),
    );
  }
}
