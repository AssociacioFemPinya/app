import 'package:fempinya3_flutter_app/features/menu/presentation/widgets/menu_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_easyloading/flutter_easyloading.dart';
import 'package:fempinya3_flutter_app/l10n/app_localizations.dart';

import 'package:fempinya3_flutter_app/features/user_profile/user_profile.dart';

class UserProfilePage extends StatelessWidget {
  const UserProfilePage({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => UserProfileViewBloc()..add(LoadUserProfile()),
      child: UserProfileViewContentsPage(),
    );
  }
}

class UserProfileViewContentsPage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return BlocBuilder<UserProfileViewBloc, UserProfileViewState>(
      builder: (context, state) {
        if (state is UserProfileViewInitial ||
            state is UserProfileLoadInProgress) {
          EasyLoading.show(status: 'Loading...');
          return Center(
            child: Text(''),
          );
        } else if (state is UserProfileLoadSuccess) {
          EasyLoading.dismiss();
          return Scaffold(
            appBar: AppBar(
              title: Text(translate.userProfileMenu),
            ),
            drawer: const MenuWidget(),
            body: Center(
              child: userProfileViewWidget(user: state.user, translate),
            ),
          );
        } else if (state is UserProfileLoadFailure) {
          EasyLoading.dismiss();
          return Scaffold(
            appBar: AppBar(
              title: Text(translate.userProfileMenu),
            ),
            body: Center(
              child: Text(state.message),
            ),
          );
        } else {
          EasyLoading.dismiss();
          return Text('Unimplemented state');
        }
      },
    );
  }

  Widget userProfileViewWidget(AppLocalizations translate,
      {required UserProfileEntity user}) {
    return ListView(
      children: [
        // Display Name and Last Name prominently
        userProfileHighlightedPropertyWidget(
          value: user.alias,
        ),

        // Grouped properties in UserSectionPropertyWidget with translated labels
        UserProfileSectionPropertyWidget(
          title: translate.userProfilePersonalInfoSection,
          icon: Icons.person,
          properties: {
            translate.userProfileUserId: (user) => user.idCasteller.toString(),
            translate.userProfileExternalId: (user) =>
                user.idCastellerExternal.toString(),
            translate.userProfileCollaId: (user) => user.collaId.toString(),
            translate.userProfileSociNumber: (user) => user.numSoci,
            translate.userProfileName: (user) => user.name.toString(),
            translate.userProfileLastName: (user) => user.lastName.toString(),
            translate.userProfileAlias: (user) => user.alias,
            translate.userProfileGender: (user) => user.gender == 1
                ? translate.userProfileMale
                : translate.userProfileFemale,
            translate.userProfileBirthdate: (user) => user.birthdate ?? 'N/A',
          },
          user: user,
        ),
        UserProfileSectionPropertyWidget(
          title: translate.userProfileContactInfoSection,
          icon: Icons.contact_mail,
          properties: {
            translate.userProfileEmail: (user) => user.email,
            translate.userProfileSecondaryEmail: (user) => user.email2,
            translate.userProfilePhoneNumber: (user) => user.phone,
            translate.userProfileMobileNumber: (user) =>
                user.mobilePhone ?? 'N/A',
            translate.userProfileEmergencyContact: (user) =>
                user.emergencyPhone ?? 'N/A',
          },
          user: user,
        ),
        UserProfileSectionPropertyWidget(
          title: translate.userProfileAddressInfoSection,
          icon: Icons.location_on,
          properties: {
            translate.userProfileStreetAddress: (user) => user.address ?? 'N/A',
            translate.userProfilePostalCode: (user) => user.postalCode ?? 'N/A',
            translate.userProfileCity: (user) => user.city ?? 'N/A',
            translate.userProfileComarca: (user) => user.comarca ?? 'N/A',
            translate.userProfileProvince: (user) => user.province ?? 'N/A',
            translate.userProfileCountry: (user) => user.country ?? 'N/A',
          },
          user: user,
        ),
        UserProfileSectionPropertyWidget(
          title: translate.userProfilePhysicalInfoSection,
          icon: Icons.fitness_center,
          properties: {
            translate.userProfileHeight: (user) => '${user.height} cm',
            translate.userProfileWeight: (user) => '${user.weight} cm',
            translate.userProfileShoulderHeight: (user) =>
                '${user.shoulderHeight} cm',
          },
          user: user,
        ),
        UserProfileSectionPropertyWidget(
          title: translate.userProfileAdditionalInfoSection,
          icon: Icons.info,
          properties: {
            translate.userProfileNationality: (user) =>
                user.nationality ?? 'N/A',
            translate.userProfileNationalIdNumber: (user) =>
                user.nationalIdNumber ?? 'N/A',
            translate.userProfileNationalIdType: (user) =>
                user.nationalIdType ?? 'N/A',
            translate.userProfileFamily: (user) => user.family ?? 'N/A',
            translate.userProfileFamilyHead: (user) => user.familyHead ?? 'N/A',
            translate.userProfileSubscriptionDate: (user) =>
                user.subscriptionDate ?? 'N/A',
            translate.userProfileComments: (user) => user.comments ?? 'N/A',
            translate.userProfilePhoto: (user) => user.photo ?? 'N/A',
            translate.userProfileStatus: (user) => user.status.toString(),
            translate.userProfileLanguage: (user) => user.language ?? 'N/A',
            translate.userProfileInteractionType: (user) =>
                user.interactionType.toString(),
            translate.userProfileCreatedAt: (user) => user.createdAt,
            translate.userProfileUpdatedAt: (user) => user.updatedAt,
          },
          user: user,
        ),
      ],
    );
  }
}
