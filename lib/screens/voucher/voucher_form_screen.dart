import 'package:ecommerce/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/voucher_model.dart'; // Import your voucher model
import 'package:ecommerce/repositories/voucher_repository.dart'; // Import your voucher repository
import 'package:ecommerce/repositories/category_repository.dart'; // Import your category repository
import 'package:ecommerce/models/category_model.dart'; // Import your category model

class VoucherFormScreen extends StatefulWidget {
  final VoucherModel? voucher;

  const VoucherFormScreen({super.key, this.voucher});

  @override
  State<VoucherFormScreen> createState() => _VoucherFormScreenState();
}

class _VoucherFormScreenState extends State<VoucherFormScreen> {
  final _formKey = GlobalKey<FormState>();
  final _codeController = TextEditingController();
  final _discountPercentageController = TextEditingController();
  final _discountDescriptionController =
      TextEditingController(); // For description
  DateTime? _expiryDate; // New field for expiry date
  bool _isActive = true; // Default value for isActive
  List<String> _selectedCategoryIds = []; // List to hold selected category IDs

  @override
  void initState() {
    super.initState();
    if (widget.voucher != null) {
      _codeController.text = widget.voucher!.code;
      _discountPercentageController.text =
          widget.voucher!.percentage.toString();
      _discountDescriptionController.text =
          widget.voucher!.description; // Set description
      _expiryDate = widget.voucher!.expiryDate; // Set expiry date if available
      _isActive = widget.voucher!.isActive; // Set isActive status
      _selectedCategoryIds =
          widget.voucher!.validCategories; // Load selected categories
    }
  }

  @override
  void dispose() {
    _codeController.dispose();
    _discountPercentageController.dispose();
    _discountDescriptionController.dispose();
    super.dispose();
  }

  void _saveVoucher() async {
    if (_formKey.currentState!.validate()) {
      final newVoucher = VoucherModel(
        id:
            widget.voucher?.id ??
            DateTime.now().millisecondsSinceEpoch.toString(),
        code: _codeController.text,
        description: _discountDescriptionController.text, // Get description
        percentage: double.parse(_discountPercentageController.text),
        isActive: _isActive, // Use the toggle value
        expiryDate: _expiryDate, // Use the selected expiry date
        validCategories: _selectedCategoryIds, // Use the selected category IDs
      );

      await VoucherRepository().addVoucher(newVoucher); // Save the voucher
      if (mounted) {
        Navigator.pop(context);
      }
    }
  }

  Future<void> _selectExpiryDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _expiryDate ?? DateTime.now(),
      firstDate: DateTime.now().subtract(Duration(days: 10)),
      lastDate: DateTime(2101),
    );
    if (picked != null && picked != _expiryDate) {
      setState(() {
        _expiryDate = picked; // Update the expiry date
      });
    }
  }

  void _clearExpiryDate() {
    setState(() {
      _expiryDate = null; // Clear the expiry date
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Add/Edit Voucher')),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  controller: _codeController,
                  decoration: const InputDecoration(labelText: 'Voucher Code'),
                  validator:
                      (value) => value!.isEmpty ? 'Please enter a code' : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  controller: _discountPercentageController,
                  decoration: const InputDecoration(
                    labelText: 'Discount Percentage',
                  ),
                  keyboardType: TextInputType.number,
                  validator:
                      (value) =>
                          value!.isEmpty
                              ? 'Please enter a discount percentage'
                              : null,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: TextFormField(
                  controller: _discountDescriptionController,
                  decoration: const InputDecoration(
                    labelText: 'Discount Description',
                  ), // New field for description
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: Row(
                  children: [
                    SizedBox(
                      width: MediaQuery.of(context).size.width / 1.3,
                      child: GestureDetector(
                        onTap: () => _selectExpiryDate(context),
                        child: AbsorbPointer(
                          child: TextFormField(
                            decoration: InputDecoration(
                              labelText:
                                  _expiryDate == null
                                      ? 'No expiry date'
                                      : '${_expiryDate!.toLocal()}'.split(
                                        ' ',
                                      )[0],
                              suffixIcon: const Icon(Icons.calendar_today),
                            ),
                            readOnly: true,
                          ),
                        ),
                      ),
                    ),
                    IconButton(
                      icon: const Icon(
                        Icons.clear,
                        color: AppTheme.quaternaryColor,
                      ),
                      onPressed: _clearExpiryDate,
                    ),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(vertical: 5.0),
                child: StreamBuilder<List<CategoryModel>>(
                  stream: CategoryRepository().getCategories(),
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const CircularProgressIndicator();
                    }
                    if (snapshot.hasError) {
                      return Text('Error: ${snapshot.error}');
                    }
                    if (!snapshot.hasData || snapshot.data!.isEmpty) {
                      return const Text('No categories available');
                    }

                    final categories = snapshot.data!;
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const Text('Select Specific Categories:'),
                        ...categories.map((category) {
                          return CheckboxListTile(
                            title: Text(category.name),
                            value: _selectedCategoryIds.contains(category.id),
                            onChanged: (bool? selected) {
                              setState(() {
                                if (selected == true) {
                                  _selectedCategoryIds.add(category.id);
                                } else {
                                  _selectedCategoryIds.remove(category.id);
                                }
                              });
                            },
                          );
                        }),
                      ],
                    );
                  },
                ),
              ),
              const SizedBox(height: 8),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: 10.0),
                    child: const Text('Active Voucher'),
                  ),
                  Switch(
                    value: _isActive,
                    onChanged: (value) {
                      setState(() {
                        _isActive = value; // Update the isActive status
                      });
                    },
                  ),
                ],
              ),
              const SizedBox(height: 16),
              ElevatedButton(
                onPressed: _saveVoucher,
                child: const Text('Save Voucher'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
