// ignore_for_file: unused_local_variable, use_build_context_synchronously, avoid_print, unrelated_type_equality_checks
import 'dart:convert';
import 'dart:io';
import 'package:image_picker/image_picker.dart';


import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:m_expense_app/ColorsProject.dart';
import 'package:m_expense_app/M_Expense_App/Trip/map_location_screen.dart';
import 'package:m_expense_app/M_Expense_App/route_names.dart';
import 'package:m_expense_app/models/Trip%20Model/trip_entity.dart';
import 'package:m_expense_app/utils/Database.dart';
import 'package:intl/intl.dart';

class ListItem {  
  int value;  
  String name;  
  
  ListItem(this.value, this.name);  
} 

  

class NewTrip extends StatefulWidget {
  // const NewTrip({Key? key}) : super(key: key);
  NewTrip({Key? key, this.theTrip}): super(key: key);

  TripEntity? theTrip;

  @override
  State<NewTrip> createState() => _NewTripState(); //State trạng thái = dữ liệu của new book là 1 cái lambda tạo ra 1 cái class new book state
}
// gọi function chỉ cần gọi tên ko cần ()
class _NewTripState extends State<NewTrip> {

  //result hiển thị kết quả nội dung để trong State của chúng ta
  // String result = "Details: ";
  final TextEditingController txtName = TextEditingController();
  final TextEditingController txtDestination = TextEditingController();
  final TextEditingController txtStartDate = TextEditingController();
  final TextEditingController txtEndDate = TextEditingController();
  final TextEditingController txtRisk = TextEditingController();
  final TextEditingController txtVehicle = TextEditingController();
  final TextEditingController txtDescription = TextEditingController();
  final TextEditingController txtContribute = TextEditingController();
  final TextEditingController txtLocation = TextEditingController();
  
  final _formKey = GlobalKey<FormState>(); // bắt buộc form state chứ ko phải newbookstate (chỉ là 1 ui) - form state rộng hơn
  // The controller for the text field
  final TextEditingController _controller = TextEditingController();


  DateTime? date;
  final dateFormat = DateFormat('dd/MM/yyyy');
  

  List<ListItem> _dropdownItems = [ 
    ListItem(1, "No payment"),  
    ListItem(2, "Pay a small"),  
    ListItem(3, "Pay half"),  
    ListItem(4, "Pay a large"), 
    ListItem(5, "Pay in full")  
  ];  
  
  late List<DropdownMenuItem<ListItem>> _dropdownMenuItems;  
  late ListItem _itemSelected;
  late String valueChoose;

  var currentLocation = "";

  File? image;
  final imagePicker = ImagePicker();
  String imageString = '';
  Future getImage() async {
    final pickedFile = await ImagePicker().getImage(source: ImageSource.camera);
    final bytes = File(pickedFile!.path).readAsBytesSync();
    final image_now = base64Encode(bytes);

    setState(() {
      if (pickedFile != null) {
        image = File(pickedFile.path); // gắn path của pickedFile vào image
        imageString = image_now;
      } else {
        print('No image selected.');
      }
    });
  }
  

  bool isSwitched = false;
  
  var switchValue = 'Switch is OFF';  
  
  void toggleSwitch(bool value) {  
  
    if(isSwitched == false)  
    {  
      setState(() {  
        isSwitched = true;    
      });  
      print('Switch Button is ON');  
    }  
    else  
    {  
      setState(() {  
        isSwitched = false;  
      });  
      print('Switch Button is OFF');  
    }  
  }  



