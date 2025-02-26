import 'package:flutter/material.dart';
import 'package:ecommerce/models/voucher_model.dart'; // Import your voucher model
import 'package:ecommerce/screens/voucher/voucher_form_screen.dart'; // Import the form screen for adding/editing vouchers
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/blocs/voucher/voucher_bloc.dart';

class VoucherManagementScreen extends StatefulWidget {
  const VoucherManagementScreen({super.key});

  @override
  State<VoucherManagementScreen> createState() =>
      _VoucherManagementScreenState();
}

class _VoucherManagementScreenState extends State<VoucherManagementScreen> {
  @override
  void initState() {
    super.initState();
    context.read<VoucherBloc>().add(LoadVouchers());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Manage Vouchers')),
      body: BlocBuilder<VoucherBloc, VoucherState>(
        builder: (context, state) {
          if (state is VoucherLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state is VoucherLoaded) {
            return ListView.builder(
              itemCount: state.vouchers.length,
              itemBuilder: (context, index) {
                final VoucherModel voucher = state.vouchers[index];
                return Card(
                  margin: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  child: ListTile(
                    title: Text(voucher.code),
                    subtitle: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text('Description: ${voucher.description}'),
                        Text('Discount: ${voucher.percentage}%'),
                        Row(
                          children: [
                            Icon(
                              voucher.isActive
                                  ? Icons.check_circle
                                  : Icons.cancel,
                              color:
                                  voucher.isActive ? Colors.green : Colors.red,
                            ),
                            const SizedBox(width: 8),
                            Text(voucher.isActive ? 'Active' : 'Inactive'),
                          ],
                        ),
                        Text(
                          'Expiry Date: ${voucher.expiryDate != null ? voucher.expiryDate!.toLocal().toString().split(' ')[0] : "No expiry date"}',
                        ),
                      ],
                    ),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        IconButton(
                          icon: const Icon(Icons.edit),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder:
                                    (context) =>
                                        VoucherFormScreen(voucher: voucher),
                              ),
                            ).then((_) {
                              if (context.mounted) {
                                context.read<VoucherBloc>().add(LoadVouchers());
                              }
                            });
                          },
                        ),
                        IconButton(
                          icon: const Icon(Icons.delete),
                          onPressed: () {
                            // Trigger delete event
                            context.read<VoucherBloc>().add(
                              DeleteVoucher(voucher.id),
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                );
              },
            );
          }

          return const Center(child: Text('No vouchers found'));
        },
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const VoucherFormScreen()),
          ).then((_) {
            if (context.mounted) {
              context.read<VoucherBloc>().add(LoadVouchers());
            }
          });
        },
        child: const Icon(Icons.add),
      ),
    );
  }
}
