import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ecommerce/models/voucher_model.dart';
import 'package:ecommerce/repositories/voucher_repository.dart';

part 'voucher_event.dart';
part 'voucher_state.dart';

class VoucherBloc extends Bloc<VoucherEvent, VoucherState> {
  final VoucherRepository _voucherRepository;

  VoucherBloc({required VoucherRepository voucherRepository})
    : _voucherRepository = voucherRepository,
      super(VoucherInitial()) {
    on<LoadVouchers>(_onLoadVouchers);
    on<DeleteVoucher>(_onDeleteVoucher);
  }

  Future<void> _onLoadVouchers(
    LoadVouchers event,
    Emitter<VoucherState> emit,
  ) async {
    emit(VoucherLoading());
    try {
      final vouchers = await _voucherRepository.getVouchers();
      emit(VoucherLoaded(vouchers));
    } catch (e) {
      emit(VoucherError(e.toString()));
    }
  }

  Future<void> _onDeleteVoucher(
    DeleteVoucher event,
    Emitter<VoucherState> emit,
  ) async {
    try {
      await _voucherRepository.deleteVoucher(event.voucherId);
      add(LoadVouchers());
    } catch (e) {
      emit(VoucherError(e.toString()));
    }
  }
}
