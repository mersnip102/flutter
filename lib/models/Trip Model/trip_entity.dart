import 'dart:convert';
import 'dart:core';

class TripConstans {
  static const String emptyString = "";
  static const String newTripId = "0";
  // static const String fsTripSet = "triípet";
}

class TripEntity {
  int id = int.parse(TripConstans.newTripId);
  String name = TripConstans.emptyString;
  String destination = TripConstans.emptyString;
  String startDate = TripConstans.emptyString;
  String endDate = TripConstans.emptyString;
  String risk = TripConstans.emptyString;
  String description = TripConstans.emptyString;
  String vehicle = TripConstans.emptyString;
  String contribute = TripConstans.emptyString;

  String location = TripConstans.emptyString;
  String image = TripConstans.emptyString;


  TripEntity(this.id, this.name, this.destination, this.startDate, this.endDate, this.risk, this.description, this.vehicle, this.contribute, this.location, this.image);
  TripEntity.newTrip(String name, String destination, String startDate, String endDate, String risk, String description, String vehicle, String contribute, String location, String image)
      : this(int.parse(TripConstans.newTripId), name, destination, startDate, endDate, risk, description, vehicle, contribute, location, image);

  TripEntity.empty(); // là một constructor không có tham số đầu vào và không có thân hàm (body) nên nó sẽ không làm gì cả
  // khi được gọi đến (không có hành động nào được thực hiện) và sẽ trả về một đối tượng rỗng với giá trị đã khai báo ở trên.


static TripEntity tripFromJson(String str) {
  final jsonData = json.decode(str);
  return TripEntity.fromMap(jsonData);
}

String tripToJson(TripEntity data) {
  final dyn = data.toMap();
  return json.encode(dyn);
}

  //dynamic là chưa biết là kiểu dữ liệu là gì để dynamic
  factory TripEntity.fromMap(Map<String, dynamic> map) {
    return TripEntity(map['id'], map['name'], map['destination'], map['startDate'], map['endDate'],
    map['risk'], map['description'], map['vehicle'], map['contribute'], map['location'], map['image']);
  }

  Map<String, dynamic> toMap() {
    // return 1 map {}
    return <String, dynamic>{
      'name': name,
      'destination': destination,
      'startDate': startDate,
      'endDate': endDate,
      'risk': risk,
      'description': description,
      'vehicle': vehicle,
      'contribute': contribute,
      'location': location,
      'image': image,
    };
  }

}