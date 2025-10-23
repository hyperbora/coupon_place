// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Korean (`ko`).
class AppLocalizationsKo extends AppLocalizations {
  AppLocalizationsKo([String locale = 'ko']) : super(locale);

  @override
  String get appTitle => '쿠폰플레이스';

  @override
  String get homeTitle => '홈';

  @override
  String get couponRegisterTitle => '쿠폰등록';

  @override
  String get couponEditTitle => '쿠폰수정';

  @override
  String get myCouponsTitle => '내 쿠폰';

  @override
  String get settingsTitle => '설정';

  @override
  String get couponRegisterTooltip => '쿠폰 등록';

  @override
  String get confirm => '확인';

  @override
  String get cancel => '취소';

  @override
  String get save => '저장';

  @override
  String get edit => '편집';

  @override
  String get delete => '삭제';

  @override
  String get couponNameLabel => '쿠폰 이름';

  @override
  String get couponNameHint => '쿠폰 이름을 입력하세요';

  @override
  String get validDateLabel => '유효기간';

  @override
  String get validDateHint => '날짜를 선택하세요';

  @override
  String get couponCodeLabel => '쿠폰 코드';

  @override
  String get memoLabel => '메모';

  @override
  String get folderLabel => '폴더 선택';

  @override
  String get folderHint => '폴더를 선택하세요';

  @override
  String get alarmLabel => '유효기간 알림 설정';

  @override
  String get imageSelect => '이미지 선택';

  @override
  String get camera => '카메라';

  @override
  String get library => '라이브러리';

  @override
  String get registerCouponPlaceholder => '쿠폰을 등록하세요.';

  @override
  String get folderAdd => '폴더 등록';

  @override
  String get folderSelect => '폴더 선택';

  @override
  String get folderNameHint => '폴더 이름';

  @override
  String get folderNameEmptyError => '폴더 이름을 입력하세요';

  @override
  String get folderCreateFirst => '폴더를 먼저 생성해주세요.';

  @override
  String get deleteCouponTitle => '쿠폰 삭제';

  @override
  String get deleteCouponContent => '정말로 이 쿠폰을 삭제하시겠습니까?';

  @override
  String get cameraUsageDescription => '이 앱은 쿠폰 등록을 위해 카메라 접근 권한이 필요합니다.';

  @override
  String get photoLibraryUsageDescription => '이 앱은 쿠폰 이미지를 선택하기 위해 사진 라이브러리 접근 권한이 필요합니다.';

  @override
  String get needPermission => '권한 필요';

  @override
  String get goToSettings => '설정으로 이동';

  @override
  String get permissionDescription => '계속 사용하시려면 설정에서 권한을 허용해야 합니다.';

  @override
  String get couponDetailTitle => '쿠폰 상세';

  @override
  String get couponNotFound => '쿠폰을 찾을 수 없습니다.';

  @override
  String get couponDetailCodeLabel => '코드';

  @override
  String get couponDetailMemoLabel => '메모';

  @override
  String get couponDetailValidDateLabel => '유효기간';

  @override
  String get selectModeTooltip => '선택 모드';

  @override
  String get deleteFolderTitle => '폴더 삭제';

  @override
  String get deleteFolderMessage => '정말로 이 폴더를 삭제하시겠습니까?';

  @override
  String get enableAlarmLabel => '알림 설정';

  @override
  String reminder(int days) {
    return '쿠폰이 $days일 후 만료됩니다.';
  }

  @override
  String get reminder_0d => '쿠폰이 오늘 만료됩니다!';

  @override
  String get couponExpireNotificationTitle => '쿠폰 만료 알림';

  @override
  String get firstAlarmLabel => '알림';

  @override
  String get secondAlarmLabel => '두 번째 알림';

  @override
  String get noAlarmDropdownItem => '없음';

  @override
  String daysBeforeDropdownItem(int days) {
    return '$days일 전';
  }

  @override
  String get onTheDayDropdownItem => '당일';

  @override
  String get settingsReminderTitle => '만료 알림';

  @override
  String get settingsDataManagementTitle => '데이터 관리';

  @override
  String get noCouponsDescription => '아직 쿠폰이 없어요.\n+ 버튼을 눌러 추가해 보세요.';

  @override
  String get dataManagementTitle => '데이터 관리';

  @override
  String get clearAllDataLabel => '모든 데이터 삭제';

  @override
  String get deleteAllDataDialogTitle => '모든 데이터 삭제';

  @override
  String get deleteAllDataDialogMessage => '이 작업을 수행하면 모든 쿠폰과 폴더가 영구적으로 삭제됩니다. 복구할 수 없습니다.';

  @override
  String get allDataDeletedMessage => '모든 데이터가 삭제되었습니다.';

  @override
  String get markAsUsedLabel => '사용 완료';

  @override
  String get restoreUseLabel => '다시 사용하기';

  @override
  String get couponUseMarkedMessage => '쿠폰을 사용 완료로 표시했어요.';

  @override
  String get couponUseRestoredMessage => '쿠폰을 다시 사용할 수 있어요.';

  @override
  String get reminderTimeLabel => '알림 시간';

  @override
  String get selectTimePlaceholder => '시간 선택';
}
