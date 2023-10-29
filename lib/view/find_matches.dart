import 'dart:math';

import 'package:circle/constant/constant_builder.dart';
import 'package:circle/constant/firebase_constant.dart';
import 'package:circle/factory/user_factory.dart';
import 'package:circle/view/widget/skeleton.dart';

class FindMatchesPage extends StatefulWidget {
  final User user;
  const FindMatchesPage(this.user, {super.key});

  @override
  State<FindMatchesPage> createState() => _FindMatchesPageState(user);
}

class _FindMatchesPageState extends State<FindMatchesPage> {

  User user;
  _FindMatchesPageState(this.user);

  UserCircle? ucl;
  int currRandIdx = -1;

  @override
  void initState(){
    super.initState();
    getRandomUser();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: 
      (ucl == null)
      ? const Center(child: CircularProgressIndicator())
      : Stack(
        children: [
          Stack(
            children: [
              SizedBox(
                height: MediaQuery.of(context).size.height * 0.8,
                child: Image.network(
                  ucl!.profileUrl, fit: BoxFit.cover,
                  loadingBuilder: (context, child, loadingProgress) {
                    if (loadingProgress == null) {
                      return child;
                    }else{
                      return Center(
                        child: skeletonBox(double.infinity, double.infinity),
                      );
                    }
                  }
                ),
              ),
              Positioned(
                bottom: 0,
                left: 0,
                right: 0,
                child: Container(
                  height: 160,
                  decoration: const BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.bottomCenter,
                      end: Alignment.topCenter,
                      stops: [0.18, 1],
                      colors: [
                        Colors.white,
                        Colors.transparent,
                        
                      ],
                    ),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.end,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "${ucl!.name}, ${ucl!.age}",
                          overflow: TextOverflow.ellipsis,
                          style: const TextStyle(
                            color: fontColor,
                            fontSize: 25,
                            fontWeight: FontWeight.bold
                          )
                        ),
                        const SizedBox(height: 5),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            (ucl!.interest.isNotEmpty)
                            ? Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                margin: const EdgeInsets.only(right: 20),
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: darkPurple,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Center(
                                  child: Text(
                                    ucl!.interest[0],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17
                                    )
                                  )
                                ),
                              ),
                            )
                            : const SizedBox(),

                            (ucl!.interest.length > 1)
                            ? Expanded(
                              child: Container(
                                margin: const EdgeInsets.only(right: 20),
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: darkPurple,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child:  Center(
                                  child: Text(
                                    ucl!.interest[1],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17
                                    )
                                  )
                                ),
                              ),
                            )
                            : const SizedBox(),

                            (ucl!.interest.length > 2)
                            ? Expanded(
                              child: Container(
                                padding: const EdgeInsets.symmetric(horizontal: 5),
                                height: 35,
                                decoration: const BoxDecoration(
                                  color: darkPurple,
                                  borderRadius: BorderRadius.all(Radius.circular(20)),
                                ),
                                child: Center(
                                  child: Text(
                                    ucl!.interest[2],
                                    overflow: TextOverflow.ellipsis,
                                    style: const TextStyle(
                                      color: Colors.white,
                                      fontSize: 17
                                    )
                                  )
                                ),
                              ),
                            )
                            : const SizedBox()
                                  
                          ],
                        )
                      ],
                    ),
                  ),
                ),
              )
            ],
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: DraggableScrollableSheet(
              initialChildSize: 0.18,
              minChildSize: 0.18,
              maxChildSize: 0.6,
              builder: (_, ScrollController scrollController)=> Container(
                  width: double.maxFinite,
                  decoration: const BoxDecoration(
                    color: appPurple,
                    borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(40),
                      topRight: Radius.circular(40)
                    )
                  ),
                  child: SingleChildScrollView(
                    controller: scrollController,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 20),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          const Center(
                            child: Icon(Icons.keyboard_arrow_up_rounded, color: Colors.white, size: 50,)
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              SizedBox(
                                height: 70,
                                width: 70,
                                child: FloatingActionButton(
                                  onPressed: (){
                                    getRandomUser();
                                  },
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.close_rounded, color: Colors.red, size: 40,),
                                  
                                ),
                              ),

                              const SizedBox(width: 50,),

                              SizedBox(
                                height: 70,
                                width: 70,
                                child: FloatingActionButton(
                                  onPressed: (){
                                    db
                                      .collection('users')
                                      .where('uid', isEqualTo: user.uid)
                                      .get()
                                      .then((querySnapshot) {
                                        for (var document in querySnapshot.docs) {
                                          List<dynamic> mymatch = document.data()['mymatch'];
                                          if (!mymatch.contains(ucl!.uid)) {
                                            document.reference.update({'mymatch': FieldValue.arrayUnion([ucl!.uid])});
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${ucl!.name} has been added to your match list!",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  )
                                                ),
                                                backgroundColor: Colors.green,
                                              ),
                                            );
                                          }else{
                                            ScaffoldMessenger.of(context).showSnackBar(
                                              SnackBar(
                                                content: Text(
                                                  "${ucl!.name} is already at your matches list!",
                                                  style: const TextStyle(
                                                    fontSize: 17,
                                                  )
                                                ),
                                                backgroundColor: Colors.red,
                                              ),
                                            );
                                          }
                                        }
                                    });
                                  },
                                  backgroundColor: Colors.white,
                                  shape: const CircleBorder(),
                                  child: const Icon(Icons.check_rounded, color: Colors.green, size: 40,),
                                  
                                ),
                              ),
                            ],
                          ),
                          
                          ConstrainedBox(
                            constraints: const BoxConstraints(
                              maxHeight: 185
                            ),
                            child: Container(
                              margin: const EdgeInsets.symmetric(vertical: 20),
                              width: double.infinity,
                              
                              decoration: BoxDecoration(
                                color: boxColour,
                                borderRadius: const BorderRadius.all(Radius.circular(30)),
                                boxShadow: [
                                  BoxShadow(
                                    color: Colors.black.withOpacity(0.15),
                                    blurRadius: 15,
                                    offset: const Offset(0, 5)
                                  )
                                ]
                              ),
                              child: Padding(
                                padding: const EdgeInsets.all(20),
                                child: Text(
                                  ucl!.aboutMe,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 17
                                  )
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(
                            width: double.infinity,
                            child: Text(
                              "Interest",
                              textAlign: TextAlign.start,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.bold
                              )
                            ),
                          ),
                          const SizedBox(height: 20),
                          (ucl!.interest.isNotEmpty)
                          ? SizedBox(
                            height: 100,
                            child: GridView.count(
                              childAspectRatio: (100 / 35),
                              padding: EdgeInsets.zero,
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              children: [
                                for (String interest in ucl!.interest)
                                  Container(
                                    padding: const EdgeInsets.symmetric(horizontal: 5),
                                    decoration: const BoxDecoration(
                                      color: darkPurple,
                                      borderRadius: BorderRadius.all(Radius.circular(20)),
                                    ),
                                    child: Center(
                                        child: Text(
                                            interest,
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                                color: Colors.white,
                                                fontSize: 15
                                            )
                                        )
                                    ),
                                  )
                              ],
                            ),
                          )
                          : const Text(
                              "User interest are empty!",
                              textAlign: TextAlign.left,
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 17,
                                fontStyle: FontStyle.italic,
                              )
                            )
                        ]
                      ),
                    )
                  ),
              )
            ),
          ),
        ],
      )
    );
  }

  Future<void> getRandomUser() async {
    final random = Random();
    final querySnapshot = await db.collection('users').get();
    final doc = querySnapshot.docs;
    int randomIndex = random.nextInt(doc.length);

    
    do{
      randomIndex = random.nextInt(doc.length);
    }while(doc[randomIndex].data()['uid'] == user.uid || randomIndex == currRandIdx);

    currRandIdx = randomIndex;
    List<dynamic> listD = doc[randomIndex].data()['interest'];
    List<String> interestList = listD.map((e) => e.toString()).toList();
    
    UserCircle uc = UserCircle(
      uid: doc[randomIndex].data()['uid'],
      name: doc[randomIndex].data()['name'],
      email: doc[randomIndex].data()['email'],
      birthDate: doc[randomIndex].data()['birthdate'].toDate(),
      profileUrl: doc[randomIndex].data()['profileUrl'],
      aboutMe: doc[randomIndex].data()['aboutMe'],
      interest: interestList,
      facebook: doc[randomIndex].data()['facebook'],
      instagram: doc[randomIndex].data()['instagram'],
      twitter: doc[randomIndex].data()['twitter'],
    );
    setState(() {
      ucl = uc;
    });
  }

}