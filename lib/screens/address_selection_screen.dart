import 'package:ecommerce/common/widgets/custom_loading.dart';
import 'package:ecommerce/screens/new_address_screen.dart';
import 'package:flutter/material.dart';
import 'package:ecommerce/models/address_model.dart';
import 'package:ecommerce/repositories/address_repository.dart';

class AddressSelectionScreen extends StatelessWidget {
  const AddressSelectionScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Select Shipping Address')),
      body: StreamBuilder<List<AddressModel>>(
        stream: AddressRepository().getAddresses(),
        builder: (context, snapshot) {
          if (snapshot.connectionState == ConnectionState.waiting) {
            return const CustomLoadingIndicator();
          }

          final addresses = snapshot.data ?? [];

          return ListView.builder(
            itemCount:
                addresses.length + 1, // +1 for the "Add New Address" button
            itemBuilder: (context, index) {
              if (index < addresses.length) {
                final address = addresses[index];
                return Card(
                  margin: const EdgeInsets.all(8),
                  child: ListTile(
                    title: Text(address.name),
                    subtitle: Text(
                      '${address.street}, ${address.city}, ${address.state}, ${address.zipCode}, ${address.country}',
                    ),
                    trailing: PopupMenuButton<String>(
                      onSelected: (value) {
                        if (value == 'edit') {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder:
                                  (context) =>
                                      NewAddressScreen(address: address),
                            ),
                          ).then((updatedAddress) {
                            if (updatedAddress != null) {
                              // Handle the updated address (e.g., refresh the list)
                            }
                          });
                        } else if (value == 'delete') {
                          // Call delete method from AddressRepository
                          AddressRepository().deleteAddress(address.id);
                        }
                      },
                      itemBuilder:
                          (context) => [
                            const PopupMenuItem(
                              value: 'edit',
                              child: Text('Edit'),
                            ),
                            const PopupMenuItem(
                              value: 'delete',
                              child: Text('Delete'),
                            ),
                          ],
                    ),
                    onTap: () {
                      Navigator.pop(context, address);
                    },
                  ),
                );
              } else {
                // This is the "Add New Address" button
                return Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) => const NewAddressScreen(),
                        ),
                      ).then((newAddress) {
                        if (newAddress != null && context.mounted) {
                          Navigator.pop(context, newAddress);
                        }
                      });
                    },
                    child: const Text('Add New Address'),
                  ),
                );
              }
            },
          );
        },
      ),
    );
  }
}
