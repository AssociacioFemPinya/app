// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Catalan Valencian (`ca`).
class AppLocalizationsCa extends AppLocalizations {
  AppLocalizationsCa([String locale = 'ca']) : super(locale);

  @override
  String menuAppName(String userName) {
    return 'FemPinya. Hola $userName!';
  }

  @override
  String get menuHome => 'Inici';

  @override
  String get menuEvents => 'Agenda';

  @override
  String get menuNotifications => 'Notícies';

  @override
  String get menuRondes => 'Rondes';

  @override
  String get menuPublicDisplayUrl => 'Pinya';

  @override
  String get menuHistorial => 'Historial';

  @override
  String get menuMore => 'Més opcions';

  @override
  String get menuLogout => 'Tancar sessió';

  @override
  String get menuAbout => 'Sobre FemCastells';

  @override
  String get menuPrivacy => 'Política de privacitat';

  @override
  String get menuHelp => 'Ajuda i comentaris';

  @override
  String get menuDisconnect => 'Desconnectar';

  @override
  String menuLanguageSettings(String locale) {
    String _temp0 = intl.Intl.selectLogic(
      locale,
      {
        'ca': 'Català',
        'en': 'English',
        'es': 'Español',
        'fr': 'Français',
        'other': '',
      },
    );
    return '$_temp0';
  }

  @override
  String get loginPageTitle => 'Iniciar sessió';

  @override
  String get loginSnackBarError => 'Error d\'autenticació';

  @override
  String get loginPageEmailTitle => 'Correu electrònic';

  @override
  String get loginPagePasswordTitle => 'Contrasenya';

  @override
  String get loginPageLoginButton => 'Iniciar sessió';

  @override
  String get loginPageInvalidMail => 'Correu electrònic invàlid';

  @override
  String get loginPageInvalidPassword => 'Contrasenya invàlida';

  @override
  String get eventsPageTitle => 'Esdeveniments';

  @override
  String get eventsPageEventsWithAlertBanner =>
      'Tens events que requereixen atencio!';

  @override
  String get eventsPageTypeChipTraining => 'Assajos';

  @override
  String get eventsPageTypeChipPerformance => 'Sortides';

  @override
  String get eventsPageTypeChipActivity => 'Activitats';

  @override
  String get eventsPageTypeFilterTitle => 'Tipus';

  @override
  String get eventsPageStatusFilterPending => 'Pendent';

  @override
  String get eventsPageStatusFilterAnswered => 'Respost';

  @override
  String get eventsPageStatusFilterWarning => 'Amb alerta';

  @override
  String get eventsPageEventViewModeList => 'Llista';

  @override
  String get eventsPageEventViewModeCalendar => 'Calendari';

  @override
  String get eventPageScheduleTitle => 'Horaris';

  @override
  String get eventPageAddCommentsTitle => 'Afegir comentaris';

  @override
  String eventsPageAttendaceQuestion(String eventName) {
    return 'Vindràs a $eventName?';
  }

  @override
  String get eventsPageAttendaceYesResponse => 'Si';

  @override
  String get eventsPageAttendaceNoResponse => 'No';

  @override
  String get eventsPageAttendaceUnknowResponse => 'No ho sé';

  @override
  String get eventPageAdditionalOptionSelector => 'Información adicional';

  @override
  String get eventPageCompanionsSelector => 'Algun acompanyant?';

  @override
  String get eventPageAttendanceSaved => 'Assistència desada';

  @override
  String get eventPageAnswersSaved => 'Respostes desades';

  @override
  String get eventPageClosedBanner =>
      'El termini per confirmar assistència ha finalitzat';

  @override
  String get commonReturn => 'Tornar';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonFilter => 'Filtrar';

  @override
  String get commonSnackBarSuccessSaving => 'Desat amb èxit';

  @override
  String get commentsScreenHintText => 'Escriu els teus comentaris';

  @override
  String get commentsScreenLabelText => 'Comentaris';

  @override
  String get rondesListEmpty =>
      'No hi ha rondes disponibles en aquest moment. Si us plau, torna a comprovar-ho més tard.';

