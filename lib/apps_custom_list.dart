import 'package:device_apps/device_apps.dart';
import 'package:flutter/material.dart';

class AppsCustomList extends StatefulWidget {
  const AppsCustomList({super.key});

  @override
  State<AppsCustomList> createState() => _AppsCustomListState();
}

class _AppsCustomListState extends State<AppsCustomList> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Custom Apps"),
      ),
      body: const _CustomAppsList(),
    );
  }
}

class _CustomAppsList extends StatefulWidget {
  const _CustomAppsList({Key? key}) : super(key: key);

  @override
  State<_CustomAppsList> createState() => _CustomAppsListState();
}

class _CustomAppsListState extends State<_CustomAppsList> {
  late Future<List<Application>>? myApps = [] as Future<List<Application>>?;

  Future<List<Application>>? loadRTApps() async {
    await DeviceApps.getApp('com.samsung.android.oneconnect')
        .then((oneConnect) => oneConnect != null
            ? myApps?.then((apps) => apps.add(oneConnect))
            : null)
        .whenComplete(() async =>
            await DeviceApps.getApp('com.sec.android.easyMover').then(
                (easyMover) => easyMover != null
                    ? myApps?.then((apps) => apps.add(easyMover))
                    : null))
        .whenComplete(() async =>
            await DeviceApps.getApp('com.samsung.android.timezone.autoupdate_O')
                .then((timeZoneUpdate) => timeZoneUpdate != null
                    ? myApps?.then((apps) => apps.add(timeZoneUpdate))
                    : null));

    return myApps!;
  }

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Application>>(
        future: loadRTApps(),
        builder: (BuildContext context, AsyncSnapshot<List<Application>> data) {
          if (data.data == null) {
            return const Center(child: CircularProgressIndicator());
          } else {
            List<Application> apps = data.data!;

            return Scrollbar(
              child: ListView.builder(
                  itemBuilder: (BuildContext context, int position) {
                    Application app = apps[position];
                    return Column(
                      children: <Widget>[
                        ListTile(
                          leading: app is ApplicationWithIcon
                              ? CircleAvatar(
                                  backgroundImage: MemoryImage(app.icon),
                                  backgroundColor: Colors.white,
                                )
                              : null,
                          onTap: () => onAppClicked(context, app),
                          title: Text('${app.appName} (${app.packageName})'),
                          subtitle: Text('Version: ${app.versionName}\n'
                              'System app: ${app.systemApp}\n'
                              'APK file path: ${app.apkFilePath}\n'
                              'Data dir: ${app.dataDir}\n'
                              'Installed: ${DateTime.fromMillisecondsSinceEpoch(app.installTimeMillis).toString()}\n'
                              'Updated: ${DateTime.fromMillisecondsSinceEpoch(app.updateTimeMillis).toString()}'),
                        ),
                        const Divider(
                          height: 1.0,
                        )
                      ],
                    );
                  },
                  itemCount: apps.length),
            );
          }
        });
  }
}

void onAppClicked(BuildContext context, Application app) {
  showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(app.appName),
          actions: <Widget>[
            _AppButtonAction(
              label: 'Open app',
              onPressed: () => app.openApp(),
            ),
            _AppButtonAction(
              label: 'Open app settings',
              onPressed: () => app.openSettingsScreen(),
            ),
            _AppButtonAction(
              label: 'Uninstall app',
              onPressed: () async => app.uninstallApp(),
            ),
          ],
        );
      });
}

class _AppButtonAction extends StatelessWidget {
  final String label;
  final VoidCallback? onPressed;

  const _AppButtonAction({required this.label, this.onPressed});

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: () {
        onPressed?.call();
        Navigator.of(context).maybePop();
      },
      child: Text(label),
    );
  }
}
