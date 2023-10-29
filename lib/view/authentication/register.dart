import 'package:circle/constant/constant_builder.dart';
import 'package:circle/constant/firebase_constant.dart';
import 'package:circle/view/authentication/login.dart';
import 'package:circle/view/master.dart';
import 'package:circle/view/widget/input_box.dart';
import 'package:intl/intl.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({super.key});

  @override
  State<RegisterPage> createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {

  final TextEditingController emailController = TextEditingController();
  final TextEditingController passwordController = TextEditingController();
  final TextEditingController nameController = TextEditingController();
  final TextEditingController birthdateController = TextEditingController();

  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool obscure = true;

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
    nameController.dispose();
    birthdateController.dispose();
    super.dispose();
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
        body: SingleChildScrollView(
          child: Form(
            key: _formKey,
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 40),
              width: double.infinity,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(
                    margin: const EdgeInsets.only(top: 60),
                    width: double.infinity,
                    child: Image.asset(
                      appLogo,
                      width: 100,
                      height: 100,
                      alignment: Alignment.topRight,
                    ),
                  ),
        
                  Container(
                    margin: const EdgeInsets.only(top: 20),
                    child: const Text(
                      'Create Account',
                      style: TextStyle(
                        fontSize: 35,
                        fontWeight: FontWeight.bold,
                        color: fontColor,
                      ),
                    )
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
                    margin: const EdgeInsets.only(top: 30),
                    child: TextFormField(
                      controller: emailController,
                      keyboardType: TextInputType.emailAddress,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return 'Please enter your email';
                        } else if(!RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(value)){
                          return 'Please enter a valid email address';
                        }
                        return null;
                      },
                      decoration: inputDec('Email', const Icon(Icons.email_outlined), hint: 'email@example.com'),
                    ),
                  ),
        
                  Container(
                    margin: const EdgeInsets.only(top: 25),
                    child: TextFormField(
                      controller: passwordController,
                      obscureText: obscure,
                      validator: (value) {
                        if(value == null || value.isEmpty) {
                          return 'Please enter your password';
                        }else if(value.length < 6) {
                          return 'Password must be at least 6 characters';
                        }
                        return null;
                      },
                      decoration: inputDec('Password', const Icon(Icons.lock_outline), isPassword: true ,obscure: obscure, togglePass:  (value) {setState(() {
                        obscure = value;
                      });},),
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
                              if(value == 'MM/DD/YYYY'){
                                return 'Please input your bithdate!';
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
                                initialDate: DateTime.now(),
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
                              onPressed: isLoading ? null : register,
                              
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
                                  'Sign Up',
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
                      Container(
                        margin: const EdgeInsets.only(bottom: 45),
                        child: InkWell(
                          onTap: () {
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const LoginPage()));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Already have an account? ',
                              style: styleR15,
                              children: const [
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color: darkPurple,
                                    fontWeight: FontWeight.w600
                                  ),
                                )
                              ]
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
        ),
      ),
    );
  }

  Future register() async{
    if(_formKey.currentState!.validate()){
      setState(() {
        isLoading = true;
      });
      try{
        await auth.createUserWithEmailAndPassword(email: emailController.text.trim(), password: passwordController.text.trim());
        
        String dateString = birthdateController.text.trim();
        List<String> dateComponents = dateString.split('/');
        DateTime date = DateTime(int.parse(dateComponents[2]), int.parse(dateComponents[0]), int.parse(dateComponents[1]));


        db.collection('users').doc(auth.currentUser!.uid).set({
          'uid': auth.currentUser!.uid,
          'name': nameController.text.trim(),
          'email': emailController.text.trim(),
          'password': passwordController.text.trim(),
          'birthdate': date,
          'profileUrl': 'https://firebasestorage.googleapis.com/v0/b/circle-c9110.appspot.com/o/profilePic%2FdefaultPic.jpg?alt=media&token=8b185887-e399-4a1b-a822-88c7dbcd4a07',
          'aboutMe': 'Hello! I am a new user.',
          'interest': [],
          'instagram': "",
          'twitter': "",
          'facebook': "",
          'mymatch': []
        }).then((value) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Account created succesfully!'),
              backgroundColor: Colors.green,
            ),
          );
        }).catchError(
          (error) {
            
          }
        );
        // ignore: use_build_context_synchronously
        Navigator.pushReplacement(
          context, 
          MaterialPageRoute(builder: (context) =>  MasterPage(auth.currentUser!))
        );
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

}