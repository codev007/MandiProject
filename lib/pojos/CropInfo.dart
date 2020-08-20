class CropInfo {
  String id;
  String cropName;
  String min;
  String max;

  CropInfo({this.id, this.cropName, this.min, this.max});

  CropInfo.fromJson(Map<String, dynamic> json) {
    id = json['id'];
    cropName = json['crop_name'];
    min = json['min'];
    max = json['max'];
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['id'] = this.id;
    data['crop_name'] = this.cropName;
    data['min'] = this.min;
    data['max'] = this.max;
    return data;
  }
}