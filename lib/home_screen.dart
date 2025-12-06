import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with SingleTickerProviderStateMixin {
  final Color _primaryColor = const Color(0xFFFDDB4D);
  final Color _deepPurple = const Color(0xFF5B21B6);
  final Color _deepBlue = const Color(0xFF1E40AF);
  final Color _deepPink = const Color(0xFFBE185D);
  
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _dateController = TextEditingController();
  final TextEditingController _timeController = TextEditingController();
  final TextEditingController _commentsController = TextEditingController();
  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  
  bool _isLoading = false;
  String? _selectedPromoCode;
  
  final List<Map<String, dynamic>> _promoCodes = [
    {
      'code': 'WELCOME10',
      'discount': 10,
      'description': 'Welcome offer - 10% off',
      'icon': Icons.card_giftcard_rounded,
      'gradient': [Color(0xFF7C3AED), Color(0xFF5B21B6)],
    },
    {
      'code': 'FIRST99',
      'discount': 20,
      'description': 'First reading - 20% off',
      'icon': Icons.stars_rounded,
      'gradient': [Color(0xFFDB2777), Color(0xFFBE185D)],
    },
    {
      'code': 'COSMIC15',
      'discount': 15,
      'description': 'Cosmic special - 15% off',
      'icon': Icons.auto_awesome_rounded,
      'gradient': [Color(0xFF2563EB), Color(0xFF1E40AF)],
    },
  ];

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 800),
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(parent: _animationController, curve: Curves.easeOut),
    );
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    _nameController.dispose();
    _dateController.dispose();
    _timeController.dispose();
    _commentsController.dispose();
    super.dispose();
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = "${picked.day.toString().padLeft(2, '0')}/${picked.month.toString().padLeft(2, '0')}/${picked.year}";
      });
    }
  }

  Future<void> _selectTime() async {
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: TimeOfDay.now(),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: _primaryColor,
              onPrimary: Colors.black,
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _timeController.text = picked.format(context);
      });
    }
  }

  void _submitForm() {
    if (_nameController.text.isEmpty ||
        _dateController.text.isEmpty ||
        _timeController.text.isEmpty) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please fill all required fields'),
          backgroundColor: const Color(0xFFDC2626),
          behavior: SnackBarBehavior.floating,
          margin: const EdgeInsets.all(16),
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
        ),
      );
      return;
    }

    setState(() {
      _isLoading = true;
    });

    Future.delayed(const Duration(seconds: 1), () {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
      });
      _showPaymentBottomSheet();
    });
  }

  void _showPaymentBottomSheet() {
    final int basePrice = 99;
    final int discount = _selectedPromoCode != null
        ? _promoCodes.firstWhere((code) => code['code'] == _selectedPromoCode)['discount']
        : 0;
    final int finalPrice = basePrice - (basePrice * discount ~/ 100);

    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (context) => Container(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        decoration: const BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.only(
            topLeft: Radius.circular(28),
            topRight: Radius.circular(28),
          ),
        ),
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(24),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: const Color(0xFFE5E7EB),
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: _primaryColor,
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: const Icon(
                    Icons.payments_rounded,
                    size: 40,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 20),
                const Text(
                  'Complete Payment',
                  style: TextStyle(
                    fontSize: 24,
                    fontWeight: FontWeight.bold,
                    color: Colors.black,
                  ),
                ),
                const SizedBox(height: 8),
                const Text(
                  'Secure checkout for your reading',
                  style: TextStyle(
                    fontSize: 15,
                    color: Color(0xFF6B7280),
                  ),
                ),
                const SizedBox(height: 24),
                Container(
                  padding: const EdgeInsets.all(20),
                  decoration: BoxDecoration(
                    color: const Color(0xFFFFFBEB),
                    borderRadius: BorderRadius.circular(16),
                  ),
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          const Text(
                            'Base Price',
                            style: TextStyle(
                              fontSize: 16,
                              color: Colors.black,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                          Text(
                            '₹$basePrice',
                            style: TextStyle(
                              fontSize: 16,
                              decoration: discount > 0 ? TextDecoration.lineThrough : null,
                              color: discount > 0 ? const Color(0xFF6B7280) : Colors.black,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
                      ),
                      if (discount > 0) ...[
                        const SizedBox(height: 12),
                        Container(
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: const Color(0xFF10B981),
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Row(
                                children: [
                                  const Icon(Icons.local_offer_rounded, size: 18, color: Colors.white),
                                  const SizedBox(width: 8),
                                  Text(
                                    'Discount ($discount%)',
                                    style: const TextStyle(
                                      fontSize: 15,
                                      color: Colors.white,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                ],
                              ),
                              Text(
                                '-₹${basePrice - finalPrice}',
                                style: const TextStyle(
                                  fontSize: 16,
                                  color: Colors.white,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                      ] else
                        const SizedBox(height: 16),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              'Total Amount',
                              style: TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                                color: Colors.white,
                              ),
                            ),
                            Text(
                              '₹$finalPrice',
                              style: TextStyle(
                                fontSize: 26,
                                fontWeight: FontWeight.bold,
                                color: _primaryColor,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                const SizedBox(height: 24),
                SizedBox(
                  width: double.infinity,
                  height: 56,
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pop(context);
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: const Row(
                            children: [
                              Icon(Icons.check_circle_rounded, color: Colors.white),
                              SizedBox(width: 12),
                              Text('Payment Successful!'),
                            ],
                          ),
                          backgroundColor: const Color(0xFF10B981),
                          behavior: SnackBarBehavior.floating,
                          margin: const EdgeInsets.all(16),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
                        ),
                      );
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: _primaryColor,
                      foregroundColor: Colors.black,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                      elevation: 0,
                    ),
                    child: const Text(
                      'Proceed to Pay',
                      style: TextStyle(
                        fontSize: 17,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: FadeTransition(
          opacity: _fadeAnimation,
          child: SingleChildScrollView(
            physics: const BouncingScrollPhysics(),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Header
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.fromLTRB(20, 24, 20, 28),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                      colors: [
                        _primaryColor,
                        _primaryColor.withOpacity(0.8),
                      ],
                    ),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Container(
                            padding: const EdgeInsets.all(12),
                            decoration: BoxDecoration(
                              color: Colors.black.withOpacity(0.1),
                              borderRadius: BorderRadius.circular(12),
                            ),
                            child: const Icon(
                              Icons.auto_awesome_rounded,
                              color: Colors.black,
                              size: 24,
                            ),
                          ),
                          const Spacer(),
                        ],
                      ),
                      const SizedBox(height: 20),
                      const Text(
                        'Your Birth Chart',
                        style: TextStyle(
                          fontSize: 32,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                          height: 1.2,
                        ),
                      ),
                      const SizedBox(height: 6),
                      const Text(
                        'Get personalized insights',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.black87,
                        ),
                      ),
                    ],
                  ),
                ),
                
                // Content
                Padding(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Form Section
                      const Text(
                        'Birth Details',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 20),
                      
                      // Name Field
                      _buildTextField(
                        controller: _nameController,
                        label: 'Full Name',
                        hint: 'Enter your full name',
                        icon: Icons.person_rounded,
                        required: true,
                      ),
                      const SizedBox(height: 16),
                      
                      // Date & Time in Row
                      Row(
                        children: [
                          Expanded(
                            child: _buildTextField(
                              controller: _dateController,
                              label: 'Birth Date',
                              hint: 'DD/MM/YYYY',
                              icon: Icons.calendar_today_rounded,
                              required: true,
                              readOnly: true,
                              onTap: _selectDate,
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: _buildTextField(
                              controller: _timeController,
                              label: 'Birth Time',
                              hint: 'HH:MM',
                              icon: Icons.access_time_rounded,
                              required: true,
                              readOnly: true,
                              onTap: _selectTime,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),
                      
                      // Comments Field
                      _buildTextField(
                        controller: _commentsController,
                        label: 'Additional Notes',
                        hint: 'Any specific questions? (Optional)',
                        icon: Icons.edit_note_rounded,
                        maxLines: 3,
                      ),
                      
                      const SizedBox(height: 28),
                      
                      // Promo Codes Section
                      const Text(
                        'Available Offers',
                        style: TextStyle(
                          fontSize: 22,
                          fontWeight: FontWeight.bold,
                          color: Colors.black,
                        ),
                      ),
                      const SizedBox(height: 16),
                      
                      ...List.generate(_promoCodes.length, (index) {
                        final promo = _promoCodes[index];
                        final isSelected = _selectedPromoCode == promo['code'];
                        
                        return Container(
                          margin: const EdgeInsets.only(bottom: 12),
                          child: Material(
                            color: Colors.transparent,
                            child: InkWell(
                              onTap: () {
                                setState(() {
                                  _selectedPromoCode = isSelected ? null : promo['code'];
                                });
                                HapticFeedback.lightImpact();
                              },
                              borderRadius: BorderRadius.circular(16),
                              child: Container(
                                padding: const EdgeInsets.all(16),
                                decoration: BoxDecoration(
                                  gradient: isSelected
                                      ? LinearGradient(
                                          begin: Alignment.topLeft,
                                          end: Alignment.bottomRight,
                                          colors: promo['gradient'],
                                        )
                                      : null,
                                  color: isSelected ? null : const Color(0xFFFAFAFA),
                                  borderRadius: BorderRadius.circular(16),
                                  border: Border.all(
                                    color: isSelected ? Colors.transparent : const Color(0xFFE5E7EB),
                                    width: 2,
                                  ),
                                ),
                                child: Row(
                                  children: [
                                    Container(
                                      padding: const EdgeInsets.all(10),
                                      decoration: BoxDecoration(
                                        color: isSelected
                                            ? Colors.white.withOpacity(0.2)
                                            : Colors.white,
                                        borderRadius: BorderRadius.circular(12),
                                      ),
                                      child: Icon(
                                        promo['icon'],
                                        color: isSelected ? Colors.white : promo['gradient'][0],
                                        size: 24,
                                      ),
                                    ),
                                    const SizedBox(width: 14),
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment: CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            promo['code'],
                                            style: TextStyle(
                                              fontSize: 16,
                                              fontWeight: FontWeight.bold,
                                              color: isSelected ? Colors.white : Colors.black,
                                            ),
                                          ),
                                          const SizedBox(height: 4),
                                          Text(
                                            promo['description'],
                                            style: TextStyle(
                                              fontSize: 13,
                                              color: isSelected
                                                  ? Colors.white.withOpacity(0.9)
                                                  : const Color(0xFF6B7280),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (isSelected)
                                      Container(
                                        padding: const EdgeInsets.all(4),
                                        decoration: const BoxDecoration(
                                          color: Colors.white,
                                          shape: BoxShape.circle,
                                        ),
                                        child: Icon(
                                          Icons.check_rounded,
                                          color: promo['gradient'][0],
                                          size: 18,
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                        );
                      }),
                      
                      const SizedBox(height: 28),
                      
                      // Info Card
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(
                          color: const Color(0xFFFEF3C7),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Icon(Icons.info_rounded, color: Color(0xFFD97706), size: 24),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Text(
                                'Expert astrologers will analyze your chart within 7 days.',
                                style: TextStyle(
                                  fontSize: 14,
                                  color: Colors.black87,
                                  height: 1.4,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                      
                      const SizedBox(height: 24),
                      
                      // Submit Button
                      SizedBox(
                        width: double.infinity,
                        height: 56,
                        child: ElevatedButton(
                          onPressed: _isLoading ? null : _submitForm,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: _primaryColor,
                            foregroundColor: Colors.black,
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14),
                            ),
                            elevation: 0,
                          ),
                          child: _isLoading
                              ? const SizedBox(
                                  width: 24,
                                  height: 24,
                                  child: CircularProgressIndicator(
                                    strokeWidth: 2.5,
                                    color: Colors.black,
                                  ),
                                )
                              : const Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      'Continue to Payment',
                                      style: TextStyle(
                                        fontSize: 17,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    SizedBox(width: 10),
                                    Icon(Icons.arrow_forward_rounded, size: 20),
                                  ],
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String label,
    required String hint,
    required IconData icon,
    bool required = false,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Text(
              label,
              style: const TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: Colors.black,
              ),
            ),
            if (required)
              const Text(
                ' *',
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: Color(0xFFDC2626),
                ),
              ),
          ],
        ),
        const SizedBox(height: 8),
        TextField(
          controller: controller,
          maxLines: maxLines,
          readOnly: readOnly,
          onTap: onTap,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w500,
            color: Colors.black,
          ),
          decoration: InputDecoration(
            hintText: hint,
            hintStyle: const TextStyle(
              color: Color(0xFF9CA3AF),
              fontWeight: FontWeight.w400,
            ),
            filled: true,
            fillColor: const Color(0xFFFAFAFA),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: const BorderSide(color: Color(0xFFE5E7EB), width: 2),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: _primaryColor, width: 2),
            ),
            contentPadding: EdgeInsets.symmetric(
              horizontal: 16,
              vertical: maxLines > 1 ? 14 : 16,
            ),
            prefixIcon: Icon(
              icon,
              color: const Color(0xFF6B7280),
              size: 20,
            ),
            suffixIcon: readOnly
                ? const Icon(Icons.arrow_drop_down_rounded, color: Color(0xFF6B7280), size: 24)
                : null,
          ),
        ),
      ],
    );
  }
}