import 'package:circle/constant/constant_builder.dart';
import 'package:circle/constant/firebase_constant.dart';
import 'package:circle/view/authentication/login.dart';

class AccountSettingsPage extends StatelessWidget {
  const AccountSettingsPage({super.key});

  static const List<String> settingsList = [
    'Account',
    'Notifications',
    'Privacy & Security',
    'about',
  ];

  static const List<Icon> iconList = [
    Icon(Icons.account_circle_outlined),
    Icon(Icons.notifications_active_outlined),
    Icon(Icons.privacy_tip_outlined),
    Icon(Icons.question_mark_rounded),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        toolbarHeight: 80,
        title: const Text(
          'Settings',
          textAlign: TextAlign.center,
          style: TextStyle(
            color: Colors.white,
            fontSize: 30,
            fontWeight: FontWeight.bold
          )
        ),
        backgroundColor: appPurple,
      ),
      body: Container(
        color: appPurple,
        child: Container(
          width: MediaQuery.sizeOf(context).width,
          margin: const EdgeInsets.only(top: 110),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(topLeft: Radius.circular(50), topRight: Radius.circular(50)),
          ),
          child: Container(
            padding: const EdgeInsets.all(20),
            child: Column(
              children: [
                ListView.separated(
                  padding: EdgeInsets.zero,
                  shrinkWrap: true,
                  physics: const BouncingScrollPhysics(),
                  itemCount: settingsList.length,
                  separatorBuilder: (context, index) {
                    return const Divider(
                      color: Colors.grey,
                      thickness: 1,

                    );
                  },
                  itemBuilder: (context, index) {
                    return Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 7),
                      child: ListTile(
                        onTap: () {
                          
                        },
                        title: Text(
                          settingsList[index],
                        ),
                        leading: iconList[index],
                        trailing: const Icon(Icons.arrow_forward_ios),
                      ),
                    );
                  }
                ),
                const SizedBox(height: 20,),
                SizedBox(
                  width: double.infinity,
                  child: ElevatedButton(
                    onPressed: () {
                      signOut();
                      Navigator.pushAndRemoveUntil(
                        context,
                        MaterialPageRoute(builder: (context) => const LoginPage()),
                        (route) => false,
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: appPurple,
                      padding: const EdgeInsets.symmetric(
                          vertical: 10, horizontal: 20),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(20),
                      ),
                    ),
                    child: const Text('Log out',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                        ))),
                ),
              ]
            )
          ),
        )
      ),
    );
  }

  signOut() async {
    await auth.signOut();
  }

}