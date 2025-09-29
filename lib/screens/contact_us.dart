import 'package:flutter/material.dart';
import '../services/contact_service.dart';
import '../services/firebase_service.dart';

class ContactUsScreen extends StatefulWidget {
  const ContactUsScreen({super.key});

  @override
  State<ContactUsScreen> createState() => _ContactUsScreenState();
}

class _ContactUsScreenState extends State<ContactUsScreen> {
  final _formKey = GlobalKey<FormState>();
  final _nameController = TextEditingController();
  final _emailController = TextEditingController();
  final _messageController = TextEditingController();
  bool _isLoading = false;
  bool _isLoadingUserData = false;

  @override
  void initState() {
    super.initState();
    _loadCurrentUserData();
  }

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _messageController.dispose();
    super.dispose();
  }

  Future<void> _loadCurrentUserData() async {
    setState(() {
      _isLoadingUserData = true;
    });

    try {
      // Check if Firebase is initialized and user is available
      final currentUser = FirebaseService.currentUser;
      if (currentUser != null) {
        String displayName = '';
        String email = '';

        // Try to get user profile from Firestore first
        try {
          final userProfile = await FirebaseService.getUserProfile(
            currentUser.uid,
          );

          if (userProfile != null) {
            displayName = userProfile.displayName;
            email = userProfile.email;
          }
        } catch (e) {
          print('Error getting user profile from Firestore: $e');
        }

        // Fallback to Firebase Auth user data if Firestore data is empty
        if (displayName.isEmpty) {
          displayName = currentUser.displayName ?? '';
        }
        if (email.isEmpty) {
          email = currentUser.email ?? '';
        }

        // Set the controllers with the obtained data
        _nameController.text = displayName;
        _emailController.text = email;

        print('Loaded user data - Name: $displayName, Email: $email');
      }
    } catch (e) {
      print('Error loading user data: $e');
      // In case of any error (e.g., Firebase not initialized), leave fields empty
      // This allows the app to work in test environments or when Firebase is unavailable
    } finally {
      if (mounted) {
        setState(() {
          _isLoadingUserData = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios, color: Colors.grey.shade800),
          onPressed: () => Navigator.pop(context),
        ),
        title: Text(
          'Contact Us',
          style: TextStyle(
            color: Colors.grey.shade800,
            fontWeight: FontWeight.bold,
          ),
        ),
        centerTitle: true,
      ),
      body: SafeArea(
        child: Padding(
          padding: EdgeInsets.all(screenHeight * 0.03),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header section
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(24),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      Icon(
                        Icons.contact_support,
                        size: 64,
                        color: Colors.blue.shade600,
                      ),
                      const SizedBox(height: 16),
                      Text(
                        'Get in Touch',
                        style: TextStyle(
                          fontSize: 24,
                          fontWeight: FontWeight.bold,
                          color: Colors.grey.shade800,
                        ),
                      ),
                      const SizedBox(height: 8),
                      Text(
                        'We\'d love to hear from you. Send us a message and we\'ll respond as soon as possible.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.grey.shade600,
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),

                // Contact options
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.shade200,
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Column(
                    children: [
                      _buildContactOption(
                        icon: Icons.email_outlined,
                        title: 'Email',
                        subtitle: 'support@taskapp.com',
                        color: Colors.red.shade600,
                      ),
                      const SizedBox(height: 16),
                      _buildContactOption(
                        icon: Icons.phone_outlined,
                        title: 'Phone',
                        subtitle: '+1 (555) 123-4567',
                        color: Colors.green.shade600,
                      ),
                      const SizedBox(height: 16),
                      _buildContactOption(
                        icon: Icons.location_on_outlined,
                        title: 'Address',
                        subtitle: '123 Main St, City, State 12345',
                        color: Colors.orange.shade600,
                      ),
                      const SizedBox(height: 24),

                      // Send message button
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            // Show message dialog
                            _showMessageDialog(context);
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.blue.shade600,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          child: const Text(
                            'Send Message',
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
                // Add some bottom padding to ensure content is not cut off
                SizedBox(height: screenHeight * 0.05),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildContactOption({
    required IconData icon,
    required String title,
    required String subtitle,
    required Color color,
  }) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: Colors.white, size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.grey.shade800,
                  ),
                ),
                Text(
                  subtitle,
                  style: TextStyle(fontSize: 14, color: Colors.grey.shade600),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  void _showMessageDialog(BuildContext context) {
    showDialog(
      context: context,
      barrierDismissible: !_isLoading,
      builder: (context) => StatefulBuilder(
        builder: (context, setDialogState) => AlertDialog(
          title: Row(
            children: [
              Icon(Icons.message, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text('Send Message'),
            ],
          ),
          content: Form(
            key: _formKey,
            child: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Show info if user is authenticated
                  if (_isUserAuthenticated())
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: Colors.blue.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.blue.shade200),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.lock,
                            color: Colors.blue.shade600,
                            size: 20,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              'Name and email are locked to your current account for security.',
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.blue.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  if (_isUserAuthenticated()) const SizedBox(height: 16),
                  TextFormField(
                    controller: _nameController,
                    enabled: !_isLoading,
                    readOnly: _isUserAuthenticated(),
                    decoration: InputDecoration(
                      labelText: 'Name *',
                      hintText: _isLoadingUserData
                          ? 'Loading...'
                          : _isUserAuthenticated()
                          ? 'Locked to current user'
                          : 'Enter your name',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.person),
                      suffixIcon: _isLoadingUserData
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : _isUserAuthenticated()
                          ? Icon(Icons.lock, color: Colors.grey.shade600)
                          : null,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return _isUserAuthenticated()
                            ? 'Account name not found. Please update your profile.'
                            : 'Please enter your name';
                      }
                      if (value.trim().length < 2) {
                        return 'Name must be at least 2 characters';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _emailController,
                    enabled: !_isLoading,
                    readOnly: _isUserAuthenticated(),
                    keyboardType: TextInputType.emailAddress,
                    decoration: InputDecoration(
                      labelText: 'Email *',
                      hintText: _isLoadingUserData
                          ? 'Loading...'
                          : _isUserAuthenticated()
                          ? 'Locked to current user'
                          : 'Enter your email',
                      border: const OutlineInputBorder(),
                      prefixIcon: const Icon(Icons.email),
                      suffixIcon: _isLoadingUserData
                          ? const SizedBox(
                              width: 16,
                              height: 16,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            )
                          : _isUserAuthenticated()
                          ? Icon(Icons.lock, color: Colors.grey.shade600)
                          : null,
                    ),
                    validator: (value) {
                      if (value == null || value.trim().isEmpty) {
                        return _isUserAuthenticated()
                            ? 'Account email not found. Please update your profile.'
                            : 'Please enter your email';
                      }
                      if (!_isValidEmail(value.trim())) {
                        return 'Please enter a valid email address';
                      }
                      return null;
                    },
                  ),
                  const SizedBox(height: 16),
                  TextFormField(
                    controller: _messageController,
                    enabled: !_isLoading,
                    maxLines: 4,
                    maxLength: 500,
                    decoration: const InputDecoration(
                      labelText: 'Message *',
                      hintText: 'Type your message here...',
                      border: OutlineInputBorder(),
                      prefixIcon: Icon(Icons.message),
                    ),
                    validator: _validateMessage,
                  ),
                ],
              ),
            ),
          ),
          actions: [
            TextButton(
              onPressed: _isLoading
                  ? null
                  : () {
                      _clearForm();
                      Navigator.pop(context);
                    },
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: _isLoading
                  ? null
                  : () async {
                      await _sendMessage(context, setDialogState);
                    },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.blue.shade600,
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
                  : const Text('Send', style: TextStyle(color: Colors.white)),
            ),
          ],
        ),
      ),
    );
  }

  bool _isValidEmail(String email) {
    return RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$').hasMatch(email);
  }

  bool _isUserAuthenticated() {
    try {
      return FirebaseService.currentUser != null;
    } catch (e) {
      // If Firebase is not initialized or there's any error, return false
      return false;
    }
  }

  String? _validateMessage(String? value) {
    try {
      if (value == null || value.trim().isEmpty) {
        return 'Please enter your message';
      }

      final trimmedValue = value.trim();

      // Minimum length check
      if (trimmedValue.length < 10) {
        return 'Message must be at least 10 characters (currently ${trimmedValue.length})';
      }

      // Maximum length check (additional safety)
      if (trimmedValue.length > 500) {
        return 'Message is too long (maximum 500 characters)';
      }

      // Check for meaningful content (not just repeated characters)
      final uniquePattern = trimmedValue.replaceAll(RegExp(r'(.)\1*'), '\$1');
      if (uniquePattern.length < 5) {
        return 'Please enter a meaningful message (avoid repeated characters)';
      }

      // Check for basic content quality (at least some letters or numbers)
      if (!RegExp(r'[a-zA-Z0-9]').hasMatch(trimmedValue)) {
        return 'Message must contain letters or numbers';
      }

      return null; // Valid message
    } catch (e) {
      // Handle any unexpected errors in validation
      return 'Invalid message format. Please try again.';
    }
  }

  void _clearForm() {
    // Only clear name and email if user is not authenticated
    // For authenticated users, these fields should remain locked to their account
    if (!_isUserAuthenticated()) {
      _nameController.clear();
      _emailController.clear();
    }
    _messageController.clear();
  }

  Future<void> _sendMessage(
    BuildContext context,
    StateSetter setDialogState,
  ) async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setDialogState(() {
      _isLoading = true;
    });

    setState(() {
      _isLoading = true;
    });

    try {
      // Additional validation before sending
      final messageValidation = _validateMessage(_messageController.text);
      if (messageValidation != null) {
        throw Exception('Message validation failed: $messageValidation');
      }

      // Ensure message meets minimum requirements
      final messageText = _messageController.text.trim();
      if (messageText.length < 10) {
        throw Exception('Message must be at least 10 characters long');
      }

      // Save message to Firebase
      final success = await ContactService.saveContactMessage(
        name: _nameController.text.trim(),
        email: _emailController.text.trim(),
        message: messageText,
      );

      if (success) {
        _clearForm();
        if (context.mounted) {
          Navigator.pop(context);
          _showSuccessFeedback(context);
        }
      } else {
        throw Exception(
          'Failed to send message. Please check your connection and try again.',
        );
      }
    } catch (e) {
      if (context.mounted) {
        _showErrorFeedback(context, e.toString());
      }
    } finally {
      if (mounted) {
        setDialogState(() {
          _isLoading = false;
        });
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showSuccessFeedback(BuildContext context) {
    // Show success snackbar
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.check_circle, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Message saved successfully!',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Your message has been saved to our database. We\'ll get back to you within 24 hours.',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.green.shade100,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.green,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'OK',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
          },
        ),
      ),
    );

    // Show success dialog with animation
    showDialog(
      context: context,
      barrierDismissible: true,
      builder: (context) => AlertDialog(
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TweenAnimationBuilder(
              tween: Tween<double>(begin: 0, end: 1),
              duration: const Duration(milliseconds: 600),
              builder: (context, double value, child) {
                return Transform.scale(
                  scale: value,
                  child: Container(
                    width: 80,
                    height: 80,
                    decoration: BoxDecoration(
                      color: Colors.green,
                      shape: BoxShape.circle,
                    ),
                    child: const Icon(
                      Icons.check,
                      color: Colors.white,
                      size: 40,
                    ),
                  ),
                );
              },
            ),
            const SizedBox(height: 24),
            const Text(
              'Thank You!',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            const Text(
              'Your message has been saved to our database. We\'ll respond within 24 hours.',
              textAlign: TextAlign.center,
              style: TextStyle(fontSize: 16),
            ),
          ],
        ),
        actions: [
          ElevatedButton(
            onPressed: () => Navigator.pop(context),
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              minimumSize: const Size(double.infinity, 45),
            ),
            child: const Text('Great!', style: TextStyle(color: Colors.white)),
          ),
        ],
      ),
    );
  }

  void _showErrorFeedback(BuildContext context, String error) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Row(
          children: [
            const Icon(Icons.error, color: Colors.white),
            const SizedBox(width: 8),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    'Failed to send message',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  Text(
                    'Please check your connection and try again.',
                    style: TextStyle(fontSize: 12, color: Colors.red.shade100),
                  ),
                ],
              ),
            ),
          ],
        ),
        backgroundColor: Colors.red,
        duration: const Duration(seconds: 4),
        action: SnackBarAction(
          label: 'Retry',
          textColor: Colors.white,
          onPressed: () {
            ScaffoldMessenger.of(context).hideCurrentSnackBar();
            _sendMessage(context, setState);
          },
        ),
      ),
    );
  }
}
