
import 'package:circle/constant/constant_builder.dart';
import 'package:circle/constant/firebase_constant.dart';
import 'package:circle/factory/user_factory.dart';
import 'package:circle/view/widget/input_box.dart';
import 'package:intl/intl.dart';

class EditProfilePage extends StatefulWidget {
  final String userUid;
  const EditProfilePage(this.userUid, {super.key});

  @override
  State<EditProfilePage> createState() => _EditProfilePageState(userUid);
}

class _EditProfilePageState extends State<EditProfilePage> {
  String userUid;
  _EditProfilePageState(this.userUid);

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();
  final TextEditingController aboutmeController = TextEditingController();
  final TextEditingController interestController = TextEditingController();
  final TextEditingController instagramController = TextEditingController();
  final TextEditingController twitterController = TextEditingController();
  final TextEditingController facebookController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  UserCircle? user;

  bool isLoading = false;
  bool obscure = true;

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    birthdateController.dispose();
    aboutmeController.dispose();
    interestController.dispose();
    instagramController.dispose();
    twitterController.dispose();
    facebookController.dispose();
    super.dispose();
  }

  bool isUpload = false;
  String imgPath = "";

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getUserData();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: AppBar(
        automaticallyImplyLeading: false,
        elevation: 0,
        backgroundColor: Colors.transparent,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.of(context).pop(),
        ),
        
      ),
      body: (user != null)
      ? SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 65),
                    alignment: Alignment.center,
                    child: const Text(
                      'Update Profile',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: fontColor,
                      ),
                    )
                  ),
                  Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.only(top: 10),
                    child: CircleAvatar(
                      radius: 50,
                      backgroundImage: 
                        NetworkImage(user!.profileUrl),
                      backgroundColor: Colors.transparent,
                    )
                  ),

                  // SizedBox(
                  //   width: double.infinity,
                  //   child: ElevatedButton(
                  //     onPressed: () async {
                  //       try {
                  //         final img = await ImagePicker()
                  //             .pickImage(source: ImageSource.gallery, imageQuality: 75);
                  //         if (img == null) return;
                  //         imgPath = img.path;
                  //       } on Exception {
                  //         ScaffoldMessenger.of(context).showSnackBar(
                  //           const SnackBar(
                  //             content: Text('Error occured!'),
                  //             backgroundColor: Colors.red,
                  //           ),
                  //         );
                  //       }
                  //     },
                      
                  //     style: ElevatedButton.styleFrom(
                  //       backgroundColor: appPurple,
                  //       padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                  //       shape: RoundedRectangleBorder(
                  //         borderRadius: BorderRadius.circular(10),
                  //       ),
                  //     ),
                  //     child: const Text(
                  //       'Upload image',
                  //       style: TextStyle(
                  //         fontSize: 15,
                  //         fontWeight: FontWeight.w600,
                  //         color: Colors.white,
                  //       )
                  //     )
                  //   ),
                  // ),

                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextField(
                      enabled: false,
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      
                      decoration: inputDec('Email', const Icon(Icons.email_outlined), hint: 'email@example.com'),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: nameController,
                      keyboardType: TextInputType.name,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return 'Please enter your name!';
                        } 
                        return null;
                      },
                      decoration: inputDec('Name', const Icon(Icons.person_2_outlined) ,hint: 'ex: John Doe'),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: birthdateController,
                            enabled: false,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return 'Please enter your birth date';
                              }
                              return null;
                            },
                            keyboardType: TextInputType.datetime,
                            decoration: inputDec('MM/DD/YYYY', const Icon(Icons.date_range), hint: 'mm/dd/yyyy')
                            ),
                          ),
                          IconButton(
                            icon: const Icon(Icons.calendar_today),
                            onPressed: () async {
                              final DateTime? picked = await showDatePicker(
                                context: context,
                                initialDate: user!.birthDate,
                                firstDate: DateTime(1900, 1),
                                lastDate: DateTime(2100),
                              );
                              if (picked != null) {
                                setState(() {
                                  birthdateController.text = DateFormat('MM/dd/yyyy').format(picked);
                                });
                              }
                            },
                          ),
                        
                      ],
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: aboutmeController,
                      maxLength: 150,
                      maxLines: null,
                      keyboardType: TextInputType.multiline,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return 'Please tell yourself!';
                        } 
                        return null;
                      },
                      decoration: inputDec('About Me', const Icon(Icons.info_outline) ,hint: 'Tell us about yourself'),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: interestController,
                      keyboardType: TextInputType.multiline,
                      decoration: inputDec('Interest', const Icon(Icons.emoji_emotions_outlined) ,hint: 'separate by comma sports, travelling, etc'),
                    ),
                  ),

                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: instagramController,
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return null;
                        }
                        else if(!value.toLowerCase().contains("instagram.com")){
                          return 'Please enter a valid Instagram URL!';
                        }
                        return null;
                      },
                      decoration: inputDec('Instagram URL', const Icon(Icons.stop_circle_sharp) ,hint: 'Instagram URL'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: twitterController,
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return null;
                        }
                        else if(!value.toLowerCase().contains("twitter.com")){
                          return 'Please enter a valid Twitter URL!';
                        }
                        return null;
                      },
                      decoration: inputDec('Twitter URL', const Icon(Icons.stop_circle_sharp) ,hint: 'Twitter URL'),
                    ),
                  ),
                  Container(
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: facebookController,
                      keyboardType: TextInputType.url,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return null;
                        }
                        else if(!value.toLowerCase().contains("facebook.com")){
                          return 'Please enter a valid Facebook URL!';
                        }
                        return null;
                      },
                      decoration: inputDec('facebook URL', const Icon(Icons.stop_circle_sharp) ,hint: 'Facebook URL'),
                    ),
                  ),


                  const SizedBox(height: 20,),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : updateProfile,
                              
                              style: ElevatedButton.styleFrom(
                                backgroundColor: appPurple,
                                padding: const EdgeInsets.symmetric(vertical: 10, horizontal: 20),
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(10),
                                ),
                              ),
                              child: isLoading 
                                ? const CircularProgressIndicator()
                                :const Text(
                                  'Update Profile',
                                  style: TextStyle(
                                    fontSize: 25,
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                  )
                                )
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            )
          ),
        )
      : const Center(
        child: CircularProgressIndicator(),
      )
    );
  }

  Future updateProfile() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
      try{
        
        String dateString = birthdateController.text.trim();
        List<String> dateComponents = dateString.split('/');
        DateTime date = DateTime(int.parse(dateComponents[2]), int.parse(dateComponents[0]), int.parse(dateComponents[1]));

        String interest = interestController.text.trim();
        List<String> interestList = interest.split(RegExp(r',\s*|\s+'));
        if(interestList.length == 1 && interestList[0] == ""){
          interestList = [];
        }

        db.collection('users').doc(userUid).update({
          'name': nameController.text.trim(),
          'birthdate': date,
          'profileUrl': user!.profileUrl,
          'aboutMe': aboutmeController.text.trim(),
          'interest': interestList,
          'instagram': instagramController.text.trim(),
          'twitter': twitterController.text.trim(),
          'facebook':  facebookController.text.trim(),
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account updated succesfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }).catchError(
          (error) {
            
          }
        );
        // ignore: use_build_context_synchronously
        Navigator.pop(context);
      } on FirebaseAuthException catch(e){
        String errorMessage = "An error occurred. Please try again later.";
        if (e.code == 'weak-password') {
          errorMessage = "The password provided is too weak.";
        } else if (e.code == 'email-already-in-use') {
          errorMessage = "The account already exists for that email.";
        } else if (e.code == 'invalid-email') {
          errorMessage = "The email address is invalid.";
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      }finally {
        setState(() {
          isLoading = false;
        });
      }
    }
  }

  getUserData() async {
    await db.collection('users').doc(userUid).get().then((value) {
      Timestamp birthDateStamp = value.data()!['birthdate'];
      String birthdateString = DateFormat('MM/dd/yyyy').format(birthDateStamp.toDate());
      List<dynamic> interest = value.data()!['interest'];
      List<String> interestList = interest.map((e) => e.toString()).toList();

      user = UserCircle(
        uid: userUid, 
        name: value.data()!['name'], 
        email: value.data()!['email'], 
        birthDate: value.data()!['birthdate'].toDate(), 
        profileUrl: value.data()!['profileUrl'], 
        aboutMe: value.data()!['aboutMe'], 
        interest: interestList, 
        facebook: value.data()!['facebook'], 
        instagram: value.data()!['instagram'], 
        twitter: value.data()!['twitter']
      );
      setState(() {
        nameController.text = user!.name;
        emailController.text = user!.email;
        birthdateController.text = birthdateString;
        aboutmeController.text = user!.aboutMe;
        instagramController.text = user!.instagram;
        twitterController.text = user!.twitter;
        facebookController.text = user!.facebook;
        interestController.text = user!.interest.join(', ');
      });
    });
  }

}