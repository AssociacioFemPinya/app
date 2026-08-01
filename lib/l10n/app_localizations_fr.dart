// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String menuAppName(String userName) {
    return 'FemPinya. Bonjour $userName!';
  }

  @override
  String get menuHome => 'Accueil';

  @override
  String get menuEvents => 'Agenda';

  @override
  String get menuNotifications => 'Actualités';

  @override
  String get menuRondes => 'Rondes';

  @override
  String get menuPublicDisplayUrl => 'Pinya';

  @override
  String get menuHistorial => 'Historique';

  @override
  String get menuMore => 'Plus d\'options';

  @override
  String get menuLogout => 'Se déconnecter';

  @override
  String get menuAbout => 'À propos de FemCastells';

  @override
  String get menuPrivacy => 'Politique de confidentialité';

  @override
  String get menuHelp => 'Aide et commentaires';

  @override
  String get menuDisconnect => 'Déconnecter';

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
  String get loginPageTitle => 'Se connecter';

  @override
  String get loginSnackBarError => 'Erreur d\'authentification';

  @override
  String get loginPageEmailTitle => 'Adresse e-mail';

  @override
  String get loginPagePasswordTitle => 'Mot de passe';

  @override
  String get loginPageLoginButton => 'Se connecter';

  @override
  String get loginPageInvalidMail => 'Adresse e-mail invalide';

  @override
  String get loginPageInvalidPassword => 'Mot de passe invalide';

  @override
  String get eventsPageTitle => 'Événements';

  @override
  String get eventsPageEventsWithAlertBanner =>
      'Vous avez des événements qui nécessitent une attention!';

  @override
  String get eventsPageTypeChipTraining => 'Entraînements';

  @override
  String get eventsPageTypeChipPerformance => 'Performances';

  @override
  String get eventsPageTypeChipActivity => 'Activités';

  @override
  String get eventsPageTypeFilterTitle => 'Type';

  @override
  String get eventsPageStatusFilterPending => 'En attente';

  @override
  String get eventsPageStatusFilterAnswered => 'Répondu';

  @override
  String get eventsPageStatusFilterWarning => 'Avec alerte';

  @override
  String get eventsPageEventViewModeList => 'Liste';

  @override
  String get eventsPageEventViewModeCalendar => 'Calendrier';

  @override
  String get eventPageScheduleTitle => 'Horaires';

  @override
  String get eventPageAddCommentsTitle => 'Ajouter des commentaires';

  @override
  String eventsPageAttendaceQuestion(String eventName) {
    return 'Vas-tu venir à $eventName?';
  }

  @override
  String get eventsPageAttendaceYesResponse => 'Oui';

  @override
  String get eventsPageAttendaceNoResponse => 'Non';

  @override
  String get eventsPageAttendaceUnknowResponse => 'Je ne sais pas';

  @override
  String get eventPageAdditionalOptionSelector =>
      'Informations supplémentaires';

  @override
  String get eventPageCompanionsSelector => 'Un accompagnant?';

  @override
  String get eventPageAttendanceSaved => 'Présence enregistrée';

  @override
  String get eventPageAnswersSaved => 'Réponses enregistrées';

  @override
  String get eventPageClosedBanner =>
      'Le délai de confirmation de présence est dépassé';

  @override
  String get commonReturn => 'Retourner';

  @override
  String get commonSave => 'Sauvegarder';

  @override
  String get commonFilter => 'Filtrer';

  @override
  String get commonSnackBarSuccessSaving => 'Sauvegardé avec succès';

  @override
  String get commentsScreenHintText => 'Écrivez vos commentaires';

  @override
  String get commentsScreenLabelText => 'Commentaires';

  @override
  String get rondesListEmpty =>
      'Aucune ronde disponible pour le moment. Veuillez vérifier plus tard.';

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
  String get notificationsTitle => 'Actualités';

  @override
  String get notificationsEmpty => 'Pas d\'actualités';

  @override
  String get timeAgoSeconds => 'il y a quelques secondes';

  @override
  String timeAgoMinutes(int minutes) {
    return 'il y a $minutes minutes';
  }

  @override
  String timeAgoHours(int hours) {
    return 'il y a $hours heures';
  }

  @override
  String timeAgoDays(int days) {
    return 'il y a $days jours';
  }

  @override
  String get userProfileMenu => 'Utilisateur';

  @override
  String get userProfileName => 'Nom';

  @override
  String get userProfileLastName => 'Nom de famille';

  @override
  String get userProfilePersonalInfoSection => 'Informations Personnelles';

  @override
  String get userProfileUserId => 'ID Utilisateur';

  @override
  String get userProfileExternalId => 'ID Externe';

  @override
  String get userProfileCollaId => 'ID Colla';

  @override
  String get userProfileSociNumber => 'Numéro de Soci';

  @override
  String get userProfileAlias => 'Pseudonyme';

  @override
  String get userProfileGender => 'Genre';

  @override
  String get userProfileMale => 'Homme';

  @override
  String get userProfileFemale => 'Femme';

  @override
  String get userProfileBirthdate => 'Date de Naissance';

  @override
  String get userProfileContactInfoSection => 'Informations de Contact';

  @override
  String get userProfileEmail => 'Email';

  @override
  String get userProfileSecondaryEmail => 'Email Secondaire';

  @override
  String get userProfilePhoneNumber => 'Numéro de Téléphone';

  @override
  String get userProfileMobileNumber => 'Numéro de Mobile';

  @override
  String get userProfileEmergencyContact => 'Contact d\'Urgence';

  @override
  String get userProfileAddressInfoSection => 'Informations d\'Adresse';

  @override
  String get userProfileStreetAddress => 'Adresse';

  @override
  String get userProfilePostalCode => 'Code Postal';

  @override
  String get userProfileCity => 'Ville';

  @override
  String get userProfileComarca => 'Comarque';

  @override
  String get userProfileProvince => 'Province';

  @override
  String get userProfileCountry => 'Pays';

  @override
  String get userProfilePhysicalInfoSection => 'Informations Physiques';

  @override
  String get userProfileHeight => 'Taille';

  @override
  String get userProfileWeight => 'Poids';

  @override
  String get userProfileShoulderHeight => 'Hauteur d\'Épaules';

  @override
  String get userProfileAdditionalInfoSection => 'Informations Supplémentaires';

  @override
  String get userProfileNationality => 'Nationalité';

  @override
  String get userProfileNationalIdNumber => 'Numéro d\'ID National';

  @override
  String get userProfileNationalIdType => 'Type d\'ID National';

  @override
  String get userProfileFamily => 'Famille';

  @override
  String get userProfileFamilyHead => 'Chef de Famille';

  @override
  String get userProfileSubscriptionDate => 'Date d\'Abonnement';

  @override
  String get userProfileComments => 'Commentaires';

  @override
  String get userProfilePhoto => 'Photo';

  @override
  String get userProfileStatus => 'Statut';

  @override
  String get userProfileLanguage => 'Langue';

  @override
  String get userProfileInteractionType => 'Type d\'Interaction';

  @override
  String get userProfileCreatedAt => 'Créé le';

  @override
  String get userProfileUpdatedAt => 'Mis à jour le';
}
