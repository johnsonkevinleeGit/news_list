import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:news_list/locale_state.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

class SettingsPage extends ConsumerWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final locale = ref.watch(providerOfLocale);

    return Scaffold(
      appBar: AppBar(
        title: Text(AppLocalizations.of(context)!.settings),
      ),
      body: Column(children: [
        Padding(
          padding: const EdgeInsets.all(12),
          child: DropdownButtonFormField(
            value: locale,
            decoration: InputDecoration(
              border: const OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(7)),
              ),
              labelText: AppLocalizations.of(context)?.language ?? '',
            ),
            items: [
              DropdownMenuItem(
                value: SupportedLocales.enUS,
                child:
                    Text(getLanguageByString(SupportedLocales.enUS.toString())),
              ),
              DropdownMenuItem(
                value: SupportedLocales.es,
                child:
                    Text(getLanguageByString(SupportedLocales.es.toString())),
              ),
            ],
            onChanged: (Locale? locale) async {
              if (locale != null) {
                ref.read(providerOfLocale.notifier).state = locale;
              }
            },
          ),
        ),
        Text(AppLocalizations.of(context)?.helloWorld ?? '')
      ]),
    );
  }
}
