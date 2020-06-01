import 'package:flutter/material.dart';

class ValuationPage extends StatefulWidget {
  @override
  _ValuationPageState createState() => _ValuationPageState();
}

class _ValuationPageState extends State<ValuationPage> {
  @override
  Widget build(BuildContext context) {
    //DemoLocalization lang = DemoLocalization.of(context);
    return Scaffold(
        appBar: AppBar(
          centerTitle: true,
          elevation: 0.0,
          title: Row(
            children: <Widget>[
              Image.asset('images/evaluation.png',height: 50.0),
              SizedBox(width: 5.0,),
              Text("EVALUATION"),
            ],
          ),
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
            decoration: BoxDecoration(
              gradient: LinearGradient(
                begin: FractionalOffset.topCenter,
                end: FractionalOffset.bottomCenter,
                stops: [
                  0.3,
                  6
                ],
                colors:[
                  Color(0xff07548f),
                  Color(0xff1290a2),
                ],
              ),
            ),
            child: Container(
              height: MediaQuery.of(context).size.height,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
              ),
              child: Padding(
                  padding: EdgeInsets.only(top: 45.0,left:10.0,right: 10.0,bottom: 10.0),
                  child: Container(
                      height: MediaQuery.of(context).size.height,
                      child: new ListView.builder (
                          itemCount: 10,
                          itemBuilder: (BuildContext context, int index) {
                            return  _buildPaymentItem();
                          }
                      )
                  )
              ),
            )
        )
    );
  }
  Widget _buildPaymentItem() {
    return new Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: new Border.all(width: 1.0,color:Color(0xffe4e6e8)),
          borderRadius: new BorderRadius.circular(4.0),
          boxShadow: <BoxShadow>[
            new BoxShadow (
              color: const Color(0xcce4e6e8),
              offset: new Offset(1.0,1.0),
              blurRadius: 1.0,
            ),
          ],
        ),
        padding: EdgeInsets.all(5.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: <Widget>[
            Container(
              decoration: BoxDecoration(
                  gradient: LinearGradient(
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                      colors: <Color>[
                        Color(0xff054798),
                        Color(0xff009ccf),
                      ])
              ),
              height: 89.0,
              child:
              _rowTitleSchedule(Icon(Icons.library_books,color: Colors.white,size: 40.0,),'Very Good'),
            ) ,
            SizedBox(width: 5.0,height: 5.0),
            Expanded(
              child: Container(
//                decoration: BoxDecoration(
//                    border: Border(bottom:BorderSide(width: 2.0,color: Color(0xff009ccf)
//                    ) )),
                child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children:[
                      Text('ភាពឧស្សាហ៍ក្នុងការសិក្សា',style: TextStyle(fontFamily: 'Khmer',)),
                      Text('Dilligence'),
                    ]
                ),
              )
            )
          ],
        )

    );
  }
  Widget _rowTitleSchedule(Icon iconType,String subjectName) {
    return Padding(
      padding: EdgeInsets.all(5.0),
      child: Column(
          children: [
            iconType,
            Text(subjectName, style:
            TextStyle(
                fontFamily: 'Montserrat',
                fontWeight: FontWeight.w600,
                color: Colors.white
            )
            ),
          ]
      ),
    );
  }


}
