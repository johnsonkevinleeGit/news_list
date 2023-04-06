import 'package:flutter/material.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:news_list/settings/settings_page.dart';

class MyEndDrawer extends StatelessWidget {
  const MyEndDrawer({super.key});

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 200,
      backgroundColor: Colors.blue,
      child: ListView(padding: EdgeInsets.zero, children: [
        Padding(
          padding: const EdgeInsets.only(top: 20, left: 20),
          child: Text(AppLocalizations.of(context)!.menu,
              style: Theme.of(context)
                  .textTheme
                  .titleLarge
                  ?.copyWith(color: Colors.white)),
        ),
        const Divider(color: Colors.white, thickness: 1),
        InkWell(
          onTap: () {
            Navigator.of(context).pop();
            Navigator.of(context).push(
                MaterialPageRoute(builder: (context) => const SettingsPage()));
          },
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: [
                const Icon(Icons.settings, color: Colors.white),
                const SizedBox(width: 5),
                Text(AppLocalizations.of(context)!.settings,
                    style: Theme.of(context)
                        .textTheme
                        .bodyLarge
                        ?.copyWith(color: Colors.white))
              ],
            ),
          ),
        )
      ]),
    );
  }
}
