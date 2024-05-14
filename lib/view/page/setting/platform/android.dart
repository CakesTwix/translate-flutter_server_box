import 'dart:convert';

import 'package:fl_lib/fl_lib.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:toolbox/core/extension/context/locale.dart';
import 'package:toolbox/data/res/store.dart';
import 'package:toolbox/view/page/setting/platform/platform_pub.dart';

class AndroidSettingsPage extends StatefulWidget {
  const AndroidSettingsPage({super.key});

  @override
  _AndroidSettingsPageState createState() => _AndroidSettingsPageState();
}

class _AndroidSettingsPageState extends State<AndroidSettingsPage> {
  late SharedPreferences _sp;

  @override
  void initState() {
    super.initState();
    SharedPreferences.getInstance().then((value) => _sp = value);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: Text('Android'),
      ),
      body: ListView(
        padding: const EdgeInsets.symmetric(horizontal: 17),
        children: [
          _buildBgRun(),
          _buildAndroidWidgetSharedPreference(),
          if (BioAuth.isPlatformSupported)
            PlatformPublicSettings.buildBioAuth(),
        ].map((e) => CardX(child: e)).toList(),
      ),
    );
  }

  Widget _buildBgRun() {
    return ListTile(
      title: Text(l10n.bgRun),
      subtitle: Text(l10n.bgRunTip, style: UIs.textGrey),
      trailing: StoreSwitch(prop: Stores.setting.bgRun),
    );
  }

  void _saveWidgetSP(String data, Map<String, String> old) {
    context.pop();
    try {
      final map = Map<String, String>.from(json.decode(data));
      final keysDel = old.keys.toSet().difference(map.keys.toSet());
      for (final key in keysDel) {
        _sp.remove(key);
      }
      map.forEach((key, value) {
        _sp.setString(key, value);
      });
      context.showSnackBar(l10n.success);
    } catch (e) {
      context.showSnackBar(e.toString());
    }
  }

  Widget _buildAndroidWidgetSharedPreference() {
    return ListTile(
      title: Text(l10n.homeWidgetUrlConfig),
      trailing: const Icon(Icons.keyboard_arrow_right),
      onTap: () {
        final data = <String, String>{};
        _sp.getKeys().forEach((key) {
          final val = _sp.getString(key);
          if (val != null) {
            data[key] = val;
          }
        });
        final ctrl = TextEditingController(text: json.encode(data));
        context.showRoundDialog(
          title: l10n.homeWidgetUrlConfig,
          child: Input(
            autoFocus: true,
            controller: ctrl,
            label: 'JSON',
            type: TextInputType.visiblePassword,
            maxLines: 7,
            onSubmitted: (p0) => _saveWidgetSP(p0, data),
          ),
          actions: [
            TextButton(
              onPressed: () {
                _saveWidgetSP(ctrl.text, data);
              },
              child: Text(l10n.ok),
            ),
          ],
        );
      },
    );
  }
}
