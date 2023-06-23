// ignore_for_file: prefer_const_constructors, must_be_immutable, override_on_non_overriding_member
//tính hiển thị của nó là static nên ko cần sateful widget vì nó ko lưu chữ cái gì cả

// ignore_for_file: prefer_const_constructors, avoid_unnecessary_containers, unrelated_type_equality_checks, prefer_interpolation_to_compose_strings, avoid_print

import 'package:flutter/src/widgets/framework.dart';
import 'package:flutter/material.dart';
import 'package:m_expense_app/M_Expense_App/Expense/new_expense.dart';
import 'package:m_expense_app/M_Expense_App/Trip/new_trip.dart';
import 'package:m_expense_app/M_Expense_App/route_names.dart';
import 'package:m_expense_app/models/Expense%20Model/expense_entity.dart';
import 'package:m_expense_app/models/Trip%20Model/trip_entity.dart';
import 'package:m_expense_app/utils/Database.dart';
import 'package:m_expense_app/utils/DatabaseExpense.dart';


class MyExpenses extends StatefulWidget {
  MyExpenses({Key? key, this.theTrip}): super(key: key);
  TripEntity? theTrip;

  @override
  State<MyExpenses> createState() => _MyExpensesState();
}

class _MyExpensesState extends State<MyExpenses> {

  List<ExpenseEntity> expenses = [];
  
  double totalMoney = 0;


  @override
  void initState()  { //initState là 1 function của State để khởi tạo dữ liệu ban đầu cho State (khởi tạo dữ liệu ban đầu cho new book state)

    allExpenseTrip();
    totalMoneyOfTrip();
   
      super.initState();
    }




