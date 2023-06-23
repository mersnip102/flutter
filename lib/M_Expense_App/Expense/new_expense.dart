// ignore_for_file: prefer_interpolation_to_compose_strings, unrelated_type_equality_checks, use_build_context_synchronously, prefer_const_constructors


import 'package:intl/intl.dart';
import 'package:flutter/src/widgets/container.dart';
import 'package:flutter/src/widgets/framework.dart';
import 'package:m_expense_app/ColorsProject.dart';
import 'package:m_expense_app/M_Expense_App/Expense/my_expenses.dart';
import 'package:m_expense_app/M_Expense_App/route_names.dart';
import 'package:m_expense_app/models/Expense%20Model/expense_entity.dart';
import 'package:flutter/material.dart';
import 'package:m_expense_app/models/Trip%20Model/trip_entity.dart';
import 'package:m_expense_app/utils/DatabaseExpense.dart';

class NewExpense extends StatefulWidget {
  NewExpense({Key? key, this.theExpense, this.theTrip}) : super(key: key);
  ExpenseEntity? theExpense;
  TripEntity? theTrip;
  @override
  State<NewExpense> createState() => _NewExpenseState();
}

class _NewExpenseState extends State<NewExpense> {
  //result hiển thị kết quả nội dung để trong State của chúng ta
  // String result = "Details: ";
  final TextEditingController txtType = TextEditingController();
  final TextEditingController txtAmount = TextEditingController();
  final TextEditingController txtDate = TextEditingController();
  final TextEditingController txtComments = TextEditingController();

  
  final _formKey = GlobalKey<FormState>(); // bắt buộc form state chứ ko phải newbookstate (chỉ là 1 ui) - form state rộng hơn
  // The controller for the text field
  final TextEditingController _controller = TextEditingController();

  DateTime? date;
  final dateFormat = DateFormat('dd/MM/yyyy');

  @override
  void initState() { //initState là 1 function của State để khởi tạo dữ liệu ban đầu cho State (khởi tạo dữ liệu ban đầu cho new book state)
    // TODO: implement initState
    // Stae<NewTrip> là của class NewTrip nên widget là lấy về cái class NewTrip
    //??= nghĩa là nếu null thì gán giá trị mới vào còn ko thì giữ nguyên giá trị cũ
    widget.theExpense ??= ExpenseEntity.empty();
    widget.theTrip ??= TripEntity.empty();
    
    txtType.text = widget.theExpense! // ! là bắt buộc có giá trị
        .type; // gán giá trị cho txtName.text = widget.theTrip.name
    txtAmount.text =  (widget.theExpense!.amount).toString();
    print(widget.theExpense!.amount);
    txtDate.text = widget.theExpense!.date;
    txtComments.text = widget.theExpense!.comments;
    super.initState(); // gọi hàm initstate của cha
  }

