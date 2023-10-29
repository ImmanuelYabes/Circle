import 'package:circle/constant/constant_builder.dart';
import 'package:circle/constant/firebase_constant.dart';
import 'package:circle/factory/circle_factory.dart';
import 'package:circle/factory/user_factory.dart';
import 'package:circle/view/widget/skeleton.dart';

class CircleDetailPage extends StatefulWidget {
  final Circle circle;
  final String placeName;
  const CircleDetailPage(this.circle, this.placeName, {super.key});

  @override
  State<CircleDetailPage> createState() => _CircleDetailPageState(circle, placeName);
}

class _CircleDetailPageState extends State<CircleDetailPage> {
  final Circle circle;
  final String placeName;
  _CircleDetailPageState(this.circle, this.placeName);

  List<String> circleMemberList = [];

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getCircleData();
  }

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
                circle.image,
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
                        circle.circleName,
                        overflow: TextOverflow.ellipsis,
                        style: const TextStyle(
                          color: fontColor,
                          fontWeight: FontWeight.bold,
                          fontSize: 22,
                        ),
                      ),
                      Text(
                        placeName,
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
                      const Icon(Icons.person_outline_rounded),
                      Text(
                        circleMemberList.length.toString(),
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
              child: Column(
                children: [
                  ConstrainedBox(
                    constraints: const BoxConstraints(
                      minHeight: 130
                    ),
                    child: Container(
                      width: double.infinity,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: const [
                          BoxShadow(
                            color: Colors.black38,
                            blurRadius: 15,
                            offset: Offset(0, 3)
                          )
                        ]
                      ),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              circle.description,
                              style: const TextStyle(
                                color: fontColor,
                                fontSize: 16,
                              )
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    height: 90,
                    child: GridView.count(
                      childAspectRatio: (100 / 35),
                      padding: EdgeInsets.zero,
                      crossAxisCount: 3,
                      mainAxisSpacing: 10,
                      crossAxisSpacing: 10,
                      children: [
                        for (String genres in circle.genres)
                          Tooltip(
                            triggerMode: TooltipTriggerMode.tap,
                            preferBelow: false,
                            message: genres,
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 5),
                              decoration: const BoxDecoration(
                                color: darkPurple,
                                borderRadius: BorderRadius.all(Radius.circular(20)),
                              ),
                              child: Center(
                                  child: Text(
                                      genres,
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                          color: Colors.white,
                                          fontSize: 15
                                      )
                                  )
                              ),
                            ),
                          )
                      ],
                    ),
                  ),
                  const SizedBox(height: 20,),
                  SizedBox(
                    height: 60,
                    child: ListView.builder(
                      padding: EdgeInsets.zero,

                      physics: const BouncingScrollPhysics(),
                      scrollDirection: Axis.horizontal,
                      itemCount: circleMemberList.length,
                      itemBuilder: (BuildContext context, int index) {
                        final userRef = db.collection('users').doc(circleMemberList[index]);
                        return FutureBuilder<DocumentSnapshot>(
                          future: userRef.get(),
                          builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                            if (!snapshot.hasData) {
                              return Padding(
                                padding: const EdgeInsets.only(left: 10),
                                child: skeletonBox(165, 30),
                              );
                            }
                            final userData = snapshot.data!.data() as Map<String, dynamic>;
                            List<dynamic> listD = userData['interest'];
                            List<String> interestList = listD.map((e) => e.toString()).toList();
                            UserCircle member = UserCircle(
                              uid: userData['uid'],
                              name: userData['name'],
                              email: userData['email'],
                              birthDate: userData['birthdate'].toDate(),
                              profileUrl: userData['profileUrl'],
                              aboutMe: userData['aboutMe'],
                              interest: interestList,
                              facebook: userData['facebook'],
                              instagram: userData['instagram'],
                              twitter: userData['twitter'],
                            );

                            return Container(
                              width: 165,
                              decoration: const BoxDecoration(
                                borderRadius:  BorderRadius.all(Radius.circular(35)),
                                color: Colors.white,
                              ),
                              child: Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                children: [
                                  Align(
                                    alignment: Alignment.centerLeft,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        border: Border.all(
                                          color: appPurple,
                                          width: 5,
                                        ),
                                      ),
                                      child: CircleAvatar(
                                        backgroundImage: NetworkImage(
                                          member.profileUrl,
                                        ),
                                        radius: 25,
                                      ),
                                    ),
                                  ),
                                  const SizedBox(width: 5,),
                                  Flexible(
                                    child: Text(
                                      "${member.name}, ${member.age}",
                                      overflow: TextOverflow.ellipsis,
                                      style: const TextStyle(
                                        color: fontColor,
                                        fontSize: 16,
                                        fontWeight: FontWeight.w600
                                      )
                                    ),
                                  ),
                                ],
                              )
                            );
                          },
                        );
                      },
                    ),
                  ),
                  const SizedBox(height: 15,),
                  Container(
                    margin: const EdgeInsets.symmetric(vertical: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: SizedBox(
                        width: double.infinity,
                        child: ElevatedButton(
                          onPressed: () {
                            addMember();
                          },
                          
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.white,
                            padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(20),
                            ),
                          ),
                          child: const Text(
                              'Join Circle',
                              style: TextStyle(
                                fontSize: 25,
                                fontWeight: FontWeight.w600,
                                color: fontColor,
                              )
                            )
                        ),
                      ),
                    ),
                  ),

                ],
              ),
            ),
          ],
        ),
      ),

    );
  }

  Future<void> getCircleData() async {
    String placeUid = circle.placeUid;
    final circleDoc = await db.collection('place').doc(placeUid).collection('circles').doc(circle.circleUid).get();


    List<dynamic> uidList = circleDoc.data()!['memberUid'];
    List<String> memberList = uidList.map((e) => e.toString()).toList();

    setState(() {
      circleMemberList = memberList;
    });
  }

  addMember() async{
    try {
      String uid = auth.currentUser!.uid;
      String placeUid = circle.placeUid;
      final circleDoc = await db.collection('place').doc(placeUid).collection('circles').doc(circle.circleUid).get();
      List<dynamic> uidList = circleDoc.data()!['memberUid'];
      List<String> memberList = uidList.map((e) => e.toString()).toList();

      if(memberList.contains(uid)){
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('You already a member!'),
            backgroundColor: Colors.red,
          ),
        );
      }else{
        memberList.add(uid);
        try{
          await db.collection('place').doc(placeUid).collection('circles').doc(circle.circleUid).update({'memberUid': memberList});
        }
        catch(e){
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Error occured when join a circle!'),
              backgroundColor: Colors.red,
            )
          );
        }
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('An error occured! Please try again!'),
          backgroundColor: Colors.red,
        ),
      );
    }
}

}