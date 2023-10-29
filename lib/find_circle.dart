import 'package:circle/constant/constant_builder.dart';
import 'package:circle/constant/firebase_constant.dart';
import 'package:circle/factory/circle_factory.dart';
import 'package:circle/view/place_detail.dart';
import 'package:circle/view/widget/skeleton.dart';

class FindCirclePage extends StatefulWidget {
  const FindCirclePage({Key? key});

  @override
  State<FindCirclePage> createState() => _FindCirclePageState();
}

class _FindCirclePageState extends State<FindCirclePage> {
  Stream<List<CirclePlace>>? _placesStream;

  @override
  void initState() {
    super.initState();
    getPlaces();
    
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appPurple,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Padding(
          padding: const EdgeInsets.only(left: 30, right: 30, top: 40),
          child: Column(
            children: [
              Image.asset(
                logoText,
                alignment: Alignment.center,
                width: double.infinity,
              ),
              StreamBuilder<List<CirclePlace>>(
                stream: _placesStream,
                builder: (context, snapshot) {
                  if (snapshot.hasError) {
                    return Text('Error: ${snapshot.error}');
                  }
      
                  if (!snapshot.hasData) {
                    return Column(
                      children: [
                        skeletonBox(double.infinity, 270),
                        const SizedBox(height: 15,),
                        skeletonBox(double.infinity, 270),
                      ],
                    );
                    
                  }
      
                  final places = snapshot.data!;
      
                  return ListView.builder(
                    shrinkWrap: true,
                    padding: EdgeInsets.zero,
                    itemCount: places.length,
                    itemBuilder: (context, index) {
                      final place = places[index];
                      return ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => PlaceDetailPage(place)
                            )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(30),
                          ),
                        ),
                        child: Container(
                          width: double.infinity,
                          margin: const EdgeInsets.only(bottom: 15),
                          height: 270,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(30),
                          ),
                          child: Column(
                            children: [
                              ClipRRect(
                                borderRadius: const BorderRadius.only(
                                  topLeft: Radius.circular(30),
                                  topRight: Radius.circular(30),
                                ),
                                child: SizedBox(
                                  width: double.infinity,
                                  height: 180,
                                  child: Image.network(
                                    place.image,
                                    fit: BoxFit.cover,
                                  ),
                                ),
                              ),
                              const SizedBox(height: 10),
                              Padding(
                                padding:const EdgeInsets.symmetric(horizontal: 16),
                                child: Row(
                                  mainAxisAlignment:MainAxisAlignment.spaceBetween,
                                  children: [
                                    Column(
                                      crossAxisAlignment: CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          place.placeName,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: fontColor,
                                            fontWeight: FontWeight.bold,
                                            fontSize: 22,
                                          ),
                                        ),
                                        Text(
                                          place.address,
                                          overflow: TextOverflow.ellipsis,
                                          style: const TextStyle(
                                            color: fontColor,
                                            fontSize: 15,
      
                                          )
                                        )
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Image.asset(
                                          smallLogo,
                                          width: 40,
                                          height: 40,
                                        ),
                                        Text(
                                          place.circles.length.toString(),
                                          style: const TextStyle(
                                            color: Color(0xff777777),
                                            fontWeight: FontWeight.bold,
                                            fontSize: 20,
                                          ),
                                        )
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    },
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
  getPlaces() async {
    final querySnapshot = await db.collection('place').get();
    final circlePlaces = <CirclePlace>[];

    for (final doc in querySnapshot.docs) {
      final circlePlace = await CirclePlace.fromFirestore(doc);
      circlePlaces.add(circlePlace);
    }

    setState(() {
      _placesStream = Stream.value(circlePlaces);
    });
  }
}