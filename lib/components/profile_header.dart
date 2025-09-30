import 'package:flutter/material.dart';
import '../models/user_model.dart';
import '../widgets/constant.dart';
import '../l10n/app_localizations.dart';

class ProfileHeader extends StatelessWidget {
  final UserModel? userProfile;
  final bool showStatusIndicator;
  final bool showStats;

  const ProfileHeader({
    super.key,
    required this.userProfile,
    this.showStatusIndicator = false,
    this.showStats = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.shade200,
            blurRadius: 15,
            offset: const Offset(0, 5),
          ),
        ],
      ),
      child: Column(
        children: [
          // Profile Image
          _buildProfileImage(),
          const SizedBox(height: 16),

          // User Name
          Text(
            userProfile?.displayName ?? AppLocalizations.of(context)!.userName,
            style: const TextStyle(
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: Color(0xFF1E293B),
            ),
          ),
          const SizedBox(height: 8),

          // Email
          Text(
            userProfile?.email ?? AppLocalizations.of(context)!.defaultEmail,
            style: TextStyle(fontSize: 16, color: Colors.grey.shade600),
          ),

          if (showStats) ...[
            const SizedBox(height: 20),
            _buildStatsRow(context),
          ],
        ],
      ),
    );
  }

  Widget _buildProfileImage() {
    Widget profileChild = const Icon(
      Icons.person,
      size: 50,
      color: Colors.white,
    );

    // Fixed: Use photoUrl instead of profileImageUrl
    if (userProfile?.photoUrl != null && userProfile!.photoUrl!.isNotEmpty) {
      profileChild = ClipOval(
        child: Image.network(
          userProfile!.photoUrl!,
          width: 100,
          height: 100,
          fit: BoxFit.cover,
          errorBuilder: (context, error, stackTrace) {
            return const Icon(Icons.person, size: 50, color: Colors.white);
          },
        ),
      );
    }

    Widget profileImage = Container(
      height: 100,
      width: 100,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [kBlue, kBlueDark],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: kBlueDark.withOpacity(0.3),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: profileChild,
    );

    if (showStatusIndicator) {
      return Stack(
        children: [
          profileImage,
          Positioned(
            bottom: 8,
            right: 8,
            child: Container(
              width: 20,
              height: 20,
              decoration: BoxDecoration(
                color: Colors.green,
                shape: BoxShape.circle,
                border: Border.all(color: Colors.white, width: 3),
              ),
            ),
          ),
        ],
      );
    }

    return profileImage;
  }

  Widget _buildStatsRow(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: [
        _buildStatItem(
          '12',
          AppLocalizations.of(context)!.tasksCompleted,
          Colors.green.shade600,
        ),
        _buildDivider(),
        _buildStatItem(
          '3',
          AppLocalizations.of(context)!.activeTasks,
          Colors.blue.shade600,
        ),
        _buildDivider(),
        _buildStatItem(
          '25',
          AppLocalizations.of(context)!.daysStreak,
          Colors.orange.shade600,
        ),
      ],
    );
  }

  Widget _buildStatItem(String number, String label, Color color) {
    return Column(
      children: [
        Text(
          number,
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          label,
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 14,
            color: Colors.grey.shade600,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }

  Widget _buildDivider() {
    return Container(height: 40, width: 1, color: Colors.grey.shade300);
  }
}
