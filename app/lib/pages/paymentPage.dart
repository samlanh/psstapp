import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:app/localization/localization.dart';
import 'package:app/pages/paymentDetail.dart';
import '../url_api.dart';

class PaymentPage extends StatefulWidget {
  final String studentId,currentLang,title;

  PaymentPage({this.title,this.studentId,this.currentLang});
  @override
  _PaymentPageState createState() => _PaymentPageState();
}

class _PaymentPageState extends State<PaymentPage> {

  List paymentList = new List();
  bool isLoading = true;
  List rowPayment = new List();

  @override
  void initState() {
    _getJsonPayment();
    // TODO: implement initState
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);
    String strLang = Localizations.localeOf(context).languageCode;
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0.0,
        centerTitle: true,
        title: Row(
          children: <Widget>[
            Image.asset('images/payment.png',height: 50.0),
            SizedBox(width: 10.0),
            Text(lang.tr(widget.title.toString()),
              style: TextStyle(
                fontFamily: (strLang=='km')?'Khmer':'Montserrat',
                fontSize: 18.0,
                color: Colors.white)
            )
          ]
        ),
        flexibleSpace: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.centerLeft,
              end: Alignment.centerRight,
              colors: <Color>[
                Color(0xff054798),
                Color(0xff009ccf)
              ])
          ),
        ),
      ),
      body: Container(
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.centerLeft,
            end: Alignment.centerRight,
            colors: <Color>[
              Color(0xff054798),
              Color(0xff009ccf)
            ]
           ),
        ),
        child: Container(
            alignment: AlignmentDirectional.center,
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Color(0xfff2f6fc),
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0))
            ),
            child:isLoading ? new Stack(alignment: AlignmentDirectional.center,
                children: <Widget>[
                  new CircularProgressIndicator(),
                ]) :
            Padding(
              padding: EdgeInsets.only(top: 45.0,left:10.0,right: 10.0,bottom: 10.0),
              child: Container(
                height: MediaQuery.of(context).size.height,
                child: paymentList.isNotEmpty
                  ? ListView.builder (
                  itemCount:paymentList.length,
                  itemBuilder: (BuildContext context, int index) {
                    return _buildPaymentItem(index,paymentList[index]);
                  }
                ): Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: <Widget>[
                      notFoundPage()
                    ],
                  ),
                )
              )
            ),
          )
      )
    );
  }
  _getJsonPayment() async{
    final String urlApi = StringData.paymentUrl+'&stu_id='+widget.studentId+'&currentLang='+widget.currentLang;
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
            paymentList = json.decode(rawData.body)['result'] as List;
            isLoading = false;
        }
      });
    }
  }

  Widget _buildPaymentItem(int index ,rowPayment) {
    DemoLocalization lang = DemoLocalization.of(context);
    String strLang = Localizations.localeOf(context).languageCode;

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
               blurRadius: 1.0
             )
           ]
         ),
        padding: EdgeInsets.all(5.0),
        child: InkWell(
          onTap:(){
            Navigator.of(context).push(MaterialPageRoute(
                builder: (context) => PaymentDetailsPage(rowPayment:rowPayment, paymentId: rowPayment['id'])
            ));
          },
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: <Widget>[
              Container(
                padding: EdgeInsets.all(5.0),
                color: Color(0xff07548f)
                ,child: Column(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.start,
                children:[
                  _rowTitlePaymentIcon(lang.tr('DEGREE'),Icon(Icons.category,color: Colors.white,size: 12.0),12.0),
                  _rowTitlePaymentIcon(lang.tr('GRADE'),Icon(Icons.playlist_add_check,color: Colors.white,size: 12.0),12.0),
                  _rowTitlePayment(rowPayment['receipt_number'],18.0),
                  _rowTitlePayment(rowPayment['paymentMethod'],12.0),
                  SizedBox(height: 10.0),
                  _rowTitlePaymentIcon(rowPayment['createDate'],Icon(Icons.date_range,color: Colors.white,size: 12.0),12.0),
                  _rowTitlePaymentIcon(rowPayment['byUser'],Icon(Icons.person,color: Colors.white,size: 12.0),12.0),
                  _rowTitlePaymentIcon((index+1).toString(),Icon(Icons.done,color: Colors.white,size: 12.0),12.0)
                ]
              )
              ),
              Expanded(
                child: Container(
                  padding: EdgeInsets.only(left: 10.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.start,
                    children:[
                      Align(
                        alignment: FractionalOffset.topRight,
                        child:  Icon(Icons.more_horiz,size: 22.0,color:Colors.black45)
                      ),
                      _rowPayment(lang.tr('TOTAL_PAYMENT'),rowPayment['totalPayment'],12.0),
                      _rowPayment(lang.tr('Credit Memo'),rowPayment['creditMemo'],12.0),
                      _rowPayment(lang.tr('Balance'),rowPayment['balanceDue'],12.0),
                      Container(
                        alignment: Alignment.bottomRight,
                        child: Text(lang.tr("Paid")+" \$ : "+rowPayment['paidAmount'],style: TextStyle(
                            fontFamily: (strLang=='km')?'Khmer':'Montserrat',
                            fontSize: 14.0,color:Colors.red.shade700,fontWeight: FontWeight.w600))
                      )
                    ]
                  )
                )
              )
            ]
          )
        )
    );
  }
  Widget _rowTitlePaymentIcon(String stringData,Icon icon, double fontSize){
    return Row(
      children:[
       icon,
        Text(stringData, style:TextStyle(
          fontFamily: 'Montserrat',
          fontSize: fontSize,
          fontWeight: FontWeight.w600,
          color: Colors.white
          )
        )
      ]
    );
  }
  Widget _rowTitlePayment(String stringData, double fontSize){
    return Row(
      children:[
        Text(
            stringData, style:TextStyle(
            fontFamily: 'Montserrat',
            fontSize: fontSize,
            fontWeight: FontWeight.w600,
            color: Colors.white
          )
        )
      ]
    );
  }
  Widget _rowPayment(String textData, priceData,double fontSize){
   String strLang = Localizations.localeOf(context).languageCode;
    return new Container(
      decoration: BoxDecoration(
        border: Border(bottom: BorderSide(color: Colors.black26,width: 1.0))
      ),
      child: Row(
        children: [
         Expanded(
           child: Text(textData,style: TextStyle(
               fontFamily: (strLang=='km')?'Khmer':'Montserrat',
               fontSize: fontSize,
               fontWeight: FontWeight.w500,
               color: Color(0xff07548f).withOpacity(0.9)
              )
           )
         ),
         Expanded(
           child: Align(
             alignment: Alignment.topRight,
               child: Text(priceData,style: TextStyle(
                   fontFamily: (strLang=='km')?'Khmer':'Montserrat',
                   fontSize: fontSize,
                   fontWeight: FontWeight.bold,
                   color: Color(0xff07548f),
                   fontStyle: FontStyle.italic
               )
             )
           )
         )
        ]
      ),
    );
  }
}