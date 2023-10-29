import 'package:circle/constant/constant_builder.dart';
import 'package:circle/find_circle.dart';
import 'package:circle/view/account_settings.dart';
import 'package:circle/view/edit_profile.dart';
import 'package:circle/view/find_matches.dart';
import 'package:circle/view/my_matches.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:top_modal_sheet/top_modal_sheet.dart';

class MasterPage extends StatefulWidget {
  final User user;
  const MasterPage(this.user, {super.key});

  @override
  State<MasterPage> createState() => _MasterPageState(this.user);
}

class _MasterPageState extends State<MasterPage> {
  User user;
  _MasterPageState(this.user);

  int _selectedIndex = 0;

  late final List<Widget> _widgetOptions;

  @override
  void initState() {
    super.initState();
    _widgetOptions = [
      FindMatchesPage(user),
      MyMatchesPage(user, onFindCircleTapped),
      const FindCirclePage(),
    ];
  }

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async{
        final shouldExit = await showDialog(
          context: context,
          builder: (context) => AlertDialog(
            title: const Text('Exit App'),
            content: const Text('Are you sure you want to exit?'),
            actions: [
              TextButton(
                  child: const Text('No'),
                  onPressed: () => Navigator.of(context).pop(false),
                ),
                TextButton(
                  child: const Text('Yes'),
                  onPressed: () => Navigator.of(context).pop(true),
                ),
            ],
          )
        );
        return shouldExit ?? false;
      },
      child: Scaffold(
        extendBodyBehindAppBar: true,
        appBar: AppBar(
          backgroundColor: Colors.transparent,
          elevation: 0,
          actions: <Widget>[
            Container(
              decoration: BoxDecoration(
                color: appPurple,
                borderRadius: BorderRadius.circular(10),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.2),
                    blurRadius: 2,
                  )
                ]
              ),
              margin: const EdgeInsets.only(right: 15, bottom: 2),
              child: IconButton(
                icon: const Icon(Icons.menu),
                splashRadius: 12,
                onPressed: (){
                  showTopModalSheet<void>(
                    context, 
                    Container(
                      color: appPurple,
                      padding: const EdgeInsets.only(top: 30, left: 25, right: 25),
                      height: 330,
                      child: Column(
                        children: <Widget>[
                          ListTile(
                            leading: const Icon(Icons.search, color: Colors.white),
                            title: const Text('Find Match', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              _onItemTapped(0);
                              Navigator.pop(context);
                            },
                          ),
                          Container(width: double.infinity, height: 1,color: Colors.white,),
                          ListTile(
                            leading: const Icon(Icons.emoji_people, color: Colors.white),
                            title: const Text('My Match', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              _onItemTapped(1);
                              Navigator.pop(context);
                            },
                          ),
                          Container(width: double.infinity, height: 1,color: Colors.white,),
                          ListTile(
                            leading: const Icon(Icons.people_alt, color: Colors.white),
                            title: const Text('Circles', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              _onItemTapped(2);
                              Navigator.pop(context);
                            },
                          ),
                          Container(width: double.infinity, height: 1,color: Colors.white,),
                          ListTile(
                            leading: const Icon(Icons.edit, color: Colors.white),
                            title: const Text('Edit Profile', style: TextStyle(color: Colors.white)),
                            onTap: () {
                               Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => EditProfilePage(user.uid),
                                )
                              );
                            },
                          ),
                          Container(width: double.infinity, height: 1,color: Colors.white,),
                          ListTile(
                            leading: const Icon(Icons.settings, color: Colors.white),
                            title: const Text('Account Settings', style: TextStyle(color: Colors.white)),
                            onTap: () {
                              Navigator.push(
                                context, 
                                MaterialPageRoute(
                                  builder: (context) => const AccountSettingsPage(),
                                )
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  );
                },
              ),
            ),
          ],
        ),
        body: _widgetOptions.elementAt(_selectedIndex),
      ),
    );
  }

  void onFindCircleTapped(){
    setState(() {
      _selectedIndex = 2;
    });
  }
}

