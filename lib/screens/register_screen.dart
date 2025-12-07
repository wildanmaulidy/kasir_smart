import 'package:flutter/material.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:firebase_core/firebase_core.dart';
import '../firebase_options.dart';
import '../widgets/animated_background.dart';

/// A screen that handles user registration with email/password and Google Sign-In
/// 
/// This screen provides:
/// - Email/password registration with validation
/// - Google Sign-In integration
/// - Proper error handling and loading states
/// - Accessibility support
/// - Performance optimizations
class RegisterScreen extends StatefulWidget {
  /// Creates a [RegisterScreen]
  /// 
  /// The [key] parameter is used to control how one widget replaces another
  /// widget in the tree. Using [super.key] follows Flutter best practices.
  const RegisterScreen({super.key});

  @override
  State<RegisterScreen> createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  // Firebase services - initialized once and reused
  static final FirebaseAuth _auth = FirebaseAuth.instance;
  static final GoogleSignIn _googleSignIn = GoogleSignIn();

  // Form and loading state
  bool _isLoading = false;
  final _formKey = GlobalKey<FormState>();
  
  // Text editing controllers for better memory management and performance
  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _passwordController;
  late final TextEditingController _confirmPasswordController;
  
  // Password visibility state
  bool _isPasswordVisible = false;
  bool _isConfirmPasswordVisible = false;

