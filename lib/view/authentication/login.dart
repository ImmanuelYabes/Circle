import 'package:circle/constant/constant_builder.dart';
import 'package:circle/constant/firebase_constant.dart';
import 'package:circle/view/authentication/register.dart';
import 'package:circle/view/master.dart';
import 'package:circle/view/widget/input_box.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  bool isLoading = false;
  bool obscure = true;

  @override
  void dispose(){
    emailController.dispose();
    passwordController.dispose();
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
        resizeToAvoidBottomInset: false,
        body: Form(
          key: formKey,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 40),
            width: double.infinity,
            height: double.infinity,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
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
                  width: double.infinity,
                  child: const Text(
                    'Login',
                    style: TextStyle(
                      fontSize: 40,
                      fontWeight: FontWeight.bold,
                      color: fontColor,
                    ),
                  )
                ),
                Container(
                  margin: const EdgeInsets.only(top: 10),
                  width: double.infinity,
                  child: const Text(
                    'Please sign in to continue',
                    style: TextStyle(
                      fontSize: 20,
                      color: fontColor,
                    ),
                  )
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
                    decoration: inputDec('Email', const Icon(Icons.email_outlined) ,hint: 'email@example.com'),
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
                    decoration: inputDec('Password', const Icon(Icons.lock_outline_rounded), isPassword: true ,obscure: obscure, togglePass:  (value) {setState(() {
                      obscure = value;
                    });},),
                  ),
                ),
                Expanded(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      Container(
                        margin: const EdgeInsets.symmetric(vertical: 15),
                        child: Align(
                          alignment: Alignment.bottomCenter,
                          child: SizedBox(
                            width: double.infinity,
                            child: ElevatedButton(
                              onPressed: isLoading ? null : login,
                              
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
                                  'Login',
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
                            Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => const RegisterPage()));
                          },
                          child: RichText(
                            text: TextSpan(
                              text: 'Don\'t have an account?',
                              style: styleR15,
                              children: const [
                                TextSpan(
                                  text: ' Sign Up',
                                  style: TextStyle(
                                    color: appPurple,
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
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  void pushPage(User user){
    Navigator.pushReplacement(
      context, 
      MaterialPageRoute(builder: (context) => MasterPage(user))
    );
  }

  Future login() async{
    if(formKey.currentState!.validate()) {
      setState(() {
        isLoading = true;
      });
      try {
        await FirebaseAuth.instance.signInWithEmailAndPassword(
          email: emailController.text.trim(),
          password: passwordController.text.trim()
        );
        
        pushPage(auth.currentUser!);

      } on FirebaseAuthException catch (e) {
        String errorMessage = "An error occurred. Please try again later.";
        if (e.code == 'user-not-found') {
          errorMessage = 'No user found!';
        } else if (e.code == 'wrong-password') {
          errorMessage = 'Wrong password provided for that user!';
        } else {
          errorMessage = 'An error occurred. Please try again later.';
        }
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(errorMessage),
            backgroundColor: Colors.red,
          ),
        );
      } finally {
        setState(() {
          isLoading = false;
        });
      }
    }
    
  }

}