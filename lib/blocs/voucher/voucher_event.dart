part of 'voucher_bloc.dart';

abstract class VoucherEvent {}

class LoadVouchers extends VoucherEvent {}

class DeleteVoucher extends VoucherEvent {
  final String voucherId; // Assuming voucher has an ID
  DeleteVoucher(this.voucherId);
}
// Add other events as needed 