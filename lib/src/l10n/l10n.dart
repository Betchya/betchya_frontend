import 'package:betchya_frontend/src/l10n/arb/app_localizations.dart'
    show AppLocalizations;
import 'package:flutter/widgets.dart';

extension AppLocalizationsX on BuildContext {
  AppLocalizations get l10n => AppLocalizations.of(this);
}
