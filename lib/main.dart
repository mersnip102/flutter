// ignore_for_file: prefer_const_constructors, equal_keys_in_map
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:m_expense_app/M_Expense_App/Expense/my_expenses.dart';
import 'package:m_expense_app/M_Expense_App/Expense/new_expense.dart';
import 'package:m_expense_app/M_Expense_App/Trip/map_location_screen.dart';
import 'package:m_expense_app/M_Expense_App/Trip/my_trips.dart';
import 'package:m_expense_app/M_Expense_App/route_names.dart';
import 'package:m_expense_app/M_Expense_App/welcome.dart';
import 'package:m_expense_app/models/Expense%20Model/expense_entity.dart';
import 'package:m_expense_app/models/Trip%20Model/trip_entity.dart';

import 'M_Expense_App/Trip/new_trip.dart';
void main() {
  WidgetsFlutterBinding.ensureInitialized();

  runApp(const M_Expense_App()); // một class là 1 widget
  
}


//widget
class M_Expense_App extends StatelessWidget {
  // constructor đầu vào là key, dấu nhọn {} là array, gọi constructor của bố. mỗi widget có 1 key để xác định id
  const M_Expense_App({Key? key}) : super(key: key);
  
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      routes: {
        RouteNames.Welcome: (context) => const Welcome(),
        // RouteNames.NewTrip: (context) => const NewBook(),
        RouteNames.NewTrip: (context) => NewTrip(theTrip: TripEntity.empty()), // NewTrip
        RouteNames.Trips: (context) => MyTrips(),
        RouteNames.Expenses: (context) => MyExpenses(),
        RouteNames.NewExpense: (context) => NewExpense(),
        RouteNames.MapLocationScreen: (context) => MapLocationScreen(),
      },
      initialRoute: RouteNames.Trips,
      //home: Welcome()
      );
  }

  
}