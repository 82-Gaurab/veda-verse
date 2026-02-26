import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:vedaverse/features/reset-password/domain/usecases/reset_password_usercase.dart';
import 'package:vedaverse/features/reset-password/presentation/state/reset_password_state.dart';

final resetPasswordViewModelProvider =
    NotifierProvider<ResetPasswordViewModel, ResetPasswordState>(
      () => ResetPasswordViewModel(),
    );

class ResetPasswordViewModel extends Notifier<ResetPasswordState> {
  late final ResetPasswordUserCase _resetPasswordUserCase;

  @override
  ResetPasswordState build() {
    _resetPasswordUserCase = ref.read(resetPasswordUseCaseProvider);
    return ResetPasswordState();
  }

  Future<void> resetPassword({
    required String email,
    required String newPassword,
  }) async {
    state = state.copyWith(status: ResetStatus.loading);

    final params = ResetPasswordUserCaseParams(
      email: email,
      newPassword: newPassword,
    );

    final result = await _resetPasswordUserCase(params);

    result.fold(
      (failure) => state = state.copyWith(
        status: ResetStatus.error,
        errorMessage: failure.message,
      ),
      (success) {
        if (success) {
          state = state.copyWith(status: ResetStatus.success);
        } else {
          state = state.copyWith(
            status: ResetStatus.error,
            errorMessage: "Reset Failed",
          );
        }
      },
    );
  }
}
