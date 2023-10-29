import 'package:circle/constant/constant_builder.dart';
import 'package:circle/factory/user_factory.dart';
import 'package:url_launcher/url_launcher.dart';

class UserDetail extends StatelessWidget {
  final UserCircle user;
  const UserDetail(this.user, {super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.transparent,
      ),
      body: Stack(
        children: [
          SizedBox(
            width: double.infinity,
            height: MediaQuery.of(context).size.height/2.45,
            child: Image.asset(
              bgDecor,
              fit: BoxFit.cover,
            ),
          ),
          const SizedBox(height: 30,),
          Container(
            width: double.infinity,
            margin: const EdgeInsets.only(top: 70),
            padding: const EdgeInsets.symmetric(horizontal: 40),
            child: Column(
              children: [
                CircleAvatar(
                  radius: 50,
                  backgroundColor: Colors.white,
                  backgroundImage: NetworkImage(user.profileUrl),
                ),
                const SizedBox(height: 10,),
                Text(
                  "${user.name}, ${user.age}",
                  overflow: TextOverflow.ellipsis,
                  style: const TextStyle(
                    color: Colors.white,
                    fontSize: 23,
                  )
                ),
                const SizedBox(height: 20),
                ConstrainedBox(
                  constraints: const BoxConstraints(
                    minHeight: 130
                  ),
                  child: Container(
                    width: double.infinity,
                    decoration: BoxDecoration(
                      color: boxColour,
                      borderRadius: BorderRadius.circular(30),
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
                        children: [
                          const Text(
                            "About me",
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 22,
                              fontWeight: FontWeight.w600
                            )
                          ),
                          Text(
                            user.aboutMe,
                            style: const TextStyle(
                              color: Colors.white,
                              fontSize: 16,
                            )
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                (user.instagram != "" || user.facebook != "" || user.twitter != "")
                ? Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      (user.instagram != "")
                      ? ElevatedButton(
                        onPressed: () {
                          launchTheURL(user.instagram);
                        },
                        style: ElevatedButton.styleFrom(
                          padding: EdgeInsets.zero,
                          elevation: 0,
                          backgroundColor: Colors.transparent,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          )
                        ),
                        child: Image.asset(instagram)
                      )
                      : const SizedBox(),
                      (user.facebook != "")
                      ? ElevatedButton(
                          onPressed: () {
                            launchTheURL(user.facebook);
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                            ),
                          child: Image.asset(facebook)
                        )
                      : const SizedBox(),
                      (user.twitter != "")
                      ? ElevatedButton(
                          onPressed: () {
                            launchTheURL(user.twitter);
                          },
                          style: ElevatedButton.styleFrom(
                              padding: EdgeInsets.zero,
                              elevation: 0,
                              backgroundColor: Colors.transparent,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20),
                              )
                            ),
                          child: Image.asset(twitter)
                        )
                      : const SizedBox(),
                    ]
                  )
                : const SizedBox(
                  child: Text(
                    "No social media",
                    style: TextStyle(
                      color: Colors.grey,
                      fontSize: 16,
                      fontStyle: FontStyle.italic
                    )
                  ),
                ),

                Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(top: 20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(30),
                    boxShadow: const [
                      BoxShadow(
                        color: Colors.black38,
                        blurRadius: 15,
                        offset: Offset(0, 3)
                      )
                    ],
                  ),
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 15),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text(
                          "Interests: ",
                          style: TextStyle(
                            color: fontColor,
                            fontSize: 15,
                            fontWeight: FontWeight.w600
                          )
                        ),
                        (user.interest.isNotEmpty)
                        ? SizedBox(
                            height: 100,
                            child: GridView.count(
                              childAspectRatio: (100 / 35),
                              padding: EdgeInsets.zero,
                              crossAxisCount: 3,
                              mainAxisSpacing: 10,
                              crossAxisSpacing: 10,
                              children: [
                                for (String interest in user.interest)
                                  Tooltip(
                                    triggerMode: TooltipTriggerMode.tap,
                                    preferBelow: false,
                                    message: interest,
                                    child: Container(
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
                                    ),
                                  )
                              ],
                            ),
                          )
                        : SizedBox(
                          height: 100,
                          child: Text(
                            "${user.name} has no interests",
                            style: const TextStyle(
                              color: Colors.grey,
                              fontSize: 15,
                              fontStyle: FontStyle.italic
                            )
                          ),
                        )
                      ],
                    )
                  )
                )
              ],
            )
          )
        ]
      ),
    );
  }

  void launchTheURL(String urls) async {
    var uri = Uri.parse(urls);
    if (!await launchUrl(uri)) {
      throw 'Could not launch $uri';
    } 
  }
}