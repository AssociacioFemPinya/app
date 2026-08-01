import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_ca.dart';
import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

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

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
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
    Locale('ca'),
    Locale('en'),
    Locale('es'),
    Locale('fr')
  ];

  /// No description provided for @menuAppName.
  ///
  /// In ca, this message translates to:
  /// **'FemPinya. Hola {userName}!'**
  String menuAppName(String userName);

  /// No description provided for @menuHome.
  ///
  /// In ca, this message translates to:
  /// **'Inici'**
  String get menuHome;

  /// No description provided for @menuEvents.
  ///
  /// In ca, this message translates to:
  /// **'Agenda'**
  String get menuEvents;

  /// No description provided for @menuNotifications.
  ///
  /// In ca, this message translates to:
  /// **'Notícies'**
  String get menuNotifications;

  /// No description provided for @menuRondes.
  ///
  /// In ca, this message translates to:
  /// **'Rondes'**
  String get menuRondes;

  /// No description provided for @menuPublicDisplayUrl.
  ///
  /// In ca, this message translates to:
  /// **'Pinya'**
  String get menuPublicDisplayUrl;

  /// No description provided for @menuHistorial.
  ///
  /// In ca, this message translates to:
  /// **'Historial'**
  String get menuHistorial;

  /// No description provided for @menuMore.
  ///
  /// In ca, this message translates to:
  /// **'Més opcions'**
  String get menuMore;

  /// No description provided for @menuLogout.
  ///
  /// In ca, this message translates to:
  /// **'Tancar sessió'**
  String get menuLogout;

  /// No description provided for @menuAbout.
  ///
  /// In ca, this message translates to:
  /// **'Sobre FemCastells'**
  String get menuAbout;

  /// No description provided for @menuPrivacy.
  ///
  /// In ca, this message translates to:
  /// **'Política de privacitat'**
  String get menuPrivacy;

  /// No description provided for @menuHelp.
  ///
  /// In ca, this message translates to:
  /// **'Ajuda i comentaris'**
  String get menuHelp;

  /// No description provided for @menuDisconnect.
  ///
  /// In ca, this message translates to:
  /// **'Desconnectar'**
  String get menuDisconnect;

  /// No description provided for @menuLanguageSettings.
  ///
  /// In ca, this message translates to:
  /// **'{locale, select, ca {Català} en {English} es {Español} fr {Français} other {}}'**
  String menuLanguageSettings(String locale);

  /// No description provided for @loginPageTitle.
  ///
  /// In ca, this message translates to:
  /// **'Iniciar sessió'**
  String get loginPageTitle;

  /// No description provided for @loginSnackBarError.
  ///
  /// In ca, this message translates to:
  /// **'Error d\'autenticació'**
  String get loginSnackBarError;

  /// No description provided for @loginPageEmailTitle.
  ///
  /// In ca, this message translates to:
  /// **'Correu electrònic'**
  String get loginPageEmailTitle;

  /// No description provided for @loginPagePasswordTitle.
  ///
  /// In ca, this message translates to:
  /// **'Contrasenya'**
  String get loginPagePasswordTitle;

  /// No description provided for @loginPageLoginButton.
  ///
  /// In ca, this message translates to:
  /// **'Iniciar sessió'**
  String get loginPageLoginButton;

  /// No description provided for @loginPageInvalidMail.
  ///
  /// In ca, this message translates to:
  /// **'Correu electrònic invàlid'**
  String get loginPageInvalidMail;

  /// No description provided for @loginPageInvalidPassword.
  ///
  /// In ca, this message translates to:
  /// **'Contrasenya invàlida'**
  String get loginPageInvalidPassword;

  /// No description provided for @eventsPageTitle.
  ///
  /// In ca, this message translates to:
  /// **'Esdeveniments'**
  String get eventsPageTitle;

  /// No description provided for @eventsPageEventsWithAlertBanner.
  ///
  /// In ca, this message translates to:
  /// **'Tens events que requereixen atencio!'**
  String get eventsPageEventsWithAlertBanner;

  /// No description provided for @eventsPageTypeChipTraining.
  ///
  /// In ca, this message translates to:
  /// **'Assajos'**
  String get eventsPageTypeChipTraining;

  /// No description provided for @eventsPageTypeChipPerformance.
  ///
  /// In ca, this message translates to:
  /// **'Sortides'**
  String get eventsPageTypeChipPerformance;

  /// No description provided for @eventsPageTypeChipActivity.
  ///
  /// In ca, this message translates to:
  /// **'Activitats'**
  String get eventsPageTypeChipActivity;

  /// No description provided for @eventsPageTypeFilterTitle.
  ///
  /// In ca, this message translates to:
  /// **'Tipus'**
  String get eventsPageTypeFilterTitle;

  /// No description provided for @eventsPageStatusFilterPending.
  ///
  /// In ca, this message translates to:
  /// **'Pendent'**
  String get eventsPageStatusFilterPending;

  /// No description provided for @eventsPageStatusFilterAnswered.
  ///
  /// In ca, this message translates to:
  /// **'Respost'**
  String get eventsPageStatusFilterAnswered;

  /// No description provided for @eventsPageStatusFilterWarning.
  ///
  /// In ca, this message translates to:
  /// **'Amb alerta'**
  String get eventsPageStatusFilterWarning;

  /// No description provided for @eventsPageEventViewModeList.
  ///
  /// In ca, this message translates to:
  /// **'Llista'**
  String get eventsPageEventViewModeList;

  /// No description provided for @eventsPageEventViewModeCalendar.
  ///
  /// In ca, this message translates to:
  /// **'Calendari'**
  String get eventsPageEventViewModeCalendar;

  /// No description provided for @eventPageScheduleTitle.
  ///
  /// In ca, this message translates to:
  /// **'Horaris'**
  String get eventPageScheduleTitle;

  /// No description provided for @eventPageAddCommentsTitle.
  ///
  /// In ca, this message translates to:
  /// **'Afegir comentaris'**
  String get eventPageAddCommentsTitle;

  /// No description provided for @eventsPageAttendaceQuestion.
  ///
  /// In ca, this message translates to:
  /// **'Vindràs a {eventName}?'**
  String eventsPageAttendaceQuestion(String eventName);

  /// No description provided for @eventsPageAttendaceYesResponse.
  ///
  /// In ca, this message translates to:
  /// **'Si'**
  String get eventsPageAttendaceYesResponse;

  /// No description provided for @eventsPageAttendaceNoResponse.
  ///
  /// In ca, this message translates to:
  /// **'No'**
  String get eventsPageAttendaceNoResponse;

  /// No description provided for @eventsPageAttendaceUnknowResponse.
  ///
  /// In ca, this message translates to:
  /// **'No ho sé'**
  String get eventsPageAttendaceUnknowResponse;

  /// No description provided for @eventPageAdditionalOptionSelector.
  ///
  /// In ca, this message translates to:
  /// **'Información adicional'**
  String get eventPageAdditionalOptionSelector;

  /// No description provided for @eventPageCompanionsSelector.
  ///
  /// In ca, this message translates to:
  /// **'Algun acompanyant?'**
  String get eventPageCompanionsSelector;

  /// No description provided for @eventPageAttendanceSaved.
  ///
  /// In ca, this message translates to:
  /// **'Assistència desada'**
  String get eventPageAttendanceSaved;

  /// No description provided for @eventPageAnswersSaved.
  ///
  /// In ca, this message translates to:
  /// **'Respostes desades'**
  String get eventPageAnswersSaved;

  /// No description provided for @eventPageClosedBanner.
  ///
  /// In ca, this message translates to:
  /// **'El termini per confirmar assistència ha finalitzat'**
  String get eventPageClosedBanner;

  /// No description provided for @commonReturn.
  ///
  /// In ca, this message translates to:
  /// **'Tornar'**
  String get commonReturn;

  /// No description provided for @commonSave.
  ///
  /// In ca, this message translates to:
  /// **'Guardar'**
  String get commonSave;

  /// No description provided for @commonFilter.
  ///
  /// In ca, this message translates to:
  /// **'Filtrar'**
  String get commonFilter;

  /// No description provided for @commonSnackBarSuccessSaving.
  ///
  /// In ca, this message translates to:
  /// **'Desat amb èxit'**
  String get commonSnackBarSuccessSaving;

  /// No description provided for @commentsScreenHintText.
  ///
  /// In ca, this message translates to:
  /// **'Escriu els teus comentaris'**
  String get commentsScreenHintText;

  /// No description provided for @commentsScreenLabelText.
  ///
  /// In ca, this message translates to:
  /// **'Comentaris'**
  String get commentsScreenLabelText;

  /// No description provided for @rondesListEmpty.
  ///
  /// In ca, this message translates to:
  /// **'No hi ha rondes disponibles en aquest moment. Si us plau, torna a comprovar-ho més tard.'**
  String get rondesListEmpty;

  /// No description provided for @rondesListRondaButton.
  ///
  /// In ca, this message translates to:
  /// **'Ronda {rondaNumber} {eventName}'**
  String rondesListRondaButton(int rondaNumber, String eventName);

  /// No description provided for @rondaViewLoadFailureStateEmptyUri.
  ///
  /// In ca, this message translates to:
  /// **'Ronda URI està vuida'**
  String get rondaViewLoadFailureStateEmptyUri;

  /// No description provided for @rondaViewLoadFailureStateWrongUri.
  ///
  /// In ca, this message translates to:
  /// **'Ronda URI incorrecta'**
  String get rondaViewLoadFailureStateWrongUri;

  /// No description provided for @publicDisplayUrlLoadFailureStateEmptyUri.
  ///
  /// In ca, this message translates to:
  /// **'Cap pinya projectada'**
  String get publicDisplayUrlLoadFailureStateEmptyUri;

  /// No description provided for @publicDisplayUrlLoadFailureStateWrongUri.
  ///
  /// In ca, this message translates to:
  /// **'URI pinya projectada incorrecta'**
  String get publicDisplayUrlLoadFailureStateWrongUri;

  /// No description provided for @notificationsTitle.
  ///
  /// In ca, this message translates to:
  /// **'Notícies'**
  String get notificationsTitle;

  /// No description provided for @notificationsEmpty.
  ///
  /// In ca, this message translates to:
  /// **'No hi ha notícies'**
  String get notificationsEmpty;

  /// No description provided for @timeAgoSeconds.
  ///
  /// In ca, this message translates to:
  /// **'fa uns segons'**
  String get timeAgoSeconds;

  /// No description provided for @timeAgoMinutes.
  ///
  /// In ca, this message translates to:
  /// **'fa {minutes} minuts'**
  String timeAgoMinutes(int minutes);

  /// No description provided for @timeAgoHours.
  ///
  /// In ca, this message translates to:
  /// **'fa {hours} hores'**
  String timeAgoHours(int hours);

  /// No description provided for @timeAgoDays.
  ///
  /// In ca, this message translates to:
  /// **'fa {days} dies'**
  String timeAgoDays(int days);

  /// No description provided for @userProfileMenu.
  ///
  /// In ca, this message translates to:
  /// **'Usuari'**
  String get userProfileMenu;

  /// No description provided for @userProfileName.
  ///
  /// In ca, this message translates to:
  /// **'Nom'**
  String get userProfileName;

  /// No description provided for @userProfileLastName.
  ///
  /// In ca, this message translates to:
  /// **'Cognom'**
  String get userProfileLastName;

  /// No description provided for @userProfilePersonalInfoSection.
  ///
  /// In ca, this message translates to:
  /// **'Informació Personal'**
  String get userProfilePersonalInfoSection;

  /// No description provided for @userProfileUserId.
  ///
  /// In ca, this message translates to:
  /// **'ID d\'Usuari'**
  String get userProfileUserId;

  /// No description provided for @userProfileExternalId.
  ///
  /// In ca, this message translates to:
  /// **'ID Extern'**
  String get userProfileExternalId;

  /// No description provided for @userProfileCollaId.
  ///
  /// In ca, this message translates to:
  /// **'ID de Colla'**
  String get userProfileCollaId;

  /// No description provided for @userProfileSociNumber.
  ///
  /// In ca, this message translates to:
  /// **'Número de Soci'**
  String get userProfileSociNumber;

  /// No description provided for @userProfileAlias.
  ///
  /// In ca, this message translates to:
  /// **'Àlies'**
  String get userProfileAlias;

  /// No description provided for @userProfileGender.
  ///
  /// In ca, this message translates to:
  /// **'Gènere'**
  String get userProfileGender;

  /// No description provided for @userProfileMale.
  ///
  /// In ca, this message translates to:
  /// **'Home'**
  String get userProfileMale;

  /// No description provided for @userProfileFemale.
  ///
  /// In ca, this message translates to:
  /// **'Dona'**
  String get userProfileFemale;

  /// No description provided for @userProfileBirthdate.
  ///
  /// In ca, this message translates to:
  /// **'Data de Naixement'**
  String get userProfileBirthdate;

  /// No description provided for @userProfileContactInfoSection.
  ///
  /// In ca, this message translates to:
  /// **'Informació de Contacte'**
  String get userProfileContactInfoSection;

  /// No description provided for @userProfileEmail.
  ///
  /// In ca, this message translates to:
  /// **'Correu Electrònic'**
  String get userProfileEmail;

  /// No description provided for @userProfileSecondaryEmail.
  ///
  /// In ca, this message translates to:
  /// **'Correu Electrònic Secundari'**
  String get userProfileSecondaryEmail;

  /// No description provided for @userProfilePhoneNumber.
  ///
  /// In ca, this message translates to:
  /// **'Número de Telèfon'**
  String get userProfilePhoneNumber;

  /// No description provided for @userProfileMobileNumber.
  ///
  /// In ca, this message translates to:
  /// **'Número de Mòbil'**
  String get userProfileMobileNumber;

  /// No description provided for @userProfileEmergencyContact.
  ///
  /// In ca, this message translates to:
  /// **'Contacte d\'Emergència'**
  String get userProfileEmergencyContact;

  /// No description provided for @userProfileAddressInfoSection.
  ///
  /// In ca, this message translates to:
  /// **'Informació d\'Adreça'**
  String get userProfileAddressInfoSection;

  /// No description provided for @userProfileStreetAddress.
  ///
  /// In ca, this message translates to:
  /// **'Adreça'**
  String get userProfileStreetAddress;

  /// No description provided for @userProfilePostalCode.
  ///
  /// In ca, this message translates to:
  /// **'Codi Postal'**
  String get userProfilePostalCode;

  /// No description provided for @userProfileCity.
  ///
  /// In ca, this message translates to:
  /// **'Ciutat'**
  String get userProfileCity;

  /// No description provided for @userProfileComarca.
  ///
  /// In ca, this message translates to:
  /// **'Comarca'**
  String get userProfileComarca;

  /// No description provided for @userProfileProvince.
  ///
  /// In ca, this message translates to:
  /// **'Província'**
  String get userProfileProvince;

  /// No description provided for @userProfileCountry.
  ///
  /// In ca, this message translates to:
  /// **'País'**
  String get userProfileCountry;

  /// No description provided for @userProfilePhysicalInfoSection.
  ///
  /// In ca, this message translates to:
  /// **'Informació Física'**
  String get userProfilePhysicalInfoSection;

  /// No description provided for @userProfileHeight.
  ///
  /// In ca, this message translates to:
  /// **'Alçada'**
  String get userProfileHeight;

  /// No description provided for @userProfileWeight.
  ///
  /// In ca, this message translates to:
  /// **'Pes'**
  String get userProfileWeight;

  /// No description provided for @userProfileShoulderHeight.
  ///
  /// In ca, this message translates to:
  /// **'Alçada d\'espatlles'**
  String get userProfileShoulderHeight;

  /// No description provided for @userProfileAdditionalInfoSection.
  ///
  /// In ca, this message translates to:
  /// **'Informació Addicional'**
  String get userProfileAdditionalInfoSection;

  /// No description provided for @userProfileNationality.
  ///
  /// In ca, this message translates to:
  /// **'Nacionalitat'**
  String get userProfileNationality;

  /// No description provided for @userProfileNationalIdNumber.
  ///
  /// In ca, this message translates to:
  /// **'Número d\'ID Nacional'**
  String get userProfileNationalIdNumber;

  /// No description provided for @userProfileNationalIdType.
  ///
  /// In ca, this message translates to:
  /// **'Tipus d\'ID Nacional'**
  String get userProfileNationalIdType;

  /// No description provided for @userProfileFamily.
  ///
  /// In ca, this message translates to:
  /// **'Família'**
  String get userProfileFamily;

  /// No description provided for @userProfileFamilyHead.
  ///
  /// In ca, this message translates to:
  /// **'Cap de Família'**
  String get userProfileFamilyHead;

  /// No description provided for @userProfileSubscriptionDate.
  ///
  /// In ca, this message translates to:
  /// **'Data de Subscripció'**
  String get userProfileSubscriptionDate;

  /// No description provided for @userProfileComments.
  ///
  /// In ca, this message translates to:
  /// **'Comentaris'**
  String get userProfileComments;

  /// No description provided for @userProfilePhoto.
  ///
  /// In ca, this message translates to:
  /// **'Foto'**
  String get userProfilePhoto;

  /// No description provided for @userProfileStatus.
  ///
  /// In ca, this message translates to:
  /// **'Estat'**
  String get userProfileStatus;

  /// No description provided for @userProfileLanguage.
  ///
  /// In ca, this message translates to:
  /// **'Idioma'**
  String get userProfileLanguage;

  /// No description provided for @userProfileInteractionType.
  ///
  /// In ca, this message translates to:
  /// **'Tipus d\'Interacció'**
  String get userProfileInteractionType;

  /// No description provided for @userProfileCreatedAt.
  ///
  /// In ca, this message translates to:
  /// **'Creat el'**
  String get userProfileCreatedAt;

  /// No description provided for @userProfileUpdatedAt.
  ///
  /// In ca, this message translates to:
  /// **'Actualitzat el'**
  String get userProfileUpdatedAt;
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
      <String>['ca', 'en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'ca':
      return AppLocalizationsCa();
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
      'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
      'an issue with the localizations generation tool. Please file an issue '
      'on GitHub with a reproducible sample app and the gen-l10n configuration '
      'that was used.');
}
