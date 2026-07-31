import 'package:flutter/material.dart';
import 'package:femcastells/features/menu/presentation/widgets/arc_menu.dart';
import 'package:femcastells/features/user_profile/user_profile.dart';
import 'package:femcastells/l10n/app_localizations.dart';

class EditProfilePage extends StatefulWidget {
  const EditProfilePage({super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final _formKey = GlobalKey<FormState>();

  UserProfileEntity? _user;
  bool _loading = true;
  bool _saving = false;
  String? _loadError;

  final _email          = TextEditingController();
  final _email2         = TextEditingController();
  final _phone          = TextEditingController();
  final _mobilePhone    = TextEditingController();
  final _emergencyPhone = TextEditingController();
  final _address        = TextEditingController();
  final _postalCode     = TextEditingController();
  final _city           = TextEditingController();
  final _province       = TextEditingController();
  final _country        = TextEditingController();
  final _password       = TextEditingController();
  final _passwordConfirm = TextEditingController();

  @override
  void initState() {
    super.initState();
    _loadProfile();
  }

  @override
  void dispose() {
    for (final c in [
      _email, _email2, _phone, _mobilePhone, _emergencyPhone,
      _address, _postalCode, _city, _province, _country,
      _password, _passwordConfirm,
    ]) {
      c.dispose();
    }
    super.dispose();
  }

  Future<void> _loadProfile() async {
    setState(() { _loading = true; _loadError = null; });
    final result = await sl<GetUserProfile>().call(params: GetUserProfileParams());
    if (!mounted) return;
    result.fold(
      (error) => setState(() { _loading = false; _loadError = error; }),
      (user) {
        _email.text          = user.email;
        _email2.text         = user.email2;
        _phone.text          = user.phone;
        _mobilePhone.text    = user.mobilePhone ?? '';
        _emergencyPhone.text = user.emergencyPhone ?? '';
        _address.text        = user.address ?? '';
        _postalCode.text     = user.postalCode ?? '';
        _city.text           = user.city ?? '';
        _province.text       = user.province ?? '';
        _country.text        = user.country ?? '';
        _password.clear();
        _passwordConfirm.clear();
        setState(() { _user = user; _loading = false; });
      },
    );
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;
    setState(() => _saving = true);

    final data = <String, dynamic>{
      'email':           _email.text.trim(),
      'email2':          _email2.text.trim(),
      'phone':           _phone.text.trim(),
      'mobile_phone':    _mobilePhone.text.trim(),
      'emergency_phone': _emergencyPhone.text.trim(),
      'address':         _address.text.trim(),
      'postal_code':     _postalCode.text.trim(),
      'city':            _city.text.trim(),
      'province':        _province.text.trim(),
      'country':         _country.text.trim(),
    };
    if (_password.text.isNotEmpty) {
      data['password']              = _password.text;
      data['password_confirmation'] = _passwordConfirm.text;
    }

    final result = await sl<UserProfileService>().updateUserProfile(data);
    if (!mounted) return;
    setState(() => _saving = false);

    result.fold(
      (error) => ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(error), backgroundColor: Theme.of(context).colorScheme.error),
      ),
      (msg) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text(msg), backgroundColor: Colors.green),
        );
        _loadProfile();
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final translate = AppLocalizations.of(context)!;

    return ArcMenu(child: Scaffold(
      appBar: AppBar(
        title: Text(translate.userProfileMenu),
        actions: [
          if (_loading || _saving) ...[
            const Padding(
              padding: EdgeInsets.all(16),
              child: SizedBox(width: 20, height: 20, child: CircularProgressIndicator(strokeWidth: 2)),
            ),
          ] else if (_user != null) ...[
            IconButton(icon: const Icon(Icons.save), onPressed: _save),
          ],
        ],
      ),
      body: _buildBody(),
    ));
  }

  Widget _buildBody() {
    if (_loading) return const Center(child: CircularProgressIndicator());
    if (_loadError != null) return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Text(_loadError!),
          const SizedBox(height: 12),
          FilledButton(onPressed: _loadProfile, child: const Text('Reintenta')),
        ],
      ),
    );

    return Form(
      key: _formKey,
      child: ListView(
        padding: const EdgeInsets.all(16),
        children: [
          _section('Identificació', [
            _readOnly('Àlies',     _user!.alias),
            _readOnly('Nom',       '${_user!.name ?? ''} ${_user!.lastName ?? ''}'.trim()),
            _readOnly('Naixement', _user!.birthdate ?? '—'),
          ]),
          _section('Contacte', [
            _field(_email,          'Correu electrònic *', keyboardType: TextInputType.emailAddress,
              validator: (v) => (v == null || v.trim().isEmpty) ? 'Obligatori' : null),
            _field(_email2,         'Correu alternatiu',   keyboardType: TextInputType.emailAddress),
            _field(_phone,          'Telèfon',             keyboardType: TextInputType.phone),
            _field(_mobilePhone,    'Mòbil',               keyboardType: TextInputType.phone),
            _field(_emergencyPhone, "Telèfon d'emergència", keyboardType: TextInputType.phone),
          ]),
          _section('Adreça', [
            _field(_address,    'Adreça'),
            _field(_postalCode, 'Codi postal'),
            _field(_city,       'Població'),
            _field(_province,   'Província'),
            _field(_country,    'País'),
          ]),
          _section('Canviar contrasenya', [
            _field(_password,        'Nova contrasenya', obscure: true,
              validator: (v) {
                if (v != null && v.isNotEmpty && v.length < 8) return 'Mínim 8 caràcters';
                return null;
              }),
            _field(_passwordConfirm, 'Confirmar contrasenya', obscure: true,
              validator: (v) {
                if (_password.text.isNotEmpty && v != _password.text) return 'No coincideixen';
                return null;
              }),
          ]),
        ],
      ),
    );
  }

  Widget _section(String title, List<Widget> children) => Column(
    crossAxisAlignment: CrossAxisAlignment.start,
    children: [
      Padding(
        padding: const EdgeInsets.only(top: 16, bottom: 8),
        child: Text(title, style: Theme.of(context).textTheme.titleSmall?.copyWith(color: Colors.grey)),
      ),
      ...children,
      const Divider(height: 24),
    ],
  );

  Widget _readOnly(String label, String value) => Padding(
    padding: const EdgeInsets.symmetric(vertical: 4),
    child: Row(
      children: [
        SizedBox(width: 120, child: Text(label, style: const TextStyle(color: Colors.grey, fontSize: 13))),
        Expanded(child: Text(value, style: const TextStyle(fontSize: 14))),
      ],
    ),
  );

  Widget _field(
    TextEditingController controller,
    String label, {
    TextInputType keyboardType = TextInputType.text,
    bool obscure = false,
    String? Function(String?)? validator,
  }) =>
      Padding(
        padding: const EdgeInsets.only(bottom: 12),
        child: TextFormField(
          controller: controller,
          decoration: InputDecoration(labelText: label, border: const OutlineInputBorder(), isDense: true),
          keyboardType: keyboardType,
          obscureText: obscure,
          validator: validator,
        ),
      );
}