  @override
  String rondesListRondaButton(int rondaNumber, String eventName) {
    return 'Ronda $rondaNumber $eventName';
  }

  @override
  String get rondaViewLoadFailureStateEmptyUri => 'Ronda URI està vuida';

  @override
  String get rondaViewLoadFailureStateWrongUri => 'Ronda URI incorrecta';

  @override
  String get publicDisplayUrlLoadFailureStateEmptyUri => 'Cap pinya projectada';

  @override
  String get publicDisplayUrlLoadFailureStateWrongUri =>
      'URI pinya projectada incorrecta';

  @override
  String get notificationsTitle => 'Notícies';

  @override
  String get notificationsEmpty => 'No hi ha notícies';

  @override
  String get timeAgoSeconds => 'fa uns segons';

  @override
  String timeAgoMinutes(int minutes) {
    return 'fa $minutes minuts';
  }

  @override
  String timeAgoHours(int hours) {
    return 'fa $hours hores';
  }

  @override
  String timeAgoDays(int days) {
    return 'fa $days dies';
  }

  @override
  String get userProfileMenu => 'Usuari';

  @override
  String get userProfileName => 'Nom';

  @override
  String get userProfileLastName => 'Cognom';

  @override
  String get userProfilePersonalInfoSection => 'Informació Personal';

  @override
  String get userProfileUserId => 'ID d\'Usuari';

  @override
  String get userProfileExternalId => 'ID Extern';

  @override
  String get userProfileCollaId => 'ID de Colla';

  @override
  String get userProfileSociNumber => 'Número de Soci';

  @override
  String get userProfileAlias => 'Àlies';

  @override
  String get userProfileGender => 'Gènere';

  @override
  String get userProfileMale => 'Home';

  @override
  String get userProfileFemale => 'Dona';

  @override
  String get userProfileBirthdate => 'Data de Naixement';

  @override
  String get userProfileContactInfoSection => 'Informació de Contacte';

  @override
  String get userProfileEmail => 'Correu Electrònic';

  @override
  String get userProfileSecondaryEmail => 'Correu Electrònic Secundari';

  @override
  String get userProfilePhoneNumber => 'Número de Telèfon';

  @override
  String get userProfileMobileNumber => 'Número de Mòbil';

  @override
  String get userProfileEmergencyContact => 'Contacte d\'Emergència';

  @override
  String get userProfileAddressInfoSection => 'Informació d\'Adreça';

  @override
  String get userProfileStreetAddress => 'Adreça';

  @override
  String get userProfilePostalCode => 'Codi Postal';

  @override
  String get userProfileCity => 'Ciutat';

  @override
  String get userProfileComarca => 'Comarca';

  @override
  String get userProfileProvince => 'Província';

  @override
  String get userProfileCountry => 'País';

  @override
  String get userProfilePhysicalInfoSection => 'Informació Física';

  @override
  String get userProfileHeight => 'Alçada';

  @override
  String get userProfileWeight => 'Pes';

  @override
  String get userProfileShoulderHeight => 'Alçada d\'espatlles';

  @override
  String get userProfileAdditionalInfoSection => 'Informació Addicional';

  @override
  String get userProfileNationality => 'Nacionalitat';

  @override
  String get userProfileNationalIdNumber => 'Número d\'ID Nacional';

  @override
  String get userProfileNationalIdType => 'Tipus d\'ID Nacional';

  @override
  String get userProfileFamily => 'Família';

  @override
  String get userProfileFamilyHead => 'Cap de Família';

  @override
  String get userProfileSubscriptionDate => 'Data de Subscripció';

  @override
  String get userProfileComments => 'Comentaris';

  @override
  String get userProfilePhoto => 'Foto';

  @override
  String get userProfileStatus => 'Estat';

  @override
  String get userProfileLanguage => 'Idioma';

  @override
  String get userProfileInteractionType => 'Tipus d\'Interacció';

  @override
  String get userProfileCreatedAt => 'Creat el';

  @override
  String get userProfileUpdatedAt => 'Actualitzat el';
}
