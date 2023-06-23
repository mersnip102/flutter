import 'package:flutter/material.dart';

import 'route_names.dart';


//future lấy dữ liệu từ database cso 2 trạng thái chưa hoàn thành và hoàn thành ( đây trạng thái của future trước khi trả về kết quả - chưa hoàn thành, một kết quả hoặc lỗi)


class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp( // bỏ chữ new
      //tham số home, class scaffold là một class cho phép có đc appbar, và có drawer: ấn có khay trượt 2 bên
      home: Scaffold(
        //Scaffold có thêm một nút fab
        floatingActionButton: FloatingActionButton(
          onPressed: () { //click event

            //là 1 lambda thực hiện chuyển screen
            Navigator.pushNamed(context, RouteNames.NewTrip);

          },
          backgroundColor: Colors.blue,
          child: const Icon(Icons.add),
        ),
        // 1 scaffold phải có 1 appBar: NavBar và một body
        appBar: AppBar(
          title: const Text("TCH2101 M_Expense_App") //const - title dính chặt vào text - ko thay đổi,
        ),
        // có thể bọc body trong Container - là là như 1 thẻ <div> - dùng để căn chỉnh
        body: Container(
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage("assets/imageBackground.jpg"),
              fit: BoxFit.cover)),
          child: Center( // wrap container với center
            child: Container(
              // text trở thành con của container, có thêm tô, vẽ, căn chỉnh, padding
              padding: const EdgeInsets.all(24), // căn 4 cạnh
              decoration: BoxDecoration(
                borderRadius: const BorderRadius.all(Radius.circular(20)),
                color: Colors.blue.shade100.withOpacity(0.8)
              ),
              child: const Text(
                'Sleeping is good\nReading book is better',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 22),
              ),
            ),
          ),
        ),
      )
    ); 
  }
}

//stateless ko có dữ liệu
// stateful có dữ liệu