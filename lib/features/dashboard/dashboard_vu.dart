import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/widgets/app_image_picker.dart';
import 'package:dev_once_app/features/profile/update_profile/update_profile_vu.dart';
// import 'package:dev_once_app/features/dashboard/dashboard_vm.dart';
import 'package:flutter/material.dart';
import 'package:flutter_extensions_pack/flutter_extensions_pack.dart';
import 'package:flutter_svg/svg.dart';
// import 'package:provider/provider.dart';

class DashboardVu extends StatefulWidget {
  const DashboardVu({super.key});

  @override
  State<DashboardVu> createState() => _DashboardVuState();
}

class _DashboardVuState extends State<DashboardVu> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    // final vm = context.read<DashboardVm>();
    return Scaffold(
      body: SingleChildScrollView(
        child: Stack(
          children: [
            Positioned(
              top: 0,
              left: 0,
              right: 0,
              height: screenHeight * 0.20,
              child: SvgPicture.asset(
                AppAssets.dashboardTop,
                fit: BoxFit.cover,
              ),
            ),

            Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                SizedBox(height: screenHeight * 0.14),

                Container(
                  padding: const EdgeInsets.fromLTRB(20, 40, 20, 25),
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(30),
                      topRight: Radius.circular(30),
                    ),
                    color: Colors.white,
                  ),
                  child: const Row(
                    children: [
                      ImageWidget(size: 52, url: 'https://backend.tawakalsolutions.com/files/common/placeholder.png'),
                      SizedBox(width: 20),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text('Welcome Back', style: TextStyle(fontSize: 14, fontWeight: FontWeight.w400)),
                          SizedBox(height: 5),
                          Text('Usama Ali', style: TextStyle(fontSize: 16, fontWeight: FontWeight.w600)),
                        ],
                      ),
                    ],
                  ),
                ),

                ColoredBox(
                  color: Colors.white,
                  child: Stack(
                    fit: StackFit.passthrough,
                    alignment: Alignment.topCenter,
                    children: [
                      SvgPicture.asset(
                        AppAssets.dashboardMiddle,
                        fit: BoxFit.fill,
                      ),
                      // This is the text content layered on top of the SVG
                      Padding(
                        padding: const EdgeInsets.fromLTRB(40, 15, 30, 20),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.stretch,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                const Text('Current Capital', style: TextStyle(color: Color(0xFF0F6679), fontSize: 20, fontWeight: FontWeight.w400, letterSpacing: -1)),
                                SvgPicture.asset(AppAssets.goTo),
                              ],
                            ),
                            const SizedBox(height: 10),
                            const Text('778,778,777', style: TextStyle(color: Colors.black, fontSize: 30, fontWeight: FontWeight.w600)),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),

                // Container for the rest of your scrollable content
                Transform.translate(
                  offset: const Offset(0, -52),
                  child: Container(
                    decoration: const BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(30),
                        topRight: Radius.circular(30),
                      ),
                      color: Colors.white,
                    ),
                    child: Column(
                      children: [
                        Padding(
                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 20),
                          child: Row(
                            spacing: 10,
                            children: [
                              Expanded(
                                child: ActionCard(
                                  icon: AppAssets.transferRollover,
                                  text: 'Transfer / Rollover\n Request',
                                  backgroundColor: const Color(0xFFA1FFFD), 
                                  iconAndTextColor: const Color(0xFF00666B),
                                  onTap: () {},
                                ),
                              ),
                              Expanded(
                                child: ActionCard(
                                  icon: AppAssets.withdraw,
                                  text: 'Withdraw\n Request',
                                  backgroundColor: const Color(0xFF01B3BC),
                                  iconAndTextColor: Colors.white,
                                  onTap: () {},
                                ),
                              ),
                              Expanded(
                                child: ActionCard(
                                  icon: AppAssets.userEdit,
                                  text: 'Update\n Profile',
                                  backgroundColor: const Color(0xFFCFE2E8), 
                                  iconAndTextColor: const Color(0xFF2E535E),
                                  onTap: () {
                                    context.push(UpdateProfileVu());
                                  },
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class ActionCard extends StatelessWidget {
  const ActionCard({
    super.key,
    required this.onTap,
    required this.text,
    required this.icon,
    required this.backgroundColor,
    required this.iconAndTextColor,
  });

  final VoidCallback onTap;
  final String text;
  final String icon;
  final Color backgroundColor;
  final Color iconAndTextColor;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(16),
      child: Container(
        // height: 120,
        decoration: BoxDecoration(
          color: backgroundColor,
          borderRadius: BorderRadius.circular(16),
        ),
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              SvgPicture.asset(
                icon,
                fit: BoxFit.fill,
              ),
              const SizedBox(height: 8),
              Text(
                text,
                textAlign: TextAlign.center,
                style: TextStyle(
                  color: iconAndTextColor,
                  fontWeight: FontWeight.w400,
                  fontSize: 10,
                  height: 1.5
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}