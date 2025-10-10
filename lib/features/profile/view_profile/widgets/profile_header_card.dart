import 'package:dev_once_app/core/theme/app_colors.dart';
import 'package:flutter/material.dart';

class ProfileHeaderCard extends StatelessWidget {
  const ProfileHeaderCard({
    super.key,
    required this.name,
    this.avatarUrl,
    this.memberSinceEpoch,
    this.memberSinceText,
  });

  final String name;
  final String? avatarUrl;
  final int? memberSinceEpoch; // milliseconds since epoch
  final String? memberSinceText; // if API sends a formatted string

  String _formatDate() {
    if (memberSinceText != null && memberSinceText!.trim().isNotEmpty) {
      return memberSinceText!;
    }
    if (memberSinceEpoch != null) {
      final dt = DateTime.fromMillisecondsSinceEpoch(memberSinceEpoch!);
      return '${dt.day.toString().padLeft(2, '0')}-${dt.month.toString().padLeft(2, '0')}-${dt.year}';
    }
    return '';
  }

  @override
  Widget build(BuildContext context) {
    final date = _formatDate();
    return Container(
      width: 300,
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 30),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.15),
            blurRadius: 22,
            spreadRadius: 0,
            offset: const Offset(0, 10),
          ),
        ],
      ),
      child: Stack(
        children: [
          // Decorative corner like the design (approximation)
          Positioned(
            top: 0,
            right: 0,
            child: Container(
              width: 44,
              height: 28,
              decoration: const BoxDecoration(
                color: AppColors.primary,
                borderRadius: BorderRadius.only(
                  topRight: Radius.circular(14),
                  bottomLeft: Radius.circular(28),
                ),
              ),
            ),
          ),
          Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              // Avatar
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: const Color(0xFFF1F1F1),
                  shape: BoxShape.circle,
                  image: avatarUrl != null && avatarUrl!.isNotEmpty
                      ? DecorationImage(image: NetworkImage(avatarUrl!), fit: BoxFit.cover)
                      : null,
                ),
                child: avatarUrl == null || avatarUrl!.isEmpty
                    ? const Icon(Icons.person, color: Color(0xFF8EA0AA))
                    : null,
              ),
              const SizedBox(width: 10),
              // Name + member since
              SizedBox(
                width: 300 - 44 - 10 - 24,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      name,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                            color: AppColors.secondary,
                            fontWeight: FontWeight.w700,
                          ),
                    ),
                    const SizedBox(height: 2),
                    Row(
            mainAxisSize: MainAxisSize.min,
            children: [
                        Text(
                          'Member Since',
                          style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                color: const Color(0xFF8EA0AA),
                                fontWeight: FontWeight.w500,
                              ),
                        ),
                        if (date.isNotEmpty) ...[
                          const SizedBox(width: 8),
                          const Text('|', style: TextStyle(color: Color(0xFF8EA0AA))),
                          const SizedBox(width: 8),
                          Text(
                            date,
                            style: Theme.of(context).textTheme.bodySmall?.copyWith(
                                  color: const Color(0xFF8EA0AA),
                                  fontWeight: FontWeight.w600,
                                ),
                          ),
                        ]
                      ],
                    )
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}




