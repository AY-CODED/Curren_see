import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/app_colors.dart';
import '../../../core/providers/providers.dart';
import '../../../shared/models/app_user.dart';
import '../../../shared/widgets/cs_header.dart';
import '../../../features/auth/widgets/cs_logo.dart';

final userProfileProvider = FutureProvider<AppUser?>((ref) async {
  final user = ref.watch(currentUserProvider);
  if (user == null) return null;
  try {
    return await ref.read(firestoreServiceProvider).getUser(user.uid);
  } catch (e) {
    debugPrint('Failed to load user profile: $e');
    return null;
  }
});

class SettingsScreen extends ConsumerWidget {
  const SettingsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final profileAsync = ref.watch(userProfileProvider);

    return Column(
      children: [
        CSHeader(
          title: 'Settings',
          eyebrow: 'Account \u00b7 preferences',
          large: true,
          leading: const CSMark(size: 26),
        ),
        Expanded(
          child: profileAsync.when(
            loading: () => const Center(
              child: CircularProgressIndicator(
                color: AppColors.gold,
                strokeWidth: 2,
              ),
            ),
            error: (error, _) => Center(
              child: Padding(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const Icon(Icons.wifi_off_rounded,
                        size: 40, color: AppColors.ink3),
                    const SizedBox(height: 12),
                    const Text(
                      'Could not load profile',
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.w600,
                        color: AppColors.ink,
                      ),
                    ),
                    const SizedBox(height: 6),
                    Text(
                      'Check your connection and try again.',
                      textAlign: TextAlign.center,
                      style: TextStyle(fontSize: 13, color: AppColors.ink3),
                    ),
                    const SizedBox(height: 20),
                    OutlinedButton.icon(
                      onPressed: () =>
                          ref.invalidate(userProfileProvider),
                      icon: const Icon(Icons.refresh_rounded, size: 16),
                      label: const Text('Retry'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: AppColors.gold,
                        side: const BorderSide(color: AppColors.gold),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            data: (profile) => _SettingsBody(profile: profile, ref: ref),
          ),
        ),
      ],
    );
  }
}

class _SettingsBody extends StatelessWidget {
  final AppUser? profile;
  final WidgetRef ref;

  const _SettingsBody({required this.profile, required this.ref});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: EdgeInsets.zero,
      children: [
        // ── Profile card ──────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 8, 22, 14),
          child: Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.hairline),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Row(
              children: [
                Container(
                  width: 48,
                  height: 48,
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [AppColors.gold, AppColors.goldDeep],
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: AppColors.goldGlow,
                        blurRadius: 16,
                        offset: Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: Text(
                      (profile?.fullName.isNotEmpty == true)
                          ? profile!.fullName[0].toUpperCase()
                          : 'U',
                      style: const TextStyle(
                        fontWeight: FontWeight.w900,
                        fontStyle: FontStyle.italic,
                        fontSize: 20,
                        color: Color(0xFF0A0E1A),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 14),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        profile?.fullName ?? 'User',
                        style: const TextStyle(
                          fontSize: 15,
                          fontWeight: FontWeight.w500,
                          color: AppColors.ink,
                        ),
                      ),
                      Text(
                        profile?.email ?? '',
                        style: const TextStyle(
                            fontSize: 12, color: AppColors.ink3),
                      ),
                    ],
                  ),
                ),
                const Icon(Icons.chevron_right_rounded,
                    size: 18, color: AppColors.ink3),
              ],
            ),
          ),
        ),

        // ── Preferences ───────────────────────────────────────────
        _SettingsSection(
          title: 'Preferences',
          children: [
            _SettingsRow(
              icon: Icons.public_rounded,
              label: 'Default base currency',
              value: profile?.defaultBaseCurrency ?? 'USD',
            ),
            _SettingsRow(
              icon: Icons.refresh_rounded,
              label: 'Auto-refresh rates',
              isToggle: true,
              toggleValue: true,
            ),
            _SettingsRow(
              icon: Icons.flash_on_rounded,
              label: 'Decimal precision',
              value: 'Auto',
            ),
            _SettingsRow(
              icon: Icons.settings_rounded,
              label: 'Appearance',
              value: 'Dark',
            ),
          ],
        ),

        // ── Notifications ─────────────────────────────────────────
        _SettingsSection(
          title: 'Notifications',
          children: [
            _SettingsRow(
              icon: Icons.notifications_outlined,
              label: 'Rate alerts',
              isToggle: true,
              toggleValue: true,
            ),
            _SettingsRow(
              icon: Icons.trending_up_rounded,
              label: 'Weekly market digest',
              isToggle: true,
              toggleValue: false,
            ),
            _SettingsRow(
              icon: Icons.mail_outline_rounded,
              label: 'Email confirmations',
              isToggle: true,
              toggleValue: true,
            ),
          ],
        ),

        // ── Support ───────────────────────────────────────────────
        _SettingsSection(
          title: 'Support',
          children: [
            _SettingsRow(
              icon: Icons.help_outline_rounded,
              label: 'Help center',
              hasArrow: true,
              onTap: () => Navigator.of(context).pushNamed('/help'),
            ),
            _SettingsRow(
              icon: Icons.send_rounded,
              label: 'Send feedback',
              hasArrow: true,
              onTap: () => Navigator.of(context).pushNamed('/feedback'),
            ),
            _SettingsRow(
              icon: Icons.shield_outlined,
              label: 'Privacy & security',
              hasArrow: true,
            ),
          ],
        ),

        // ── Sign out ──────────────────────────────────────────────
        Padding(
          padding: const EdgeInsets.fromLTRB(22, 20, 22, 8),
          child: OutlinedButton.icon(
            onPressed: () async {
              await ref.read(authServiceProvider).signOut();
              if (context.mounted) {
                Navigator.of(context).pushReplacementNamed('/login');
              }
            },
            icon: const Icon(Icons.close_rounded, size: 16),
            label: const Text('Sign out'),
            style: OutlinedButton.styleFrom(
              foregroundColor: AppColors.ink,
              side: const BorderSide(color: AppColors.hairline2),
              padding: const EdgeInsets.symmetric(vertical: 14),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),

        Center(
          child: Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              'V 1.0.0 \u00b7 BUILD 2026.05',
              style: TextStyle(
                fontSize: 11,
                letterSpacing: 0.88,
                color: AppColors.ink3,
              ),
            ),
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _SettingsSection extends StatelessWidget {
  final String title;
  final List<Widget> children;

  const _SettingsSection({required this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(22, 6, 22, 18),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.only(bottom: 10),
            child: Text(
              title.toUpperCase(),
              style: const TextStyle(
                fontSize: 10,
                fontWeight: FontWeight.w800,
                letterSpacing: 1.54,
                color: AppColors.ink3,
              ),
            ),
          ),
          Container(
            decoration: BoxDecoration(
              color: AppColors.surface,
              border: Border.all(color: AppColors.hairline),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(children: children),
          ),
        ],
      ),
    );
  }
}

