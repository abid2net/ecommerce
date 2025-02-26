part of 'voucher_bloc.dart';

abstract class VoucherState {}

class VoucherInitial extends VoucherState {}

class VoucherLoading extends VoucherState {}

class VoucherLoaded extends VoucherState {
  final List<VoucherModel> vouchers;
  VoucherLoaded(this.vouchers);
}

class VoucherError extends VoucherState {
  final String message;
  VoucherError(this.message);
}
