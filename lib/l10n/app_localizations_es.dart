// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Spanish Castilian (`es`).
class AppLocalizationsEs extends AppLocalizations {
  AppLocalizationsEs([String locale = 'es']) : super(locale);

  @override
  String menuAppName(String userName) {
    return 'FemPinya. ¡Hola $userName!';
  }

  @override
  String get menuHome => 'Inicio';

  @override
  String get menuEvents => 'Agenda';

  @override
  String get menuNotifications => 'Noticias';

  @override
  String get menuRondes => 'Rondas';

  @override
  String get menuPublicDisplayUrl => 'Pinya';

  @override
  String get menuHistorial => 'Historial';

  @override
  String get menuMore => 'Más opciones';

  @override
  String get menuLogout => 'Cerrar sesión';

  @override
  String get menuAbout => 'Sobre FemCastells';

  @override
  String get menuPrivacy => 'Política de privacidad';

  @override
  String get menuHelp => 'Ayuda y comentarios';

  @override
  String get menuDisconnect => 'Desconectar';

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
  String get loginPageTitle => 'Iniciar sesión';

  @override
  String get loginSnackBarError => 'Error de autenticación';

  @override
  String get loginPageEmailTitle => 'Correo electrónico';

  @override
  String get loginPagePasswordTitle => 'Contraseña';

  @override
  String get loginPageLoginButton => 'Iniciar sesión';

  @override
  String get loginPageInvalidMail => 'Correo electrónico inválido';

  @override
  String get loginPageInvalidPassword => 'Contraseña inválida';

  @override
  String get eventsPageTitle => 'Eventos';

  @override
  String get eventsPageEventsWithAlertBanner =>
      '¡Tienes eventos que requieren atención!';

  @override
  String get eventsPageTypeChipTraining => 'Ensayos';

  @override
  String get eventsPageTypeChipPerformance => 'Salidas';

  @override
  String get eventsPageTypeChipActivity => 'Actividades';

  @override
  String get eventsPageTypeFilterTitle => 'Tipo';

  @override
  String get eventsPageStatusFilterPending => 'Pendiente';

  @override
  String get eventsPageStatusFilterAnswered => 'Respondido';

  @override
  String get eventsPageStatusFilterWarning => 'Con alerta';

  @override
  String get eventsPageEventViewModeList => 'Lista';

  @override
  String get eventsPageEventViewModeCalendar => 'Calendario';

  @override
  String get eventPageScheduleTitle => 'Horarios';

  @override
  String get eventPageAddCommentsTitle => 'Añadir comentarios';

  @override
  String eventsPageAttendaceQuestion(String eventName) {
    return '¿Vendrás a $eventName?';
  }

  @override
  String get eventsPageAttendaceYesResponse => 'Sí';

  @override
  String get eventsPageAttendaceNoResponse => 'No';

  @override
  String get eventsPageAttendaceUnknowResponse => 'No lo sé';

  @override
  String get eventPageAdditionalOptionSelector => 'Información adicional';

  @override
  String get eventPageCompanionsSelector => '¿Algún acompañante?';

  @override
  String get eventPageAttendanceSaved => 'Asistencia guardada';

  @override
  String get eventPageAnswersSaved => 'Respuestas guardadas';

  @override
  String get eventPageClosedBanner =>
      'El plazo para confirmar asistencia ha finalizado';

  @override
  String get commonReturn => 'Volver';

  @override
  String get commonSave => 'Guardar';

  @override
  String get commonFilter => 'Filtrar';

  @override
  String get commonSnackBarSuccessSaving => 'Guardado con éxito';

  @override
  String get commentsScreenHintText => 'Escribe tus comentarios';

  @override
  String get commentsScreenLabelText => 'Comentarios';

  @override
  String get rondesListEmpty =>
      'No hay rondas disponibles en este momento. Por favor, vuelve a comprobar más tarde.';

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
  String get notificationsTitle => 'Noticias';

  @override
  String get notificationsEmpty => 'No hay noticias';

  @override
  String get timeAgoSeconds => 'hace unos segundos';

  @override
  String timeAgoMinutes(int minutes) {
    return 'hace $minutes minutos';
  }

  @override
  String timeAgoHours(int hours) {
    return 'hace $hours horas';
  }

  @override
  String timeAgoDays(int days) {
    return 'hace $days días';
  }

  @override
  String get userProfileMenu => 'Usuario';

  @override
  String get userProfileName => 'Nombre';

  @override
  String get userProfileLastName => 'Apellido';

  @override
  String get userProfilePersonalInfoSection => 'Información Personal';

  @override
  String get userProfileUserId => 'ID de Usuario';

  @override
  String get userProfileExternalId => 'ID Externo';

  @override
  String get userProfileCollaId => 'ID de Colla';

  @override
  String get userProfileSociNumber => 'Número de Socio';

  @override
  String get userProfileAlias => 'Alias';

  @override
  String get userProfileGender => 'Género';

  @override
  String get userProfileMale => 'Hombre';

  @override
  String get userProfileFemale => 'Mujer';

  @override
  String get userProfileBirthdate => 'Fecha de Nacimiento';

  @override
  String get userProfileContactInfoSection => 'Información de Contacto';

  @override
  String get userProfileEmail => 'Correo Electrónico';

  @override
  String get userProfileSecondaryEmail => 'Correo Electrónico Secundario';

  @override
  String get userProfilePhoneNumber => 'Número de Teléfono';

  @override
  String get userProfileMobileNumber => 'Número de Móvil';

  @override
  String get userProfileEmergencyContact => 'Contacto de Emergencia';

  @override
  String get userProfileAddressInfoSection => 'Información de Dirección';

  @override
  String get userProfileStreetAddress => 'Dirección';

  @override
  String get userProfilePostalCode => 'Código Postal';

  @override
  String get userProfileCity => 'Ciudad';

  @override
  String get userProfileComarca => 'Comarca';

  @override
  String get userProfileProvince => 'Provincia';

  @override
  String get userProfileCountry => 'País';

  @override
  String get userProfilePhysicalInfoSection => 'Información Física';

  @override
  String get userProfileHeight => 'Altura';

  @override
  String get userProfileWeight => 'Peso';

  @override
  String get userProfileShoulderHeight => 'Altura de Hombros';

  @override
  String get userProfileAdditionalInfoSection => 'Información Adicional';

  @override
  String get userProfileNationality => 'Nacionalidad';

  @override
  String get userProfileNationalIdNumber => 'Número de ID Nacional';

  @override
  String get userProfileNationalIdType => 'Tipo de ID Nacional';

  @override
  String get userProfileFamily => 'Familia';

  @override
  String get userProfileFamilyHead => 'Jefe de Familia';

  @override
  String get userProfileSubscriptionDate => 'Fecha de Suscripción';

  @override
  String get userProfileComments => 'Comentarios';

  @override
  String get userProfilePhoto => 'Foto';

  @override
  String get userProfileStatus => 'Estado';

  @override
  String get userProfileLanguage => 'Idioma';

  @override
  String get userProfileInteractionType => 'Tipo de Interacción';

  @override
  String get userProfileCreatedAt => 'Creado el';

  @override
  String get userProfileUpdatedAt => 'Actualizado el';
}
