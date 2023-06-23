import 'dart:convert';


class Constants {
  static const String emptyString = "";
  static const String newExpenseId = "0";
  // static const String fsTripSet = "expenses";
}

class ExpenseEntity {
  int id = int.parse(Constants.newExpenseId) ;
  String type = Constants.emptyString;
  int amount = 0;
  String date = Constants.emptyString;
  String comments = Constants.emptyString;
  int trip = 0 ;

  


  ExpenseEntity(this.id, this.type, this.amount, this.date, this.comments, this.trip);

  ExpenseEntity.newExpense(String type, int amount, String date, String comments, int trip)
    :this(int.parse(Constants.newExpenseId), type, amount, date, comments, trip);

  ExpenseEntity.empty();


  static ExpenseEntity expenseFromJson(String str) {
  final jsonData = json.decode(str);
  return ExpenseEntity.fromMap(jsonData);
}

String expenseToJson(ExpenseEntity data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}



  factory ExpenseEntity.fromMap(Map<dynamic, dynamic> map) {
    return ExpenseEntity(map['id'], map['type'], map['amount'], map['date'], map['comments'], map['trip']);
  }

  Map<String, dynamic> toMap() {
    return {
      'type': type,
      'amount': amount,
      'date': date,
      'comments': comments,
      'trip': trip,
    };
  }


}