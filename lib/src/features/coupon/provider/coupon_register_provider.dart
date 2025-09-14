import 'package:flutter_riverpod/flutter_riverpod.dart';

class CouponRegisterState {
  final String? imageFilePath;
  final String name;
  final String code;
  final String memo;
  final String? folder;
  final bool enableAlarm;
  final DateTime? validDate;

  CouponRegisterState({
    this.imageFilePath,
    this.name = '',
    this.code = '',
    this.memo = '',
    this.folder,
    this.enableAlarm = false,
    this.validDate,
  });

  CouponRegisterState copyWith({
    String? imageFilePath,
    String? name,
    String? code,
    String? memo,
    String? folder,
    bool? enableAlarm,
    DateTime? validDate,
  }) {
    return CouponRegisterState(
      imageFilePath: imageFilePath,
      name: name ?? this.name,
      code: code ?? this.code,
      memo: memo ?? this.memo,
      folder: folder ?? this.folder,
      enableAlarm: enableAlarm ?? this.enableAlarm,
      validDate: validDate ?? this.validDate,
    );
  }
}

class CouponRegisterNotifier extends StateNotifier<CouponRegisterState> {
  CouponRegisterNotifier() : super(CouponRegisterState());

  void setImagePath(String? filePath) =>
      state = state.copyWith(imageFilePath: filePath);
  void setName(String name) => state = state.copyWith(name: name);
  void setCode(String code) => state = state.copyWith(code: code);
  void setMemo(String memo) => state = state.copyWith(memo: memo);
  void setFolder(String? folder) => state = state.copyWith(folder: folder);
  void setEnableAlarm(bool enable) =>
      state = state.copyWith(enableAlarm: enable);
  void setValidDate(DateTime? date) => state = state.copyWith(validDate: date);

  void reset() => state = CouponRegisterState();
}

final couponRegisterProvider =
    StateNotifierProvider<CouponRegisterNotifier, CouponRegisterState>(
      (ref) => CouponRegisterNotifier(),
    );