  Future<Position> _getCurrentLocation() async {
    print('Current Location là' );
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();

    if(!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if(permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if(permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if(permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied, we cannot request permissions.');
    }

    Position position = await Geolocator.getCurrentPosition();

    currentLocation = "Latitude: " + position.latitude.toString() + ", Longitude: " + position.longitude.toString();
    
    return position;
     
  }

  @override
  void initState() { //initState là 1 function của State để khởi tạo dữ liệu ban đầu cho State (khởi tạo dữ liệu ban đầu cho new book state)
    // TODO: implement initState
    // Stae<NewTrip> là của class NewTrip nên widget là lấy về cái class NewTrip
    //??= nghĩa là nếu null thì gán giá trị mới vào còn ko thì giữ nguyên giá trị cũ

     _dropdownMenuItems = buildDropDownMenuItems(_dropdownItems);
     if(widget.theTrip!.contribute != "" && widget.theTrip!.contribute != null) {

        _itemSelected = _dropdownMenuItems.firstWhere((element) => element.value?.name == widget.theTrip!.contribute).value!; //firstWhere là tìm phần tử đầu tiên thỏa mãn điều kiện
        //firstWhere là tìm phần tử đầu tiên thỏa mãn điều kiện
        //value là giá trị của phần tử đó
        //name là tên của phần tử đó
        // ? để tránh lỗi null safety (nếu có thì lấy giá trị đó) 
        //widget.theBook!.name là tên của sách đang được chọn
        //element.value.name là tên của sách trong list
        //nếu tên sách trong list trùng với tên sách đang được chọn thì trả về phần tử đó
        //value là giá trị của phần tử đó
        //vì value là 1 cái ListItem nên ta phải gọi value.name để lấy ra tên của sách đó
      } else {
        _itemSelected = _dropdownMenuItems[0].value!;
      }
    
    isSwitched = false;
    if(widget.theTrip!.risk == "false" || widget.theTrip!.risk == "") {
    isSwitched = false;}
    else {
      isSwitched = true;
    }


    widget.theTrip ??= TripEntity.empty();
    
    txtName.text = widget.theTrip! // ! là bắt buộc có giá trị
        .name; // gán giá trị cho txtName.text = widget.theTrip.name
    txtDestination.text = widget.theTrip!.destination;
    txtStartDate.text = widget.theTrip!.startDate;
    print(widget.theTrip!.startDate);
    txtEndDate.text = widget.theTrip!.endDate;
    txtRisk.text = widget.theTrip!.risk;
    txtDescription.text = widget.theTrip!.description;
    txtVehicle.text = widget.theTrip!.vehicle;
    txtContribute.text = widget.theTrip!.contribute;
    txtLocation.text = widget.theTrip!.location;

    imageString = widget.theTrip!.image;


    
    super.initState(); // gọi hàm initstate của cha
  }

  // This function is triggered when the clear buttion is pressed
  void _clearTextField() {
    // Clear everything in the text field
    _controller.clear();
    // Call setState to update the UI
    setState(() {});
  }

    List<DropdownMenuItem<ListItem>> buildDropDownMenuItems(List listItems) {  
    List<DropdownMenuItem<ListItem>> items = [];  
    for (ListItem listItem in listItems) {  
      items.add(  
        DropdownMenuItem(  
          child: Text(listItem.name),  
          value: listItem,  
        ),  
      );  
    }  
    return items;  
  }  


  @override
  Widget build(BuildContext context) {

    double fontSize = 18;
    // vì nó không phải là một cái app nên chỉ cần return scaffold - 1 stateful widget
    return Scaffold(
     appBar: AppBar(
      // if trip = null => add trip else edit trip
      title: Text(widget.theTrip!.id == int.parse(TripConstans.newTripId) ? "Add Trip" : "Edit Trip"), //App bar là 1 widget hiển thị text trên đầu và các nút điều hướng
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
                  controller: txtName,
                  keyboardType: TextInputType.name, //type text
                  decoration: const InputDecoration(
                    label: (Text("Name of trip")),
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
                  controller: txtDestination,
                  keyboardType: TextInputType.text, //type text
                  decoration: const InputDecoration(
                    label: (Text("Destination of trip")),
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
                
                
                const SizedBox(height: 10),
                Row(
                  children: [
                    Container(
                      width: MediaQuery.of(context).size.width - 32,
                      child: Padding(padding: const EdgeInsets.only(bottom: 10),
                           child: TextFormField( //input type text,
                           //close keyboard when click on other textfield
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
                            txtStartDate.text = dateFormat.format(date!);
                            var currentFocus = FocusScope.of(context); //context là state của widget
                            if(!currentFocus.hasPrimaryFocus){ // đóng keyboard
                              currentFocus.unfocus();
      }
                          });
                        });
                            },
                  
                  validator: requiredDate,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: txtStartDate,
                  keyboardType: TextInputType.text, //type text
                  decoration: const InputDecoration(
                    // hintText: "Date", //placeholder
                    label: (Text("Start Date")),
                    prefixIcon: Icon(Icons.date_range,
                    color: ColorsProject.tSecondaryColor),
                    hintStyle: TextStyle(color: Colors.teal),
                    labelStyle: TextStyle(color: ColorsProject.tSecondaryColor),
                    focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: ColorsProject.tSecondaryColor, width: 2.0), //border khi focus //border khi focus
                              ),
                            ),
                      ),
                      ),
                    ),
                  ],
                ),


                const SizedBox(height: 10),
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
                            txtEndDate.text = dateFormat.format(date!);
                            var currentFocus = FocusScope.of(context); //context là state của widget
                            if(!currentFocus.hasPrimaryFocus){ // đóng keyboard
                              currentFocus.unfocus();
      }
                          });
                        });
                           },
                  
                  validator: requiredDate,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: txtEndDate,
                  keyboardType: TextInputType.text, //type text
                  decoration: const InputDecoration(
                    label: (Text("End Date")),
                    
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
                Row(
                  children: [
                    Container(
                      width: 170,
                      
                      child: Padding(padding: const EdgeInsets.only(bottom: 10),
                           child: TextFormField(
                              
                              style: TextStyle(fontSize: 14),
                              
                              enabled: false,
                              controller: txtLocation,
                              keyboardType: TextInputType.text, //type text
                              decoration: const InputDecoration(
                                
                                // hintText: "Date", //placeholder
                                label: (Text("Location")),
                                hintStyle: TextStyle(color: Colors.teal),
                                labelStyle: TextStyle(color: ColorsProject.tSecondaryColor),
                                
                                        ),

                            ),
                      ),
                      ),
                    Container(
                      width: 190,
                      child: ElevatedButton.icon(onPressed: () async {
                        if(txtLocation.text == "") {
                          Position position = await _getCurrentLocation();
                          setState(() {
                          txtLocation.text = position.latitude.toString() + "," + position.longitude.toString();
                        });

                        } else {
                          showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Alert"),
                                content: Text("Do you want to change location?"),
                                actions: [
                                  TextButton(onPressed: () {
                                    Navigator.of(context).pop();
                                  }, child: Text("Cancel")),
                                  TextButton(onPressed: () async {
                                    Navigator.of(context).pop();
                                    Position position = await _getCurrentLocation();
                                    setState(() {
                                      txtLocation.text = position.latitude.toString() + "," + position.longitude.toString();
                                    });
                                  }, child: Text("OK")),
                                ],
                              );
                            }
                          );
                        }
                        
                        
                        
                      },
                       icon: Icon(Icons.location_on),
                       label: Text("Get Current Location"),
                        ),
                    ),
                  ],
                ),
                
                  const SizedBox(height: 10,),
                Padding(padding: const EdgeInsets.only(bottom: 10),
                 child: ElevatedButton.icon( //input type text
                 icon: Icon(Icons.map),
                  style: ElevatedButton.styleFrom(
                    
                    primary: Colors.green,
                    
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                  ),
                 onPressed: () async {
                  if(txtLocation.text == ""){
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text("Please get current location"))); // ScaffoldMessenger.of(context).showSnackBar để hiện thông báo lên màn hình khi click vào button
                  }else{

                    Navigator.push(context,
                    MaterialPageRoute( 
                    builder: (context) => MapLocationScreen(currentLocation: txtLocation.text,),
                    ),
              );
                  } 
                   
              },  label: Text("View Map"),
                
              
  ),
                ),



                  const SizedBox(height: 10,),
                Row(
                  children: [
                    Container(
                      
                      width: 44,
                      child: Text("Image: "),
                      ),
                    
                    (imageString != null && imageString != "") ?
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 145,
                      child: image != null ? Image.file(image!, width: 120, height: 120, fit: BoxFit.cover,) : Image.memory(base64Decode(widget.theTrip!.image), width: 120, height: 120, fit: BoxFit.cover,),
                      // Image.file( image!, width: 120, height: 120, fit: BoxFit.cover,),
                      ) :
                    Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 145,
                      child: Icon(Icons.image, color: Colors.green,
                      size: 120,)),
                     Container(
                      margin: const EdgeInsets.only(left: 10),
                      width: 150,
                      child: ElevatedButton.icon(onPressed: () async {
                        
                        getImage();
                        
                      },
                       icon: Icon(Icons.image),
                       label:  Text("Take a photo"),
                       ),

                     ),
                        
                        
                      
                       ],
                    ),

                 Row(
                  children: [
                    Container(
                      width: 50,
                      margin: const EdgeInsets.only(left: 13),
                      child: Padding(padding: const EdgeInsets.only(bottom: 10),
                           child: Text("Risk: ", style: TextStyle(fontSize: 17),)
                      ),
                    ),
                    Container(
                      width: 50,
                      child: Padding(
                        padding: const EdgeInsets.only(bottom: 10.0),
                        child: Switch(  
                        onChanged: toggleSwitch,  
                        value: isSwitched,  
                        activeColor: Colors.blue,  
                        activeTrackColor: Colors.blue,  
                        inactiveThumbColor: Colors.red,  
                        inactiveTrackColor: Colors.grey,  
                    ),
                      ),
                    ),
                  ],
                ),

                 const SizedBox(height: 10,),
                Padding(padding: const EdgeInsets.only(bottom: 10),
                 child: TextFormField( //input type text
                  validator: requiredField,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: txtDescription,
                  keyboardType: TextInputType.text, //type text
                  decoration: const InputDecoration(
                    label: (Text("description")),
                    prefixIcon: Icon(Icons.description,
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
                Padding(padding: const EdgeInsets.only(bottom: 10),
                 child: TextFormField( //input type text
                  validator: requiredField,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  controller: txtVehicle,
                  keyboardType: TextInputType.text, //type text
                  decoration: const InputDecoration(
                    label: (Text("Vehicle")),
                    prefixIcon: Icon(Icons.directions_car,
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
                Padding(padding: const EdgeInsets.only(bottom: 10),
                 child: Container(  
                    padding: const EdgeInsets.all(10.0),  
                    
                    decoration: BoxDecoration(  
                        color: Colors.white,  
                        border: Border.all()),
                
                    child: Row(
                      // border none
                      
                      children: [
                      Icon(Icons.attach_money, color: ColorsProject.tSecondaryColor),
                      Text("Contribute: ", style: TextStyle(fontSize: 17),),
                      
                      SizedBox(width: 10, height: 10,),
                      Expanded( //expand để cho dropdown button chiếm toàn bộ chiều ngang
                        child: Container(
                          padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        
                        decoration: BoxDecoration(
                          border: Border.all(color: Colors.grey, width: 1),
                          borderRadius: BorderRadius.circular(10.0),),
                          child: DropdownButton(
                            
                            isExpanded: true,
                            hint: Text("Select Contribute"),
                            value: _itemSelected,
                            onChanged: (newValue) {
                              setState(() {
                                _itemSelected = newValue!;
                              });
                            },
                            items: _dropdownItems.map((contribute) {
                              return DropdownMenuItem(
                                
                                child: Text(contribute.name),
                                value: contribute,
                              );
                            }).toList(),
                          ),
                        ),
                      ),
                    ],
                    ),

                  //   child: DropdownButtonHideUnderline(  
                  //     child: Container(
                  //       padding: const EdgeInsets.only(left: 16.0, right: 16.0),
                        
                  //       decoration: BoxDecoration(
                  //         border: Border.all(color: Colors.grey, width: 1),
                  //         borderRadius: BorderRadius.circular(10.0),
                  //       ),
                  //       child: DropdownButton(
                  //         hint: Text('Select Contribute'),
                  //         dropdownColor: Colors.white,
                  //         underline: SizedBox(),
                  //         iconSize: 36.0,
                  //         isExpanded: true,
                  //         value: _itemSelected,
                  //         items: _dropdownMenuItems,  
                  //         onChanged: (value) {  
                  //           setState(() {  
                  //               _itemSelected = value!;  
                  //             });  
                  //           }),
                  //     ),  
                  //   ),  
                  ), 
                ),


                const SizedBox(height: 10,),
                Padding(padding: const EdgeInsets.symmetric(vertical: 10),
                 child: ElevatedButton( //input type text
                  onPressed: () => showDialog<String>(
                    context: context,
                    builder: (BuildContext context) =>AlertDialog(
                      title: const Text('Are you sure add/edit this trip?'),
                      content: const Text('This action cannot be undone'),
                      actions: <Widget>[
                        TextButton(
                          onPressed: () => Navigator.pop(context, 'Cancel'),
                          child: const Text('Cancel'),
                        ),
                        TextButton(
                          onPressed: () => {
                            if (_formKey.currentState!.validate()) {
                              saveTrip(),
                            } else {
                              Navigator.pop(context, 'OK'),}
                            
                            },
                          child: const Text('OK'),
                        ),
                      ],
                    ),), // c // click nut này để chạy method saveTrip
                  child: Text('Save', // nội dung trong nút đó
                    style: TextStyle(
                      fontSize: fontSize,
                    ),)
                  ),
                ),
                // Text(result,
                //   style: TextStyle(
                //     fontSize: fontSize,
                //   ),)
            
              ],
            ),
          ),
        ),
  

      ));
  }

  List<Widget> get buildMenus { //return 1 property: getter - đây là 1 getter, đầu ra 1 list các widget vì flutter mọi nút, icons là widget
    var d = <Widget>[];
    if(widget.theTrip!.id != int.parse(TripConstans.newTripId) ) { //nếu id của trip đang được truyền vào là null thì không hiển thị nút delete
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
  
  void saveTrip() async {
    if (_formKey.currentState!.validate()) { // currentState đã validate chưa
      // thay đổi UI phải dùng đến method đặc biệt này

      var aTrip = TripEntity.newTrip(txtName.text, txtDestination.text, txtStartDate.text, txtEndDate.text, isSwitched.toString(), txtDescription.text, txtVehicle.text, _itemSelected.name.toString(), txtLocation.text, imageString);

      var tId = widget.theTrip!.id;
      if(tId == int.parse(TripConstans.newTripId) ) {
        // add an new trip
        try {
          await DBProvider.db.newTrip(aTrip);
          goToRoute(RouteNames.Trips, "New trip added: " + aTrip.toString());
          
        } catch (e) {
          print("Error: " + e.toString());
        }
        
      } else {
        // update an existing trip
        try {
          await DBProvider.db.updateTrip(widget.theTrip!.id, aTrip)
          .then((value) => goToRoute(RouteNames.Trips, "Trip updated: " + widget.theTrip!.toString()));
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

      // then(_) là 1 method của Future, chạy sau khi Future hoàn thành chức năng của nó (ở đây là chạy sau khi DBProvider.db.newTrip(aTrip) hoàn thành)
      // _ có argument nhưng là tham số ko cần thiết (biết) vì id cũ của nó mình biết rồi

      // back to welcome screen
      // Navigator.pushNamed(context, RouteNames.Trips);
      //String interpolation:
        // result += "\n ${txtName.text} | ${txtDestination.text} | ${txtDate.text}"; // lấy dữ liệu từ textfield
        // txtName.clear(); // xóa dữ liệu trong textfield
        // txtDestination.clear();
        // txtDate.clear();
      
      });
    }
  }

  void goToRoute(String routeName, [String msg = ""]) {
        if(msg != "") {
          print(msg);
        }

        Navigator.pushNamed(context, routeName);
      }


  @override
  void dispose() { // khi back lại screen khác thì xóa dữ liệu trong textfield, giảm bộ nhớ ram
    // TODO: implement dispose
    txtName.dispose();
    txtDestination.dispose();
    txtStartDate.dispose();
    txtEndDate.dispose();
    txtRisk.dispose();
    txtVehicle.dispose();
    txtDescription.dispose();
    txtContribute.dispose();
    super.dispose();
  }
  

  String? requiredField(String? value) {
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    return null;
  }

  String? requiredDate(String? value) {
    if(txtStartDate.text == null || txtStartDate.text.isEmpty) {
        return 'Please enter start date';
      } else {
        if(txtEndDate.text == null || txtEndDate.text.isEmpty) {
          return 'Please enter end date';
        } else {
           List<String> startDateSplit = txtStartDate.text.split("/");
           List<String> endDateSplit = txtEndDate.text.split("/");

            if (int.parse(startDateSplit[2]) > int.parse(endDateSplit[2])) {
              return 'Start date must be before end date';

                } else if (int.parse(startDateSplit[1]) > int.parse(endDateSplit[1])) {
                  return 'Start date must be before end date';
                } else if (int.parse(startDateSplit[0]) > int.parse(endDateSplit[0])) {
                  return 'Start date must be before end date';
                }
        }
    }
    
    return null;
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
}

