//flutter
import 'package:flutter/foundation.dart';

//ENUM
import '../emums/request_status_enum.dart';

class RequestModel {
  final String id;
  final String customerName;
  final String customerId;
  final String response;
  final String body;
  final DateTime creationDate;
  final RequestStatus status;

  const RequestModel({
    @required this.id,
    @required this.customerName,
    @required this.customerId,
    @required this.body,
    this.response = '',
    @required this.creationDate,
     this.status = RequestStatus.Pending,
  });

  RequestModel.fromFirebaseDocument(Map<String, dynamic> snapshot)
      : id = snapshot['id'],
        customerId = snapshot['customerId'],
        customerName = snapshot['customerName'],
        body = snapshot['body'],
        response = snapshot['reponse'],
        creationDate = DateTime.parse(
          snapshot['creationDate'],
        ),
        status = snapshot['status'] == "PENDING"
            ? RequestStatus.Pending
            : RequestStatus.Answered;

  Map<String, dynamic> toFireBaseDoc() {
    return {
      'id' : id ,
      'customerId'  : customerId ,
      'customerName' : customerName ,
      'body' : body ,
      'response' :response ,
      'creationDate' : creationDate.toIso8601String(),
       'status':   "PENDING" 
    };
  }
}
