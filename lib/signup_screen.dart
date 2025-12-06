import 'package:chiluka_useer/splash_screen.dart';
import 'package:chiluka_useer/home_screen.dart';
import 'bottom_navigation.dart';
import 'package:flutter/material.dart';

class LoginScreen extends StatefulWidget {
  const LoginScreen({super.key});

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  final Color _primaryColor = const Color(0xFFFDDB4D);
  final TextEditingController _emailController = TextEditingController();
  final List<TextEditingController> _otpControllers = List.generate(4, (index) => TextEditingController());
  final List<FocusNode> _otpFocusNodes = List.generate(4, (index) => FocusNode());
  
  bool _isEmailSubmitted = false;
  bool _isLoading = false;

  @override
  void initState() {
    super.initState();
    for (int i = 0; i < _otpFocusNodes.length; i++) {
      _otpFocusNodes[i].addListener(() {
        if (!_otpFocusNodes[i].hasFocus && i < _otpFocusNodes.length - 1) {
          FocusScope.of(context).requestFocus(_otpFocusNodes[i + 1]);
        }
      });
    }
  }

  @override
  void dispose() {
    _emailController.dispose();
    for (var controller in _otpControllers) {
      controller.dispose();
    }
    for (var focusNode in _otpFocusNodes) {
      focusNode.dispose();
    }
    super.dispose();
  }