  @override
  Widget build(BuildContext context) {
    print("MyTrips build");
    return Scaffold(
      appBar: AppBar(
      leading: IconButton(
      icon: Icon(Icons.arrow_back),
      onPressed: () {
            Navigator.pushNamed(context, RouteNames.Trips);
      }),
      // if trip = null => add trip else edit trip
      title: Text(widget.theTrip!.id == TripConstans.newTripId ? "Add Trip" : "Edit Trip"), //App bar là 1 widget hiển thị text trên đầu và các nút điều hướng
      actions: buildMenus, //action trả ra 1 array = nút 3 chấm ở góc phải trên cùng của appbar - nút điều hướng, chứa tất cả các điều hướng
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add a new trip
          // Navigator.pushNamed(context, RouteNames.NewExpense, arguments: widget.theTrip);

          Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => NewExpense(theExpense: ExpenseEntity.empty(), theTrip: widget.theTrip!),
              ));
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Column( // trên 1 cột
        children: <Widget>[
          Stack( // stack cho phép chsung ta đặt các widget chồng lên nhau
            children: <Widget>[ //  là một danh sách các widget con của Stack.
              Container(
                height: 280, // chiều cao của container
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(30.0), 
                  // ignore: prefer_const_literals_to_create_immutables
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26, 
                      offset: Offset(0.0, 2.0), 
                      blurRadius: 6.0, 
                      ),// đổ bóng
                  ], 
                ),
                child: Hero( // Hero để chuyển đổi giữa các màn hình và có thể chuyển đổi giữa các widget khác nhau trên cùng một màn hình. 
                  tag: 'assets/bacground.jpg', // tag để xác định widget nào sẽ được chuyển đổi
                  child: ClipRRect( // là một widget giúp chúng ta cắt bớt các widget con bên trong nó, bo tròn
                    borderRadius: BorderRadius.circular(30.0), // bo góc
                    child: Image(
                        image: AssetImage('assets/background.jpg'),
                        fit: BoxFit.cover,
                      ),
                    
                  ),
                ),
              ),

              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // căn trái
                  children: <Widget>[
                    Text(
                      widget.theTrip!.name +  " (${expenses.length} expenses)",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 35.0,
                        fontWeight: FontWeight.w600,
                        letterSpacing: 1.2, // khoảng cách giữa các chữ
                      ),
                    ),

                    Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[
                        Icon(
                          // icon location arrow
                          Icons.location_searching,
                          size: 15.0,
                          color: Colors.white,
                        ),
                        SizedBox(width: 5.0), // khoảng cách giữa icon và text
                        Text(
                          widget.theTrip!.destination,
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                      ],
                    ),
              
                  ], // danh sách các widget con của Column
                ),
              ),

              Positioned(
                right: 20.0,
                bottom: 20.0,
                child:  Row(
                      // ignore: prefer_const_literals_to_create_immutables
                      children: <Widget>[ // widget con của Row là 1 danh sách các widget con khác nhau của Row 
                        
                        SizedBox(width: 5.0), // khoảng cách giữa icon và text
                        Text(
                          "Money: $totalMoney ",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 15.0,
                          ),
                        ),
                        Icon(
                          // icon location arrow
                          Icons.monetization_on_outlined,
                          size: 15.0,
                          color: Colors.white,
                        ),
                      ],
                    ),
              ),
            ]
          ),
          

              Positioned( // Positioned cho phép widget con của nó được đặt tại vị trí tương đối
                
                left: 30.0,
                top: 15.0,
                bottom: 10.0,
                child: Container(
                  margin: EdgeInsets.only(top: 10.0),
                  // height: 120.0,
                  // width: 100.0,
                  // decoration: BoxDecoration(
                  //   color: Colors.white,
                  //   borderRadius: BorderRadius.circular(10.0),
                  // ),
                  
                  child: Center(
                    child: Text(
                      widget.theTrip!.startDate + " =====> " + widget.theTrip!.endDate,
                      style: TextStyle(
                        color: Color(Colors.blue.value),
                        fontSize: 18.0,
                        fontWeight: FontWeight.w600,
                      ),

                    ),
                  ),
                ),
              ),
              Positioned( // Positioned cho phép widget con của nó được đặt tại vị trí tương đối
                left: 30.0,
                top: 15.0,
                bottom: 10.0,
                child: Container(
                  child: Center(
                    child: Text(
                      "List expenses of trip: ",
                      style: TextStyle(
                        color: Color(Colors.red.value),
                        fontSize: 19.0,
                        fontWeight: FontWeight.bold,
                      ),

                    ),
                  ),
                ),
              ),

               expenses.isEmpty == true? 
           
          Container(
            margin: EdgeInsets.only(top: 110),
            child: Column(
              children: [
                 Image(
                          image: AssetImage('assets/no-data.png'),
                          //code to set width  =10 and height = 10
                          width: 100,
                          height: 100,

                        ),
                Text("No data found", //set style for text
                    style: TextStyle(
                        fontSize: 20,
                        color: Colors.black,
                        fontWeight: FontWeight.bold)),
              ],
            ), ) :

          FutureBuilder<List<ExpenseEntity>> (
            future: allExpenseTrip(),
            builder: (BuildContext context, AsyncSnapshot<List<ExpenseEntity>> snapshot) {
              if (snapshot.hasError) {
                return Text('Something went wrong! ${snapshot.error}');
              } else if(snapshot.hasData) {
                final expenses = snapshot.data!;
                print("expenses: $expenses");
                return buildListView(expenses);
              }
              else {
                return const Center(child: CircularProgressIndicator());
              }
            },
          ),
        ],
      ),
    );
  }

  Future<List<ExpenseEntity>> allExpenseTrip() async {
    List<ExpenseEntity> expensesTemp = await DBProvider2.db.getAllExpenses(widget.theTrip!.id);

    setState(() {
      expenses = expensesTemp;
    });
    return expenses;

    
  }

  void totalMoneyOfTrip() async {
    
     List<ExpenseEntity> expensesTemp = await DBProvider2.db.getAllExpenses(widget.theTrip!.id);
     setState(() {
      for (var expense in expenses) {
      totalMoney += expense.amount;
  }
       
     });
    
    
  }

  Expanded buildListView(List<ExpenseEntity> expenses) {
    
    return Expanded( // EXPANDED cho phép widget con của nó chiếm toàn bộ không gian còn lại của widget cha
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
        shrinkWrap: true, // tự động co giãn
        itemCount: expenses.length,
        itemBuilder: (BuildContext context, int index) {
        
          var expense = expenses[index];
         
          return ListTile(
            onTap: () {
              print(expense.id);
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => NewExpense(theTrip: widget.theTrip!, theExpense: expenses[index]),
                
              ));
              
              }, // chuyển và đưa dữ liệu qua trang khác = push
            title: Stack(
              children: <Widget>[
                Container(margin: EdgeInsets.fromLTRB(40.0, 5.0, 20.0, 5.0), // fromLTRB là khoảng cách
                // của các widget từ trái sang phải, từ trên xuống dưới
                height:  170.0,
                width: double.infinity,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(20.0),
                ),
                child: Padding(
                  padding: EdgeInsets.fromLTRB(100.0, 20.0, 20.0, 20.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center, // căn giữa theo chiều dọc của widget con của Column
                    crossAxisAlignment: CrossAxisAlignment.start, // căn trái theo chiều ngang của widget con của Column
                    children: <Widget>[
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: <Widget>[
                          Container(
                            
                            child: Text(expense.type, style: TextStyle(
                              fontSize: 18.0,
                              fontWeight: FontWeight.w600
                              ),
                              overflow: TextOverflow.ellipsis, // nếu text quá dài thì sẽ hiển thị dấu ...
                              maxLines: 2,
                            ),
                          
                          ),
                          Column(
                            children: <Widget>[
                              Text('\$${expense.amount}', style: TextStyle(fontSize: 22.0, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 2,),
                              Text('Amount', style: TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis, maxLines: 2,),
                            ],
                          ),
                        ],
                      ),
                      // Text(
                      // trip.destination,
                      // style: TextStyle(
                      //   color: Colors.grey,
                      //   ),
                      // ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5.0),
                            width: 110.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              expense.date,
                            ),
                          ),
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned( // Positioned cho phép widget con của nó được đặt tại vị trí tương đối
                left: 20.0,
                top: 15.0,
                bottom: 15.0,
                child: ClipRRect( //ClipRRect là widget giới hạn vùng hiển thị của widget con.
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image(
                    width: 110.0,
                    image: AssetImage('assets/Time-Expense-Tracking-.png'),
                    fit: BoxFit.cover,
                  ),
                  ),
              ),
              ],
            ),
          );
        },
      ),
    );
  }

  List<Widget> get buildMenus {
  var d = <Widget>[];
    if(widget.theTrip!.id != TripConstans.newTripId) { //nếu id của trip đang được truyền vào là null thì không hiển thị nút delete
      d.add(IconButton(onPressed: editTrip, icon: Icon(Icons.edit)));
      d.add(IconButton(
        icon: const Icon(Icons.delete),
        onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>AlertDialog(
                      title: const Text('Are you sure delete this trip?'),
                      content: const Text('This action cannot be undone'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: deleteTrip,
                          child: const Text('OK'),
                        ),
                      ],
                    ),), // c


      ));
      
      d.add(const Padding(padding: EdgeInsets.symmetric(horizontal: 5)));
    }
    return d;
  }

 void goToRoute(String routeName, [String msg = ""]) {
        if(msg != "") {
          print(msg);
        }

        Navigator.pushNamed(context, routeName);
      }

  void deleteTrip () async {
    
    try {
      await DBProvider.db.deleteTrip(widget.theTrip!.id);
      print("Trip deleted: " + widget.theTrip!.toString());
      goToRoute(RouteNames.Trips, "Trip deleted: " + widget.theTrip!.toString());
    } catch (e) {
      print("Error: " + e.toString());
      
    }
  }

  void editTrip() async {
    try {
      print(widget.theTrip!.id);
      await  Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => NewTrip(theTrip: widget.theTrip),
              ));
    } catch (e) {
      print("Error: " + e.toString());
      
    }
}
}

//buffer = 1 stream vì dữ liệu từ web về từng chút một có delay
// steambulder đi cùng với stream để lấy dữ liệu từ database
// nguồn steam: stream: láy từ method nào đó