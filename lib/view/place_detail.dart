import 'package:circle/constant/constant_builder.dart';
import 'package:circle/factory/circle_factory.dart';
import 'package:circle/view/circle_detail.dart';

class PlaceDetailPage extends StatelessWidget {
  final CirclePlace place;
  const PlaceDetailPage(this.place, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appPurple,
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: Container(
          margin: const EdgeInsets.all(5),
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.8),
            shape: BoxShape.circle,
          ),
          child: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.black),
            onPressed: () => Navigator.of(context).pop(),
            padding: const EdgeInsets.all(5),
          ),
        ),
      ),

      body: SingleChildScrollView(
        child: Column(
          children: [
            SizedBox(
              width: double.infinity,
              height: 200,
              child: Image.network(
                place.image,
                fit: BoxFit.cover,
              ),
            ),
            Container(
              padding:const EdgeInsets.symmetric(horizontal: 16),
              width: double.infinity,
              height: 70,
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  bottomLeft: Radius.circular(5),
                  bottomRight: Radius.circular(5),
                ),
                
              ),
              child: Row(
                mainAxisAlignment:MainAxisAlignment.spaceBetween,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
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
                    mainAxisAlignment: MainAxisAlignment.center,
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
            const SizedBox(height: 20,),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 20),
              child: GridView.count(
                physics: const NeverScrollableScrollPhysics(),
                shrinkWrap: true,
                crossAxisCount: 2,
                padding: EdgeInsets.zero,
                mainAxisSpacing: 20,
                crossAxisSpacing: 20,
                children: [
                  for (var i = 0; i < place.circles.length; i++)
                    Container(
                      decoration: BoxDecoration(
                        color: Colors.transparent,
                        borderRadius: const BorderRadius.all(Radius.circular(20)),
                        image: DecorationImage(
                          fit: BoxFit.cover,
                          image: NetworkImage(place.circles[i].image),
                        ),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black26,
                            blurRadius: 10,
                            offset: Offset(0, 5),
                          )
                        ]
                      ),
                      child: ElevatedButton(
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => CircleDetailPage(place.circles[i], place.placeName),
                            )
                          );
                        },
                        style: ElevatedButton.styleFrom(
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          padding: EdgeInsets.zero,
                          backgroundColor: Colors.transparent,
                        ),
                        child: Container(
                          decoration: const BoxDecoration(
                            borderRadius: BorderRadius.all(Radius.circular(20)),
                            gradient: LinearGradient(
                              begin: Alignment.bottomCenter,
                              end: Alignment.topCenter,
                              stops: [0.1, 0.7],
                              colors: [
                                Colors.white,
                                Colors.transparent,
                              ],
                            ),
                          ),
                          child: Container(
                            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                            alignment: Alignment.bottomCenter,
                            child: Text(
                              place.circles[i].circleName,
                              overflow: TextOverflow.ellipsis,
                              style: const TextStyle(
                                color: fontColor,
                                fontSize: 18,
                              )
                            ),
                          ),
                        ),
                      )
                    )
                ],
                  
              ),
            )
          ],
        ),
      )
    );
  }
}