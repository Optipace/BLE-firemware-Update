import 'package:hive/hive.dart';

part 'getNumberModel.g.dart';


@HiveType(typeId : 6)
class GetNumberModel extends HiveObject{
  @HiveField(0)
  int  id;

  @HiveField(1)
  int productId;

  @HiveField(2)
  String discription;

  @HiveField(3)
  String createdOn;

  @HiveField(4)
  String active;

  GetNumberModel({
    required this.id,
    required this.productId,
    required this.discription,
    required this.createdOn,
    required this.active
  });

  @override
  String toString(){
    return 'GetNumberModel { id : $id, productId : $productId, Discription : $discription, createdOn : $createdOn, Active : $active}';
  }

  factory GetNumberModel.fromJson(Map<String, dynamic> json){
    return GetNumberModel(
        id: json['id'] ?? 0,
        productId: json['productId'] ??'',
        discription: json['discription'] ?? '',
        createdOn: json['createdOn'] ?? '',
        active: json['active'] ?? ''
    );
  }

  Map<String, dynamic> toJson(){
    return{
      'id' : id,
      'productId' : productId,
      'discription' : discription,
      'createdOn' : createdOn,
      'active' : active
    };
  }

}