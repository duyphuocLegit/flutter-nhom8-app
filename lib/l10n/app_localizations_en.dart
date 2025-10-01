// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get appTitle => 'TaskApp';

  @override
  String get hello => 'Hello';

  @override
  String get welcome => 'Welcome';

  @override
  String get letsBeProductive => 'Let\'s be productive today';

  @override
  String get login => 'Login';

  @override
  String get logout => 'Logout';

  @override
  String get email => 'Email';

  @override
  String get password => 'Password';

  @override
  String get confirmPassword => 'Confirm Password';

  @override
  String get signUp => 'Sign Up';

  @override
  String get forgotPassword => 'Forgot Password?';

  @override
  String get createAccount => 'Create Account';

  @override
  String get alreadyHaveAccount => 'Already have an account?';

  @override
  String get dontHaveAccount => 'Don\'t have an account?';

  @override
  String get home => 'Home';

  @override
  String get tasks => 'Tasks';

  @override
  String get calendar => 'Calendar';

  @override
  String get settings => 'Settings';

  @override
  String get profile => 'Profile';

  @override
  String get addTask => 'Add Task';

  @override
  String get taskTitle => 'Task Title';

  @override
  String get taskDescription => 'Task Description';

  @override
  String get dueDate => 'Due Date';

  @override
  String get priority => 'Priority';

  @override
  String get high => 'High';

  @override
  String get medium => 'Medium';

  @override
  String get low => 'Low';

  @override
  String get save => 'Save';

  @override
  String get cancel => 'Cancel';

  @override
  String get delete => 'Delete';

  @override
  String get edit => 'Edit';

  @override
  String get language => 'Language';

  @override
  String get theme => 'Theme';

  @override
  String get notifications => 'Notifications';

  @override
  String get aboutApp => 'About App';

  @override
  String get version => 'Version';

  @override
  String get darkMode => 'Dark Mode';

  @override
  String get lightMode => 'Light Mode';

  @override
  String get systemMode => 'System Mode';

  @override
  String get completed => 'Completed';

  @override
  String get pending => 'Pending';

  @override
  String get overdue => 'Overdue';

  @override
  String get noTasksFound => 'No tasks found';

  @override
  String get searchTasks => 'Search tasks...';

  @override
  String get yourProgress => 'Your Progress';

  @override
  String get done => 'Done';

  @override
  String get left => 'Left';

  @override
  String get findTasks => 'Find Tasks';

  @override
  String get yourTasks => 'Your Tasks';

  @override
  String get clear => 'Clear';

  @override
  String showingTasks(int count) {
    String _temp0 = intl.Intl.pluralLogic(
      count,
      locale: localeName,
      other: 's',
      one: '',
    );
    return 'Showing $count task$_temp0';
  }

  @override
  String get allCompleted => 'All completed! 🎉';

  @override
  String get clearAllFilters => 'Clear All Filters';

  @override
  String get filterByPriority => 'Filter by Priority';

  @override
  String get filterByStatus => 'Filter by Status';

  @override
  String get all => 'All';

  @override
  String get today => 'Today';

  @override
  String get thisWeek => 'This Week';

  @override
  String get thisMonth => 'This Month';

  @override
  String get error => 'Error';

  @override
  String get success => 'Success';

  @override
  String get loading => 'Loading...';

  @override
  String get retry => 'Retry';

  @override
  String get noInternetConnection => 'No internet connection';

  @override
  String get pleaseEnterValidEmail => 'Please enter a valid email';

  @override
  String get passwordTooShort => 'Password must be at least 6 characters';

  @override
  String get passwordsDoNotMatch => 'Passwords do not match';

  @override
  String get fieldRequired => 'This field is required';

  @override
  String get clearCache => 'Clear Cache';

  @override
  String get resetSettings => 'Reset Settings';

  @override
  String get clearCacheMessage =>
      'This will clear all temporary files and cached data. The app may need to download content again.';

  @override
  String get resetSettingsMessage =>
      'This will reset all settings to their default values. This action cannot be undone.';

  @override
  String get cacheCleared => 'Cache cleared successfully';

  @override
  String get reset => 'Reset';

  @override
  String get removeAccount => 'Remove Account';

  @override
  String removeAccountMessage(String email) {
    return 'Remove $email from saved accounts?';
  }

  @override
  String get remove => 'Remove';

  @override
  String get accountRemoved => 'Account removed';

  @override
  String errorRemovingAccount(String error) {
    return 'Error removing account: $error';
  }

  @override
  String get accountSaved => 'Account saved and synced with Firebase';

  @override
  String get mostRecent => 'Most Recent';

  @override
  String get alphabetical => 'Alphabetical';

  @override
  String get editTask => 'Edit Task';

  @override
  String get addNewTask => 'Add New Task';

  @override
  String get menu => 'Menu';

  @override
  String get account => 'Account';

  @override
  String get contactUs => 'Contact Us';

  @override
  String get aboutUs => 'About Us';

  @override
  String get help => 'Help';

  @override
  String get sendMessage => 'Send Message';

  @override
  String get send => 'Send';

  @override
  String get name => 'Name';

  @override
  String get message => 'Message';

  @override
  String get writeYourMessage => 'Write your message here...';

  @override
  String get messageSent => 'Message sent successfully!';

  @override
  String get viewAll => 'View All';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get changePassword => 'Change Password';

  @override
  String get accountDataUsage => 'Account Data Usage';

  @override
  String get totalTasks => 'Total Tasks';

  @override
  String get activeProjects => 'Active Projects';

  @override
  String get dataSync => 'Data Sync';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get lastUpdated => 'Last Updated';

  @override
  String get privacyDescription =>
      'Your privacy is important to us. This policy explains how we collect, use, and protect your information.';

  @override
  String get informationWeCollect => 'Information We Collect';

  @override
  String get howWeUseYourInformation => 'How We Use Your Information';

  @override
  String get dataStorageSecurity => 'Data Storage & Security';

  @override
  String get dataSharing => 'Data Sharing';

  @override
  String get yourRights => 'Your Rights';

  @override
  String get thirdPartyServices => 'Third-Party Services';

  @override
  String get questionsOrConcerns => 'Questions or Concerns?';

  @override
  String get privacyContactDescription =>
      'If you have any questions about this Privacy Policy or how we handle your data, please contact us:';

  @override
  String get privacyResponseTime =>
      'We will respond to all privacy-related inquiries within 48 hours.';

  @override
  String get accountInfoCollection =>
      'Account Information: Email address, name, and profile picture when you sign up';

  @override
  String get taskDataCollection =>
      'Task Data: Your tasks, categories, due dates, and completion status';

  @override
  String get usageDataCollection =>
      'Usage Data: How you interact with the app for improving user experience';

  @override
  String get deviceInfoCollection =>
      'Device Information: Device type and operating system for compatibility';

  @override
  String get provideService =>
      'Provide and maintain the task management service';

  @override
  String get syncData => 'Sync your data across your devices securely';

  @override
  String get sendNotifications =>
      'Send notifications about your tasks and deadlines';

  @override
  String get improveApp => 'Improve app performance and add new features';

  @override
  String get customerSupport => 'Provide customer support when needed';

  @override
  String get secureStorage =>
      'Your data is stored securely using Firebase with industry-standard encryption';

  @override
  String get httpsConnections =>
      'We use secure HTTPS connections for all data transmission';

  @override
  String get privateTasks =>
      'Your tasks are private and only accessible to you';

  @override
  String get securityUpdates =>
      'We implement regular security updates and monitoring';

  @override
  String get encryptedBackups =>
      'Data backups are encrypted and stored securely';

  @override
  String get noSellData =>
      'We do not sell your personal information to third parties';

  @override
  String get noShareTasks => 'We do not share your task data with other users';

  @override
  String get anonymousStats =>
      'Anonymous usage statistics may be used to improve the app';

  @override
  String get legalRequirements =>
      'We may share data only if required by law or to protect our rights';

  @override
  String get accessRight => 'Access: You can view all your data within the app';

  @override
  String get updateRight =>
      'Update: You can modify your profile and task information anytime';

  @override
  String get deleteRight =>
      'Delete: You can delete your account and all associated data';

  @override
  String get exportRight => 'Export: You can request a copy of your data';

  @override
  String get controlRight =>
      'Control: You can manage notification and privacy settings';

  @override
  String get firebaseService =>
      'Firebase: Used for authentication, data storage, and cloud functions';

  @override
  String get googlePlayServices =>
      'Google Play Services: For app distribution and crash reporting';

  @override
  String get noAdvertising =>
      'No advertising networks or tracking services are used';

  @override
  String get thirdPartyCompliance =>
      'All third-party services comply with their own privacy policies';

  @override
  String get profileUpdatedSuccess => 'Profile updated successfully!';

  @override
  String get errorUpdatingProfile => 'Error updating profile';

  @override
  String get photoUploadComingSoon => 'Photo upload feature coming soon!';

  @override
  String get tapCameraToChangePhoto => 'Tap camera icon to change photo';

  @override
  String get personalInformation => 'Personal Information';

  @override
  String get displayName => 'Display Name';

  @override
  String get enterDisplayName => 'Enter your display name';

  @override
  String get pleaseEnterDisplayName => 'Please enter a display name';

  @override
  String get displayNameMinLength =>
      'Display name must be at least 2 characters';

  @override
  String get emailAddress => 'Email Address';

  @override
  String get emailCannotBeChanged =>
      'Email cannot be changed from this screen for security reasons';

  @override
  String get passwordChangedSuccess => 'Password changed successfully!';

  @override
  String get currentPasswordIncorrect => 'Current password is incorrect';

  @override
  String get newPasswordTooWeak => 'New password is too weak';

  @override
  String get requiresRecentLogin =>
      'Please log out and log in again before changing password';

  @override
  String get errorChangingPassword => 'Error changing password';

  @override
  String get currentPassword => 'Current Password';

  @override
  String get newPassword => 'New Password';

  @override
  String get confirmNewPassword => 'Confirm New Password';

  @override
  String get pleaseEnterCurrentPassword => 'Please enter your current password';

  @override
  String get pleaseEnterNewPassword => 'Please enter a new password';

  @override
  String get passwordMinLength => 'Password must be at least 6 characters';

  @override
  String get passwordMustContainLowercase =>
      'Password must contain at least one lowercase letter';

  @override
  String get passwordMustContainUppercase =>
      'Password must contain at least one uppercase letter';

  @override
  String get passwordMustContainNumber =>
      'Password must contain at least one number';

  @override
  String get passwordMustContainSpecial =>
      'Password must contain at least one special character';

  @override
  String get pleaseConfirmNewPassword => 'Please confirm your new password';

  @override
  String get contactMessages => 'Contact Messages';

  @override
  String get newMessages => 'new';

  @override
  String get errorLoadingMessages => 'Error';

  @override
  String get noContactMessages => 'No contact messages yet';

  @override
  String get newLabel => 'NEW';

  @override
  String get messageLabel => 'Message:';

  @override
  String get markAsRead => 'Mark as Read';

  @override
  String get markAsUnread => 'Mark as Unread';

  @override
  String get reply => 'Reply';

  @override
  String get deleteMessage => 'Delete Message';

  @override
  String get dayAgo => 'day ago';

  @override
  String get daysAgo => 'days ago';

  @override
  String get hourAgo => 'hour ago';

  @override
  String get hoursAgo => 'hours ago';

  @override
  String get minuteAgo => 'minute ago';

  @override
  String get minutesAgo => 'minutes ago';

  @override
  String get justNow => 'Just now';

  @override
  String get failedToUpdateStatus => 'Failed to update message status';

  @override
  String get confirmDeleteMessage =>
      'Are you sure you want to delete this message? This action cannot be undone.';

  @override
  String get messageDeletedSuccess => 'Message deleted successfully';

  @override
  String get failedToDeleteMessage => 'Failed to delete message';

  @override
  String get replyTo => 'Reply to';

  @override
  String get emailLabel => 'Email:';

  @override
  String get emailAppDescription =>
      'This will open your default email app to compose a reply.';

  @override
  String get openEmailApp => 'Open Email App';

  @override
  String get emailFunctionalityPlaceholder =>
      'Email functionality would be implemented here';

  @override
  String get userName => 'User Name';

  @override
  String get defaultEmail => 'user@example.com';

  @override
  String get tasksCompleted => 'Tasks\nCompleted';

  @override
  String get activeTasks => 'Active\nTasks';

  @override
  String get daysStreak => 'Days\nStreak';

  @override
  String get appearance => 'Appearance';

  @override
  String get appSettings => 'App Settings';

  @override
  String get getRemindersForTasks => 'Get reminders for your tasks';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get taskManager => 'Task Manager';

  @override
  String get versionNumber => 'Version 1.0.0';

  @override
  String get ourMission => 'Our Mission';

  @override
  String get missionDescription =>
      'We believe in making task management simple and efficient. Our app is designed to help you organize your daily tasks, set priorities, and achieve your goals with ease.';

  @override
  String get keyFeatures => 'Key Features';

  @override
  String get taskCreationManagement => 'Task Creation & Management';

  @override
  String get prioritySetting => 'Priority Setting';

  @override
  String get userProfileManagement => 'User Profile Management';

  @override
  String get secureAuthentication => 'Secure Authentication';

  @override
  String get cloudSynchronization => 'Cloud Synchronization';

  @override
  String get ourTeam => 'Our Team';

  @override
  String get teamDescription =>
      'Developed by Group 10 - A dedicated team of developers passionate about creating intuitive and powerful productivity tools.';

  @override
  String get messageSavedSuccessfully => 'Message saved successfully!';

  @override
  String get messageSavedDescription =>
      'Your message has been saved to our database. We\'ll get back to you within 24 hours.';

  @override
  String get thankYou => 'Thank You!';

  @override
  String get thankYouDescription =>
      'Your message has been saved to our database. We\'ll respond within 24 hours.';

  @override
  String get failedToSendMessage => 'Failed to send message';

  @override
  String get checkConnectionTryAgain =>
      'Please check your connection and try again.';

  @override
  String get pleaseEnterMessage => 'Please enter your message';

  @override
  String messageMinLength(int currentLength) {
    return 'Message must be at least 10 characters (currently $currentLength)';
  }

  @override
  String get messageTooLong => 'Message is too long (maximum 500 characters)';

  @override
  String get meaningfulMessage =>
      'Please enter a meaningful message (avoid repeated characters)';

  @override
  String get messageMustContainLetters =>
      'Message must contain letters or numbers';

  @override
  String get invalidMessageFormat =>
      'Invalid message format. Please try again.';

  @override
  String get howCanWeHelp => 'How can we help you?';

  @override
  String get helpDescription =>
      'Find answers to common questions and learn how to use the app effectively.';

  @override
  String get frequentlyAskedQuestions => 'Frequently Asked Questions';

  @override
  String get howToCreateTask => 'How do I create a new task?';

  @override
  String get createTaskAnswer =>
      'Tap the \"+\" button on the home screen and fill in the task details including title, description, and priority level.';

  @override
  String get howToEditProfile => 'How can I edit my profile?';

  @override
  String get editProfileAnswer =>
      'Go to Menu > My Account > Edit Profile to update your personal information and profile picture.';

  @override
  String get howToChangePassword => 'How do I change my password?';

  @override
  String get changePasswordAnswer =>
      'Navigate to Menu > My Account > Change Password and follow the instructions to update your password.';

  @override
  String get howToDeleteTasks => 'Can I delete completed tasks?';

  @override
  String get deleteTasksAnswer =>
      'Yes, you can delete tasks by swiping left on any task in your task list and tapping the delete button.';

  @override
  String get howToSetPriorities => 'How do I set task priorities?';

  @override
  String get setPrioritiesAnswer =>
      'When creating or editing a task, you can select from three priority levels: High, Medium, or Low.';

  @override
  String get quickActions => 'Quick Actions';

  @override
  String get contactSupport => 'Contact Support';

  @override
  String get getHelpFromSupport => 'Get help from our support team';

  @override
  String get reportBug => 'Report a Bug';

  @override
  String get letUsKnowAboutIssues => 'Let us know about any issues';

  @override
  String get sendFeedback => 'Send Feedback';

  @override
  String get shareThoughtsSuggestions => 'Share your thoughts and suggestions';

  @override
  String get describeBugEncountered =>
      'Please describe the bug you encountered:';

  @override
  String get describeBugPlaceholder => 'Describe the bug...';

  @override
  String get bugReportSubmitted => 'Bug report submitted successfully!';

  @override
  String get wedLoveHearThoughts => 'We\'d love to hear your thoughts:';

  @override
  String get yourFeedbackPlaceholder => 'Your feedback...';

  @override
  String get feedbackSentSuccessfully => 'Feedback sent successfully!';

  @override
  String get getInTouch => 'Get in Touch';

  @override
  String get getInTouchDescription =>
      'We\'d love to hear from you. Send us a message and we\'ll respond as soon as possible.';

  @override
  String get emailContact => 'Email';

  @override
  String get phoneContact => 'Phone';

  @override
  String get addressContact => 'Address';

  @override
  String get supportEmail => 'support@taskapp.com';

  @override
  String get supportPhone => '+1 (555) 123-4567';

  @override
  String get supportAddress => '123 Main St, City, State 12345';

  @override
  String get sendMessageButton => 'Send Message';

  @override
  String get nameAndEmailLocked =>
      'Name and email are locked to your current account for security.';

  @override
  String get nameFieldLabel => 'Name *';

  @override
  String get emailFieldLabel => 'Email *';

  @override
  String get messageFieldLabel => 'Message *';

  @override
  String get loadingText => 'Loading...';

  @override
  String get lockedToCurrentUser => 'Locked to current user';

  @override
  String get enterYourName => 'Enter your name';

  @override
  String get enterYourEmail => 'Enter your email';

  @override
  String get typeYourMessageHere => 'Type your message here...';

  @override
  String get accountNameNotFound =>
      'Account name not found. Please update your profile.';

  @override
  String get nameMinLength => 'Name must be at least 2 characters';

  @override
  String get accountEmailNotFound =>
      'Account email not found. Please update your profile.';

  @override
  String get pleaseEnterValidEmailContact =>
      'Please enter a valid email address';

  @override
  String get great => 'Great!';

  @override
  String errorGettingUserProfile(String error) {
    return 'Error getting user profile from Firestore: $error';
  }

  @override
  String loadedUserData(String name, String email) {
    return 'Loaded user data - Name: $name, Email: $email';
  }

  @override
  String errorLoadingUserData(String error) {
    return 'Error loading user data: $error';
  }

  @override
  String messageValidationFailed(String validationError) {
    return 'Message validation failed: $validationError';
  }

  @override
  String get messageTooShort => 'Message must be at least 10 characters long';

  @override
  String get failedToSendMessageConnection =>
      'Failed to send message. Please check your connection and try again.';

  @override
  String get storageUsed => 'Storage Used:';

  @override
  String get profileImages => 'Profile Images:';

  @override
  String get accountCreated => 'Account Created:';

  @override
  String get lastActive => 'Last Active:';

  @override
  String get confirmLogout =>
      'Are you sure you want to logout from this device?';

  @override
  String get signingOut => 'Signing out...';

  @override
  String errorSigningOut(String error) {
    return 'Error signing out: $error';
  }

  @override
  String get completedTasks => 'Completed Tasks:';

  @override
  String get pendingTasks => 'Pending Tasks:';

  @override
  String get close => 'Close';

  @override
  String get accountManagement => 'Account Management';

  @override
  String get updateProfileDetails => 'Update name, photo, and personal details';

  @override
  String get updatePasswordForSecurity =>
      'Update your account password for security';

  @override
  String get accountData => 'Account Data';

  @override
  String get viewAccountStorage => 'View your account storage and data usage';

  @override
  String get signOutOfAccount => 'Sign out of your account on this device';

  @override
  String get deleteAccount => 'Delete Account';

  @override
  String get permanentlyDeleteAccount =>
      'Permanently delete your account and all data';

  @override
  String get active => 'Active';

  @override
  String get deleteAccountWarning => 'This action will permanently remove:';

  @override
  String get deleteProfileSettings => '• Your profile and personal settings';

  @override
  String deleteAllTasks(String taskCount) {
    return '• All $taskCount tasks and their data';
  }

  @override
  String get deleteAccountAccess => '• Account access and login credentials';

  @override
  String get deletePreferencesHistory => '• All stored preferences and history';

  @override
  String get actionCannotBeUndone => 'This action cannot be undone';

  @override
  String get continueToDelete => 'Continue to Delete';

  @override
  String get finalConfirmation => 'Final Confirmation';

  @override
  String get finalDeleteInstruction =>
      'For security, please enter your password and type \"DELETE\" to confirm:';

  @override
  String get enterPassword => 'Enter your password';

  @override
  String get confirmation => 'Confirmation';

  @override
  String get typeDeleteHere => 'Type DELETE here';

  @override
  String get deleteWarningDetails =>
      '⚠️ This will permanently delete:\n• Your profile and settings\n• All tasks and data\n• Account access';

  @override
  String get pleaseEnterPassword => 'Please enter your password';

  @override
  String get pleaseTypeDelete => 'Please type \"DELETE\" to confirm';

  @override
  String get deleteForever => 'Delete Forever';

  @override
  String get deletingAccount => 'Deleting your account...';

  @override
  String get mayTakeFewMoments => 'This may take a few moments';

  @override
  String get accountDeletedSuccessfully => 'Account deleted successfully';

  @override
  String get incorrectPassword => 'Incorrect password. Please try again.';

  @override
  String get tooManyAttempts => 'Too many attempts. Please try again later.';

  @override
  String get networkError => 'Network error. Please check your connection.';

  @override
  String failedToDeleteAccount(String error) {
    return 'Failed to delete account: $error';
  }

  @override
  String get signOutAndBackIn => 'Please sign out and back in, then try again.';

  @override
  String get january => 'January';

  @override
  String get february => 'February';

  @override
  String get march => 'March';

  @override
  String get april => 'April';

  @override
  String get may => 'May';

  @override
  String get june => 'June';

  @override
  String get july => 'July';

  @override
  String get august => 'August';

  @override
  String get september => 'September';

  @override
  String get october => 'October';

  @override
  String get november => 'November';

  @override
  String get december => 'December';

  @override
  String get filterTasksTitle => 'Filter & Search Tasks';

  @override
  String get clearAll => 'Clear All';

  @override
  String get status => 'Status';

  @override
  String get allTasks => 'All Tasks';

  @override
  String get allPriorities => 'All Priorities';

  @override
  String get highPriority => 'High Priority';

  @override
  String get mediumPriority => 'Medium Priority';

  @override
  String get lowPriority => 'Low Priority';

  @override
  String get allDates => 'All Dates';

  @override
  String get dueToday => 'Due Today';

  @override
  String get customRange => 'Custom Range';

  @override
  String get customDateRange => 'Custom Date Range';

  @override
  String get clearCustomRange => 'Clear custom range';

  @override
  String get selectDateRange => 'Select Date Range';

  @override
  String get category => 'Category';

  @override
  String get allCategories => 'All Categories';

  @override
  String get work => 'Work';

  @override
  String get personal => 'Personal';

  @override
  String get shopping => 'Shopping';

  @override
  String get health => 'Health';

  @override
  String get education => 'Education';

  @override
  String get saveCurrentFilters => 'Save Current Filters';

  @override
  String get applyFilters => 'Apply Filters';

  @override
  String get searchTasksTitle => 'Search Tasks';

  @override
  String get searchByTaskNameOrDescription =>
      'Search by task name or description...';

  @override
  String get savedPresets => 'Saved Presets';

  @override
  String get deletePreset => 'Delete Preset';

  @override
  String deletePresetConfirmation(String presetName) {
    return 'Are you sure you want to delete the preset \"$presetName\"?';
  }

  @override
  String get pleaseEnterPresetName => 'Please enter a preset name';

  @override
  String presetSavedSuccessfully(String name) {
    return 'Preset \"$name\" saved successfully!';
  }

  @override
  String appliedPreset(String presetName) {
    return 'Applied preset \"$presetName\"';
  }

  @override
  String presetRemoved(String name) {
    return 'Preset \"$name\" removed';
  }

  @override
  String get noTasksYet => 'No Tasks Yet';

  @override
  String get createFirstTask =>
      'Create your first task to get started with productivity!';

  @override
  String get noSearchResults => 'No Search Results';

  @override
  String get noTasksMatchSearch =>
      'No tasks match your search query. Try different keywords.';

  @override
  String get clearSearch => 'Clear Search';

  @override
  String get noMatchingTasks => 'No Matching Tasks';

  @override
  String get noTasksMatchCriteria =>
      'No tasks match your search and filter criteria.';

  @override
  String get adjustFilters => 'Try adjusting your filters to see more tasks.';

  @override
  String get clearFilters => 'Clear Filters';

  @override
  String get noTasksToDisplay => 'No tasks to display';

  @override
  String get addNewTaskToGetStarted => 'Add a new task to get started';

  @override
  String get pullDownToRefresh => 'Pull down to refresh or add a new task';

  @override
  String get dueLabel => 'Due:';

  @override
  String get markAsPending => 'Mark as Pending';

  @override
  String get markAsCompleted => 'Mark as Completed';

  @override
  String get enterTaskTitle => 'Enter task title';

  @override
  String get pleaseEnterTitle => 'Please enter a title';

  @override
  String get taskDescriptionOptional => 'Task Description (Optional)';

  @override
  String get enterTaskDescriptionOptional =>
      'Enter task description (optional)';

  @override
  String get dueDateOptional => 'Due Date (Optional)';

  @override
  String get selectDueDate => 'Select due date';

  @override
  String get updateTask => 'Update Task';

  @override
  String get taskUpdatedSuccessfully => 'Task updated successfully!';

  @override
  String get taskAddedSuccessfully => 'Task added successfully!';

  @override
  String get failedToAddTask => 'Failed to add task';

  @override
  String anErrorOccurred(String error) {
    return 'An error occurred: $error';
  }

  @override
  String helloFriend(String name) {
    return 'Hello, $name! 👋';
  }

  @override
  String get helloFriendDefault => 'Hello, Friend! 👋';

  @override
  String get successRate => 'Success Rate';

  @override
  String get categories => 'Categories';

  @override
  String get dailyAvg => 'Daily Avg';

  @override
  String get recentActivity => 'Recent Activity';

  @override
  String get noRecentActivity => 'No recent activity';

  @override
  String get achievements => 'Achievements 🏆';

  @override
  String get firstTask => 'First Task';

  @override
  String get firstTaskDesc => 'Create your first task';

  @override
  String get finisher => 'Finisher';

  @override
  String get finisherDesc => 'Complete your first task';

  @override
  String get productive => 'Productive';

  @override
  String get productiveDesc => 'Complete 5 tasks';

  @override
  String get taskMaster => 'Task Master';

  @override
  String get taskMasterDesc => 'Complete 20 tasks';

  @override
  String get lightning => 'Lightning';

  @override
  String get lightningDesc => 'Complete 50 tasks';

  @override
  String get organizer => 'Organizer';

  @override
  String get organizerDesc => 'Use 3 different categories';

  @override
  String get achiever => 'Achiever';

  @override
  String get achieverDesc => 'Maintain 80% completion rate';

  @override
  String get streak => 'Streak';

  @override
  String get streakDesc => 'Complete tasks for 7 days';

  @override
  String achievementsProgress(int earned, int total) {
    return 'Progress: $earned/$total achievements unlocked';
  }

  @override
  String completedTask(String title) {
    return 'Completed \"$title\"';
  }

  @override
  String createdTask(String title) {
    return 'Created \"$title\"';
  }

  @override
  String get accountInformation => 'Account Information';

  @override
  String get memberSince => 'Member Since';

  @override
  String get notAvailable => 'Not available';

  @override
  String get unknown => 'Unknown';

  @override
  String monthAgo(int count) {
    return '$count month ago';
  }

  @override
  String monthsAgo(int count) {
    return '$count months ago';
  }

  @override
  String yearAgo(int count) {
    return '$count year ago';
  }

  @override
  String yearsAgo(int count) {
    return '$count years ago';
  }

  @override
  String get productivityInsights => 'Productivity Insights';

  @override
  String get completionRate => 'Completion Rate';

  @override
  String get dailyAverage => 'Daily Average';

  @override
  String get taskDistribution => 'Task Distribution';

  @override
  String get byCategory => 'By Category';

  @override
  String get byPriority => 'By Priority';

  @override
  String get weeklyProgress => 'Weekly Progress';

  @override
  String get allActivity => 'All Activity';

  @override
  String get noActivityToShow => 'No activity to show';

  @override
  String get testNotifications => 'Test Notifications';

  @override
  String get testNotificationFeatures => 'Test notification features:';

  @override
  String get dataAndPrivacy => 'Data & Privacy';

  @override
  String get learnAboutPrivacyPractices => 'Learn about our privacy practices';

  @override
  String get freeUpStorageSpace => 'Free up storage space';

  @override
  String get resetAllSettingsToDefault => 'Reset all settings to default';

  @override
  String get settingsResetSuccessfully => 'Settings reset successfully';

  @override
  String get welcomeBack => 'Welcome Back';

  @override
  String get signInToContinue => 'Sign in to continue';

  @override
  String get signUpToStart => 'Sign up to start';

  @override
  String get selectSavedAccount => 'Select saved account';

  @override
  String get enterEmailManually => 'Enter email manually';

  @override
  String get fullName => 'Full Name';

  @override
  String get rememberMe => 'Remember Me';

  @override
  String get signIn => 'Sign In';

  @override
  String get pleaseEnterYourName => 'Please enter your name';

  @override
  String get pleaseEnterYourEmail => 'Please enter your email';

  @override
  String get pleaseEnterYourPassword => 'Please enter your password';

  @override
  String get passwordMustBeAtLeast6Characters =>
      'Password must be at least 6 characters';

  @override
  String get noAccountFoundWithThisEmail => 'No account found with this email';

  @override
  String get invalidEmailOrPassword =>
      'Invalid email or password. Please check your credentials and try again.';

  @override
  String get accountAlreadyExistsWithThisEmail =>
      'An account already exists with this email';

  @override
  String get passwordIsTooWeak => 'Password is too weak';

  @override
  String get invalidEmailAddress => 'Invalid email address';

  @override
  String get networkConnectionFailed =>
      'Network connection failed. Please check your internet connection.';

  @override
  String get tooManyFailedAttempts =>
      'Too many failed attempts. Please try again later.';

  @override
  String authenticationFailed(String error) {
    return 'Authentication failed: $error';
  }

  @override
  String get accountSavedAndSyncedWithFirebase =>
      'Account saved and synced with Firebase';
}
