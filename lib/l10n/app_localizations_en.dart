// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String menuAppName(String userName) {
    return 'FemPinya. Hello $userName!';
  }

  @override
  String get menuHome => 'Home';

  @override
  String get menuEvents => 'Agenda';

  @override
  String get menuNotifications => 'News';

  @override
  String get menuRondes => 'Rondes';

  @override
  String get menuPublicDisplayUrl => 'Pinya';

  @override
  String get menuHistorial => 'History';

  @override
  String get menuMore => 'More options';

  @override
  String get menuLogout => 'Log out';

  @override
  String get menuAbout => 'About FemCastells';

  @override
  String get menuPrivacy => 'Privacy Policy';

  @override
  String get menuHelp => 'Help & Feedback';

  @override
  String get menuDisconnect => 'Disconnect';

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
  String get loginPageTitle => 'Log in';

  @override
  String get loginSnackBarError => 'Authenticate error';

  @override
  String get loginPageEmailTitle => 'Email';

  @override
  String get loginPagePasswordTitle => 'Password';

  @override
  String get loginPageLoginButton => 'Log in';

  @override
  String get loginPageInvalidMail => 'Invalid email';

  @override
  String get loginPageInvalidPassword => 'Invalid password';

  @override
  String get eventsPageTitle => 'Events';

  @override
  String get eventsPageEventsWithAlertBanner =>
      'You have events that require attention!';

  @override
  String get eventsPageTypeChipTraining => 'Trainings';

  @override
  String get eventsPageTypeChipPerformance => 'Performances';

  @override
  String get eventsPageTypeChipActivity => 'Activities';

  @override
  String get eventsPageTypeFilterTitle => 'Type';

  @override
  String get eventsPageStatusFilterPending => 'Pending';

  @override
  String get eventsPageStatusFilterAnswered => 'Answered';

  @override
  String get eventsPageStatusFilterWarning => 'With alert';

  @override
  String get eventsPageEventViewModeList => 'List';

  @override
  String get eventsPageEventViewModeCalendar => 'Calendar';

  @override
  String get eventPageScheduleTitle => 'Schedule';

  @override
  String get eventPageAddCommentsTitle => 'Add comments';

  @override
  String eventsPageAttendaceQuestion(String eventName) {
    return 'Will you come to $eventName?';
  }

  @override
  String get eventsPageAttendaceYesResponse => 'Yes';

  @override
  String get eventsPageAttendaceNoResponse => 'No';

  @override
  String get eventsPageAttendaceUnknowResponse => 'I don\'t know';

  @override
  String get eventPageAdditionalOptionSelector => 'Additional information';

  @override
  String get eventPageCompanionsSelector => 'Any companions?';

  @override
  String get eventPageAttendanceSaved => 'Attendance saved';

  @override
  String get eventPageAnswersSaved => 'Answers saved';

  @override
  String get eventPageClosedBanner =>
      'The deadline to confirm attendance has passed';

  @override
  String get commonReturn => 'Return';

  @override
  String get commonSave => 'Save';

  @override
  String get commonFilter => 'Filter';

  @override
  String get commonSnackBarSuccessSaving => 'Saved successfully';

  @override
  String get commentsScreenHintText => 'Write your comments';

  @override
  String get commentsScreenLabelText => 'Comments';

  @override
  String get rondesListEmpty =>
      'No rondas available at the moment. Please check back later.';

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
  String get notificationsTitle => 'News';

  @override
  String get notificationsEmpty => 'No news';

  @override
  String get timeAgoSeconds => 'a few seconds ago';

  @override
  String timeAgoMinutes(int minutes) {
    return '$minutes minutes ago';
  }

  @override
  String timeAgoHours(int hours) {
    return '$hours hours ago';
  }

  @override
  String timeAgoDays(int days) {
    return '$days days ago';
  }

  @override
  String get userProfileMenu => 'User';

  @override
  String get userProfileName => 'Name';

  @override
  String get userProfileLastName => 'Last Name';

  @override
  String get userProfilePersonalInfoSection => 'Personal Information';

  @override
  String get userProfileUserId => 'User ID';

  @override
  String get userProfileExternalId => 'External ID';

  @override
  String get userProfileCollaId => 'Colla ID';

  @override
  String get userProfileSociNumber => 'Soci Number';

  @override
  String get userProfileAlias => 'Alias';

  @override
  String get userProfileGender => 'Gender';

  @override
  String get userProfileMale => 'Male';

  @override
  String get userProfileFemale => 'Female';

  @override
  String get userProfileBirthdate => 'Date of Birth';

  @override
  String get userProfileContactInfoSection => 'Contact Information';

  @override
  String get userProfileEmail => 'Email';

  @override
  String get userProfileSecondaryEmail => 'Secondary Email';

  @override
  String get userProfilePhoneNumber => 'Phone Number';

  @override
  String get userProfileMobileNumber => 'Mobile Number';

  @override
  String get userProfileEmergencyContact => 'Emergency Contact';

  @override
  String get userProfileAddressInfoSection => 'Address Information';

  @override
  String get userProfileStreetAddress => 'Street Address';

  @override
  String get userProfilePostalCode => 'Postal Code';

  @override
  String get userProfileCity => 'City';

  @override
  String get userProfileComarca => 'Comarca';

  @override
  String get userProfileProvince => 'Province';

  @override
  String get userProfileCountry => 'Country';

  @override
  String get userProfilePhysicalInfoSection => 'Physical Information';

  @override
  String get userProfileHeight => 'Height';

  @override
  String get userProfileWeight => 'Weight';

  @override
  String get userProfileShoulderHeight => 'Shoulder Height';

  @override
  String get userProfileAdditionalInfoSection => 'Additional Information';

  @override
  String get userProfileNationality => 'Nationality';

  @override
  String get userProfileNationalIdNumber => 'National ID Number';

  @override
  String get userProfileNationalIdType => 'National ID Type';

  @override
  String get userProfileFamily => 'Family';

  @override
  String get userProfileFamilyHead => 'Family Head';

  @override
  String get userProfileSubscriptionDate => 'Subscription Date';

  @override
  String get userProfileComments => 'Comments';

  @override
  String get userProfilePhoto => 'Photo';

  @override
  String get userProfileStatus => 'Status';

  @override
  String get userProfileLanguage => 'Language';

  @override
  String get userProfileInteractionType => 'Interaction Type';

  @override
  String get userProfileCreatedAt => 'Created At';

  @override
  String get userProfileUpdatedAt => 'Updated At';
}