  @override
  void initState() {
    super.initState();
    // Initialize controllers in initState for better performance
    _nameController = TextEditingController();
    _emailController = TextEditingController();
    _passwordController = TextEditingController();
    _confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    // Dispose controllers to prevent memory leaks
    _nameController.dispose();
    _emailController.dispose();
    _passwordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  /// Handles Google Sign-In with comprehensive error handling
  Future<void> _signInWithGoogle() async {
    if (!mounted) return;
    
    setState(() => _isLoading = true);

    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      // Trigger the authentication flow
      final GoogleSignInAccount? googleUser = await _googleSignIn.signIn();

      if (googleUser == null) {
        // User canceled the sign-in
        if (mounted) {
          setState(() => _isLoading = false);
        }
        return;
      }

      // Obtain the auth details from the request
      final GoogleSignInAuthentication googleAuth = await googleUser.authentication;

      // Create a new credential
      final credential = GoogleAuthProvider.credential(
        accessToken: googleAuth.accessToken,
        idToken: googleAuth.idToken,
      );

      // Sign in with the credential
      final UserCredential userCredential = await _auth.signInWithCredential(credential);
      
      // Verify the user was created successfully
      if (userCredential.user != null && mounted) {
        _navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _showErrorSnackBar(_getFirebaseErrorMessage(e));
      }
    } on Exception catch (e) {
      if (mounted) {
        _showErrorSnackBar('Terjadi kesalahan: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Handles email/password registration with validation and error handling
  Future<void> _registerWithEmailPassword() async {
    if (!_formKey.currentState!.validate() || !mounted) {
      return;
    }

    setState(() => _isLoading = true);

    try {
      // Check if Firebase is initialized
      if (Firebase.apps.isEmpty) {
        await Firebase.initializeApp(
          options: DefaultFirebaseOptions.currentPlatform,
        );
      }

      final UserCredential userCredential = await _auth.createUserWithEmailAndPassword(
        email: _emailController.text.trim(),
        password: _passwordController.text,
      );

      // Update display name if provided
      if (_nameController.text.trim().isNotEmpty && userCredential.user != null) {
        await userCredential.user!.updateDisplayName(_nameController.text.trim());
        await userCredential.user!.reload();
      }

      // Send email verification
      if (userCredential.user != null && !userCredential.user!.emailVerified) {
        await userCredential.user!.sendEmailVerification();
        if (mounted) {
          _showSuccessSnackBar('Email verifikasi telah dikirim. Silakan periksa inbox Anda.');
        }
      }

      if (mounted) {
        _navigateToHome();
      }
    } on FirebaseAuthException catch (e) {
      if (mounted) {
        _showErrorSnackBar(_getFirebaseErrorMessage(e));
      }
    } on Exception catch (e) {
      if (mounted) {
        _showErrorSnackBar('Pendaftaran gagal: ${e.toString()}');
      }
    } finally {
      if (mounted) {
        setState(() => _isLoading = false);
      }
    }
  }

  /// Provides user-friendly error messages for Firebase Auth exceptions
  String _getFirebaseErrorMessage(FirebaseAuthException e) {
    switch (e.code) {
      case 'weak-password':
        return 'Password terlalu lemah. Gunakan kombinasi huruf, angka, dan simbol.';
      case 'email-already-in-use':
        return 'Email sudah terdaftar. Silakan gunakan email lain atau masuk ke akun Anda.';
      case 'invalid-email':
        return 'Format email tidak valid.';
      case 'operation-not-allowed':
        return 'Pendaftaran dengan email/password tidak diizinkan.';
      case 'network-request-failed':
        return 'Koneksi internet bermasalah. Silakan coba lagi.';
      case 'too-many-requests':
        return 'Terlalu banyak percobaan. Silakan tunggu beberapa saat.';
      default:
        return 'Terjadi kesalahan: ${e.message ?? 'Unknown error'}';
    }
  }

  /// Shows error message in a SnackBar
  void _showErrorSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.red,
        behavior: SnackBarBehavior.floating,
        action: SnackBarAction(
          label: 'Tutup',
          textColor: Colors.white,
          onPressed: () => ScaffoldMessenger.of(context).hideCurrentSnackBar(),
        ),
      ),
    );
  }

  /// Shows success message in a SnackBar
  void _showSuccessSnackBar(String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: Colors.green,
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  /// Navigates to home screen
  void _navigateToHome() {
    Navigator.of(context).pushReplacementNamed('/home');
  }

  /// Enhanced email validator with more comprehensive checks
  String? _validateEmail(String? value) {
    if (value == null || value.trim().isEmpty) {
      return 'Email tidak boleh kosong';
    }
    
    final email = value.trim();
    if (!RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$').hasMatch(email)) {
      return 'Format email tidak valid';
    }
    
    if (email.length > 254) {
      return 'Email terlalu panjang';
    }
    
    return null;
  }

  /// Enhanced password validator with strength requirements
  String? _validatePassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Password tidak boleh kosong';
    }
    
    if (value.length < 8) {
      return 'Password minimal 8 karakter';
    }
    
    if (value.length > 128) {
      return 'Password maksimal 128 karakter';
    }
    
    // Check for at least one uppercase letter
    if (!RegExp(r'[A-Z]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 huruf besar';
    }
    
    // Check for at least one lowercase letter
    if (!RegExp(r'[a-z]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 huruf kecil';
    }
    
    // Check for at least one digit
    if (!RegExp(r'[0-9]').hasMatch(value)) {
      return 'Password harus mengandung minimal 1 angka';
    }
    
    return null;
  }

  /// Validates password confirmation
  String? _validateConfirmPassword(String? value) {
    if (value == null || value.isEmpty) {
      return 'Konfirmasi password tidak boleh kosong';
    }
    
    if (value != _passwordController.text) {
      return 'Password tidak cocok';
    }
    
    return null;
  }

  /// Builds a custom text field with consistent styling
  Widget _buildTextField({
    required TextEditingController controller,
    required String labelText,
    required IconData prefixIcon,
    required String? Function(String?) validator,
    TextInputType keyboardType = TextInputType.text,
    bool obscureText = false,
    bool isPassword = false,
    VoidCallback? onVisibilityToggle,
    bool isVisible = false,
  }) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        labelStyle: const TextStyle(color: Colors.white70),
        prefixIcon: Icon(prefixIcon, color: Colors.white70),
        suffixIcon: isPassword
            ? IconButton(
                icon: Icon(
                  isVisible ? Icons.visibility : Icons.visibility_off,
                  color: Colors.white70,
                ),
                onPressed: onVisibilityToggle,
              )
            : null,
        enabledBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.white30),
        ),
        focusedBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Color(0xFF3B82F6)),
        ),
        errorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
        focusedErrorBorder: const UnderlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      style: const TextStyle(color: Colors.white),
      keyboardType: keyboardType,
      obscureText: obscureText,
      validator: validator,
      textInputAction: TextInputAction.next,
      autocorrect: false,
      enableSuggestions: !obscureText,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const AnimatedBackground(),
          SafeArea(
            child: Center(
              child: SingleChildScrollView(
                padding: const EdgeInsets.all(24),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    // Logo and App Name
                    Hero(
                      tag: 'app_logo',
                      child: Container(
                        padding: const EdgeInsets.all(24),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            colors: [Color(0xFF3B82F6), Color(0xFF1D4ED8)],
                          ),
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: const Color(0xFF3B82F6).withOpacity(0.3),
                              blurRadius: 20,
                              offset: const Offset(0, 10),
                            ),
                          ],
                        ),
                        child: const Icon(
                          Icons.store,
                          color: Colors.white,
                          size: 64,
                          semanticLabel: 'Logo Kasir Smart',
                        ),
                      ),
                    ),

                    const SizedBox(height: 32),

                    const Text(
                      'KASIR SMART',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 32,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                    const SizedBox(height: 8),

                    Text(
                      'Belanja Mudah & Cepat',
                      style: TextStyle(
                        color: Colors.white.withOpacity(0.8),
                        fontSize: 16,
                      ),
                    ),

                    const SizedBox(height: 64),

                    // Registration Card
                    Container(
                      padding: const EdgeInsets.all(32),
                      decoration: BoxDecoration(
                        color: const Color(0xFF1E293B),
                        borderRadius: BorderRadius.circular(20),
                        border: Border.all(
                          color: const Color(0xFF3B82F6).withOpacity(0.2),
                        ),
                      ),
                      child: Column(
                        children: [
                          const Text(
                            'Daftar Akun Baru',
                            style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),

                          const SizedBox(height: 8),

                          Text(
                            'Daftar dengan email dan password atau akun Google',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.7),
                              fontSize: 14,
                            ),
                            textAlign: TextAlign.center,
                          ),

                          const SizedBox(height: 32),

                          // Registration Form
                          Form(
                            key: _formKey,
                            child: Column(
                              children: [
                                // Name Field
                                _buildTextField(
                                  controller: _nameController,
                                  labelText: 'Nama (Opsional)',
                                  prefixIcon: Icons.person,
                                  validator: (value) => null, // Optional field
                                ),
                                const SizedBox(height: 16),

                                // Email Field
                                _buildTextField(
                                  controller: _emailController,
                                  labelText: 'Email',
                                  prefixIcon: Icons.email,
                                  keyboardType: TextInputType.emailAddress,
                                  validator: _validateEmail,
                                ),
                                const SizedBox(height: 16),

                                // Password Field
                                _buildTextField(
                                  controller: _passwordController,
                                  labelText: 'Password',
                                  prefixIcon: Icons.lock,
                                  obscureText: !_isPasswordVisible,
                                  isPassword: true,
                                  isVisible: _isPasswordVisible,
                                  onVisibilityToggle: () {
                                    setState(() {
                                      _isPasswordVisible = !_isPasswordVisible;
                                    });
                                  },
                                  validator: _validatePassword,
                                ),
                                const SizedBox(height: 16),

                                // Confirm Password Field
                                _buildTextField(
                                  controller: _confirmPasswordController,
                                  labelText: 'Konfirmasi Password',
                                  prefixIcon: Icons.lock_outline,
                                  obscureText: !_isConfirmPasswordVisible,
                                  isPassword: true,
                                  isVisible: _isConfirmPasswordVisible,
                                  onVisibilityToggle: () {
                                    setState(() {
                                      _isConfirmPasswordVisible = !_isConfirmPasswordVisible;
                                    });
                                  },
                                  validator: _validateConfirmPassword,
                                ),
                                const SizedBox(height: 24),

                                // Register Button
                                SizedBox(
                                  width: double.infinity,
                                  height: 50,
                                  child: ElevatedButton(
                                    onPressed: _isLoading ? null : _registerWithEmailPassword,
                                    style: ElevatedButton.styleFrom(
                                      backgroundColor: const Color(0xFF10B981),
                                      foregroundColor: Colors.white,
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      elevation: 2,
                                    ),
                                    child: _isLoading
                                        ? const SizedBox(
                                            width: 20,
                                            height: 20,
                                            child: CircularProgressIndicator(
                                              strokeWidth: 2,
                                              valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                            ),
                                          )
                                        : const Text(
                                            'Daftar',
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.w600,
                                            ),
                                          ),
                                  ),
                                ),
                                const SizedBox(height: 16),

                                // Divider
                                Row(
                                  children: [
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withOpacity(0.3),
                                        thickness: 1,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.symmetric(horizontal: 16),
                                      child: Text(
                                        'atau',
                                        style: TextStyle(
                                          color: Colors.white.withOpacity(0.7),
                                          fontSize: 14,
                                        ),
                                      ),
                                    ),
                                    Expanded(
                                      child: Divider(
                                        color: Colors.white.withOpacity(0.3),
                                        thickness: 1,
                                      ),
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 16),
                              ],
                            ),
                          ),

                          // Google Sign In Button
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton.icon(
                              onPressed: _isLoading ? null : _signInWithGoogle,
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white,
                                foregroundColor: Colors.black87,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                                elevation: 2,
                              ),
                              icon: _isLoading
                                  ? const SizedBox(
                                      width: 20,
                                      height: 20,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                        valueColor: AlwaysStoppedAnimation<Color>(Colors.black87),
                                      ),
                                    )
                                  : Image.asset(
                                      'assets/images/google_logo.png',
                                      width: 20,
                                      height: 20,
                                      errorBuilder: (context, error, stackTrace) {
                                        return const Icon(
                                          Icons.account_circle,
                                          color: Colors.black87,
                                        );
                                      },
                                    ),
                              label: Text(
                                _isLoading ? 'Sedang Mendaftar...' : 'Daftar dengan Google',
                                style: const TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                            ),
                          ),

                          const SizedBox(height: 24),

                          // Terms and Privacy
                          Text(
                            'Dengan masuk, Anda menyetujui\nSyarat & Ketentuan dan Kebijakan Privasi kami',
                            style: TextStyle(
                              color: Colors.white.withOpacity(0.6),
                              fontSize: 12,
                            ),
                            textAlign: TextAlign.center,
                          ),
                        ],
                      ),
                    ),

                    const SizedBox(height: 32),

                    // Guest Access
                    TextButton(
                      onPressed: () => _navigateToHome(),
                      child: Text(
                        'Lanjutkan sebagai Tamu',
                        style: TextStyle(
                          color: const Color(0xFF3B82F6).withOpacity(0.8),
                          fontSize: 14,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}