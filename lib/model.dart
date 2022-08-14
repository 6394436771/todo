class Date {
  String? time;
  String? title;
  String? year;

  Date({this.time, this.title, this.year});

  Date.fromJson(Map<String, dynamic> json) {
    time = json['time'];
    title = json['title'];
    year = json['year'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['time'] = this.time;
    data['title'] = this.title;
    data['year'] = this.year;
    return data;
  }
}