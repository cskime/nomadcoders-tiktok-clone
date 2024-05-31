import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class SettingsScreen extends StatefulWidget {
  const SettingsScreen({super.key});

  @override
  State<SettingsScreen> createState() => _SettingsScreenState();
}

class _SettingsScreenState extends State<SettingsScreen> {
  bool _notifications = false;

  void _notificationChanged(bool? newValue) {
    if (newValue == null) return;

    setState(() {
      _notifications = newValue;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Settings'),
      ),
      body: ListView(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Material'),
                  Checkbox(
                    value: _notifications,
                    onChanged: _notificationChanged,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Cupertino'),
                  CupertinoCheckbox(
                    value: _notifications,
                    onChanged: _notificationChanged,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Adaptive'),
                  Checkbox.adaptive(
                    value: _notifications,
                    onChanged: _notificationChanged,
                  ),
                ],
              ),
            ],
          ),
          CheckboxListTile(
            value: _notifications,
            title: const Text('ListTile with material design checkbox'),
            checkColor: Colors.white,
            activeColor: Colors.black,
            onChanged: _notificationChanged,
          ),
          CheckboxListTile.adaptive(
            value: _notifications,
            title: const Text('ListTile with platform preferred checkbox'),
            onChanged: _notificationChanged,
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Column(
                children: [
                  const Text('Material'),
                  Switch(
                    value: _notifications,
                    onChanged: _notificationChanged,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Cupertino'),
                  CupertinoSwitch(
                    value: _notifications,
                    onChanged: _notificationChanged,
                  ),
                ],
              ),
              Column(
                children: [
                  const Text('Adaptive'),
                  Switch.adaptive(
                    value: _notifications,
                    onChanged: _notificationChanged,
                  ),
                ],
              ),
            ],
          ),
          SwitchListTile(
            value: _notifications,
            title: const Text('ListTile with material design switch'),
            onChanged: _notificationChanged,
          ),
          SwitchListTile.adaptive(
            value: _notifications,
            title: const Text('ListTile with platform preferred switch'),
            onChanged: _notificationChanged,
          ),
          ListTile(
            onTap: () => showAboutDialog(
              context: context,
              applicationVersion: '1.0',
              applicationLegalese: 'All rights reserved',
            ),
            title: const Text(
              'About',
              style: TextStyle(
                fontWeight: FontWeight.w600,
              ),
            ),
            subtitle: const Text('About this app...'),
          ),
          const AboutListTile(),
          ListTile(
            onTap: () async {
              final date = await showDatePicker(
                context: context,
                initialDate: DateTime.now(),
                firstDate: DateTime(1950),
                lastDate: DateTime(2030),
              );
              print(date);

              final time = await showTimePicker(
                context: context,
                initialTime: TimeOfDay.now(),
              );
              print(time);

              final range = await showDateRangePicker(
                context: context,
                firstDate: DateTime(1950),
                lastDate: DateTime(2030),
                builder: (context, child) {
                  return Theme(
                    data: ThemeData(
                      useMaterial3: false,
                      appBarTheme: const AppBarTheme(
                        foregroundColor: Colors.white,
                        backgroundColor: Colors.black,
                      ),
                    ),
                    child: child!,
                  );
                },
              );
              print(range);
            },
            title: const Text('What is your birthday?'),
          ),
        ],
      ),
    );
  }
}