  void _submitEmail() async {
    if (_emailController.text.isEmpty || !_emailController.text.contains('@')) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a valid email'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
      _isEmailSubmitted = true;
    });

    FocusScope.of(context).requestFocus(_otpFocusNodes[0]);
  }

  void _verifyOtp() async {
    String otp = '';
    for (var controller in _otpControllers) {
      otp += controller.text;
    }

    if (otp.length != 4) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter complete 4-digit OTP'),
          backgroundColor: Colors.red.shade400,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    await Future.delayed(const Duration(seconds: 2));

    if (!mounted) return;

    setState(() {
      _isLoading = false;
    });

    Navigator.of(context).pushReplacement(
      MaterialPageRoute(
        builder: (context) => const MainScreen()
      ),
    );
  }

  void _handleOtpChange(String value, int index) {
    if (value.length == 1 && index < _otpControllers.length - 1) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index + 1]);
    } else if (value.isEmpty && index > 0) {
      FocusScope.of(context).requestFocus(_otpFocusNodes[index - 1]);
    }
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size;
    final keyboardVisible = MediaQuery.of(context).viewInsets.bottom > 0;
    
    return Scaffold(
      backgroundColor: Colors.white,
      resizeToAvoidBottomInset: true,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Column(
                    children: [
                      // Top Image Section - Responsive
                      if (!keyboardVisible)
                        Container(
                          height: size.height * 0.45,
                          width: double.infinity,
                          decoration: BoxDecoration(
                            gradient: LinearGradient(
                              begin: Alignment.topCenter,
                              end: Alignment.bottomCenter,
                              colors: [
                                _primaryColor.withOpacity(0.15),
                                _primaryColor.withOpacity(0.05),
                                Colors.white,
                              ],
                            ),
                          ),
                          child: Stack(
                            children: [
                              Positioned.fill(
                                child: Image.asset(
                                  'assets/image.png',
                                  fit: BoxFit.cover,
                                ),
                              ),
                              // Gradient overlay for smooth transition
                              Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                height: 50,
                                child: Container(
                                  decoration: BoxDecoration(
                                    gradient: LinearGradient(
                                      begin: Alignment.topCenter,
                                      end: Alignment.bottomCenter,
                                      colors: [
                                        Colors.transparent,
                                        Colors.white,
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ],
                          ),
                        ),
                      
                      // Bottom Input Section
                      Expanded(
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(
                            horizontal: size.width * 0.06,
                            vertical: 20,
                          ),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              if (!_isEmailSubmitted)
                                _buildEmailSection()
                              else
                                _buildOtpSection(),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  Widget _buildEmailSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Welcome Back!',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Text(
          'Enter your email to receive a verification code',
          textAlign: TextAlign.center,
          style: TextStyle(
            fontSize: 15,
            color: Colors.grey[600],
            height: 1.4,
          ),
        ),
        const SizedBox(height: 32),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: _primaryColor.withOpacity(0.1),
                blurRadius: 20,
                offset: const Offset(0, 10),
              ),
            ],
          ),
          child: TextField(
            controller: _emailController,
            keyboardType: TextInputType.emailAddress,
            style: const TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w500,
            ),
            decoration: InputDecoration(
              hintText: 'example@email.com',
              hintStyle: TextStyle(color: Colors.grey[400]),
              filled: true,
              fillColor: Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
              ),
              enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
              ),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(16),
                borderSide: BorderSide(color: _primaryColor, width: 2.5),
              ),
              contentPadding: const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 18,
              ),
              prefixIcon: Container(
                margin: const EdgeInsets.only(left: 12, right: 8),
                child: Icon(
                  Icons.email_outlined,
                  color: Colors.grey[600],
                  size: 22,
                ),
              ),
            ),
          ),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _submitEmail,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
              shadowColor: _primaryColor.withOpacity(0.3),
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.black87,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Send Code',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.arrow_forward_rounded, size: 22),
                    ],
                  ),
          ),
        ),
      ],
    );
  }

  Widget _buildOtpSection() {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(
          'Verify Your Email',
          style: TextStyle(
            fontSize: 28,
            fontWeight: FontWeight.bold,
            color: Colors.grey[900],
            letterSpacing: -0.5,
          ),
        ),
        const SizedBox(height: 8),
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16),
          child: Text(
            'Enter the 4-digit code sent to\n${_emailController.text}',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey[600],
              height: 1.4,
            ),
          ),
        ),
        const SizedBox(height: 32),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: List.generate(4, (index) {
            return Container(
              width: MediaQuery.of(context).size.width * 0.18,
              height: 64,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color: _primaryColor.withOpacity(0.1),
                    blurRadius: 15,
                    offset: const Offset(0, 8),
                  ),
                ],
              ),
              child: TextField(
                controller: _otpControllers[index],
                focusNode: _otpFocusNodes[index],
                keyboardType: TextInputType.number,
                textAlign: TextAlign.center,
                maxLength: 1,
                style: const TextStyle(
                  fontSize: 28,
                  fontWeight: FontWeight.bold,
                ),
                onChanged: (value) => _handleOtpChange(value, index),
                decoration: InputDecoration(
                  counterText: '',
                  filled: true,
                  fillColor: Colors.white,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(color: Colors.grey[200]!, width: 1.5),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(16),
                    borderSide: BorderSide(
                      color: _primaryColor,
                      width: 2.5,
                    ),
                  ),
                ),
              ),
            );
          }),
        ),
        const SizedBox(height: 24),
        SizedBox(
          width: double.infinity,
          height: 56,
          child: ElevatedButton(
            onPressed: _isLoading ? null : _verifyOtp,
            style: ElevatedButton.styleFrom(
              backgroundColor: _primaryColor,
              foregroundColor: Colors.black87,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(16),
              ),
              elevation: 0,
            ),
            child: _isLoading
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child: CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.black87,
                    ),
                  )
                : const Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'Verify',
                        style: TextStyle(
                          fontSize: 17,
                          fontWeight: FontWeight.bold,
                          letterSpacing: 0.3,
                        ),
                      ),
                      SizedBox(width: 10),
                      Icon(Icons.check_circle_outline_rounded, size: 22),
                    ],
                  ),
          ),
        ),
        const SizedBox(height: 16),
        TextButton(
          onPressed: _isLoading
              ? null
              : () {
                  setState(() {
                    _isEmailSubmitted = false;
                    for (var controller in _otpControllers) {
                      controller.clear();
                    }
                  });
                },
          style: TextButton.styleFrom(
            padding: const EdgeInsets.symmetric(horizontal: 24, vertical: 12),
          ),
          child: Text(
            'Change Email',
            style: TextStyle(
              color: Colors.grey[700],
              fontSize: 15,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
      ],
    );
  }
}