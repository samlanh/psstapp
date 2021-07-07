import 'dart:io';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:path_provider/path_provider.dart';
import 'package:app/functions/progress_bar.dart';
import 'package:app/services/web.client.dart';
import 'package:share_extend/share_extend.dart';
import 'package:open_file/open_file.dart';
import 'dart:async';
import 'package:app/localization/localization.dart';
import '../url_api.dart';

class DownloadAndSharePage extends StatefulWidget {
  final String stuId,groupId,examType,forSemester,forMonth;

  DownloadAndSharePage({this.stuId,this.groupId,this.examType,
      this.forSemester,this.forMonth});

  _DownloadAndSharePageState createState() => _DownloadAndSharePageState();
}

class _DownloadAndSharePageState extends State<DownloadAndSharePage>
    with SingleTickerProviderStateMixin {

  double _percentage;
  bool _progressDone;

  @override
  initState() {
    super.initState();
    downloadFile();
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
    DemoLocalization lang = DemoLocalization.of(context);
    return Scaffold(
        appBar: AppBar(
          title: Text('Download and Share'),
          flexibleSpace: Container(
            decoration: BoxDecoration(
                gradient: LinearGradient(
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                    colors: <Color>[
                      Color(0xff054798),
                      Color(0xff009ccf),
                    ])
            ),
          ),
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
                FlatButton.icon(
                    onPressed:(){
                      downloadFile();
                    },
                    color: Colors.red,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Colors.red)
                    ),
                    icon: Icon(Icons.file_download,color: Colors.white),
                    label: Text(lang.tr("DOWNLOAD"),style:TextStyle(
                      color:Colors.white,fontSize: 16.0,
                    ))
                ),
//                RaisedButton(
//                  child: Text(lang.tr("DOWNLOAD")),
//                  onPressed: () {
//                    setState(() {
//                      _percentage = 0;
//                      _progressDone = false;
//                    });
//
//                    final String dir =
//                        (await getApplicationDocumentsDirectory()).path;
////                    final String path = '$dir/http://192.168.1.7/psst/trunk/public/api/index/transcriptpdf?stu_id=2&group_id=1&exam_type=1&for_semester=1&for_month=6';
////                    final File file = File(path);
//
//                    await http.download(
//                      'http://192.168.1.7/psst/trunk/public/api/index/transcriptpdf?stu_id=2&group_id=1&exam_type=1&for_semester=1&for_month=',
//                      '$dir/psis_transcripts.pdf',
//                      showDownloadProgress,
//                    );
//                  },
//              ),
//                RaisedButton(
//                    child: Text("View File"),
//                    onPressed:openFile
//                ),
              if (_progressDone)
                FlatButton.icon(
                  onPressed:openFile,
                  color: Colors.blue,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8.0),
                      side: BorderSide(color: Colors.blue)
                  ),
                  icon: Icon(Icons.remove_red_eye,color: Colors.white),
                  label: Text(lang.tr("VIEW_FILE"),style:TextStyle(
                    color:Colors.white,fontSize: 16.0,
                  ))
                ),
              if (_progressDone)
                    FlatButton.icon(
                      onPressed: () async {
                        final String dir =
                        (await getApplicationDocumentsDirectory()).path;
                        final String path = '$dir/psis_transcripts.pdf';
                        ShareExtend.share(path, "file");
                    },
                    color: Color(0xff054798),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(8.0),
                        side: BorderSide(color: Color(0xff054798))
                    ),
                    icon: Icon(Icons.share,color: Colors.white),
                    label: Text(lang.tr("SHARE"),style:TextStyle(
                      color:Colors.white,fontSize: 16.0,
                    ))
                ),
//                RaisedButton(
//                  child: Text("SHARE"),
//                    onPressed: () async {
//                    // get file from local store
//                      final String dir =
//                      (await getApplicationDocumentsDirectory()).path;
//                      final String path = '$dir/psis_transcripts.pdf';
////                      debugPrint('part receiver '+path);
//                      ShareExtend.share(path, "file");
//                    },
//                ),
            ],
          ),
        ),
      );
  }
  void downloadFile() async{
    setState(() {
      _percentage = 0;
      _progressDone = false;
    });

    final String dir =
        (await getApplicationDocumentsDirectory()).path;
    String urlDownload = StringData.downloadTranscript+'?&stu_id='+widget.stuId+'&group_id='+widget.groupId+'&exam_type='+widget.examType+'&for_semester='+widget.forSemester+'&for_month='+widget.forMonth;

    await http.download(
       urlDownload,
      //StringData.downloadTranscript+'&stu_id='+widget.stuId+'&group_id='+widget.stuId+'&exam_type='+widget.stuId+'&for_semester='+widget.stuId+'&for_month='+widget.stuId,
//      'http://192.168.1.7/psst/trunk/public/api/index/transcriptpdf?stu_id=2&group_id=1&exam_type=1&for_semester=1&for_month=1',
      '$dir/psis_transcripts.pdf',
      showDownloadProgress,
    );
  }
  void showDownloadProgress(received, total) {
    if (total != -1) {
      var percentage = (received / total * 100);
      setState(() {
        if (percentage < 100) {
          _percentage = percentage;
        } else {
          _progressDone = true;
        }
      });
    }
  }
  Future<void> openFile() async {

    final String dir =(await getApplicationDocumentsDirectory()).path;
    final String path = '$dir/psis_transcripts.pdf';
    final result = await OpenFile.open(path);
//    setState(() {
//      _openResult = "type=${result.type}  message=${result.message}";
//    }
//    );
  }


}