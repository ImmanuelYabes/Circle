import 'package:circle/constant/constant_builder.dart';
import 'package:circle/constant/firebase_constant.dart';
import 'package:circle/factory/circle_factory.dart';
import 'package:circle/factory/user_factory.dart';
import 'package:circle/view/user_detail.dart';
import 'package:circle/view/widget/skeleton.dart';

class MyMatchesPage extends StatefulWidget {
  final User user;
  final void Function() onFindCircleTapped;
  const MyMatchesPage(this.user, this.onFindCircleTapped, {super.key});

  @override
  State<MyMatchesPage> createState() => _MyMatchesPageState(user, onFindCircleTapped);
}

class _MyMatchesPageState extends State<MyMatchesPage> {
  final void Function() onFindCircleTapped;
  User user;
  _MyMatchesPageState(this.user, this.onFindCircleTapped);

  List<List<Circle>> groupCircle= [];
  List<String> myMatchesList = [];
  int circleCount = 0;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getMatchesDocs();
    getMatchesFromCircle();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appPurple,
      body: SingleChildScrollView(
        physics: const BouncingScrollPhysics(),
        child: Container(
          margin: const EdgeInsets.only(top: 80),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              const Text(
                "My Matches",
                style: TextStyle(
                  color: Colors.white,
                  fontSize: 40,
                  fontWeight: FontWeight.bold
                )
              ),
              const SizedBox(height: 20,),
              GridView.builder(
                shrinkWrap: true,
                padding: const EdgeInsets.symmetric(horizontal: 20,),
                physics: const BouncingScrollPhysics(),
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisCount: 2,
                  crossAxisSpacing: 20,
                  mainAxisSpacing: 20,
                ),
                itemCount: myMatchesList.length,
                itemBuilder: (BuildContext context, int index) {
                  final userRef = db.collection('users').doc(myMatchesList[index]);
                  return FutureBuilder<DocumentSnapshot>(
                    future: userRef.get(),
                    builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                      if (!snapshot.hasData) {
                        return SizedBox(
                          child: skeletonBox(150, 150),
                        );
                      }
                      final userData = snapshot.data!.data() as Map<String, dynamic>;
                      List<dynamic> listD = userData['interest'];
                      List<String> interestList = listD.map((e) => e.toString()).toList();
                      UserCircle matchUser = UserCircle(
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
                        decoration: BoxDecoration(
                          borderRadius: const BorderRadius.all(Radius.circular(20)),
                          color: Colors.white,
                          image: DecorationImage(
                            fit: BoxFit.cover,
                            image: NetworkImage(
                              matchUser.profileUrl,
                            )
                          ),
                        ),
                        child: ElevatedButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => UserDetail(matchUser),
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
                              borderRadius: BorderRadius.only(
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                              ),
                              gradient: LinearGradient(
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                                stops: [0.1, 0.6],
                                colors: [
                                  Colors.white,
                                  Colors.transparent,
                                ],
                              ),
                            ),
                            child: Container(
                              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                              alignment: Alignment.bottomLeft,
                              child: Text(
                                "${matchUser.name}, ${matchUser.age}",
                                overflow: TextOverflow.ellipsis,
                                style: const TextStyle(
                                  color: fontColor,
                                  fontSize: 20,
                                  fontWeight: FontWeight.w600
                                )
                              ),
                            ),
                          ),
                        )
                      );
                    },
                  );
                },
              ),
              const SizedBox(height: 20,),
              for (int i = 0; i < groupCircle.length; i++)
                ListView.builder(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  itemCount: groupCircle[i].length,
                  itemBuilder: (BuildContext context, int indexB) {
                    return Container(
                      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
                      padding: const EdgeInsets.symmetric(vertical: 15),
                      decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(20)),
                        color: darkPurple,
                      ),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 20),
                            child: Row(
                              children: [
                                Image.asset(smallLogoTrs),
                                const SizedBox(width: 10,),
                                Text(
                                  groupCircle[i][indexB].circleName,
                                  style: const TextStyle(
                                    color: Colors.white,
                                    fontSize: 20,
                                  )
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(height: 10,),
                          GridView.builder(
                            shrinkWrap: true,
                            padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 5),
                            physics: const BouncingScrollPhysics(),
                            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisCount: 2,
                              crossAxisSpacing: 20,
                              mainAxisSpacing: 20,
                            ),
                            itemCount: groupCircle[i][indexB].memberUid.length,
                            itemBuilder: (BuildContext context, int indexC) {
                              final userRef = db.collection('users').doc(groupCircle[i][indexB].memberUid[indexC]);
                              return FutureBuilder<DocumentSnapshot>(
                                future: userRef.get(),
                                builder: (BuildContext context, AsyncSnapshot<DocumentSnapshot> snapshot) {
                                  if (!snapshot.hasData) {
                                    return SizedBox(
                                      child: skeletonBox(150, 150),
                                    );
                                  }
                                  final userData = snapshot.data!.data() as Map<String, dynamic>;
                                  List<dynamic> listD = userData['interest'];
                                  List<String> interestList = listD.map((e) => e.toString()).toList();
                                  UserCircle matchUser = UserCircle(
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
                                    decoration: BoxDecoration(
                                      borderRadius: const BorderRadius.all(Radius.circular(20)),
                                      color: Colors.white,
                                      image: DecorationImage(
                                        fit: BoxFit.cover,
                                        image: NetworkImage(
                                          matchUser.profileUrl,
                                        )
                                      ),
                                    ),
                                    child: ElevatedButton(
                                      onPressed: () {
                                        Navigator.push(
                                          context,
                                          MaterialPageRoute(
                                            builder: (context) => UserDetail(matchUser),
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
                                          borderRadius: BorderRadius.only(
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                          ),
                                          gradient: LinearGradient(
                                            begin: Alignment.bottomCenter,
                                            end: Alignment.topCenter,
                                            stops: [0.1, 0.6],
                                            colors: [
                                              Colors.white,
                                              Colors.transparent,
                                            ],
                                          ),
                                        ),
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 5),
                                          alignment: Alignment.bottomLeft,
                                          child: Text(
                                            "${matchUser.name}, ${matchUser.age}",
                                            overflow: TextOverflow.ellipsis,
                                            style: const TextStyle(
                                              color: fontColor,
                                              fontSize: 20,
                                              fontWeight: FontWeight.w600
                                            )
                                          ),
                                        ),
                                      ),
                                    )
                                  );
                                },
                              );
                            },
                          ),
                        ],
                      ),
                    );
                  }
                ),
                const SizedBox(height: 20,),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20),
                  child: RichText(
                    textAlign: TextAlign.center,
                    text: const TextSpan(
                      children: [
                        TextSpan(
                          text: 'Find ',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          )
                        ),
                        TextSpan(
                          text: 'Circles',
                          style: TextStyle(
                            color: darkPurple,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          )
                        ),
                        TextSpan(
                          text: ' and meet new matches!',
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 18
                          )
                        )
                      ]
                    )
                  ),
                ),
                Container(
                  margin: const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
                  child: Align(
                    alignment: Alignment.bottomCenter,
                    child: SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: () {
                          onFindCircleTapped();
                        },
                        
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white,
                          padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                        ),
                        child: const Text(
                            'Click Here',
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
      ),
    );
  }

  Future<void> getMatchesDocs() async {
    
    final userRef = await db.collection('users').where('uid', isEqualTo: user.uid).get();
    final docs = userRef.docs;


    List<dynamic> uidList = docs.first.data()['mymatch'];
    List<String> myMatchList = uidList.map((e) => e.toString()).toList();


    setState(() {
      myMatchesList = myMatchList;
    });
  }

  getMatchesFromCircle() async{
    String uid = auth.currentUser!.uid;

    final circleRef = await db.collectionGroup('circles').where('memberUid', arrayContains: uid).get();
    final docs = circleRef.docs;

    if(docs.isEmpty){
      return;
    }else{
      String placeUid = docs.first.data()['placeUid'];
      List<Circle> temp = []; 
      for(int i = 0; i < docs.length; i++){
        if(placeUid != docs[i].data()['placeUid']){
          groupCircle.add(temp);
          temp.clear();
          placeUid = docs[i].data()['placeUid'];
          if(i == docs.length - 1){
            return;
          }
        }
        Circle c = Circle.fromMap(docs[i].data());
        if(c.memberUid.contains(uid)){
          c.memberUid.remove(uid);
          if(c.memberUid.isEmpty){
            if(i == docs.length - 1){
              groupCircle.add(temp);
            }
            continue;
          }
        }
        temp.add(c);

        if(i == docs.length - 1){
          groupCircle.add(temp);
        }
      }
    }
    setState(() {
      
    });
  }
}