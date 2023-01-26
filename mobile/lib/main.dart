import 'package:flutter/material.dart';
import 'package:usage_stats/usage_stats.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  // List<EventUsageInfo> events = [];
  List<UsageInfo> usageInfo = [];
  // This widget is the root of your application.
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {initUsage();});
  }
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Usage Stats',
      theme: ThemeData(
        // This is the theme of your application.
        //
        // Try running your application with "flutter run". You'll see the
        // application has a blue toolbar. Then, without quitting the app, try
        // changing the primarySwatch below to Colors.green and then invoke
        // "hot reload" (press "r" in the console where you ran "flutter run",
        // or simply save your changes to "hot reload" in a Flutter IDE).
        // Notice that the counter didn't reset back to zero; the application
        // is not restarted.
        primarySwatch: Colors.blue,
      ),
      home: Scaffold(
        appBar: AppBar(
          title: const Text("Usage Stats"),
        ),
        body: Container(
            child: ListView.separated(itemBuilder: (context, index) {
              return ListTile(
                title: Text(usageInfo[index].packageName!),
                subtitle: Text(
                    "First time used: ${DateTime.fromMillisecondsSinceEpoch(int.parse(usageInfo[index].firstTimeStamp!)).toIso8601String()}" +
                        "\nLast time used: ${DateTime.fromMillisecondsSinceEpoch(int.parse(usageInfo[index].lastTimeStamp!)).toIso8601String()}" +
                        "\nLength of usage: ${int.parse(usageInfo[index].totalTimeInForeground!) / 1000 / 60}"
                ),
              );
            }, separatorBuilder: (context, index) =>Divider(), itemCount: usageInfo.length)
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: (){
            initUsage();
          },
          child: Icon(Icons.refresh),
          mini: true,
        ),
      ),
    );
  }

  Future<void> initUsage() async {
    UsageStats.grantUsagePermission();
    DateTime endDate = DateTime.now();
    DateTime startDate = DateTime(2023, 1,1,0,0,0);

    // List<EventUsageInfo> queryEvents = await UsageStats.queryEvents(startDate, endDate);
// query usage stats
    List<UsageInfo> usageStats = await UsageStats.queryUsageStats(startDate, endDate);
    List<String> packageList = [
      "com.android.chrome",
      "com.android.localtransport"];

    usageStats.forEach((element) { print("${element.packageName}\n");});

    setState(() {
      // usageInfo = usageStats.reversed
      //     .where((i) {
      //       return !i.packageName.toString().contains("com.android")  ;
      // })
      // .where((i) =>  !i.packageName.toString().contains("com.google.android"))
      //     .toList();
      // usageInfo.add(usageStats.firstWhere((element) => element.packageName == "com.android.gms"));
      usageInfo.addAll(
          usageStats
              .toList()
      );
    });



  }
}

