import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_pt.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations)!;
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('es'),
    Locale('pt'),
  ];

  /// No description provided for @app_title.
  ///
  /// In en, this message translates to:
  /// **'Inicie To-do'**
  String get app_title;

  /// No description provided for @home_welcome.
  ///
  /// In en, this message translates to:
  /// **'Welcome to\nInicie To-do!'**
  String get home_welcome;

  /// No description provided for @home_tab_all.
  ///
  /// In en, this message translates to:
  /// **'All Tasks'**
  String get home_tab_all;

  /// No description provided for @home_tab_pending.
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get home_tab_pending;

  /// No description provided for @home_tab_completed.
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get home_tab_completed;

  /// No description provided for @home_empty.
  ///
  /// In en, this message translates to:
  /// **'No tasks found'**
  String get home_empty;

  /// No description provided for @home_selected_count.
  ///
  /// In en, this message translates to:
  /// **'{count} selected'**
  String home_selected_count(int count);

  /// No description provided for @home_cancel_selection.
  ///
  /// In en, this message translates to:
  /// **'Cancel selection'**
  String get home_cancel_selection;

  /// No description provided for @home_menu_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get home_menu_edit;

  /// No description provided for @home_menu_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get home_menu_delete;

  /// No description provided for @task_new_title.
  ///
  /// In en, this message translates to:
  /// **'Create new task'**
  String get task_new_title;

  /// No description provided for @task_edit_title.
  ///
  /// In en, this message translates to:
  /// **'Edit task'**
  String get task_edit_title;

  /// No description provided for @task_field_title.
  ///
  /// In en, this message translates to:
  /// **'Title'**
  String get task_field_title;

  /// No description provided for @task_field_title_hint.
  ///
  /// In en, this message translates to:
  /// **'Enter the title'**
  String get task_field_title_hint;

  /// No description provided for @task_field_date.
  ///
  /// In en, this message translates to:
  /// **'Date (Optional)'**
  String get task_field_date;

  /// No description provided for @task_field_time.
  ///
  /// In en, this message translates to:
  /// **'Time (Optional)'**
  String get task_field_time;

  /// No description provided for @task_button_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get task_button_save;

  /// No description provided for @task_no_due_date.
  ///
  /// In en, this message translates to:
  /// **'No due date'**
  String get task_no_due_date;

  /// No description provided for @msg_task_created.
  ///
  /// In en, this message translates to:
  /// **'Task created successfully'**
  String get msg_task_created;

  /// No description provided for @msg_task_updated.
  ///
  /// In en, this message translates to:
  /// **'Task updated successfully'**
  String get msg_task_updated;

  /// No description provided for @msg_tasks_deleted.
  ///
  /// In en, this message translates to:
  /// **'{count} task(s) deleted'**
  String msg_tasks_deleted(int count);

  /// No description provided for @error_generic.
  ///
  /// In en, this message translates to:
  /// **'An error occurred'**
  String get error_generic;

  /// No description provided for @error_title_required.
  ///
  /// In en, this message translates to:
  /// **'Title is required'**
  String get error_title_required;

  /// No description provided for @error_invalid_date_format.
  ///
  /// In en, this message translates to:
  /// **'Incomplete date (use dd/mm/yyyy)'**
  String get error_invalid_date_format;

  /// No description provided for @error_invalid_date.
  ///
  /// In en, this message translates to:
  /// **'Invalid date'**
  String get error_invalid_date;

  /// No description provided for @error_date_before_today.
  ///
  /// In en, this message translates to:
  /// **'Date cannot be in the past'**
  String get error_date_before_today;

  /// No description provided for @error_invalid_time_format.
  ///
  /// In en, this message translates to:
  /// **'Incomplete time (use HH:mm)'**
  String get error_invalid_time_format;

  /// No description provided for @error_invalid_time.
  ///
  /// In en, this message translates to:
  /// **'Invalid time'**
  String get error_invalid_time;

  /// No description provided for @error_time_before_now.
  ///
  /// In en, this message translates to:
  /// **'Time cannot be earlier than now'**
  String get error_time_before_now;

  /// No description provided for @error_task_not_found.
  ///
  /// In en, this message translates to:
  /// **'Task not found'**
  String get error_task_not_found;

  /// No description provided for @error_max_length.
  ///
  /// In en, this message translates to:
  /// **'Max {max} characters'**
  String error_max_length(int max);

  /// No description provided for @common_save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get common_save;

  /// No description provided for @common_undo.
  ///
  /// In en, this message translates to:
  /// **'Undo'**
  String get common_undo;

  /// No description provided for @common_cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get common_cancel;

  /// No description provided for @common_edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get common_edit;

  /// No description provided for @common_delete.
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get common_delete;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'es', 'pt'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'pt':
      return AppLocalizationsPt();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
