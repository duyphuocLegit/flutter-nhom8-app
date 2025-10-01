// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get appTitle => 'Ứng Dụng Nhiệm Vụ';

  @override
  String get hello => 'Xin chào';

  @override
  String get welcome => 'Chào mừng';

  @override
  String get letsBeProductive => 'Hãy làm việc hiệu quả hôm nay';

  @override
  String get login => 'Đăng nhập';

  @override
  String get logout => 'Đăng xuất';

  @override
  String get email => 'Email';

  @override
  String get password => 'Mật khẩu';

  @override
  String get confirmPassword => 'Xác nhận mật khẩu';

  @override
  String get signUp => 'Đăng ký';

  @override
  String get forgotPassword => 'Quên mật khẩu?';

  @override
  String get createAccount => 'Tạo tài khoản';

  @override
  String get alreadyHaveAccount => 'Đã có tài khoản?';

  @override
  String get dontHaveAccount => 'Chưa có tài khoản?';

  @override
  String get home => 'Trang chủ';

  @override
  String get tasks => 'Nhiệm vụ';

  @override
  String get calendar => 'Lịch';

  @override
  String get settings => 'Cài đặt';

  @override
  String get profile => 'Hồ sơ';

  @override
  String get addTask => 'Thêm nhiệm vụ';

  @override
  String get taskTitle => 'Tiêu đề nhiệm vụ';

  @override
  String get taskDescription => 'Mô tả nhiệm vụ';

  @override
  String get dueDate => 'Ngày đến hạn';

  @override
  String get priority => 'Độ ưu tiên';

  @override
  String get high => 'Cao';

  @override
  String get medium => 'Trung bình';

  @override
  String get low => 'Thấp';

  @override
  String get save => 'Lưu';

  @override
  String get cancel => 'Hủy';

  @override
  String get delete => 'Xóa';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get language => 'Ngôn ngữ';

  @override
  String get theme => 'Chủ đề';

  @override
  String get notifications => 'Thông báo';

  @override
  String get aboutApp => 'Về ứng dụng';

  @override
  String get version => 'Phiên bản';

  @override
  String get darkMode => 'Chế độ tối';

  @override
  String get lightMode => 'Chế độ sáng';

  @override
  String get systemMode => 'Chế độ hệ thống';

  @override
  String get completed => 'Hoàn thành';

  @override
  String get pending => 'Đang chờ';

  @override
  String get overdue => 'Quá hạn';

  @override
  String get noTasksFound => 'Không tìm thấy nhiệm vụ nào';

  @override
  String get searchTasks => 'Tìm kiếm nhiệm vụ...';

  @override
  String get yourProgress => 'Tiến Độ Của Bạn';

  @override
  String get done => 'Hoàn thành';

  @override
  String get left => 'Còn lại';

  @override
  String get findTasks => 'Tìm Nhiệm Vụ';

  @override
  String get yourTasks => 'Nhiệm Vụ Của Bạn';

  @override
  String get clear => 'Xóa';

  @override
  String showingTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: '',
      one: '',
    );
    return 'Hiển thị $count nhiệm vụ$_temp0';
  }

  @override
  String get allCompleted => 'Tất cả đã hoàn thành! 🎉';

  @override
  String get clearAllFilters => 'Xóa Tất Cả Bộ Lọc';

  @override
  String get filterByPriority => 'Lọc theo độ ưu tiên';

  @override
  String get filterByStatus => 'Lọc theo trạng thái';

  @override
  String get all => 'Tất cả';

  @override
  String get today => 'Hôm nay';

  @override
  String get thisWeek => 'Tuần này';

  @override
  String get thisMonth => 'Tháng này';

  @override
  String get error => 'Lỗi';

  @override
  String get success => 'Thành công';

  @override
  String get loading => 'Đang tải...';

  @override
  String get retry => 'Thử lại';

  @override
  String get noInternetConnection => 'Không có kết nối internet';

  @override
  String get pleaseEnterValidEmail => 'Vui lòng nhập email hợp lệ';

  @override
  String get passwordTooShort => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get passwordsDoNotMatch => 'Mật khẩu không khớp';

  @override
  String get fieldRequired => 'Trường này là bắt buộc';

  @override
  String get clearCache => 'Xóa bộ nhớ đệm';

  @override
  String get resetSettings => 'Đặt lại cài đặt';

  @override
  String get clearCacheMessage =>
      'Điều này sẽ xóa tất cả các tệp tạm thời và dữ liệu được lưu trong bộ nhớ đệm. Ứng dụng có thể cần tải lại nội dung.';

  @override
  String get resetSettingsMessage =>
      'Điều này sẽ đặt lại tất cả cài đặt về giá trị mặc định. Hành động này không thể hoàn tác.';

  @override
  String get cacheCleared => 'Đã xóa bộ nhớ đệm thành công';

  @override
  String get reset => 'Đặt lại';

  @override
  String get removeAccount => 'Xóa tài khoản';

  @override
  String removeAccountMessage(String email) {
    return 'Xóa $email khỏi danh sách tài khoản đã lưu?';
  }

  @override
  String get remove => 'Xóa';

  @override
  String get accountRemoved => 'Đã xóa tài khoản';

  @override
  String errorRemovingAccount(String error) {
    return 'Lỗi khi xóa tài khoản: $error';
  }

  @override
  String get accountSaved => 'Tài khoản đã được lưu và đồng bộ với Firebase';

  @override
  String get mostRecent => 'Gần đây nhất';

  @override
  String get alphabetical => 'Theo bảng chữ cái';

  @override
  String get editTask => 'Chỉnh sửa nhiệm vụ';

  @override
  String get addNewTask => 'Thêm nhiệm vụ mới';

  @override
  String get menu => 'Menu';

  @override
  String get account => 'Tài khoản';

  @override
  String get contactUs => 'Liên hệ';

  @override
  String get aboutUs => 'Giới thiệu';

  @override
  String get help => 'Trợ giúp';

  @override
  String get sendMessage => 'Gửi tin nhắn';

  @override
  String get send => 'Gửi';

  @override
  String get name => 'Tên';

  @override
  String get message => 'Tin nhắn';

  @override
  String get writeYourMessage => 'Viết tin nhắn của bạn tại đây...';

  @override
  String get messageSent => 'Tin nhắn đã được gửi thành công!';

  @override
  String get viewAll => 'Xem tất cả';

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get changePassword => 'Đổi mật khẩu';

  @override
  String get accountDataUsage => 'Sử dụng dữ liệu tài khoản';

  @override
  String get totalTasks => 'Tổng số nhiệm vụ';

  @override
  String get activeProjects => 'Dự án đang hoạt động';

  @override
  String get dataSync => 'Đồng bộ dữ liệu';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get lastUpdated => 'Cập nhật lần cuối: 27 tháng 9, 2025';

  @override
  String get privacyDescription =>
      'Quyền riêng tư của bạn rất quan trọng đối với chúng tôi. Chính sách này giải thích cách chúng tôi thu thập, sử dụng và bảo vệ thông tin của bạn.';

  @override
  String get informationWeCollect => 'Thông tin chúng tôi thu thập';

  @override
  String get howWeUseYourInformation =>
      'Cách chúng tôi sử dụng thông tin của bạn';

  @override
  String get dataStorageSecurity => 'Lưu trữ dữ liệu & Bảo mật';

  @override
  String get dataSharing => 'Chia sẻ dữ liệu';

  @override
  String get yourRights => 'Quyền của bạn';

  @override
  String get thirdPartyServices => 'Dịch vụ bên thứ ba';

  @override
  String get questionsOrConcerns => 'Câu hỏi hoặc quan tâm?';

  @override
  String get privacyContactDescription =>
      'Nếu bạn có bất kỳ câu hỏi nào về Chính sách bảo mật này hoặc cách chúng tôi xử lý dữ liệu của bạn, vui lòng liên hệ với chúng tôi:';

  @override
  String get privacyResponseTime =>
      'Chúng tôi sẽ phản hồi tất cả các câu hỏi liên quan đến quyền riêng tư trong vòng 48 giờ.';

  @override
  String get accountInfoCollection =>
      'Thông tin tài khoản: Địa chỉ email, tên và ảnh đại diện khi bạn đăng ký';

  @override
  String get taskDataCollection =>
      'Dữ liệu nhiệm vụ: Các nhiệm vụ, danh mục, ngày đến hạn và trạng thái hoàn thành của bạn';

  @override
  String get usageDataCollection =>
      'Dữ liệu sử dụng: Cách bạn tương tác với ứng dụng để cải thiện trải nghiệm người dùng';

  @override
  String get deviceInfoCollection =>
      'Thông tin thiết bị: Loại thiết bị và hệ điều hành để đảm bảo tương thích';

  @override
  String get provideService => 'Cung cấp và duy trì dịch vụ quản lý nhiệm vụ';

  @override
  String get syncData =>
      'Đồng bộ dữ liệu của bạn trên các thiết bị một cách an toàn';

  @override
  String get sendNotifications =>
      'Gửi thông báo về nhiệm vụ và thời hạn của bạn';

  @override
  String get improveApp =>
      'Cải thiện hiệu suất ứng dụng và thêm các tính năng mới';

  @override
  String get customerSupport => 'Cung cấp hỗ trợ khách hàng khi cần thiết';

  @override
  String get secureStorage =>
      'Dữ liệu của bạn được lưu trữ an toàn bằng Firebase với mã hóa tiêu chuẩn ngành';

  @override
  String get httpsConnections =>
      'Chúng tôi sử dụng kết nối HTTPS an toàn cho tất cả việc truyền dữ liệu';

  @override
  String get privateTasks =>
      'Nhiệm vụ của bạn là riêng tư và chỉ bạn mới có thể truy cập';

  @override
  String get securityUpdates =>
      'Chúng tôi thực hiện cập nhật bảo mật và giám sát thường xuyên';

  @override
  String get encryptedBackups =>
      'Dữ liệu sao lưu được mã hóa và lưu trữ an toàn';

  @override
  String get noSellData =>
      'Chúng tôi không bán thông tin cá nhân của bạn cho bên thứ ba';

  @override
  String get noShareTasks =>
      'Chúng tôi không chia sẻ dữ liệu nhiệm vụ của bạn với người dùng khác';

  @override
  String get anonymousStats =>
      'Thống kê sử dụng ẩn danh có thể được sử dụng để cải thiện ứng dụng';

  @override
  String get legalRequirements =>
      'Chúng tôi chỉ có thể chia sẻ dữ liệu nếu được yêu cầu bởi pháp luật hoặc để bảo vệ quyền lợi của chúng tôi';

  @override
  String get accessRight =>
      'Truy cập: Bạn có thể xem tất cả dữ liệu của mình trong ứng dụng';

  @override
  String get updateRight =>
      'Cập nhật: Bạn có thể sửa đổi hồ sơ và thông tin nhiệm vụ bất cứ lúc nào';

  @override
  String get deleteRight =>
      'Xóa: Bạn có thể xóa tài khoản và tất cả dữ liệu liên quan';

  @override
  String get exportRight =>
      'Xuất: Bạn có thể yêu cầu một bản sao dữ liệu của mình';

  @override
  String get controlRight =>
      'Kiểm soát: Bạn có thể quản lý cài đặt thông báo và quyền riêng tư';

  @override
  String get firebaseService =>
      'Firebase: Được sử dụng để xác thực, lưu trữ dữ liệu và các chức năng đám mây';

  @override
  String get googlePlayServices =>
      'Dịch vụ Google Play: Để phân phối ứng dụng và báo cáo sự cố';

  @override
  String get noAdvertising =>
      'Không sử dụng mạng quảng cáo hoặc dịch vụ theo dõi';

  @override
  String get thirdPartyCompliance =>
      'Tất cả các dịch vụ bên thứ ba tuân thủ chính sách bảo mật riêng của họ';

  @override
  String get profileUpdatedSuccess => 'Cập nhật hồ sơ thành công!';

  @override
  String get errorUpdatingProfile => 'Lỗi cập nhật hồ sơ';

  @override
  String get photoUploadComingSoon => 'Tính năng tải ảnh lên sẽ có sớm!';

  @override
  String get tapCameraToChangePhoto =>
      'Nhấn vào biểu tượng máy ảnh để thay đổi ảnh';

  @override
  String get personalInformation => 'Thông tin cá nhân';

  @override
  String get displayName => 'Tên hiển thị';

  @override
  String get enterDisplayName => 'Nhập tên hiển thị của bạn';

  @override
  String get pleaseEnterDisplayName => 'Vui lòng nhập tên hiển thị';

  @override
  String get displayNameMinLength => 'Tên hiển thị phải có ít nhất 2 ký tự';

  @override
  String get emailAddress => 'Địa chỉ email';

  @override
  String get emailCannotBeChanged =>
      'Email không thể thay đổi từ màn hình này vì lý do bảo mật';

  @override
  String get passwordChangedSuccess => 'Thay đổi mật khẩu thành công!';

  @override
  String get currentPasswordIncorrect => 'Mật khẩu hiện tại không đúng';

  @override
  String get newPasswordTooWeak => 'Mật khẩu mới quá yếu';

  @override
  String get requiresRecentLogin =>
      'Vui lòng đăng xuất và đăng nhập lại trước khi thay đổi mật khẩu';

  @override
  String get errorChangingPassword => 'Lỗi thay đổi mật khẩu';

  @override
  String get currentPassword => 'Mật khẩu hiện tại';

  @override
  String get newPassword => 'Mật khẩu mới';

  @override
  String get confirmNewPassword => 'Xác nhận mật khẩu mới';

  @override
  String get pleaseEnterCurrentPassword => 'Vui lòng nhập mật khẩu hiện tại';

  @override
  String get pleaseEnterNewPassword => 'Vui lòng nhập mật khẩu mới';

  @override
  String get passwordMinLength => 'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get passwordMustContainLowercase =>
      'Mật khẩu phải chứa ít nhất một chữ cái thường';

  @override
  String get passwordMustContainUppercase =>
      'Mật khẩu phải chứa ít nhất một chữ cái hoa';

  @override
  String get passwordMustContainNumber => 'Mật khẩu phải chứa ít nhất một số';

  @override
  String get passwordMustContainSpecial =>
      'Mật khẩu phải chứa ít nhất một ký tự đặc biệt';

  @override
  String get pleaseConfirmNewPassword => 'Vui lòng xác nhận mật khẩu mới';

  @override
  String get contactMessages => 'Tin nhắn liên hệ';

  @override
  String get newMessages => 'mới';

  @override
  String get errorLoadingMessages => 'Lỗi';

  @override
  String get noContactMessages => 'Chưa có tin nhắn liên hệ nào';

  @override
  String get newLabel => 'MỚI';

  @override
  String get messageLabel => 'Tin nhắn:';

  @override
  String get markAsRead => 'Đánh dấu đã đọc';

  @override
  String get markAsUnread => 'Đánh dấu chưa đọc';

  @override
  String get reply => 'Trả lời';

  @override
  String get deleteMessage => 'Xóa tin nhắn';

  @override
  String get dayAgo => 'ngày trước';

  @override
  String get daysAgo => 'ngày trước';

  @override
  String get hourAgo => 'giờ trước';

  @override
  String get hoursAgo => 'giờ trước';

  @override
  String get minuteAgo => 'phút trước';

  @override
  String get minutesAgo => 'phút trước';

  @override
  String get justNow => 'Vừa xong';

  @override
  String get failedToUpdateStatus => 'Không thể cập nhật trạng thái tin nhắn';

  @override
  String get confirmDeleteMessage =>
      'Bạn có chắc chắn muốn xóa tin nhắn này không? Hành động này không thể hoàn tác.';

  @override
  String get messageDeletedSuccess => 'Xóa tin nhắn thành công';

  @override
  String get failedToDeleteMessage => 'Không thể xóa tin nhắn';

  @override
  String get replyTo => 'Trả lời cho';

  @override
  String get emailLabel => 'Email:';

  @override
  String get emailAppDescription =>
      'Điều này sẽ mở ứng dụng email mặc định của bạn để soạn thảo trả lời.';

  @override
  String get openEmailApp => 'Mở ứng dụng Email';

  @override
  String get emailFunctionalityPlaceholder =>
      'Chức năng email sẽ được triển khai ở đây';

  @override
  String get userName => 'Tên người dùng';

  @override
  String get defaultEmail => 'user@example.com';

  @override
  String get tasksCompleted => 'Nhiệm vụ\nHoàn thành';

  @override
  String get activeTasks => 'Nhiệm vụ\nĐang thực hiện';

  @override
  String get daysStreak => 'Ngày\nLiên tiếp';

  @override
  String get appearance => 'Giao diện';

  @override
  String get appSettings => 'Cài đặt ứng dụng';

  @override
  String get getRemindersForTasks => 'Nhận nhắc nhở cho nhiệm vụ của bạn';

  @override
  String get updateProfile => 'Cập nhật hồ sơ';

  @override
  String get taskManager => 'Quản Lý Nhiệm Vụ';

  @override
  String get versionNumber => 'Phiên bản 1.0.0';

  @override
  String get ourMission => 'Sứ Mệnh Của Chúng Tôi';

  @override
  String get missionDescription =>
      'Chúng tôi tin rằng việc quản lý nhiệm vụ nên đơn giản và hiệu quả. Ứng dụng của chúng tôi được thiết kế để giúp bạn tổ chức các nhiệm vụ hàng ngày, đặt ưu tiên và đạt được mục tiêu một cách dễ dàng.';

  @override
  String get keyFeatures => 'Tính Năng Chính';

  @override
  String get taskCreationManagement => 'Tạo & Quản Lý Nhiệm Vụ';

  @override
  String get prioritySetting => 'Thiết Lập Ưu Tiên';

  @override
  String get userProfileManagement => 'Quản Lý Hồ Sơ Người Dùng';

  @override
  String get secureAuthentication => 'Xác Thực Bảo Mật';

  @override
  String get cloudSynchronization => 'Đồng Bộ Đám Mây';

  @override
  String get ourTeam => 'Đội Ngũ Của Chúng Tôi';

  @override
  String get teamDescription =>
      'Được phát triển bởi Nhóm 10 - Một đội ngũ các nhà phát triển tận tâm, đam mê tạo ra các công cụ năng suất trực quan và mạnh mẽ.';

  @override
  String get messageSavedSuccessfully => 'Lưu tin nhắn thành công!';

  @override
  String get messageSavedDescription =>
      'Tin nhắn của bạn đã được lưu vào cơ sở dữ liệu. Chúng tôi sẽ phản hồi trong vòng 24 giờ.';

  @override
  String get thankYou => 'Cảm Ơn!';

  @override
  String get thankYouDescription =>
      'Tin nhắn của bạn đã được lưu vào cơ sở dữ liệu. Chúng tôi sẽ phản hồi trong vòng 24 giờ.';

  @override
  String get failedToSendMessage => 'Không thể gửi tin nhắn';

  @override
  String get checkConnectionTryAgain => 'Vui lòng kiểm tra kết nối và thử lại.';

  @override
  String get pleaseEnterMessage => 'Vui lòng nhập tin nhắn của bạn';

  @override
  String messageMinLength(int currentLength) {
    return 'Tin nhắn phải có ít nhất 10 ký tự (hiện tại $currentLength)';
  }

  @override
  String get messageTooLong => 'Tin nhắn quá dài (tối đa 500 ký tự)';

  @override
  String get meaningfulMessage =>
      'Vui lòng nhập tin nhắn có ý nghĩa (tránh lặp lại ký tự)';

  @override
  String get messageMustContainLetters => 'Tin nhắn phải chứa chữ cái hoặc số';

  @override
  String get invalidMessageFormat =>
      'Định dạng tin nhắn không hợp lệ. Vui lòng thử lại.';

  @override
  String get howCanWeHelp => 'Chúng tôi có thể giúp gì cho bạn?';

  @override
  String get helpDescription =>
      'Tìm câu trả lời cho các câu hỏi thường gặp và học cách sử dụng ứng dụng hiệu quả.';

  @override
  String get frequentlyAskedQuestions => 'Câu Hỏi Thường Gặp';

  @override
  String get howToCreateTask => 'Làm thế nào để tạo nhiệm vụ mới?';

  @override
  String get createTaskAnswer =>
      'Nhấn nút \"+\" trên màn hình chính và điền thông tin chi tiết nhiệm vụ bao gồm tiêu đề, mô tả và mức độ ưu tiên.';

  @override
  String get howToEditProfile => 'Làm thế nào để chỉnh sửa hồ sơ?';

  @override
  String get editProfileAnswer =>
      'Vào Menu > Tài Khoản > Chỉnh Sửa Hồ Sơ để cập nhật thông tin cá nhân và ảnh hồ sơ.';

  @override
  String get howToChangePassword => 'Làm thế nào để đổi mật khẩu?';

  @override
  String get changePasswordAnswer =>
      'Điều hướng đến Menu > Tài Khoản > Đổi Mật Khẩu và làm theo hướng dẫn để cập nhật mật khẩu.';

  @override
  String get howToDeleteTasks => 'Tôi có thể xóa nhiệm vụ đã hoàn thành không?';

  @override
  String get deleteTasksAnswer =>
      'Có, bạn có thể xóa nhiệm vụ bằng cách vuốt sang trái trên bất kỳ nhiệm vụ nào trong danh sách nhiệm vụ và nhấn nút xóa.';

  @override
  String get howToSetPriorities => 'Làm thế nào để đặt ưu tiên nhiệm vụ?';

  @override
  String get setPrioritiesAnswer =>
      'Khi tạo hoặc chỉnh sửa nhiệm vụ, bạn có thể chọn từ ba mức độ ưu tiên: Cao, Trung bình hoặc Thấp.';

  @override
  String get quickActions => 'Hành Động Nhanh';

  @override
  String get contactSupport => 'Liên Hệ Hỗ Trợ';

  @override
  String get getHelpFromSupport =>
      'Nhận trợ giúp từ đội ngũ hỗ trợ của chúng tôi';

  @override
  String get reportBug => 'Báo Lỗi';

  @override
  String get letUsKnowAboutIssues => 'Cho chúng tôi biết về bất kỳ vấn đề nào';

  @override
  String get sendFeedback => 'Gửi Phản Hồi';

  @override
  String get shareThoughtsSuggestions => 'Chia sẻ suy nghĩ và đề xuất của bạn';

  @override
  String get describeBugEncountered => 'Vui lòng mô tả lỗi bạn gặp phải:';

  @override
  String get describeBugPlaceholder => 'Mô tả lỗi...';

  @override
  String get bugReportSubmitted => 'Báo cáo lỗi đã được gửi thành công!';

  @override
  String get wedLoveHearThoughts => 'Chúng tôi rất muốn nghe suy nghĩ của bạn:';

  @override
  String get yourFeedbackPlaceholder => 'Phản hồi của bạn...';

  @override
  String get feedbackSentSuccessfully => 'Phản hồi đã được gửi thành công!';

  @override
  String get getInTouch => 'Liên Hệ Với Chúng Tôi';

  @override
  String get getInTouchDescription =>
      'Chúng tôi rất muốn nghe ý kiến của bạn. Gửi tin nhắn cho chúng tôi và chúng tôi sẽ phản hồi sớm nhất có thể.';

  @override
  String get emailContact => 'Email';

  @override
  String get phoneContact => 'Điện Thoại';

  @override
  String get addressContact => 'Địa Chỉ';

  @override
  String get supportEmail => 'support@taskapp.com';

  @override
  String get supportPhone => '+1 (555) 123-4567';

  @override
  String get supportAddress => '123 Main St, Thành Phố, Tiểu Bang 12345';

  @override
  String get sendMessageButton => 'Gửi Tin Nhắn';

  @override
  String get nameAndEmailLocked =>
      'Tên và email được khóa với tài khoản hiện tại của bạn vì lý do bảo mật.';

  @override
  String get nameFieldLabel => 'Tên *';

  @override
  String get emailFieldLabel => 'Email *';

  @override
  String get messageFieldLabel => 'Tin Nhắn *';

  @override
  String get loadingText => 'Đang tải...';

  @override
  String get lockedToCurrentUser => 'Đã khóa với người dùng hiện tại';

  @override
  String get enterYourName => 'Nhập tên của bạn';

  @override
  String get enterYourEmail => 'Nhập email của bạn';

  @override
  String get typeYourMessageHere => 'Nhập tin nhắn của bạn tại đây...';

  @override
  String get accountNameNotFound =>
      'Không tìm thấy tên tài khoản. Vui lòng cập nhật hồ sơ của bạn.';

  @override
  String get nameMinLength => 'Tên phải có ít nhất 2 ký tự';

  @override
  String get accountEmailNotFound =>
      'Không tìm thấy email tài khoản. Vui lòng cập nhật hồ sơ của bạn.';

  @override
  String get pleaseEnterValidEmailContact =>
      'Vui lòng nhập địa chỉ email hợp lệ';

  @override
  String get great => 'Tuyệt vời!';

  @override
  String errorGettingUserProfile(String error) {
    return 'Lỗi khi lấy hồ sơ người dùng từ Firestore: $error';
  }

  @override
  String loadedUserData(String name, String email) {
    return 'Đã tải dữ liệu người dùng - Tên: $name, Email: $email';
  }

  @override
  String errorLoadingUserData(String error) {
    return 'Lỗi khi tải dữ liệu người dùng: $error';
  }

  @override
  String messageValidationFailed(String validationError) {
    return 'Xác thực tin nhắn thất bại: $validationError';
  }

  @override
  String get messageTooShort => 'Tin nhắn phải có ít nhất 10 ký tự';

  @override
  String get failedToSendMessageConnection =>
      'Không thể gửi tin nhắn. Vui lòng kiểm tra kết nối của bạn và thử lại.';

  @override
  String get storageUsed => 'Dung lượng đã sử dụng:';

  @override
  String get profileImages => 'Ảnh hồ sơ:';

  @override
  String get accountCreated => 'Ngày tạo tài khoản:';

  @override
  String get lastActive => 'Hoạt động gần nhất:';

  @override
  String get confirmLogout =>
      'Bạn có chắc chắn muốn đăng xuất khỏi thiết bị này không?';

  @override
  String get signingOut => 'Đang đăng xuất...';

  @override
  String errorSigningOut(String error) {
    return 'Lỗi khi đăng xuất: $error';
  }

  @override
  String get completedTasks => 'Công việc đã hoàn thành:';

  @override
  String get pendingTasks => 'Công việc đang chờ:';

  @override
  String get close => 'Đóng';

  @override
  String get accountManagement => 'Quản lý tài khoản';

  @override
  String get updateProfileDetails => 'Cập nhật tên, ảnh và thông tin cá nhân';

  @override
  String get updatePasswordForSecurity => 'Cập nhật mật khẩu để bảo mật';

  @override
  String get accountData => 'Dữ liệu tài khoản';

  @override
  String get viewAccountStorage =>
      'Xem dung lượng lưu trữ và dữ liệu tài khoản';

  @override
  String get signOutOfAccount => 'Đăng xuất khỏi tài khoản trên thiết bị này';

  @override
  String get deleteAccount => 'Xóa tài khoản';

  @override
  String get permanentlyDeleteAccount =>
      'Xóa vĩnh viễn tài khoản và toàn bộ dữ liệu';

  @override
  String get active => 'Đang hoạt động';

  @override
  String get deleteAccountWarning => 'Thao tác này sẽ xóa vĩnh viễn:';

  @override
  String get deleteProfileSettings => '• Hồ sơ và cài đặt cá nhân';

  @override
  String deleteAllTasks(String taskCount) {
    return '• Tất cả $taskCount công việc và dữ liệu';
  }

  @override
  String get deleteAccountAccess => '• Quyền truy cập và thông tin đăng nhập';

  @override
  String get deletePreferencesHistory => '• Tất cả tùy chọn và lịch sử đã lưu';

  @override
  String get actionCannotBeUndone => 'Thao tác này không thể hoàn tác';

  @override
  String get continueToDelete => 'Tiếp tục xóa';

  @override
  String get finalConfirmation => 'Xác nhận cuối cùng';

  @override
  String get finalDeleteInstruction =>
      'Vui lòng nhập mật khẩu và gõ \"DELETE\" để xác nhận:';

  @override
  String get enterPassword => 'Nhập mật khẩu';

  @override
  String get confirmation => 'Xác nhận';

  @override
  String get typeDeleteHere => 'Gõ DELETE tại đây';

  @override
  String get deleteWarningDetails =>
      '⚠️ Thao tác này sẽ xóa vĩnh viễn:\n• Hồ sơ và cài đặt\n• Tất cả công việc và dữ liệu\n• Quyền truy cập tài khoản';

  @override
  String get pleaseEnterPassword => 'Vui lòng nhập mật khẩu';

  @override
  String get pleaseTypeDelete => 'Vui lòng gõ \"DELETE\" để xác nhận';

  @override
  String get deleteForever => 'Xóa vĩnh viễn';

  @override
  String get deletingAccount => 'Đang xóa tài khoản...';

  @override
  String get mayTakeFewMoments => 'Quá trình này có thể mất vài phút';

  @override
  String get accountDeletedSuccessfully => 'Xóa tài khoản thành công';

  @override
  String get incorrectPassword => 'Mật khẩu không đúng. Vui lòng thử lại.';

  @override
  String get tooManyAttempts => 'Quá nhiều lần thử. Vui lòng thử lại sau.';

  @override
  String get networkError => 'Lỗi mạng. Vui lòng kiểm tra kết nối.';

  @override
  String failedToDeleteAccount(String error) {
    return 'Không thể xóa tài khoản: $error';
  }

  @override
  String get signOutAndBackIn =>
      'Vui lòng đăng xuất và đăng nhập lại, sau đó thử lại.';

  @override
  String get january => 'Tháng 1';

  @override
  String get february => 'Tháng 2';

  @override
  String get march => 'Tháng 3';

  @override
  String get april => 'Tháng 4';

  @override
  String get may => 'Tháng 5';

  @override
  String get june => 'Tháng 6';

  @override
  String get july => 'Tháng 7';

  @override
  String get august => 'Tháng 8';

  @override
  String get september => 'Tháng 9';

  @override
  String get october => 'Tháng 10';

  @override
  String get november => 'Tháng 11';

  @override
  String get december => 'Tháng 12';

  @override
  String get filterTasksTitle => 'Lọc & Tìm Kiếm Nhiệm Vụ';

  @override
  String get clearAll => 'Xóa Tất Cả';

  @override
  String get status => 'Trạng Thái';

  @override
  String get allTasks => 'Tất Cả Nhiệm Vụ';

  @override
  String get allPriorities => 'Tất Cả Độ Ưu Tiên';

  @override
  String get highPriority => 'Ưu Tiên Cao';

  @override
  String get mediumPriority => 'Ưu Tiên Trung Bình';

  @override
  String get lowPriority => 'Ưu Tiên Thấp';

  @override
  String get allDates => 'Tất Cả Ngày';

  @override
  String get dueToday => 'Đến Hạn Hôm Nay';

  @override
  String get customRange => 'Khoảng Tùy Chỉnh';

  @override
  String get customDateRange => 'Khoảng Ngày Tùy Chỉnh';

  @override
  String get clearCustomRange => 'Xóa khoảng tùy chỉnh';

  @override
  String get selectDateRange => 'Chọn Khoảng Ngày';

  @override
  String get category => 'Danh Mục';

  @override
  String get allCategories => 'Tất Cả Danh Mục';

  @override
  String get work => 'Công Việc';

  @override
  String get personal => 'Cá Nhân';

  @override
  String get shopping => 'Mua Sắm';

  @override
  String get health => 'Sức Khỏe';

  @override
  String get education => 'Giáo Dục';

  @override
  String get saveCurrentFilters => 'Lưu Bộ Lọc Hiện Tại';

  @override
  String get applyFilters => 'Áp Dụng Bộ Lọc';

  @override
  String get searchTasksTitle => 'Tìm Kiếm Nhiệm Vụ';

  @override
  String get searchByTaskNameOrDescription =>
      'Tìm kiếm theo tên nhiệm vụ hoặc mô tả...';

  @override
  String get savedPresets => 'Bộ Lọc Đã Lưu';

  @override
  String get deletePreset => 'Xóa Bộ Lọc';

  @override
  String deletePresetConfirmation(String presetName) {
    return 'Bạn có chắc chắn muốn xóa bộ lọc \"$presetName\"?';
  }

  @override
  String get pleaseEnterPresetName => 'Vui lòng nhập tên bộ lọc';

  @override
  String presetSavedSuccessfully(String name) {
    return 'Đã lưu bộ lọc \"$name\" thành công!';
  }

  @override
  String appliedPreset(String presetName) {
    return 'Đã áp dụng bộ lọc \"$presetName\"';
  }

  @override
  String presetRemoved(String name) {
    return 'Đã xóa bộ lọc \"$name\"';
  }

  @override
  String get noTasksYet => 'Chưa Có Nhiệm Vụ Nào';

  @override
  String get createFirstTask =>
      'Tạo nhiệm vụ đầu tiên của bạn để bắt đầu với năng suất!';

  @override
  String get noSearchResults => 'Không Có Kết Quả Tìm Kiếm';

  @override
  String get noTasksMatchSearch =>
      'Không có nhiệm vụ nào khớp với truy vấn tìm kiếm của bạn. Hãy thử các từ khóa khác.';

  @override
  String get clearSearch => 'Xóa Tìm Kiếm';

  @override
  String get noMatchingTasks => 'Không Có Nhiệm Vụ Phù Hợp';

  @override
  String get noTasksMatchCriteria =>
      'Không có nhiệm vụ nào khớp với tiêu chí tìm kiếm và bộ lọc của bạn.';

  @override
  String get adjustFilters => 'Hãy thử điều chỉnh bộ lọc để xem thêm nhiệm vụ.';

  @override
  String get clearFilters => 'Xóa Bộ Lọc';

  @override
  String get noTasksToDisplay => 'Không có nhiệm vụ để hiển thị';

  @override
  String get addNewTaskToGetStarted => 'Thêm nhiệm vụ mới để bắt đầu';

  @override
  String get pullDownToRefresh => 'Kéo xuống để làm mới hoặc thêm nhiệm vụ mới';

  @override
  String get dueLabel => 'Đến hạn:';

  @override
  String get markAsPending => 'Đánh Dấu Chưa Hoàn Thành';

  @override
  String get markAsCompleted => 'Đánh Dấu Đã Hoàn Thành';

  @override
  String get enterTaskTitle => 'Nhập tiêu đề nhiệm vụ';

  @override
  String get pleaseEnterTitle => 'Vui lòng nhập tiêu đề';

  @override
  String get taskDescriptionOptional => 'Mô Tả Nhiệm Vụ (Tùy Chọn)';

  @override
  String get enterTaskDescriptionOptional => 'Nhập mô tả nhiệm vụ (tùy chọn)';

  @override
  String get dueDateOptional => 'Ngày Đến Hạn (Tùy Chọn)';

  @override
  String get selectDueDate => 'Chọn ngày đến hạn';

  @override
  String get updateTask => 'Cập Nhật Nhiệm Vụ';

  @override
  String get taskUpdatedSuccessfully => 'Nhiệm vụ đã được cập nhật thành công!';

  @override
  String get taskAddedSuccessfully => 'Nhiệm vụ đã được thêm thành công!';

  @override
  String get failedToAddTask => 'Không thể thêm nhiệm vụ';

  @override
  String anErrorOccurred(String error) {
    return 'Đã xảy ra lỗi: $error';
  }

  @override
  String helloFriend(String name) {
    return 'Xin chào, $name! 👋';
  }

  @override
  String get helloFriendDefault => 'Xin chào, bạn! 👋';

  @override
  String get successRate => 'Tỷ lệ thành công';

  @override
  String get categories => 'Danh mục';

  @override
  String get dailyAvg => 'Trung bình ngày';

  @override
  String get recentActivity => 'Hoạt động gần đây';

  @override
  String get noRecentActivity => 'Không có hoạt động gần đây';

  @override
  String get achievements => 'Thành tích 🏆';

  @override
  String get firstTask => 'Nhiệm vụ đầu tiên';

  @override
  String get firstTaskDesc => 'Tạo nhiệm vụ đầu tiên của bạn';

  @override
  String get finisher => 'Người hoàn thành';

  @override
  String get finisherDesc => 'Hoàn thành nhiệm vụ đầu tiên';

  @override
  String get productive => 'Năng suất';

  @override
  String get productiveDesc => 'Hoàn thành 5 nhiệm vụ';

  @override
  String get taskMaster => 'Bậc thầy nhiệm vụ';

  @override
  String get taskMasterDesc => 'Hoàn thành 20 nhiệm vụ';

  @override
  String get lightning => 'Tia chớp';

  @override
  String get lightningDesc => 'Hoàn thành 50 nhiệm vụ';

  @override
  String get organizer => 'Người tổ chức';

  @override
  String get organizerDesc => 'Sử dụng 3 danh mục khác nhau';

  @override
  String get achiever => 'Người đạt được';

  @override
  String get achieverDesc => 'Duy trì tỷ lệ hoàn thành 80%';

  @override
  String get streak => 'Chuỗi';

  @override
  String get streakDesc => 'Hoàn thành nhiệm vụ trong 7 ngày';

  @override
  String achievementsProgress(int earned, int total) {
    return 'Tiến độ: $earned/$total thành tích đã mở khóa';
  }

  @override
  String completedTask(String title) {
    return 'Đã hoàn thành \"$title\"';
  }

  @override
  String createdTask(String title) {
    return 'Đã tạo \"$title\"';
  }

  @override
  String get accountInformation => 'Thông tin tài khoản';

  @override
  String get memberSince => 'Thành viên từ';

  @override
  String get notAvailable => 'Không có sẵn';

  @override
  String get unknown => 'Không xác định';

  @override
  String monthAgo(int count) {
    return '$count tháng trước';
  }

  @override
  String monthsAgo(int count) {
    return '$count tháng trước';
  }

  @override
  String yearAgo(int count) {
    return '$count năm trước';
  }

  @override
  String yearsAgo(int count) {
    return '$count năm trước';
  }

  @override
  String get productivityInsights => 'Thông tin năng suất';

  @override
  String get completionRate => 'Tỷ lệ hoàn thành';

  @override
  String get dailyAverage => 'Trung bình hàng ngày';

  @override
  String get taskDistribution => 'Phân bổ nhiệm vụ';

  @override
  String get byCategory => 'Theo danh mục';

  @override
  String get byPriority => 'Theo ưu tiên';

  @override
  String get weeklyProgress => 'Tiến độ hàng tuần';

  @override
  String get allActivity => 'Tất cả hoạt động';

  @override
  String get noActivityToShow => 'Không có hoạt động để hiển thị';

  @override
  String get testNotifications => 'Kiểm tra thông báo';

  @override
  String get testNotificationFeatures => 'Kiểm tra các tính năng thông báo:';

  @override
  String get dataAndPrivacy => 'Dữ liệu & Bảo mật';

  @override
  String get learnAboutPrivacyPractices =>
      'Tìm hiểu về các thực hành bảo mật của chúng tôi';

  @override
  String get freeUpStorageSpace => 'Giải phóng dung lượng lưu trữ';

  @override
  String get resetAllSettingsToDefault => 'Đặt lại tất cả cài đặt về mặc định';

  @override
  String get settingsResetSuccessfully => 'Đã đặt lại cài đặt thành công';

  @override
  String get welcomeBack => 'Chào mừng trở lại';

  @override
  String get signInToContinue => 'Đăng nhập để tiếp tục';

  @override
  String get signUpToStart => 'Đăng ký để bắt đầu';

  @override
  String get selectSavedAccount => 'Chọn tài khoản đã lưu';

  @override
  String get enterEmailManually => 'Nhập email thủ công';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get rememberMe => 'Ghi nhớ đăng nhập';

  @override
  String get signIn => 'Đăng nhập';

  @override
  String get pleaseEnterYourName => 'Vui lòng nhập tên của bạn';

  @override
  String get pleaseEnterYourEmail => 'Vui lòng nhập email của bạn';

  @override
  String get pleaseEnterYourPassword => 'Vui lòng nhập mật khẩu của bạn';

  @override
  String get passwordMustBeAtLeast6Characters =>
      'Mật khẩu phải có ít nhất 6 ký tự';

  @override
  String get noAccountFoundWithThisEmail =>
      'Không tìm thấy tài khoản với email này';

  @override
  String get invalidEmailOrPassword =>
      'Email hoặc mật khẩu không hợp lệ. Vui lòng kiểm tra thông tin đăng nhập và thử lại.';

  @override
  String get accountAlreadyExistsWithThisEmail =>
      'Đã có tài khoản với email này';

  @override
  String get passwordIsTooWeak => 'Mật khẩu quá yếu';

  @override
  String get invalidEmailAddress => 'Địa chỉ email không hợp lệ';

  @override
  String get networkConnectionFailed =>
      'Kết nối mạng thất bại. Vui lòng kiểm tra kết nối internet của bạn.';

  @override
  String get tooManyFailedAttempts =>
      'Quá nhiều lần thử thất bại. Vui lòng thử lại sau.';

  @override
  String authenticationFailed(String error) {
    return 'Xác thực thất bại: $error';
  }

  @override
  String get accountSavedAndSyncedWithFirebase =>
      'Tài khoản đã được lưu và đồng bộ với Firebase';
}
