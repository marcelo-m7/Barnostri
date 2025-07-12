import 'package:flutter/material.dart';
import 'package:barnostri_app/l10n/generated/app_localizations.dart';

class NotFoundPage extends StatelessWidget {
  const NotFoundPage({super.key});

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context);
    return Scaffold(
      backgroundColor: Theme.of(context).colorScheme.surface,
      body: Center(
        child: Text(l10n.pageNotFound),
      ),
    );
  }
}
