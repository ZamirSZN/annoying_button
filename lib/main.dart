import 'package:flutter/material.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Annoying Form',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        primaryColor: Colors.black,
        fontFamily: "PulpDisplay",
      ),
      home: const HomeScreen(),
    );
  }
}

class HomeScreen extends StatefulWidget {
  const HomeScreen({
    super.key,
  });

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final TextEditingController emailController = TextEditingController();

  final TextEditingController passwordController = TextEditingController();

  Color buttonColor = Colors.grey.shade800;

  bool _isPasswordVisible = false;

  final GlobalKey<FormState> _annoyingFormKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    Size deviceScreen = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        centerTitle: true,
        title: const Text(
          "Annoying Form",
        ),
      ),
      body: Form(
        onChanged: () {
          // this might be kind of expensive
          final form = _annoyingFormKey.currentState;
          if (form!.validate()) {
            setState(() {
              buttonColor = Colors.green;
              isFormDirty = false;
            });
          } else {
            setState(() {
              buttonColor = Colors.grey.shade800;
              isFormDirty = true;
            });
          }
        },
        key: _annoyingFormKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: AnnoyedTextField(
                hintText: "Email",
                onSuffixIconPress: () {
                  emailController.clear();
                },
                preffixIconData: Icons.email_rounded,
                suffixIconData: Icons.close,
                textEditingController: emailController,
                textInputType: TextInputType.emailAddress,
                validator: (value) {
                  if (value!.isNotEmpty &&
                      value.length >= 8 &&
                      value.contains("@")) {
                    return null;
                  } else if (value.length < 5 && value.isNotEmpty) {
                    return "email is too short";
                  } else {
                    return "enter your real email \$h#@ head";
                  }
                },
                isPassword: false,
              ),
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(vertical: 8.0, horizontal: 15),
              child: AnnoyedTextField(
                hintText: "Password",
                onSuffixIconPress: () {
                  makePasswordVisible();
                },
                preffixIconData: Icons.password_rounded,
                suffixIconData: _isPasswordVisible
                    ? Icons.visibility_off
                    : Icons.visibility,
                textEditingController: passwordController,
                textInputType: TextInputType.visiblePassword,
                maxLines: 1,
                validator: (value) {
                  if (value!.isEmpty) {
                    return "please enter a password ";
                  } else if (value.length < 8 && value.isNotEmpty) {
                    return "password is too short, you punk";
                  } else {
                    return null;
                  }
                },
                isPassword: _isPasswordVisible ? false : true,
              ),
            ),
            SizedBox(
              height: 70,
              width: deviceScreen.width,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  AnnoyingButton(
                    color: buttonColor,
                    duration: const Duration(milliseconds: 150),
                    onTouch: () {},
                    child: const Text(
                      "Submit",
                      style: TextStyle(fontSize: 15, color: Colors.white),
                    ),
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void makePasswordVisible() {
    if (!_isPasswordVisible) {
      setState(() {
        _isPasswordVisible = true;
      });
    } else {
      setState(() {
        _isPasswordVisible = false;
      });
    }
  }
}

bool isFormDirty = true;

class AnnoyingButton extends StatefulWidget {
  const AnnoyingButton({
    super.key,
    required this.child,
    required this.duration,
    required this.onTouch,
    required this.color,
  });
  final Widget child;
  final Duration duration;
  final Function() onTouch;
  final Color color;

  @override
  State<AnnoyingButton> createState() => _AnnoyingButtonState();
}

class _AnnoyingButtonState extends State<AnnoyingButton>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late final Animation<Offset> _animation =
      Tween<Offset>(begin: Offset.zero, end: const Offset(1.1, 0))
          .animate(CurvedAnimation(parent: _controller, curve: Curves.easeIn));

  bool isButtonForward = false;

  @override
  void initState() {
    _controller = AnimationController(
      vsync: this,
      duration: widget.duration,
    );

    _controller.addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return SlideTransition(
      position: _animation,
      child: InkWell(
        onTapDown: (details) {
          widget.onTouch();
          checkFormState(isFormDirty);
        },
        child: Container(
            decoration: ShapeDecoration(
                color: widget.color,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10))),
            height: 40,
            width: 100,
            child: Center(child: widget.child)),
      ),
    );
  }

  void checkFormState(bool isClean) {
    bool isFormClean = isClean;
    if (isFormClean && !isButtonForward) {
      _controller.forward();
      isButtonForward = true;
    } else if (isFormClean && isButtonForward) {
      _controller.reverse();
      isButtonForward = false;
    }
  }
}

class AnnoyedTextField extends StatefulWidget {
  const AnnoyedTextField({
    Key? key,
    required this.hintText,
    this.isPassword = false,
    required this.textInputType,
    required this.textEditingController,
    required this.preffixIconData,
    required this.suffixIconData,
    required this.onSuffixIconPress,
    required this.validator,
    this.maxLines,
  }) : super(key: key);
  final String hintText;
  final bool isPassword;
  final TextInputType textInputType;
  final TextEditingController textEditingController;
  final IconData preffixIconData;
  final IconData suffixIconData;
  final VoidCallback onSuffixIconPress;
  final String? Function(String?)? validator;
  final dynamic maxLines;

  @override
  State<AnnoyedTextField> createState() => _AnnoyedTextFieldState();
}

class _AnnoyedTextFieldState extends State<AnnoyedTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      onChanged: (value) {
        setState(() {});
      },
      validator: widget.validator,
      controller: widget.textEditingController,
      onEditingComplete: () {},
      keyboardType: widget.textInputType,
      autofocus: false,
      maxLines: widget.maxLines,
      cursorColor: Colors.black,
      obscureText: widget.isPassword,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        fillColor: Colors.orange,
        contentPadding: const EdgeInsets.all(15.0),
        hintText: widget.hintText,
        hintStyle: const TextStyle(
          color: Colors.grey,
        ),
        prefixIcon: Icon(
          widget.preffixIconData,
          color: Colors.black,
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.red,
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.red,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
            width: 1,
            style: BorderStyle.solid,
            color: Colors.black,
          ),
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(15.0),
          borderSide: const BorderSide(
              width: 1, style: BorderStyle.solid, color: Colors.black54),
        ),
        counterStyle: const TextStyle(color: Colors.black),
        focusColor: Colors.black,
        suffixIcon: IconButton(
          onPressed: () {
            widget.onSuffixIconPress();
          },
          icon: Icon(widget.suffixIconData),
          color: Colors.black,
        ),
      ),
      style: const TextStyle(
        color: Colors.black,
      ),
    );
  }
}
