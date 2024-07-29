

class Campuses{
  final String id;
  final String name;
  final List<String> members;
  final int points;

  Campuses(
    {
      required this.id,
      required this.name,
      required this.members,
      required this.points
    }
  );

  

  factory Campuses.fromJson(Map<String, dynamic>json){
    return Campuses(
       id: json['_id'] != null ? json['_id'] as String : '',
    name: json['name'] != null ? json['name'] as String : '',
    members: (json['members'] != null && json['members'] is List)
        ? List<String>.from(json['members'] as List)
        : [],
    points: json['points'] != null ? json['points'] as int : 0,
    );
  }
  Map<String, dynamic> toJson(){
    return {
      '_id': id,
      'name': name,
      'members': members,
      'points': points,
    };
  }
}

class AllCampusesResponse {
  final int result;
  final int statusCode;
  final String msg;
  final List<Campuses> data;

  AllCampusesResponse({
    required this.result,
    required this.statusCode,
    required this.msg,
    required this.data,
  });

  factory AllCampusesResponse.fromJson(Map<String, dynamic> json) {
    return AllCampusesResponse(
      result: json['result'] as int,
      statusCode: json['statusCode'] as int,
      msg: json['msg'] as String,
      data: List<Campuses>.from(json['data'].map((x) => Campuses.fromJson(x as Map<String, dynamic>))),
    );
  }
}