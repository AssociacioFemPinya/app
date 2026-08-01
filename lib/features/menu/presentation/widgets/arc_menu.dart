import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:go_router/go_router.dart';
import 'package:femcastells/core/navigation/route_names.dart';
import 'package:femcastells/features/login/login.dart' hide sl;
import 'package:femcastells/l10n/app_localizations.dart';

const Color _kGreen      = Color(0xFF1A5C38);
const Color _kGreenLight = Color(0xFF2D7A50);
const String _kMoreSheet = '__more__';

class ArcMenu extends StatefulWidget {
  final Widget child;
  const ArcMenu({required this.child, super.key});

  @override
  State<ArcMenu> createState() => _ArcMenuState();
}

class _ArcMenuState extends State<ArcMenu> with SingleTickerProviderStateMixin {
  bool _open = false;
  late final AnimationController _ctrl;
  late final Animation<double> _anim;

  @override
  void initState() {
    super.initState();
    _ctrl = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 300),
    );
    _anim = CurvedAnimation(parent: _ctrl, curve: Curves.easeOut);
  }

  @override
  void dispose() {
    _ctrl.dispose();
    super.dispose();
  }

  void _toggle() {
    if (_open) {
      _ctrl.reverse().then((_) {
        if (mounted) setState(() => _open = false);
      });
    } else {
      setState(() => _open = true);
      _ctrl.forward();
    }
  }

  void _navigate(String route) {
    _ctrl.reverse().then((_) {
      if (mounted) {
        setState(() => _open = false);
        if (route == _kMoreSheet) {
          _showMoreSheet();
        } else {
          context.pushNamed(route);
        }
      }
    });
  }

  void _showMoreSheet() {
    final t = AppLocalizations.of(context)!;
    showModalBottomSheet(
      context: context,
      builder: (_) => SafeArea(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            ListTile(
              leading: const Icon(Icons.info_outline),
              title: Text(t.menuAbout),
              onTap: () { Navigator.pop(context); context.pushNamed(aboutRoute); },
            ),
            ListTile(
              leading: const Icon(Icons.privacy_tip_outlined),
              title: Text(t.menuPrivacy),
              onTap: () { Navigator.pop(context); context.push(gdprConsentRoute, extra: true); },
            ),
            ListTile(
              leading: const Icon(Icons.help_outline),
              title: Text(t.menuHelp),
              onTap: () { Navigator.pop(context); context.pushNamed(helpRoute); },
            ),
            const Divider(height: 1),
            ListTile(
              leading: const Icon(Icons.logout, color: Colors.red),
              title: Text(t.menuLogout, style: const TextStyle(color: Colors.red)),
              onTap: () async {
                const storage = FlutterSecureStorage();
                final bloc = context.read<AuthenticationBloc>();
                await storage.deleteAll();
                if (mounted) {
                  Navigator.pop(context);
                  bloc.add(AuthenticationLogoutPressed());
                }
              },
            ),
          ],
        ),
      ),
    );
  }

  List<_MenuItem> _buildItems(AppLocalizations t) => [
        _MenuItem(Icons.home_rounded, t.menuHome, homeRoute),
        _MenuItem(Icons.calendar_month, t.menuEvents, eventsRoute),
        _MenuItem(Icons.hub_outlined, t.menuPublicDisplayUrl, publicDisplayUrlRoute),
        _MenuItem(Icons.layers_outlined, t.menuRondes, rondesRoute),
        _MenuItem(Icons.history, t.menuHistorial, historialRoute),
        _MenuItem(Icons.notifications_none, t.menuNotifications, notificationsRoute),
        _MenuItem(Icons.more_horiz, t.menuMore, _kMoreSheet),
      ];

  @override
  Widget build(BuildContext context) {
    final t = AppLocalizations.of(context)!;
    final bottomPad = MediaQuery.of(context).padding.bottom;
    final items = _buildItems(t);

    return Stack(
      children: [
        widget.child,

        // Backdrop — closes menu on tap outside
        if (_open)
          GestureDetector(
            onTap: _toggle,
            behavior: HitTestBehavior.opaque,
            child: Container(color: Colors.black38),
          ),

        // Arc background + icon buttons
        if (_open)
          AnimatedBuilder(
            animation: _anim,
            builder: (ctx, _) {
              final size = MediaQuery.of(ctx).size;
              const rx = 360.0;
              const ry = 280.0;
              const startDeg = 162.0;
              const endDeg = 96.0;
              final step = (startDeg - endDeg) / (items.length - 1);

              return Stack(
                children: [
                  SizedBox.expand(
                    child: CustomPaint(
                      painter: _ArcPainter(
                        color: _kGreen
                            .withAlpha((220 * _anim.value).round()),
                        progress: _anim.value,
                      ),
                    ),
                  ),
                  ...List.generate(items.length, (i) {
                    final deg = startDeg - i * step;
                    final rad = deg * pi / 180;
                    final bx = size.width + rx * cos(rad) - 32;
                    final by = size.height - ry * sin(rad) - 32 - bottomPad;

                    final itemAnim = CurvedAnimation(
                      parent: _ctrl,
                      curve: Interval(
                        i * 0.08,
                        1.0,
                        curve: Curves.easeOut,
                      ),
                    );

                    return Positioned(
                      left: bx,
                      top: by,
                      child: FadeTransition(
                        opacity: itemAnim,
                        child: ScaleTransition(
                          scale: itemAnim,
                          child: _ArcButton(
                            icon: items[i].icon,
                            label: items[i].label,
                            onTap: () => _navigate(items[i].route),
                          ),
                        ),
                      ),
                    );
                  }),
                ],
              );
            },
          ),

        // FAB trigger
        Positioned(
          bottom: 16 + bottomPad,
          right: 16,
          child: FloatingActionButton(
            heroTag: null,
            onPressed: _toggle,
            backgroundColor: _kGreen,
            child: AnimatedIcon(
              icon: AnimatedIcons.menu_close,
              progress: _anim,
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

class _MenuItem {
  final IconData icon;
  final String label;
  final String route;
  const _MenuItem(this.icon, this.label, this.route);
}

class _ArcButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const _ArcButton({
    required this.icon,
    required this.label,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: label,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          width: 64,
          height: 64,
          decoration: BoxDecoration(
            shape: BoxShape.circle,
            color: _kGreenLight,
            boxShadow: const [
              BoxShadow(
                color: Colors.black26,
                blurRadius: 6,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: Icon(icon, color: Colors.white, size: 28),
        ),
      ),
    );
  }
}

class _ArcPainter extends CustomPainter {
  final Color color;
  final double progress;

  const _ArcPainter({required this.color, required this.progress});

  @override
  void paint(Canvas canvas, Size size) {
    final paint = Paint()..color = color;
    final center = Offset(size.width, size.height);
    final radius = 400.0 * progress;
    final rect = Rect.fromCircle(center: center, radius: radius);
    // Arc from left (π) sweeping counterclockwise 90° to up (-π/2)
    canvas.drawArc(rect, pi, -pi / 2, true, paint);
  }

  @override
  bool shouldRepaint(_ArcPainter old) =>
      old.progress != progress || old.color != color;
}
