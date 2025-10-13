import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:dev_once_app/core/utils/util_service.dart';
import 'package:dev_once_app/core/widgets/app_background.dart';
import 'package:dev_once_app/core/widgets/app_loading.dart';
import 'package:dev_once_app/features/profile/update_bank_details/update_bank_details_vu.dart';
import 'package:dev_once_app/features/profile/update_profile/update_profile_vu.dart';
import 'package:dev_once_app/features/profile/view_profile/view_profile_vu.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:provider/provider.dart';

import '../view_profile/view_profile_vm.dart';

class ProfileHomeVu extends StatelessWidget {
  const ProfileHomeVu({super.key});

  @override
  Widget build(BuildContext context) {
    final vm = context.watch<ViewProfileVm>();

    return Scaffold(
      body: AppBackground(
        title: 'Profile',
        headerFraction: 0.28,
        topCornerRadius: 30,
        leading: SvgPicture.asset(
          AppAssets.authDo,
          width: 40,
          height: 40,
          fit: BoxFit.contain,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
        topRightDecoration: SvgPicture.asset(AppAssets.authRoundedShapesVertical),
        child: vm.isBusy
            ? Center(child: LoadingWidget(size: 30, color: AppColors.primary))
            : Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  _SummaryCard(
                    name: vm.details.name!,
                    memberSince: vm.details.memberSince ?? 0,
                    // avatarUrl: vm.details.profileImageCompleteUrl,
                    onUpdateProfile: () => context.push(UpdateProfileVu()),
                    onUpdateBank: () => context.push(UpdateBankDetailsVu()),
                    onViewProfile: () => context.push(const ViewProfileVu()),
                  ),
                  const SizedBox(height: 22),
                  const _SectionHeader(title: 'Personal Details'),
                  const SizedBox(height: 12),
                  _PersonalGrid(
                    email: vm.details.email,
                    mobile: vm.details.mobile,
                    address: vm.details.address,
                    userId: vm.details.username,
                  ),
                ],
              ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.name,
    // required this.avatarUrl,
    required this.memberSince,
    required this.onUpdateProfile,
    required this.onUpdateBank,
    required this.onViewProfile,
  });

  final String name;
  // final String? avatarUrl;
  final int memberSince;
  final VoidCallback onUpdateProfile;
  final VoidCallback onUpdateBank;
  final VoidCallback onViewProfile;

  // String _formatDate() {
  //   if (memberSinceText != null && memberSinceText!.trim().isNotEmpty) return memberSinceText!;
  //   if (memberSinceEpoch != null) {
  //     final dt = DateTime.fromMillisecondsSinceEpoch(memberSinceEpoch!);
  //     return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
  //   }
  //   return '';
  // }

  @override
  Widget build(BuildContext context) {
    final date = Utils.formateDateTimeStamp(memberSince);
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(22),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.06),
            blurRadius: 16,
            offset: const Offset(0, 6),
          )
        ],
      ),
      padding: const EdgeInsets.fromLTRB(16, 38, 16, 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Align(
            alignment: Alignment.topCenter,
            child: Transform.translate(
              offset: const Offset(0, -36),
              child: Container(
                width: 64,
                height: 64,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  borderRadius: BorderRadius.circular(14),
                  // image: avatarUrl != null && avatarUrl!.isNotEmpty
                  //     ? DecorationImage(image: NetworkImage(avatarUrl!), fit: BoxFit.cover)
                  //     : null,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.12),
                      blurRadius: 10,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                // child: avatarUrl == null || avatarUrl!.isEmpty
                //     ? const Icon(Icons.person, color: Color(0xFF8EA0AA), size: 36)
                //     : null,
              ),
            ),
          ),
          const SizedBox(height: 4),
          Center(
            child: Column(
              children: [
                Text(
                  name,
                  style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        color: AppColors.primary,
                        fontWeight: FontWeight.w700,
                      ),
                ),
                const SizedBox(height: 4),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text('Member Since', style: TextStyle(color: const Color(0xFF8EA0AA), fontSize: 12)),
                    if (date.isNotEmpty) ...[
                      const SizedBox(width: 10),
                      const Text('�', style: TextStyle(color: Color(0xFF8EA0AA), fontSize: 12)),
                      const SizedBox(width: 10),
                      Text(date, style: const TextStyle(color: Color(0xFF8EA0AA), fontSize: 12)),
                    ],
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _NavTile(title: 'Update Profile', onTap: onUpdateProfile),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _NavTile(title: 'Update Bank Details', onTap: onUpdateBank),
          const Divider(height: 1, color: Color(0xFFE6E6E6)),
          _NavTile(title: 'View Profile', onTap: onViewProfile),
        ],
      ),
    );
  }
}

class _NavTile extends StatelessWidget {
  const _NavTile({required this.title, required this.onTap});
  final String title;
  final VoidCallback onTap;
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 14),
        child: Row(
          children: [
            Expanded(child: Text(title, style: Theme.of(context).textTheme.bodyMedium?.copyWith(fontWeight: FontWeight.w500))),
            const Icon(Icons.chevron_right_rounded, color: Color(0xFF8EA0AA)),
          ],
        ),
      ),
    );
  }
}

class _SectionHeader extends StatelessWidget {
  const _SectionHeader({required this.title});
  final String title;
  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(Icons.person_outline_rounded, color: AppColors.secondary),
        const SizedBox(width: 8),
        Text(title, style: Theme.of(context).textTheme.titleMedium?.copyWith(fontWeight: FontWeight.w600)),
      ],
    );
  }
}

class _PersonalGrid extends StatelessWidget {
  const _PersonalGrid({this.userId, this.email, this.mobile, this.address});
  final String? userId;
  final String? email;
  final String? mobile;
  final String? address;

  @override
  Widget build(BuildContext context) {
    final width = MediaQuery.of(context).size.width;
    final cardW = (width * 0.88 - 12) / 2;

    return Wrap(
      spacing: 12,
      runSpacing: 12,
      children: [
        _InfoCard(
          width: cardW,
          color: const Color(0xFFCFFFF6),
          icon: Icons.badge_outlined,
          title: 'User ID:',
          value: userId ?? '-',
        ),
        _InfoCard(
          width: cardW,
          color: AppColors.primary,
          icon: Icons.alternate_email_outlined,
          title: 'Email ID',
          value: email ?? '-',
          dark: true,
        ),
        _InfoCard(
          width: cardW,
          color: const Color(0xFFD8E9F0),
          icon: Icons.phone_outlined,
          title: 'Mobile',
          value: mobile ?? '-',
        ),
        _InfoCard(
          width: cardW,
          color: const Color(0xFFCFE8F2),
          icon: Icons.location_on_outlined,
          title: 'Address',
          value: address ?? '-',
        ),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  const _InfoCard({
    required this.width,
    required this.color,
    required this.icon,
    required this.title,
    required this.value,
    this.dark = false,
  });

  final double width;
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final bool dark;

  @override
  Widget build(BuildContext context) {
    final fg = dark ? Colors.white : AppColors.secondary;
    return Container(
      width: width,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: color,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, color: fg),
          const SizedBox(height: 8),
          Text(title, style: TextStyle(color: fg.withOpacity(0.8), fontSize: 12, fontWeight: FontWeight.w500)),
          const SizedBox(height: 6),
          Text(
            value,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: fg, fontWeight: FontWeight.w600),
          ),
        ],
      ),
    );
  }
}
