import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:testapi/pages/progress_bar.dart';
import 'package:testapi/services/web.client.dart';
import 'package:share_extend/share_extend.dart';
import 'package:open_file/open_file.dart';
import 'dart:async';

class DownloadAndSharePage extends StatefulWidget {
  DownloadAndSharePage({Key key}) : super(key: key);

  _DownloadAndSharePageState createState() => _DownloadAndSharePageState();
}

class _DownloadAndSharePageState extends State<DownloadAndSharePage>



    with SingleTickerProviderStateMixin {
  double _percentage;
  bool _progressDone;

  @override
  initState() {
    super.initState();
    _percentage = 0.0;
    _progressDone = false;
  }

  Widget getProgressText() {
    return Text(
      _percentage == 0 ? '' : '${_percentage.toInt()}',
      style: TextStyle(
        fontSize: 40,
        fontWeight: FontWeight.w800,
        color: Colors.green,
      ),
    );
  }

  Widget progressView() {
    return CustomPaint(
      child: Center(
        child: _progressDone
            ? Icon(Icons.check, size: 50, color: Colors.green)
            : getProgressText(),
      ),
      foregroundPainter: ProgressPainter(
        defaultCircleColor: Colors.amber,
        percentageCompletedCircleColor: Colors.green,
        completedPercentage: _percentage,
        circleWidth: 20.0,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Text('Download and Share'),
        ),
        body: Container(
            alignment: Alignment.center,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: <Widget>[
              Container(
              height: 200.0,
              width: 200.0,
              padding: EdgeInsets.all(20.0),
              margin: EdgeInsets.all(30.0),
              child: progressView(),
            ),
            RaisedButton(
              child: Text("Open"),
              onPressed:openFile
            ),
            RaisedButton(
              child: Text("START"),
              onPressed: () async {
                setState(() {
                  _percentage = 0;
                  _progressDone = false;
                });

                // create temp file
                final String dir =
                    (await getApplicationDocumentsDirectory()).path;
                final String path = '$dir/download_demo.png';

                final File file = File(path);
                // -------

                //download 25mb image
                debugPrint("Store Location "+'$dir/download_demo.png');
                await http.download(
                  'https://s3.amazonaws.com/images.seroundtable.com/google-css-images-1515761601.jpg',
                  '$dir/download_demo.png',
                  showDownloadProgress,
                );

              },
            ),
            if (_progressDone)
        RaisedButton(
        child: Text("SHARE"),
    onPressed: () async {
    // get file from local store
    final String dir =
    (await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/download_demo.png';
    debugPrint('part receiver '+path);

    ShareExtend.share(path, "file");
    },
    ),



    ],
    ),
    ),
    );
  }
  Future<void> openFile() async {

    final String dir =
        (await getApplicationDocumentsDirectory()).path;
    //final String path = '$dir/download_demo.png';

    final String  path = '/data/user/0/com.example.testapi/app_flutter/download_demo.png';
    final result = await OpenFile.open(path);
    debugPrint(result.message.toString());

//    setState(() {
//      _openResult = "type=${result.type}  message=${result.message}";
//    }
//    );

  }

  void showDownloadProgress(received, total) {
    if (total != -1) {
      //calculate %
      var percentage = (received / total * 100);
      // update progress state
      setState(() {
        if (percentage < 100) {
          _percentage = percentage;
        } else {
          _progressDone = true;
        }
      });
    }
  }
}