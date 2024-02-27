import 'package:anokha_admin/auth/login_screen.dart';
import 'package:anokha_admin/super_admin/profile/profile_screen.dart';
import 'package:anokha_admin/util/home/event_options.dart';
import 'package:anokha_admin/util/home/official_options.dart';
import 'package:anokha_admin/util/home/tag_options.dart';
import 'package:anokha_admin/util/home/welcome_container.dart';
import 'package:anokha_admin/util/loading_screen.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class SuperAdminHomeScreen extends StatefulWidget {
  const SuperAdminHomeScreen({super.key});

  @override
  State<SuperAdminHomeScreen> createState() => _SuperAdminHomeScreenState();
}

class _SuperAdminHomeScreenState extends State<SuperAdminHomeScreen> {
  bool isLoading = false;
  String? managerFullName;

  @override
  void initState() {
    super.initState();

    setState(() {
      isLoading = false;
    });

    SharedPreferences.getInstance().then((sp) {
      setState(() {
        managerFullName = sp.getString("managerFullName") ?? "";
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: isLoading == true
          ? const LoadingComponent()
          : CustomScrollView(
              slivers: [
                SliverAppBar(
                  floating: false,
                  pinned: true,
                  snap: false,
                  centerTitle: true,
                  leading: IconButton(
                    onPressed: () {
                      Navigator.of(context).push(
                        CupertinoPageRoute(
                          builder: (context) {
                            return const SuperAdminProfileScreen();
                          },
                        ),
                      );
                    },
                    icon: Icon(
                      Icons.admin_panel_settings_rounded,
                      color: Theme.of(context).colorScheme.onBackground,
                    ),
                  ),
                  actions: [
                    IconButton(
                      onPressed: () {
                        SharedPreferences.getInstance().then((sp) {
                          final String? managerEmail =
                              sp.getString("managerEmail");
                          sp.clear();
                          sp.setString("managerEmail", managerEmail ?? "");
                        });

                        Navigator.of(context).pushAndRemoveUntil(
                            CupertinoPageRoute(builder: (context) {
                          return const LoginScreen();
                        }), (route) => false);
                      },
                      icon: Icon(
                        Icons.logout_rounded,
                        color: Theme.of(context).colorScheme.onBackground,
                      ),
                    ),
                  ],
                ),
                SliverToBoxAdapter(
                  child: SingleChildScrollView(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 16.0,
                      vertical: 32.0,
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        HomeScreenWelcomeContainer(
                          managerFullName: managerFullName ?? "",
                          managerRoleId: "1",
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const HomeScreenOfficialComponent(
                          managerRoleId: "1",
                        ),
                        const SizedBox(
                          height: 24,
                        ),
                        const HomeScreenEventComponent(managerRoleId: "1"),
                        const SizedBox(
                          height: 24,
                        ),
                        const HomeScreenTagComponent(managerRoleId: "1"),
                      ],
                    ),
                  ),
                ),
              ],
            ),
    );
  }
}