  // This function is triggered when the clear buttion is pressed
  void _clearTextField() {
    // Clear everything in the text field
    _controller.clear();
    // Call setState to update the UI - để update UI
    setState(() {});
  }
  @override
  Widget build(BuildContext context) {

    double fontSize = 18;
    // vì nó không phải là một cái app nên chỉ cần return scaffold - 1 stateful widget
    return Scaffold(
     appBar: AppBar(
      leading: IconButton(
        icon: Icon(Icons.arrow_back),
        onPressed: () {
            //  saveExpense();
            //  Navigator.pushNamed(context, RouteNames.Trips);
            if(widget.theExpense!.id == int.parse(Constants.newExpenseId)){
              
              Navigator.pushNamed(context, RouteNames.Trips);
            }else{
             Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => MyExpenses(theTrip: widget.theTrip!),
            
              ));
            }
        }
    ),
      // if trip = null => add trip else edit trip
      title: Text(widget.theExpense!.id == int.parse(Constants.newExpenseId) ? "Add Expense" : "Edit Expense"), //App bar là 1 widget hiển thị text trên đầu và các nút điều hướng
      actions: buildMenus, //action trả ra 1 array = nút 3 chấm ở góc phải trên cùng của appbar - nút điều hướng, chứa tất cả các điều hướng
      ),
      // body là một SingleChildScrollView có thể scroll nếu quá dài
      body: SingleChildScrollView(

        child: Padding(padding: const EdgeInsets.all(16.0),
          child: Form(
            key: _formKey, //key để xác định form 
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start, // bắt đầu từ trên xg dưới, từ start
              children: [
                Padding(padding: const EdgeInsets.only(bottom: 10),
                child: TextFormField( //input type text
                  // Mỗi một textFormField đc điều khiển bởi controller - ko giống như native sử dụng qua id
                  validator: requiredField,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: txtType,
                  keyboardType: TextInputType.name, //type text
                  decoration: const InputDecoration(
                    label: (Text("Type of expense")),
                    prefixIcon: Icon(Icons.trip_origin,
                    color: ColorsProject.tSecondaryColor),
                    hintStyle: TextStyle(color: Colors.teal),
                    labelStyle: TextStyle(color: ColorsProject.tSecondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorsProject.tSecondaryColor, width: 2.0), //border khi focus
                    ),
                    border: OutlineInputBorder(),
                    // hintText: "Name of trip", //placeholder
                  ),
                ),),
                const SizedBox(height: 10,), // SizedBox để tạo khoảng cách giữa các widget
                Padding(padding: const EdgeInsets.only(bottom: 10),
                 child: TextFormField( //input type text                             
                  validator: requiredField,
                  autovalidateMode: AutovalidateMode.onUserInteraction, // nhập ký tự thì tự validate
                  controller: txtAmount,
                  keyboardType: TextInputType.number, //type number
                  decoration: const InputDecoration(
                    label: (Text("Amount")),
                    prefixIcon: Icon(Icons.location_on,
                    color: ColorsProject.tSecondaryColor),
                    hintStyle: TextStyle(color: Colors.teal),
                    labelStyle: TextStyle(color: ColorsProject.tSecondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorsProject.tSecondaryColor, width: 2.0), //border khi focus
                    ),
                      
                    )
                    
                    // hintText: "Destination", //placeholder
                  ),
                ),
                const SizedBox(height: 10,),
                Row(
                  children: [
                    Container(
                       width: MediaQuery.of(context).size.width - 32,
                      child: Padding(padding: const EdgeInsets.only(bottom: 10),
                           child: TextFormField( //input type text
                           onTap: () async {
                            FocusScope.of(context).requestFocus(new FocusNode());
                             showDatePicker(
                          context: context,
                          initialDate: DateTime.now(),
                          firstDate: DateTime(2000),
                          lastDate: DateTime(2025))
                          .then((value) {
                          setState(() {
                            date = value!;
                            txtDate.text = dateFormat.format(date!);
                            var currentFocus = FocusScope.of(context); //context là state của widget
                            if(!currentFocus.hasPrimaryFocus){ // đóng keyboard
                              currentFocus.unfocus();
      }
                          });
                        });},

                            validator: requiredDate,
                            autovalidateMode: AutovalidateMode.onUserInteraction,
                            controller: txtDate,
                            keyboardType: TextInputType.text, //type text
                            decoration: const InputDecoration(
                              // hintText: "Date", //placeholder
                              
                              label: (Text("Date")),
                              prefixIcon: Icon(Icons.date_range,
                              color: ColorsProject.tSecondaryColor),
                              hintStyle: TextStyle(color: Colors.teal),
                              labelStyle: TextStyle(color: ColorsProject.tSecondaryColor),
                              focusedBorder: OutlineInputBorder(
                                borderSide: BorderSide(color: ColorsProject.tSecondaryColor, width: 2.0), //border khi focus
                              ),
                            ),
                      ),
                      ),
                    ),
                  ],
                ),
                  
                    

                const SizedBox(height: 10,),
                Padding(padding: const EdgeInsets.only(bottom: 10),
                 child: TextFormField( //input type text
                  controller: txtComments,
                  keyboardType: TextInputType.text, //type text
                  decoration: const InputDecoration(
                    label: (Text("Comments")),
                    prefixIcon: Icon(Icons.notes,
                    color: ColorsProject.tSecondaryColor),
                    hintStyle: TextStyle(color: Colors.teal),
                    labelStyle: TextStyle(color: ColorsProject.tSecondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorsProject.tSecondaryColor, width: 2.0), //border khi focus
                    ),
                  ),
                ),
                ),

                const SizedBox(height: 10,),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                 child: ElevatedButton( //input type text
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>AlertDialog(
                      title: const Text('Are you sure add/edit this expense?'),
                      content: const Text('This action cannot be undone'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => {
                            if (_formKey.currentState!.validate()) {
                              saveExpense(),
                            } else {
                              Navigator.pop(context, 'OK'),}
                            
                            },
                          child: const Text('OK'),
                        ),
                      ],
                    ),), // click nut này để chạy method saveTrip
                  child: Text('Save', // nội dung trong nút đó
                    style: TextStyle(
                      fontSize: fontSize,
                    ),)
                  ),
                ),
              ],
            ),
          ),
        ),
  

      ));
  }

  List<Widget> get buildMenus { //return 1 property: getter - đây là 1 getter, đầu ra 1 list các widget vì flutter mọi nút, icons là widget
    var d = <Widget>[];
    print("ĐÙ" + widget.theExpense!.id.toString());
    print(Constants.newExpenseId);
    
    if((widget.theExpense!.id) != int.parse(Constants.newExpenseId) ) { //nếu id của trip đang được truyền vào là null thì không hiển thị nút delete
      d.add(IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>AlertDialog(
                      title: const Text('Are you sure delete this expense?'),
                      content: const Text('This action cannot be undone'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: deleteExpense,
                          child: const Text('OK'),
                        ),
                      ],
                    ),), 

      ));
      d.add(const Padding(padding: EdgeInsets.symmetric(horizontal: 5)));
    }
    return d;

  }
  
  void saveExpense() async {
    if (_formKey.currentState!.validate()) { // currentState đã validate chưa
      // thay đổi UI phải dùng đến method đặc biệt này

      var aExpense = ExpenseEntity.newExpense(txtType.text, int.parse(txtAmount.text), txtDate.text, txtComments.text, widget.theTrip!.id);

      var eId = widget.theExpense!.id;
      if(eId == int.parse(Constants.newExpenseId) ) {
        // add an new expense
        try {
          await DBProvider2.db.newExpense(aExpense);
          // Navigator.push(context,
          //     MaterialPageRoute(
          //       builder: (context) => MyExpenses(theTrip: widget.theTrip!),
          //     ));
          goToRoute(RouteNames.Expenses, "New expense added: " + aExpense.toString());

          
        } catch (e) {
          print("Error: " + e.toString());
        }
        
      } else {
        // update an existing trip
        try {
          await DBProvider2.db.updateExpense(widget.theExpense!, aExpense). then((value) => {
            goToRoute(RouteNames.Expenses, "Expense updated: " + aExpense.toString())
          });
          
          // .then((value) => goToRoute(RouteNames.Expenses, "Expense updated: " + widget.theExpense!.toString()));
        } catch (e) {
          print("Error: " + e.toString());
        
      }
      }
      setState(() { // chạy 1 lambda function - ko tên, ko tham số chạy chức năng bên trong này
      // đóng bàn phím xuống khi click nút save
      // close keyboard
      var currentFocus = FocusScope.of(context); //context là state của widget
      if(!currentFocus.hasPrimaryFocus){ // đóng keyboard
        currentFocus.unfocus();
      }
      });
    }
  }


  @override
  void dispose() { // khi back lại screen khác thì xóa dữ liệu trong textfield, giảm bộ nhớ ram
    // TODO: implement dispose
    txtType.dispose();
    txtAmount.dispose();
    txtDate.dispose();
    txtComments.dispose();
    super.dispose();
  }
  

  String? requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? requiredDate(String? value) {
    if(txtDate.text == null ||txtDate.text.isEmpty) {
        return 'Please enter start date';
      } else {
           List<String> dateSplit = txtDate.text.split("/");
           List<String> startDateSplit = widget.theTrip!.startDate.split("/");
           List<String> endDateSplit = widget.theTrip!.endDate.split("/");
           //The expense date must be within the duration of the trip
           
            if(int.parse(dateSplit[2]) < int.parse(startDateSplit[2]) || int.parse(dateSplit[2]) > int.parse(endDateSplit[2])) {
              return 'The expense date must be within the duration of the trip (' + widget.theTrip!.startDate + ' - ' + widget.theTrip!.endDate + ')';
            } else if(int.parse(dateSplit[1]) < int.parse(startDateSplit[1]) || int.parse(dateSplit[1]) > int.parse(endDateSplit[1])) {
              return 'The expense date must be within the duration of the trip (' + widget.theTrip!.startDate + ' - ' + widget.theTrip!.endDate + ')';
            } else if(int.parse(dateSplit[0]) < int.parse(startDateSplit[0])|| int.parse(dateSplit[0]) > int.parse(endDateSplit[0])) {
              return 'The expense date must be within the duration of the trip (' + widget.theTrip!.startDate + ' - ' + widget.theTrip!.endDate + ')';
            }
    }
    
    return null;
  }

  void deleteExpense () async {

    try {
      await DBProvider2.db.deleteExpense(widget.theExpense!.id);
      print("Expense deleted: " + widget.theExpense!.toString());
      Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => MyExpenses(theTrip: widget.theTrip!),
              ));
    } catch (e) {
      print("Error: " + e.toString());
      
    }
  }
  
  void goToRoute(String routeName, [String msg = ""]) {
        if(msg != "") {
          print(msg);
        }

        Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => MyExpenses(theTrip: widget.theTrip!),
              ));
      }
}