class _SettingsRow extends StatefulWidget {
  final IconData icon;
  final String label;
  final String? value;
  final bool hasArrow;
  final bool isToggle;
  final bool toggleValue;
  final VoidCallback? onTap;

  const _SettingsRow({
    required this.icon,
    required this.label,
    this.value,
    this.hasArrow = false,
    this.isToggle = false,
    this.toggleValue = false,
    this.onTap,
  });

  @override
  State<_SettingsRow> createState() => _SettingsRowState();
}

class _SettingsRowState extends State<_SettingsRow> {
  late bool _on;

  @override
  void initState() {
    super.initState();
    _on = widget.toggleValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: widget.onTap,
      behavior: HitTestBehavior.opaque,
      child: Container(
        padding: const EdgeInsets.all(14),
        decoration: const BoxDecoration(
          border: Border(bottom: BorderSide(color: AppColors.hairline)),
        ),
        child: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.surface2,
                borderRadius: BorderRadius.circular(8),
              ),
              child: Icon(widget.icon, size: 18, color: AppColors.gold),
            ),
            const SizedBox(width: 14),
            Expanded(
              child: Text(
                widget.label,
                style: const TextStyle(fontSize: 14, color: AppColors.ink),
              ),
            ),
            if (widget.value != null)
              Text(
                widget.value!,
                style: const TextStyle(fontSize: 13, color: AppColors.ink2),
              ),
            if (widget.hasArrow)
              const Icon(Icons.chevron_right_rounded,
                  size: 16, color: AppColors.ink3),
            if (widget.isToggle)
              GestureDetector(
                onTap: () => setState(() => _on = !_on),
                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 200),
                  width: 36,
                  height: 22,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(100),
                    color: _on ? AppColors.gold : AppColors.hairline2,
                  ),
                  child: AnimatedAlign(
                    duration: const Duration(milliseconds: 200),
                    alignment:
                        _on ? Alignment.centerRight : Alignment.centerLeft,
                    child: Container(
                      margin: const EdgeInsets.all(2),
                      width: 18,
                      height: 18,
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: _on
                            ? const Color(0xFF0A0E1A)
                            : AppColors.ink3,
                      ),
                    ),
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }
}