//tính hiển thị của nó là static nên ko cần sateful widget vì nó ko lưu chữ cái gì cả

// ignore_for_file: prefer_const_constructors, avoid_print


import 'package:flutter/material.dart';
import 'package:m_expense_app/M_Expense_App/Expense/my_expenses.dart';
import 'package:m_expense_app/M_Expense_App/Trip/new_trip.dart';
import 'package:m_expense_app/M_Expense_App/route_names.dart';
import 'package:m_expense_app/models/Expense%20Model/expense_entity.dart';
import 'package:m_expense_app/models/Trip%20Model/trip_entity.dart';
import 'package:m_expense_app/utils/Database.dart';
import 'package:m_expense_app/utils/DatabaseExpense.dart';
import 'package:sqflite/sqflite.dart';


class MyTrips extends StatefulWidget {
  MyTrips({super.key});
  
  @override
  State<MyTrips> createState() => _MyTripsState();
}

class _MyTripsState extends State<MyTrips> {

  TextEditingController editingController = TextEditingController();

  List<TripEntity> searchTrips = [];

  List<TripEntity> trips = [];
  
  double totalMoney = 0;

  //set visiblity trips when we have data and invisible when we don't have data
  // bool isVisible = false;
  

  @override
  void initState()  { //initState là 1 function của State để khởi tạo dữ liệu ban đầu cho State (khởi tạo dữ liệu ban đầu cho new book state)

    allTrips();
    totalMoneyOfTrips();
   
      super.initState();
    }
  @override
  Widget build(BuildContext context) {
    //set visiblity trips when we have data and invisible when we don't have data
    // if(trips.length > 0){
    //   isVisible = true;
    // }else{
    //   isVisible = false;
    // } then use Visibility widget to display trips

    print("MyTrips build");
    return Scaffold(
      appBar: null,
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // add a new trip
          Navigator.pushNamed(context, RouteNames.NewTrip);
        },
        backgroundColor: Colors.blue,
        child: const Icon(Icons.add),
      ),
      body: Column( // trên 1 cột
        children: <Widget>[
          Stack( // stack cho phép chsung ta đặt các widget chồng lên nhau
            children: <Widget>[ //  là một danh sách các widget con của Stack.
              Container(
                height: MediaQuery.of(context).size.width, // chiều cao của container
                width: MediaQuery.of(context).size.width, // chiều rộng của container
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
                  tag: 'assets/back-groud2.jpg', // tag để xác định widget nào sẽ được chuyển đổi
                  child: ClipRRect( // là một widget giúp chúng ta cắt bớt các widget con bên trong nó, bo tròn
                    borderRadius: BorderRadius.circular(30.0), // bo góc
                    child: Image(
                        image: AssetImage('assets/back-groud2.jpg'),
                        //set max width and height = 100
                        fit: BoxFit.cover,
                        
                      ),
                    
                  ),
                ),
              ),
              Padding( // symmetrical padding - padding đối xứng, horizontal - padding ngang, vertical - padding dọc
                padding: const EdgeInsets.symmetric(horizontal: 10.0, vertical: 40.0), // padding cho 2 bên trái phải và trên dưới là 10 và 40
                  child: TextField(
                        onChanged: searchTrip,
                        
                        // onTap: () {
                        //   // FocusScope để xác định phạm vi của các widget có thể nhận được sự tập trung của người dùng.
                        //   FocusScope.of(context).requestFocus(new FocusNode()); // requestFocus để focus vào 1 widget nào đó 
                        // },
                        
                        autofocus: false,
                        maxLength: 100,
                        style: const TextStyle(fontSize: 18.0, color: Colors.red, fontWeight: FontWeight.bold),
                        controller: editingController,
                        decoration: InputDecoration(
                            labelText: "Search",
                            labelStyle: const TextStyle(color: Colors.white),
                            //set color of hintText
                            hintText: "Search",
                            hintStyle: const TextStyle(color: Colors.white),
                            // fillColor: Colors.red,
                            
                            prefixIcon: Icon(Icons.search, color: Colors.white),
                            enabledBorder: OutlineInputBorder(
                            borderSide: BorderSide(width: 3, color: Colors.red),),
                            border: OutlineInputBorder(
                                // borderSide: BorderSide(color: Colors.red),
                                borderRadius: BorderRadius.all(Radius.circular(25.0)), borderSide: BorderSide(color: Colors.red),
                                ),),
                      ),         
                
                ),
              

              Positioned(
                left: 20.0,
                bottom: 20.0,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start, // căn trái
                  children: <Widget>[
                    Text(
                      "Total Trip: ${trips.length}",
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
                       
                        SizedBox(width: 5.0), // khoảng cách giữa icon và text
                        Text(
                          "Total Money: $totalMoney",
                          style: TextStyle(
                            color: Colors.white,
                            fontSize: 20.0,
                          ),
                        ),
                         Icon(
                          // icon location arrow
                          Icons.monetization_on_rounded,
                          size: 20.0,
                          color: Colors.white,
                        ),
                         Container(
                          margin: EdgeInsets.only(left: 15.0),
                           child: Padding(padding: const EdgeInsets.symmetric(vertical: 0),
                            child: ElevatedButton( //input type text
                              style: ElevatedButton.styleFrom(
                                primary: Colors.red,
                                onPrimary: Colors.white,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10.0),
                                ),
                              ),
                            onPressed: () => showDialog(
                              context: context,
                              builder: (BuildContext context) =>AlertDialog(
                                title: const Text('Alert!'),
                                content: const Text('Do you want delete all database? This action cannot be undone'),
                                actions: <Widget>[
                                  TextButton(
                                    onPressed: () => Navigator.pop(context, 'Cancel'),
                                    child: const Text('Cancel'),
                                  ),
                                  TextButton(
                                    onPressed: () async {
                                      await deleteAll();
                                      Navigator.pop(context, 'Yes');
                                      setState(() {
                                        
                                      });
                                      },
                                    child: const Text('Yes'),
                                  ),
                                ],
                              ),), // c // click nut này để chạy method saveTrip
                            child: Text('Delete database', // nội dung trong nút đó
                              style: TextStyle(
                                fontSize: 16,
                              ),)
                            ),
                        ),
                         ),
                      ],
                    ),
              
                  ], // danh sách các widget con của Column
                ),
              ),

              // Positioned(
              //   right: 20.0,
              //   bottom: 20.0,
              //   child: Icon(
              //     Icons.location_on,
              //     color: Colors.white,
              //     size: 25.0,
              //   ),
              // ),
            ]
          ),
         
          
          trips.isEmpty == true? 
           
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
          
          FutureBuilder<List<TripEntity>> (
            
            future: searchTrip(editingController.text),
            builder: (BuildContext context, AsyncSnapshot<List<TripEntity>> snapshot) {
              if (snapshot.hasError) {
                
                return Text('Something went wrong! ${snapshot.error}');
              } else if(snapshot.hasData) {
                final trips = snapshot.data!;
                return buildListView(trips);
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

  
 
  
  Future<List<TripEntity>> allTrips() async {
   List<TripEntity> tripsTemp =  await DBProvider.db.getAllTrips();

   setState(() {
      trips = tripsTemp;
    });
    searchTrips = trips;
    return tripsTemp;
  }


  void totalMoneyOfTrips() async {

    
     List<ExpenseEntity> expenses = await DBProvider2.db.getAllExpensesFromDatabase();
     setState(() {
      for (var expense in expenses) {
      totalMoney += expense.amount;
  }
       
     });
    
    
  }
  
  Expanded buildListView(List<TripEntity> trips) {
    
    return Expanded( // EXPANDED cho phép widget con của nó chiếm toàn bộ không gian còn lại của widget cha
      child: ListView.builder(
        padding: EdgeInsets.only(top: 10.0, bottom: 15.0),
        shrinkWrap: true, // tự động co giãn
        itemCount: trips.length,
        itemBuilder: (BuildContext context, int index) {
        
          var trip = trips[index];
         
          return ListTile( // ListTile là một widget có sẵn trong Flutter, nó cho phép chúng ta hiển thị một danh sách các item dưới dạng một hàng
            onTap: () {
              print(trip.id);
              Navigator.push(context,
              MaterialPageRoute(
                builder: (context) => MyExpenses(theTrip: trip),
                
              ));
              }, // chuyển và đưa dữ liệu qua trang khác = push
            title: Stack( // Stack để đặt các widget lên nhanh chóng lên trên nhau và có thể chỉnh sửa vị trí của chúng bằng cách sử dụng các thuộc tính top, bottom, left, right và start, end. 
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
                            
                            child: Text("Name: "+ trip.name, style: TextStyle(
                              fontSize: 17.0,
                              fontWeight: FontWeight.w600
                              ),
                              overflow: TextOverflow.ellipsis, // nếu text quá dài thì sẽ hiển thị dấu ...
                              maxLines: 2,
                            ),
                          
                          ),
                          Column(
                            children: <Widget>[
                              Text(trip.vehicle, style: TextStyle(fontSize: 16.0, fontWeight: FontWeight.w600), overflow: TextOverflow.ellipsis, maxLines: 2,),
                              Text('Vehicle', style: TextStyle(color: Colors.grey), overflow: TextOverflow.ellipsis, maxLines: 2,),
                            ],
                          ),
                        ],
                      ),
                      Text(
                      "Destination: " + trip.destination,
                      style: TextStyle(
                        color: Colors.grey,
                        ),
                      ),
                      SizedBox(height: 10.0),
                      Row(
                        children: <Widget>[
                          Container(
                            padding: EdgeInsets.all(5.0),
                            width: 59.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              trip.startDate,
                            ),
                          ),
                          SizedBox(width : 10.0),
                          Container(
                            padding: EdgeInsets.all(5.0),
                            width: 59.0,
                            decoration: BoxDecoration(
                              color: Theme.of(context).accentColor,
                              borderRadius: BorderRadius.circular(10.0),
                            ),
                            alignment: Alignment.center,
                            child: Text(
                              trip.endDate,
                            ),
                          )
                        ],
                      )
                    ],
                  ),
                ),
              ),
              Positioned(
                left: 20.0,
                top: 15.0,
                bottom: 15.0,
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(20.0),
                  child: Image(
                    width: 110.0,
                    image: AssetImage('assets/businesstravel.jpg'),
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

  Future<List<TripEntity>> searchTrip(String query) async {
    searchTrips = await allTrips();
    final suggestions = searchTrips.where((trip) {
      final tripLower = trip.name.toLowerCase();
      final tripDes = trip.destination.toLowerCase();
      final tripStartDate = trip.startDate.toLowerCase();
      final tripEndDate = trip.endDate.toLowerCase();
      final queryLower = query.toLowerCase();

      return tripLower.contains(queryLower) || tripDes.contains(queryLower) || tripStartDate.contains(queryLower) || tripEndDate.contains(queryLower);
    }).toList();

      // this.searchTrips = suggestions;
    
    setState(() {
      this.searchTrips = suggestions;
    });

    return searchTrips;
  }
  
  deleteAll() async {
    try {
      await DBProvider.db.deleteAllTrip();
      await DBProvider2.db.deleteAllExpense();
    } catch (e) {
      print("Error: " + e.toString());
      
    }
  }
}


//buffer = 1 stream vì dữ liệu từ web về từng chút một có delay
// steambulder đi cùng với stream để lấy dữ liệu từ database
// nguồn steam: stream: láy từ method nào đó.