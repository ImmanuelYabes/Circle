import 'package:circle/constant/firebase_constant.dart';

class CirclePlace{
  final String placeName;
  final String image;
  final String address;
  List<Circle> circles;
  CirclePlace({required this.placeName, required this.image, required this.address, required this.circles});

  static Future<CirclePlace> fromFirestore(DocumentSnapshot doc) async {
    final data = doc.data() as Map<String, dynamic>;

    final circlesCollection = doc.reference.collection('circles');
    final circlesList = await circlesCollection.get().then((querySnapshot) {
      return querySnapshot.docs.map((doc) => Circle.fromMap(doc.data())).toList();
    });

    return CirclePlace(
      placeName: data['placeName'],
      image: data['image'],
      address: data['address'],
      circles: circlesList,
    );
  }

  Map<String, dynamic> toMap() {
    final circlesList = circles.map((circle) => circle.toMap()).toList();
    return {
      'placeName': placeName,
      'image': image,
      'address': address,
      'circles': circlesList,
    };
  }

}

class Circle {
  final String circleName;
  final String description;
  final String image;
  final List<String> genres;
  final List<String> memberUid;
  final String placeUid;
  final String circleUid;

  Circle({
    required this.circleName,
    required this.description,
    required this.genres,
    required this.memberUid,
    required this.image,
    required this.placeUid,
    required this.circleUid,
  });

  factory Circle.fromMap(Map<String, dynamic> data) {
    return Circle(
      circleName: data['circleName'] ?? '',
      description: data['description'] ?? '',
      genres: List<String>.from(data['genre'] ?? []),
      memberUid: List<String>.from(data['memberUid'] ?? []),
      image: data['image'] ?? '',
      placeUid: data['placeUid'],
      circleUid: data['circleUid'],
    );
  }

  Map<String, dynamic> toMap() {
    return {
      'circleName': circleName,
      'description': description,
      'genre': genres,
      'memberUid': memberUid,
      'image': image,
      'placeUid': placeUid,
      'circleUid': circleUid,
    };
  }
}