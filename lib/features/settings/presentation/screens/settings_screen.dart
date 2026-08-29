import 'package:flutter/material.dart';

import '../../../../app/theme/app_colors.dart';
import '../../../../core/theme/theme_controller.dart';

class SettingsScreen extends StatefulWidget {
  final ThemeController themeController;

  const SettingsScreen({
    super.key,
    required this.themeController,
  });

  @override
  State<SettingsScreen> createState() =>
      _SettingsScreenState();
}

class _SettingsScreenState
    extends State<SettingsScreen> {
  @override
  Widget build(BuildContext context) {
    final controller = widget.themeController;

    return AnimatedBuilder(
      animation: controller,
      builder: (context, _) {
        return Scaffold(
          appBar: AppBar(
            title: const Text(
              'Settings',
              style: TextStyle(
                fontWeight: FontWeight.w800,
              ),
            ),
          ),
          body: ListView(
            padding: const EdgeInsets.all(20),
            children: [
              const Text(
                'Appearance',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface,
                  borderRadius:
                  BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.18),
                  ),
                ),
                child: RadioGroup<ThemeMode>(
                  groupValue:
                  controller.themeMode,
                  onChanged: (value) {
                    if (value != null) {
                      controller.setThemeMode(
                        value,
                      );
                    }
                  },
                  child: Column(
                    children: const [
                      RadioListTile<ThemeMode>(
                        value: ThemeMode.light,
                        title: Text('Light'),
                        subtitle: Text(
                          'Use light appearance',
                        ),
                      ),

                      RadioListTile<ThemeMode>(
                        value: ThemeMode.dark,
                        title: Text('Dark'),
                        subtitle: Text(
                          'Use dark appearance',
                        ),
                      ),

                      RadioListTile<ThemeMode>(
                        value: ThemeMode.system,
                        title: Text('System'),
                        subtitle: Text(
                          'Follow device appearance',
                        ),
                      ),
                    ],
                  ),
                ),
              ),

              const SizedBox(height: 28),

              const Text(
                'About',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: AppColors.textSecondary,
                ),
              ),

              const SizedBox(height: 10),

              Container(
                padding: const EdgeInsets.all(18),
                decoration: BoxDecoration(
                  color: Theme.of(context)
                      .colorScheme
                      .surface,
                  borderRadius:
                  BorderRadius.circular(18),
                  border: Border.all(
                    color: Theme.of(context)
                        .colorScheme
                        .outline
                        .withValues(alpha: 0.18),
                  ),
                ),
                child: const Column(
                  crossAxisAlignment:
                  CrossAxisAlignment.start,
                  children: [
                    Text(
                      'Know Via',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Personal knowledge management',
                      style: TextStyle(
                        color:
                        AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Version 2.0.0',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 20),

                    Text(
                      'Info',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight:
                        FontWeight.w800,
                      ),
                    ),

                    SizedBox(height: 5),

                    Text(
                      'Developed By:',
                      style: TextStyle(
                        fontWeight:
                        FontWeight.w800,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),

                    SizedBox(height: 12),

                    Text(
                      'Nikhil Singh',
                      style: TextStyle(
                        fontSize: 12,
                        color:
                        AppColors.textSecondary,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
