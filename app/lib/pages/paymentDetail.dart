import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import '../url_api.dart';
import 'package:app/localization/localization.dart';

class PaymentDetailsPage extends StatefulWidget {
  final paymentId;
  final rowPayment;

  PaymentDetailsPage({this.rowPayment, this.paymentId});
  @override
  _PaymentDetailsPageState createState() => _PaymentDetailsPageState();
}

class _PaymentDetailsPageState extends State<PaymentDetailsPage> {

   List paymentListDetail = new List();
   bool isLoading = true;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _getJsonPayment();
  }

  @override
  Widget build(BuildContext context) {
    DemoLocalization lang = DemoLocalization.of(context);
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0.0,
          title: Row(
            children: <Widget>[
              Image.asset('images/payment.png', height: 50.0),
              SizedBox(width: 10.0),
              Text((lang.tr("PAYMENT_DETAIL"))+widget.rowPayment['receipt_number'],
                  style: TextStyle(
                      fontFamily: 'Montserrat',
                      fontSize: 18.0,
                      color: Colors.white)
              ),

            ],
          ),
          centerTitle: true,
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
        body:  Container(
            height: MediaQuery.of(context).size.height,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.only(topLeft: Radius.circular(40.0)),
            ),
            child: Padding(
                padding: EdgeInsets.only(top: 45.0),
                child: Column(
                  children: <Widget>[
                    Expanded(
                      flex: 12,
                      child: Container(
                          margin: EdgeInsets.only(right: 5.0,left: 5.0),
                          height: MediaQuery
                              .of(context)
                              .size
                              .height,
                          child: isLoading?new Stack(alignment: AlignmentDirectional.center,
                              children: <Widget>[new CircularProgressIndicator()]) : new ListView.builder (
                              itemCount: paymentListDetail.length,
                              itemBuilder: (BuildContext context, int index) {
                                return _buildPaymentItem(paymentListDetail[index]);
                              }
                          )
                      ),
                    ),
                    Expanded(
                        flex: 4,
                        child:Container(
                          decoration: BoxDecoration(
                              gradient: LinearGradient(
                                  begin: Alignment.centerLeft,
                                  end: Alignment.centerRight,
                                  colors: <Color>[
                                    Color(0xff054798),
                                    Color(0xff009ccf),
                                  ])
                          ),
                          padding: EdgeInsets.only(top:2.0,bottom: 2.0,left: 5.0,right: 5.0),
                          child: Row(
                            children: <Widget>[
                              Expanded(flex: 1,
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Text(lang.tr("RECEIPT No")+widget.rowPayment['receipt_number'],style: TextStyle(color: Colors.white.withOpacity(0.9),
                                        fontWeight: FontWeight.bold)
                                    ),
                                    _rowPaymentSummary(lang.tr("Payment Method"),widget.rowPayment['paymentMethod']),
                                    _rowPaymentSummary(lang.tr("Paid Date"),widget.rowPayment['createDate']),
                                    _rowPaymentSummary(lang.tr("Cashier"),widget.rowPayment['byUser'])
                                  ],
                                ),
                              ),
                              SizedBox(width: 5.0),
                              Expanded(
                                  flex: 1,
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.start,
                                    crossAxisAlignment: CrossAxisAlignment.start,
                                    children: <Widget>[
                                      _rowPaymentSummary(lang.tr("Penalty"),widget.rowPayment['penalty']),
                                      _rowPaymentSummary(lang.tr("T.Payment"),widget.rowPayment['totalPayment']),
                                      _rowPaymentSummary(lang.tr("Credit Memo"),widget.rowPayment['creditMemo']),
                                      _rowPaymentSummary(lang.tr("Paid"),widget.rowPayment['paidAmount']),
                                      _rowPaymentSummary(lang.tr("Balance"),widget.rowPayment['balanceDue']),
                                      Container(
                                        alignment: FractionalOffset.topRight,
                                        width: MediaQuery.of(context).size.width,
                                        decoration: BoxDecoration(
                                            border: Border(top: BorderSide(color: Colors.white,width: 2.0))
                                        ),
                                        child: Text(lang.tr("TOTAL")+" \$"+widget.rowPayment['paidAmount'],style: TextStyle(color: Colors.white,fontWeight: FontWeight.bold)),
                                      )
                                    ],
                                  )
                              )
                            ],
                          ),
                        )
                    )
                  ],
                )
            ),
          ),
    );
  }
  _getJsonPayment() async{
    final String urlApi = StringData.paymentDetailUrl+'&payment_id='+widget.paymentId.toString();
    http.Response rawData = await http.get(urlApi);
    if(rawData.statusCode==200){
      setState(() {
        if(json.decode(rawData.body)['code']=='SUCCESS'){
            paymentListDetail = json.decode(rawData.body)['result'] as List;
            isLoading = false;
        }
      });
    }
  }
  Widget _buildPaymentItem(rowData) {
    DemoLocalization lang = DemoLocalization.of(context);
    return Container(
        margin: EdgeInsets.only(bottom: 10.0),
        decoration: new BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(width: 1.0, color: Color(0xffdddddd)),
            right: BorderSide(width: 1.0, color: Color(0xffdddddd)),
            bottom: BorderSide(width: 1.0, color: Color(0xffdddddd)),
            left: BorderSide(width: 5.0, color: Colors.lightBlue.shade600),
          ),
          boxShadow: <BoxShadow>[
            new BoxShadow (
              color: Colors.black26,
              offset: new Offset(0.0, 2.0),
              blurRadius: 3.0,
            ),
          ],
        ),
        padding: EdgeInsets.only(left: 5.0, right: 5.0, top: 5.0, bottom: 5.0),
        child: Column(
          children: <Widget>[
            Row(
              crossAxisAlignment: CrossAxisAlignment.center,
              mainAxisAlignment: MainAxisAlignment.start,
              children: <Widget>[
                Icon(Icons.filter_list,size: 18.0,color:Colors.black38),
                _rowTitlePayment(rowData['serviceTitle'].toString(), rowData['serviceCategory'].toString()),
              ],
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: <Widget>[
                Expanded(
                    flex: 1,
                    child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          _rowPayment(lang.tr('Pay Term'), rowData['payment_term'], 12.0),
                          _rowPayment(lang.tr('Qty'), rowData['qty'], 12.0),
                          _rowPayment(lang.tr('Start Date'), rowData['startDate'], 12.0),
                          _rowPayment(lang.tr('End Date'), rowData['validate'], 12.0),
                        ]
                    )
                ),
                Expanded(
                    flex: 1,
                    child: Padding(padding: EdgeInsets.only(left: 10.0),
                        child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              _rowPayment(lang.tr('Unit Price'), rowData['fee'], 12.0),
                              _rowPayment(lang.tr('Deduct_Extra'), rowData['extraFee'], 12.0),
                              _rowPayment(lang.tr('Disc'), rowData['discountAmount'], 12.0),
                              _rowPayment(lang.tr('Total'), rowData['paidAmount'], 12.0),
                              Container(
                                alignment: Alignment.bottomRight,
                                child: Text(lang.tr("Paid")+" : \$ "+rowData['paidAmount'], style: TextStyle(
                                    fontSize: 14.0,
                                    color: Colors.red.shade700,
                                    fontWeight: FontWeight.w600),),
                              )
                            ]
                        ))

                ),
              ],
            ),

          ],
        )
    );
  }
  Widget _rowTitlePayment(String textService, String serviceCate){
    return Text.rich(

        TextSpan(
      text: textService,
      style: TextStyle(fontSize:13,fontWeight: FontWeight.bold,color: Color(0xff07548f).withOpacity(0.9),),
      children: <TextSpan>[
        TextSpan(
            text: '('+serviceCate+')',

            style: TextStyle(
              fontSize: 10,
              color: Colors.black38
            )),
        // can add more TextSpans here...
      ],
    ));
  }
  Widget _rowPayment(String textData, String priceData,double fontSize){
    return new Container(
      decoration: BoxDecoration(
          border: Border(bottom: BorderSide(color: Colors.black26,width: 1.0))
      ),
      child: Row(
          children: [
            Expanded(
              child: Text(textData,style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: fontSize,
                  fontWeight: FontWeight.w400,
                  color: Color(0xff07548f).withOpacity(0.9)
              )
              ),
            ),
            Expanded(
              child:  Align(
                alignment: Alignment.topRight,
                child: Text(priceData,style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: fontSize,
                    fontWeight: FontWeight.w500,
                    color: Color(0xff07548f),
                    fontStyle: FontStyle.italic
                )
                ),
              ),
            )
          ]
      ),
    );
  }Widget _rowPaymentSummary(String textData, String priceData){
    return new Container(
      child: Row(
          children: [
            Container(
              child: Text(textData,style: TextStyle(
                  fontFamily: 'Montserrat',
                  fontSize: 12.0,
                  fontWeight: FontWeight.bold,
                  color: Colors.white.withOpacity(0.8)
              )
              ),
            ),
            Expanded(
              child:  Align(
                alignment: Alignment.topRight,
                child: Text(priceData,style: TextStyle(
                    fontFamily: 'Montserrat',
                    fontSize: 12.0,
                    fontWeight: FontWeight.w500,
                    color: Colors.white.withOpacity(0.8),
                    fontStyle: FontStyle.italic
                )
                ),
              ),
            )
          ]
      ),
    );
  }
}