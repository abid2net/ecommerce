import 'package:ecommerce/blocs/auth/auth_bloc.dart';
import 'package:ecommerce/blocs/auth/auth_event.dart';
import 'package:ecommerce/blocs/auth/auth_state.dart';
import 'package:ecommerce/common/common.dart';
import 'package:ecommerce/theme/app_theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'dart:io';
import 'package:image_picker/image_picker.dart';
import 'package:ecommerce/widgets/global_loading.dart';

class ProfileScreen extends StatefulWidget {
  const ProfileScreen({super.key});

  @override
  State<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends State<ProfileScreen> {
  final _formKey = GlobalKey<FormState>();
  final _displayNameController = TextEditingController();
  final _phoneController = TextEditingController();
  final _addressController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();
  bool _isEditingPassword = false;
  File? _imageFile;
  final _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    final state = context.read<AuthBloc>().state;
    if (state is Authenticated) {
      _displayNameController.text = state.user.displayName ?? '';
      _phoneController.text = state.user.phone ?? '';
      _addressController.text = state.user.address ?? '';
    }
  }

  @override
  void dispose() {
    _displayNameController.dispose();
    _phoneController.dispose();
    _addressController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _togglePasswordEdit() {
    setState(() {
      _isEditingPassword = !_isEditingPassword;
      if (!_isEditingPassword) {
        _currentPasswordController.clear();
        _newPasswordController.clear();
        _confirmPasswordController.clear();
      }
    });
  }

  Future<void> _pickImage() async {
    try {
      final pickedFile = await _picker.pickImage(source: ImageSource.gallery);
      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
        });
      }
    } catch (e) {
      if (mounted) {
        showErrorSnackBar(context: context, message: 'Error picking image: $e');
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<AuthBloc, AuthState>(
      listener: (context, state) {
        if (state is AuthError) {
          showErrorSnackBar(context: context, message: state.message);
        } else if (state is Authenticated) {
          if (_isEditingPassword) {
            showSuccessSnackBar(
              context: context,
              message: 'Password updated successfully',
            );
            _togglePasswordEdit();
          } else {
            showSuccessSnackBar(
              context: context,
              message: 'Profile updated successfully',
            );
          }
        }
      },
      builder: (context, state) {
        if (state is! Authenticated) {
          return const GlobalLoading();
        }

        final user = state.user;

        return Stack(
          children: [
            Scaffold(
              appBar: AppBar(title: const Text('Profile')),
              body: SingleChildScrollView(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.stretch,
                    children: [
                      Center(
                        child: Stack(
                          children: [
                            Container(
                              decoration: BoxDecoration(
                                shape: BoxShape.circle,
                                border: Border.all(
                                  color: Theme.of(context).primaryColor,
                                  width: 3,
                                ),
                              ),
                              child: CircleAvatar(
                                radius: 50,
                                backgroundImage:
                                    _imageFile != null
                                        ? FileImage(_imageFile!)
                                        : (user.photoUrl != null
                                                ? NetworkImage(user.photoUrl!)
                                                : null)
                                            as ImageProvider?,
                                child:
                                    user.photoUrl == null && _imageFile == null
                                        ? const Icon(Icons.person, size: 50)
                                        : null,
                              ),
                            ),
                            Positioned(
                              right: -10,
                              bottom: -10,
                              child: IconButton(
                                icon: const Icon(
                                  Icons.camera_alt,
                                  color: AppTheme.primaryColor,
                                ),
                                onPressed: _pickImage,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 24),
                      TextFormField(
                        controller: _displayNameController,
                        decoration: const InputDecoration(
                          labelText: 'Display Name',
                          border: OutlineInputBorder(),
                        ),
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your display name';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _phoneController,
                        decoration: const InputDecoration(
                          labelText: 'Phone Number',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.phone),
                        ),
                        keyboardType: TextInputType.phone,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your phone number';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 16),
                      TextFormField(
                        controller: _addressController,
                        decoration: const InputDecoration(
                          labelText: 'Address',
                          border: OutlineInputBorder(),
                          prefixIcon: Icon(Icons.location_on),
                        ),
                        maxLines: 3,
                        validator: (value) {
                          if (value == null || value.isEmpty) {
                            return 'Please enter your address';
                          }
                          return null;
                        },
                      ),
                      const SizedBox(height: 24),
                      Text(
                        'Email: ${user.email}',
                        style: Theme.of(context).textTheme.titleMedium,
                      ),
                      const SizedBox(height: 24),
                      ElevatedButton(
                        onPressed: () {
                          if (_formKey.currentState!.validate()) {
                            final updatedUser = user.copyWith(
                              displayName: _displayNameController.text,
                              phone: _phoneController.text,
                              address: _addressController.text,
                            );
                            context.read<AuthBloc>().add(
                              UpdateProfileEvent(
                                updatedUser,
                                imageFile: _imageFile,
                              ),
                            );
                          }
                        },
                        child: const Text('Update Profile'),
                      ),
                      const SizedBox(height: 32),
                      const Divider(),
                      const SizedBox(height: 16),
                      if (!_isEditingPassword) ...[
                        ElevatedButton(
                          onPressed: _togglePasswordEdit,
                          child: const Text('Change Password'),
                        ),
                      ] else ...[
                        TextFormField(
                          controller: _currentPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Current Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your current password';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _newPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'New Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please enter your new password';
                            }
                            if (value.length < 6) {
                              return 'Password must be at least 6 characters';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 16),
                        TextFormField(
                          controller: _confirmPasswordController,
                          decoration: const InputDecoration(
                            labelText: 'Confirm New Password',
                            border: OutlineInputBorder(),
                          ),
                          obscureText: true,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return 'Please confirm your new password';
                            }
                            if (value != _newPasswordController.text) {
                              return 'Passwords do not match';
                            }
                            return null;
                          },
                        ),
                        const SizedBox(height: 24),
                        Row(
                          children: [
                            Expanded(
                              child: BlocBuilder<AuthBloc, AuthState>(
                                builder: (context, state) {
                                  return ElevatedButton(
                                    onPressed:
                                        state is AuthLoading
                                            ? null
                                            : () {
                                              if (_formKey.currentState!
                                                  .validate()) {
                                                context.read<AuthBloc>().add(
                                                  UpdatePasswordEvent(
                                                    _newPasswordController.text,
                                                  ),
                                                );
                                              }
                                            },
                                    child:
                                        state is AuthLoading
                                            ? const SizedBox(
                                              height: 20,
                                              width: 20,
                                              child: GlobalLoading(),
                                            )
                                            : const Text('Update Password'),
                                  );
                                },
                              ),
                            ),
                            const SizedBox(width: 16),
                            Expanded(
                              child: TextButton(
                                onPressed: _togglePasswordEdit,
                                child: const Text('Cancel'),
                              ),
                            ),
                          ],
                        ),
                      ],
                      const SizedBox(height: 20),
                      ElevatedButton(
                        onPressed:
                            () => context.read<AuthBloc>().add(SignOutEvent()),
                        child: const Text('Logout'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            if (state is AuthLoading) const GlobalLoading(),
          ],
        );
      },
    );
  }
}
