import 'package:dev_once_app/core/constants/assets.dart';
import 'package:dev_once_app/core/widgets/app_image_picker.dart';
// import 'package:dev_once_app/features/dashboard/dashboard_vm.dart';
import 'package:flutter/material.dart';
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
    // final vm = context.read<DashboardVm>();
    return Scaffold(
      // I need to cover top 20% percent of the screen with topSvg
      body: Stack(
        children: [
          Positioned(
            top: 0,
            left: 0,
            right: 0,
            height: MediaQuery.of(context).size.height * 0.20,
            child: SizedBox(
              child: SvgPicture.asset(
                AppAssets.dashboardTop,
                fit: BoxFit.cover,
              ),
            ),
          ),
          
          Positioned(
            top: MediaQuery.of(context).size.height * 0.15,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageWidget(size: 52, url: 'https://backend.tawakalsolutions.com/files/common/placeholder.png'),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Usama Ali',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  )
                ],
                
              ),
            ),
          ),
        
          Positioned(
            top: MediaQuery.of(context).size.height * 0.28,
            left: 0,
            right: 0,
            child: SizedBox(
              child: SvgPicture.asset(
                AppAssets.dashboardMiddle,
                fit: BoxFit.cover,
              ),
            ),
          ),

          Positioned(
            top: MediaQuery.of(context).size.height * 0.28,
            left: 0,
            right: 0,
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 40, vertical: 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        'Current Capital',
                        style: TextStyle(
                          color: Color(0xFF0F6679),
                          fontSize: 20,
                          fontWeight: FontWeight.w400,
                          letterSpacing: -1
                        ),
                      ),
                      SvgPicture.asset(
                        AppAssets.goTo,
                        fit: BoxFit.cover,
                      ),
                    ]
                  ),
                  SizedBox(height: 10),
                  Text(
                    '778,778,777',
                    style: TextStyle(
                      color: Colors.black,
                      fontSize: 30,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ])
            )
          ),
        
          Positioned(
            top: MediaQuery.of(context).size.height * 0.41,
            left: 0,
            right: 0,
            bottom: 0,
            child: Container(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(40),
                color: Colors.white,
              ),
              child: const Column(
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 20, vertical: 40),
                    child: Row(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        ImageWidget(size: 52, url: 'https://backend.tawakalsolutions.com/files/common/placeholder.png'),
                        SizedBox(width: 20),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              'Welcome Back',
                              style: TextStyle(
                                fontSize: 14,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 5),
                            Text(
                              'Usama Ali',
                              style: TextStyle(
                                fontSize: 16,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                            
                          ],
                        ),
                      ],
                    ),
                  )
                ],
                
              ),
            ),
          ),
        ]
      ),
    );
  }

  final topIcon = SvgPicture.asset(
    AppAssets.dashboardTop,
    // width: 40,
    // height: 40,
    // fit: BoxFit.contain,
    // colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
  );
}