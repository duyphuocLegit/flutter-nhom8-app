import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// The title of the application
  ///
  /// In en, this message translates to:
  /// **'TaskApp'**
  String get appTitle;

  /// A greeting
  ///
  /// In en, this message translates to:
  /// **'Hello'**
  String get hello;

  /// Welcome message
  ///
  /// In en, this message translates to:
  /// **'Welcome'**
  String get welcome;

  /// Motivational message for home screen
  ///
  /// In en, this message translates to:
  /// **'Let\'s be productive today'**
  String get letsBeProductive;

  /// Login button text
  ///
  /// In en, this message translates to:
  /// **'Login'**
  String get login;

  /// Logout button text
  ///
  /// In en, this message translates to:
  /// **'Logout'**
  String get logout;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// Password field label
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get password;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get confirmPassword;

  /// Sign up button text
  ///
  /// In en, this message translates to:
  /// **'Sign Up'**
  String get signUp;

  /// Forgot password link text
  ///
  /// In en, this message translates to:
  /// **'Forgot Password?'**
  String get forgotPassword;

  /// Create account text
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get createAccount;

  /// Already have account text
  ///
  /// In en, this message translates to:
  /// **'Already have an account?'**
  String get alreadyHaveAccount;

  /// Don't have account text
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account?'**
  String get dontHaveAccount;

  /// Home tab label
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// Tasks tab label
  ///
  /// In en, this message translates to:
  /// **'Tasks'**
  String get tasks;

  /// Calendar tab label
  ///
  /// In en, this message translates to:
  /// **'Calendar'**
  String get calendar;

  /// Settings tab label
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settings;

  /// Profile tab label
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// Add task button text
  ///
  /// In en, this message translates to:
  /// **'Add Task'**
  String get addTask;

  /// Task title field label
  ///
  /// In en, this message translates to:
  /// **'Task Title'**
  String get taskTitle;

  /// Task description field label
  ///
  /// In en, this message translates to:
  /// **'Task Description'**
  String get taskDescription;

  /// Due date field label
  ///
  /// In en, this message translates to:
  /// **'Due Date'**
  String get dueDate;

  /// Priority field label
  ///
  /// In en, this message translates to:
  /// **'Priority'**
  String get priority;

  /// High priority
  ///
  /// In en, this message translates to:
  /// **'High'**
  String get high;

  /// Medium priority
  ///
  /// In en, this message translates to:
  /// **'Medium'**
  String get medium;

  /// Low priority
  ///
  /// In en, this message translates to:
  /// **'Low'**
  String get low;

  /// Save button text
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// Cancel button text
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// Delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete'**
  String get delete;

  /// Edit button text
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// Language setting label
  ///
  /// In en, this message translates to:
  /// **'Language'**
  String get language;

  /// Theme setting label
  ///
  /// In en, this message translates to:
  /// **'Theme'**
  String get theme;

  /// Notifications setting label
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// About app setting label
  ///
  /// In en, this message translates to:
  /// **'About App'**
  String get aboutApp;

  /// Version label
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// Dark mode setting label
  ///
  /// In en, this message translates to:
  /// **'Dark Mode'**
  String get darkMode;

  /// Light mode setting label
  ///
  /// In en, this message translates to:
  /// **'Light Mode'**
  String get lightMode;

  /// System mode setting label
  ///
  /// In en, this message translates to:
  /// **'System Mode'**
  String get systemMode;

  /// Completed status
  ///
  /// In en, this message translates to:
  /// **'Completed'**
  String get completed;

  /// Pending status
  ///
  /// In en, this message translates to:
  /// **'Pending'**
  String get pending;

  /// Overdue status
  ///
  /// In en, this message translates to:
  /// **'Overdue'**
  String get overdue;

  /// Message when no tasks are found
  ///
  /// In en, this message translates to:
  /// **'No tasks found'**
  String get noTasksFound;

  /// Search tasks placeholder
  ///
  /// In en, this message translates to:
  /// **'Search tasks...'**
  String get searchTasks;

  /// Progress section title
  ///
  /// In en, this message translates to:
  /// **'Your Progress'**
  String get yourProgress;

  /// Completed tasks label
  ///
  /// In en, this message translates to:
  /// **'Done'**
  String get done;

  /// Remaining tasks label
  ///
  /// In en, this message translates to:
  /// **'Left'**
  String get left;

  /// Find tasks section title
  ///
  /// In en, this message translates to:
  /// **'Find Tasks'**
  String get findTasks;

  /// Your tasks section title
  ///
  /// In en, this message translates to:
  /// **'Your Tasks'**
  String get yourTasks;

  /// Clear filters button text
  ///
  /// In en, this message translates to:
  /// **'Clear'**
  String get clear;

  /// Task count display text
  ///
  /// In en, this message translates to:
  /// **'Showing {count} task{count, plural, =1{} other{s}}'**
  String showingTasks(int count);

  /// Message when all tasks are completed
  ///
  /// In en, this message translates to:
  /// **'All completed! 🎉'**
  String get allCompleted;

  /// Clear all filters button text
  ///
  /// In en, this message translates to:
  /// **'Clear All Filters'**
  String get clearAllFilters;

  /// Filter by priority option
  ///
  /// In en, this message translates to:
  /// **'Filter by Priority'**
  String get filterByPriority;

  /// Filter by status option
  ///
  /// In en, this message translates to:
  /// **'Filter by Status'**
  String get filterByStatus;

  /// All filter option
  ///
  /// In en, this message translates to:
  /// **'All'**
  String get all;

  /// Today text
  ///
  /// In en, this message translates to:
  /// **'Today'**
  String get today;

  /// This week filter option
  ///
  /// In en, this message translates to:
  /// **'This Week'**
  String get thisWeek;

  /// This month filter option
  ///
  /// In en, this message translates to:
  /// **'This Month'**
  String get thisMonth;

  /// Generic error message
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get error;

  /// Generic success message
  ///
  /// In en, this message translates to:
  /// **'Success'**
  String get success;

  /// Loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loading;

  /// Retry button text
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No internet connection message
  ///
  /// In en, this message translates to:
  /// **'No internet connection'**
  String get noInternetConnection;

  /// Invalid email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email'**
  String get pleaseEnterValidEmail;

  /// Password too short validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordTooShort;

  /// Passwords don't match validation message
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get passwordsDoNotMatch;

  /// Required field validation message
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get fieldRequired;

  /// Clear cache button/option text
  ///
  /// In en, this message translates to:
  /// **'Clear Cache'**
  String get clearCache;

  /// Reset settings button/option text
  ///
  /// In en, this message translates to:
  /// **'Reset Settings'**
  String get resetSettings;

  /// Clear cache dialog message
  ///
  /// In en, this message translates to:
  /// **'This will clear all temporary files and cached data. The app may need to download content again.'**
  String get clearCacheMessage;

  /// Reset settings dialog message
  ///
  /// In en, this message translates to:
  /// **'This will reset all settings to their default values. This action cannot be undone.'**
  String get resetSettingsMessage;

  /// Cache cleared success message
  ///
  /// In en, this message translates to:
  /// **'Cache cleared successfully'**
  String get cacheCleared;

  /// Reset button text
  ///
  /// In en, this message translates to:
  /// **'Reset'**
  String get reset;

  /// Remove account dialog title
  ///
  /// In en, this message translates to:
  /// **'Remove Account'**
  String get removeAccount;

  /// Remove account confirmation message
  ///
  /// In en, this message translates to:
  /// **'Remove {email} from saved accounts?'**
  String removeAccountMessage(String email);

  /// Remove button text
  ///
  /// In en, this message translates to:
  /// **'Remove'**
  String get remove;

  /// Account removed success message
  ///
  /// In en, this message translates to:
  /// **'Account removed'**
  String get accountRemoved;

  /// Error removing account message
  ///
  /// In en, this message translates to:
  /// **'Error removing account: {error}'**
  String errorRemovingAccount(String error);

  /// Account saved success message
  ///
  /// In en, this message translates to:
  /// **'Account saved and synced with Firebase'**
  String get accountSaved;

  /// Most recent sort option
  ///
  /// In en, this message translates to:
  /// **'Most Recent'**
  String get mostRecent;

  /// Alphabetical sort option
  ///
  /// In en, this message translates to:
  /// **'Alphabetical'**
  String get alphabetical;

  /// Edit task screen title
  ///
  /// In en, this message translates to:
  /// **'Edit Task'**
  String get editTask;

  /// Add new task screen title
  ///
  /// In en, this message translates to:
  /// **'Add New Task'**
  String get addNewTask;

  /// Menu screen title
  ///
  /// In en, this message translates to:
  /// **'Menu'**
  String get menu;

  /// Account menu item
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get account;

  /// Contact Us menu item
  ///
  /// In en, this message translates to:
  /// **'Contact Us'**
  String get contactUs;

  /// About Us menu item
  ///
  /// In en, this message translates to:
  /// **'About Us'**
  String get aboutUs;

  /// Help menu item
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// Send message button text
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessage;

  /// Send button text
  ///
  /// In en, this message translates to:
  /// **'Send'**
  String get send;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name'**
  String get name;

  /// Message field label
  ///
  /// In en, this message translates to:
  /// **'Message'**
  String get message;

  /// Message field placeholder
  ///
  /// In en, this message translates to:
  /// **'Write your message here...'**
  String get writeYourMessage;

  /// Message sent success text
  ///
  /// In en, this message translates to:
  /// **'Message sent successfully!'**
  String get messageSent;

  /// View all button text
  ///
  /// In en, this message translates to:
  /// **'View All'**
  String get viewAll;

  /// Edit profile button text
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// Change password button text
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get changePassword;

  /// Account data usage section title
  ///
  /// In en, this message translates to:
  /// **'Account Data Usage'**
  String get accountDataUsage;

  /// Total tasks label
  ///
  /// In en, this message translates to:
  /// **'Total Tasks'**
  String get totalTasks;

  /// Active projects label
  ///
  /// In en, this message translates to:
  /// **'Active Projects'**
  String get activeProjects;

  /// Data sync label
  ///
  /// In en, this message translates to:
  /// **'Data Sync'**
  String get dataSync;

  /// Privacy Policy title
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// Last updated label
  ///
  /// In en, this message translates to:
  /// **'Last Updated'**
  String get lastUpdated;

  /// Privacy policy description
  ///
  /// In en, this message translates to:
  /// **'Your privacy is important to us. This policy explains how we collect, use, and protect your information.'**
  String get privacyDescription;

  /// Privacy section title
  ///
  /// In en, this message translates to:
  /// **'Information We Collect'**
  String get informationWeCollect;

  /// Privacy section title
  ///
  /// In en, this message translates to:
  /// **'How We Use Your Information'**
  String get howWeUseYourInformation;

  /// Privacy section title
  ///
  /// In en, this message translates to:
  /// **'Data Storage & Security'**
  String get dataStorageSecurity;

  /// Privacy section title
  ///
  /// In en, this message translates to:
  /// **'Data Sharing'**
  String get dataSharing;

  /// Privacy section title
  ///
  /// In en, this message translates to:
  /// **'Your Rights'**
  String get yourRights;

  /// Privacy section title
  ///
  /// In en, this message translates to:
  /// **'Third-Party Services'**
  String get thirdPartyServices;

  /// Contact section title
  ///
  /// In en, this message translates to:
  /// **'Questions or Concerns?'**
  String get questionsOrConcerns;

  /// Privacy contact description
  ///
  /// In en, this message translates to:
  /// **'If you have any questions about this Privacy Policy or how we handle your data, please contact us:'**
  String get privacyContactDescription;

  /// Privacy response time message
  ///
  /// In en, this message translates to:
  /// **'We will respond to all privacy-related inquiries within 48 hours.'**
  String get privacyResponseTime;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Account Information: Email address, name, and profile picture when you sign up'**
  String get accountInfoCollection;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Task Data: Your tasks, categories, due dates, and completion status'**
  String get taskDataCollection;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Usage Data: How you interact with the app for improving user experience'**
  String get usageDataCollection;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Device Information: Device type and operating system for compatibility'**
  String get deviceInfoCollection;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Provide and maintain the task management service'**
  String get provideService;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Sync your data across your devices securely'**
  String get syncData;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Send notifications about your tasks and deadlines'**
  String get sendNotifications;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Improve app performance and add new features'**
  String get improveApp;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Provide customer support when needed'**
  String get customerSupport;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Your data is stored securely using Firebase with industry-standard encryption'**
  String get secureStorage;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'We use secure HTTPS connections for all data transmission'**
  String get httpsConnections;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Your tasks are private and only accessible to you'**
  String get privateTasks;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'We implement regular security updates and monitoring'**
  String get securityUpdates;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Data backups are encrypted and stored securely'**
  String get encryptedBackups;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'We do not sell your personal information to third parties'**
  String get noSellData;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'We do not share your task data with other users'**
  String get noShareTasks;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Anonymous usage statistics may be used to improve the app'**
  String get anonymousStats;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'We may share data only if required by law or to protect our rights'**
  String get legalRequirements;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Access: You can view all your data within the app'**
  String get accessRight;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Update: You can modify your profile and task information anytime'**
  String get updateRight;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Delete: You can delete your account and all associated data'**
  String get deleteRight;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Export: You can request a copy of your data'**
  String get exportRight;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Control: You can manage notification and privacy settings'**
  String get controlRight;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Firebase: Used for authentication, data storage, and cloud functions'**
  String get firebaseService;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'Google Play Services: For app distribution and crash reporting'**
  String get googlePlayServices;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'No advertising networks or tracking services are used'**
  String get noAdvertising;

  /// Privacy content item
  ///
  /// In en, this message translates to:
  /// **'All third-party services comply with their own privacy policies'**
  String get thirdPartyCompliance;

  /// Profile update success message
  ///
  /// In en, this message translates to:
  /// **'Profile updated successfully!'**
  String get profileUpdatedSuccess;

  /// Profile update error message
  ///
  /// In en, this message translates to:
  /// **'Error updating profile'**
  String get errorUpdatingProfile;

  /// Photo upload feature message
  ///
  /// In en, this message translates to:
  /// **'Photo upload feature coming soon!'**
  String get photoUploadComingSoon;

  /// Photo change instruction
  ///
  /// In en, this message translates to:
  /// **'Tap camera icon to change photo'**
  String get tapCameraToChangePhoto;

  /// Personal information section title
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInformation;

  /// Display name field label
  ///
  /// In en, this message translates to:
  /// **'Display Name'**
  String get displayName;

  /// Display name field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your display name'**
  String get enterDisplayName;

  /// Display name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a display name'**
  String get pleaseEnterDisplayName;

  /// Display name length validation message
  ///
  /// In en, this message translates to:
  /// **'Display name must be at least 2 characters'**
  String get displayNameMinLength;

  /// Email address field label
  ///
  /// In en, this message translates to:
  /// **'Email Address'**
  String get emailAddress;

  /// Email security message
  ///
  /// In en, this message translates to:
  /// **'Email cannot be changed from this screen for security reasons'**
  String get emailCannotBeChanged;

  /// Password change success message
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully!'**
  String get passwordChangedSuccess;

  /// Wrong password error message
  ///
  /// In en, this message translates to:
  /// **'Current password is incorrect'**
  String get currentPasswordIncorrect;

  /// Weak password error message
  ///
  /// In en, this message translates to:
  /// **'New password is too weak'**
  String get newPasswordTooWeak;

  /// Recent login required error message
  ///
  /// In en, this message translates to:
  /// **'Please log out and log in again before changing password'**
  String get requiresRecentLogin;

  /// General password change error
  ///
  /// In en, this message translates to:
  /// **'Error changing password'**
  String get errorChangingPassword;

  /// Current password field label
  ///
  /// In en, this message translates to:
  /// **'Current Password'**
  String get currentPassword;

  /// New password field label
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPassword;

  /// Confirm password field label
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get confirmNewPassword;

  /// Current password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your current password'**
  String get pleaseEnterCurrentPassword;

  /// New password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter a new password'**
  String get pleaseEnterNewPassword;

  /// Password length validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMinLength;

  /// Confirm password validation message
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get pleaseConfirmNewPassword;

  /// Contact messages screen title
  ///
  /// In en, this message translates to:
  /// **'Contact Messages'**
  String get contactMessages;

  /// New messages count label
  ///
  /// In en, this message translates to:
  /// **'new'**
  String get newMessages;

  /// Error loading messages
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorLoadingMessages;

  /// Empty state message
  ///
  /// In en, this message translates to:
  /// **'No contact messages yet'**
  String get noContactMessages;

  /// New message label
  ///
  /// In en, this message translates to:
  /// **'NEW'**
  String get newLabel;

  /// Message content label
  ///
  /// In en, this message translates to:
  /// **'Message:'**
  String get messageLabel;

  /// Mark as read button
  ///
  /// In en, this message translates to:
  /// **'Mark as Read'**
  String get markAsRead;

  /// Mark as unread button
  ///
  /// In en, this message translates to:
  /// **'Mark as Unread'**
  String get markAsUnread;

  /// Reply button
  ///
  /// In en, this message translates to:
  /// **'Reply'**
  String get reply;

  /// Delete message button
  ///
  /// In en, this message translates to:
  /// **'Delete Message'**
  String get deleteMessage;

  /// Single day ago
  ///
  /// In en, this message translates to:
  /// **'day ago'**
  String get dayAgo;

  /// Multiple days ago
  ///
  /// In en, this message translates to:
  /// **'days ago'**
  String get daysAgo;

  /// Single hour ago
  ///
  /// In en, this message translates to:
  /// **'hour ago'**
  String get hourAgo;

  /// Multiple hours ago
  ///
  /// In en, this message translates to:
  /// **'hours ago'**
  String get hoursAgo;

  /// Single minute ago
  ///
  /// In en, this message translates to:
  /// **'minute ago'**
  String get minuteAgo;

  /// Multiple minutes ago
  ///
  /// In en, this message translates to:
  /// **'minutes ago'**
  String get minutesAgo;

  /// Just now time label
  ///
  /// In en, this message translates to:
  /// **'Just now'**
  String get justNow;

  /// Update status error message
  ///
  /// In en, this message translates to:
  /// **'Failed to update message status'**
  String get failedToUpdateStatus;

  /// Delete confirmation message
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete this message? This action cannot be undone.'**
  String get confirmDeleteMessage;

  /// Delete success message
  ///
  /// In en, this message translates to:
  /// **'Message deleted successfully'**
  String get messageDeletedSuccess;

  /// Delete error message
  ///
  /// In en, this message translates to:
  /// **'Failed to delete message'**
  String get failedToDeleteMessage;

  /// Reply dialog title prefix
  ///
  /// In en, this message translates to:
  /// **'Reply to'**
  String get replyTo;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email:'**
  String get emailLabel;

  /// Email app description
  ///
  /// In en, this message translates to:
  /// **'This will open your default email app to compose a reply.'**
  String get emailAppDescription;

  /// Open email app button
  ///
  /// In en, this message translates to:
  /// **'Open Email App'**
  String get openEmailApp;

  /// Email functionality placeholder message
  ///
  /// In en, this message translates to:
  /// **'Email functionality would be implemented here'**
  String get emailFunctionalityPlaceholder;

  /// Default user name fallback
  ///
  /// In en, this message translates to:
  /// **'User Name'**
  String get userName;

  /// Default email fallback
  ///
  /// In en, this message translates to:
  /// **'user@example.com'**
  String get defaultEmail;

  /// Tasks completed label
  ///
  /// In en, this message translates to:
  /// **'Tasks\nCompleted'**
  String get tasksCompleted;

  /// Active tasks label
  ///
  /// In en, this message translates to:
  /// **'Active\nTasks'**
  String get activeTasks;

  /// Days streak label
  ///
  /// In en, this message translates to:
  /// **'Days\nStreak'**
  String get daysStreak;

  /// No description provided for @appearance.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearance;

  /// No description provided for @appSettings.
  ///
  /// In en, this message translates to:
  /// **'App Settings'**
  String get appSettings;

  /// No description provided for @getRemindersForTasks.
  ///
  /// In en, this message translates to:
  /// **'Get reminders for your tasks'**
  String get getRemindersForTasks;

  /// Update profile button text
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// App name in about screen
  ///
  /// In en, this message translates to:
  /// **'Task Manager'**
  String get taskManager;

  /// App version number
  ///
  /// In en, this message translates to:
  /// **'Version 1.0.0'**
  String get versionNumber;

  /// Our mission section title
  ///
  /// In en, this message translates to:
  /// **'Our Mission'**
  String get ourMission;

  /// Mission description text
  ///
  /// In en, this message translates to:
  /// **'We believe in making task management simple and efficient. Our app is designed to help you organize your daily tasks, set priorities, and achieve your goals with ease.'**
  String get missionDescription;

  /// Key features section title
  ///
  /// In en, this message translates to:
  /// **'Key Features'**
  String get keyFeatures;

  /// Task creation feature
  ///
  /// In en, this message translates to:
  /// **'Task Creation & Management'**
  String get taskCreationManagement;

  /// Priority setting feature
  ///
  /// In en, this message translates to:
  /// **'Priority Setting'**
  String get prioritySetting;

  /// Profile management feature
  ///
  /// In en, this message translates to:
  /// **'User Profile Management'**
  String get userProfileManagement;

  /// Authentication feature
  ///
  /// In en, this message translates to:
  /// **'Secure Authentication'**
  String get secureAuthentication;

  /// Cloud sync feature
  ///
  /// In en, this message translates to:
  /// **'Cloud Synchronization'**
  String get cloudSynchronization;

  /// Our team section title
  ///
  /// In en, this message translates to:
  /// **'Our Team'**
  String get ourTeam;

  /// Team description text
  ///
  /// In en, this message translates to:
  /// **'Developed by Group 10 - A dedicated team of developers passionate about creating intuitive and powerful productivity tools.'**
  String get teamDescription;

  /// Message saved success message
  ///
  /// In en, this message translates to:
  /// **'Message saved successfully!'**
  String get messageSavedSuccessfully;

  /// Message saved description
  ///
  /// In en, this message translates to:
  /// **'Your message has been saved to our database. We\'ll get back to you within 24 hours.'**
  String get messageSavedDescription;

  /// Thank you dialog title
  ///
  /// In en, this message translates to:
  /// **'Thank You!'**
  String get thankYou;

  /// Thank you dialog description
  ///
  /// In en, this message translates to:
  /// **'Your message has been saved to our database. We\'ll respond within 24 hours.'**
  String get thankYouDescription;

  /// Failed to send message error title
  ///
  /// In en, this message translates to:
  /// **'Failed to send message'**
  String get failedToSendMessage;

  /// Connection error message
  ///
  /// In en, this message translates to:
  /// **'Please check your connection and try again.'**
  String get checkConnectionTryAgain;

  /// Message validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your message'**
  String get pleaseEnterMessage;

  /// Message minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 10 characters (currently {currentLength})'**
  String messageMinLength(int currentLength);

  /// Message maximum length validation
  ///
  /// In en, this message translates to:
  /// **'Message is too long (maximum 500 characters)'**
  String get messageTooLong;

  /// Meaningful message validation
  ///
  /// In en, this message translates to:
  /// **'Please enter a meaningful message (avoid repeated characters)'**
  String get meaningfulMessage;

  /// Message content validation
  ///
  /// In en, this message translates to:
  /// **'Message must contain letters or numbers'**
  String get messageMustContainLetters;

  /// Invalid message format error
  ///
  /// In en, this message translates to:
  /// **'Invalid message format. Please try again.'**
  String get invalidMessageFormat;

  /// Help screen header
  ///
  /// In en, this message translates to:
  /// **'How can we help you?'**
  String get howCanWeHelp;

  /// Help screen description
  ///
  /// In en, this message translates to:
  /// **'Find answers to common questions and learn how to use the app effectively.'**
  String get helpDescription;

  /// FAQ section title
  ///
  /// In en, this message translates to:
  /// **'Frequently Asked Questions'**
  String get frequentlyAskedQuestions;

  /// FAQ question
  ///
  /// In en, this message translates to:
  /// **'How do I create a new task?'**
  String get howToCreateTask;

  /// FAQ answer
  ///
  /// In en, this message translates to:
  /// **'Tap the \"+\" button on the home screen and fill in the task details including title, description, and priority level.'**
  String get createTaskAnswer;

  /// FAQ question
  ///
  /// In en, this message translates to:
  /// **'How can I edit my profile?'**
  String get howToEditProfile;

  /// FAQ answer
  ///
  /// In en, this message translates to:
  /// **'Go to Menu > My Account > Edit Profile to update your personal information and profile picture.'**
  String get editProfileAnswer;

  /// FAQ question
  ///
  /// In en, this message translates to:
  /// **'How do I change my password?'**
  String get howToChangePassword;

  /// FAQ answer
  ///
  /// In en, this message translates to:
  /// **'Navigate to Menu > My Account > Change Password and follow the instructions to update your password.'**
  String get changePasswordAnswer;

  /// FAQ question
  ///
  /// In en, this message translates to:
  /// **'Can I delete completed tasks?'**
  String get howToDeleteTasks;

  /// FAQ answer
  ///
  /// In en, this message translates to:
  /// **'Yes, you can delete tasks by swiping left on any task in your task list and tapping the delete button.'**
  String get deleteTasksAnswer;

  /// FAQ question
  ///
  /// In en, this message translates to:
  /// **'How do I set task priorities?'**
  String get howToSetPriorities;

  /// FAQ answer
  ///
  /// In en, this message translates to:
  /// **'When creating or editing a task, you can select from three priority levels: High, Medium, or Low.'**
  String get setPrioritiesAnswer;

  /// Quick actions section title
  ///
  /// In en, this message translates to:
  /// **'Quick Actions'**
  String get quickActions;

  /// Contact support action
  ///
  /// In en, this message translates to:
  /// **'Contact Support'**
  String get contactSupport;

  /// Contact support description
  ///
  /// In en, this message translates to:
  /// **'Get help from our support team'**
  String get getHelpFromSupport;

  /// Report bug action
  ///
  /// In en, this message translates to:
  /// **'Report a Bug'**
  String get reportBug;

  /// Report bug description
  ///
  /// In en, this message translates to:
  /// **'Let us know about any issues'**
  String get letUsKnowAboutIssues;

  /// Send feedback action
  ///
  /// In en, this message translates to:
  /// **'Send Feedback'**
  String get sendFeedback;

  /// Send feedback description
  ///
  /// In en, this message translates to:
  /// **'Share your thoughts and suggestions'**
  String get shareThoughtsSuggestions;

  /// Bug report dialog text
  ///
  /// In en, this message translates to:
  /// **'Please describe the bug you encountered:'**
  String get describeBugEncountered;

  /// Bug description placeholder
  ///
  /// In en, this message translates to:
  /// **'Describe the bug...'**
  String get describeBugPlaceholder;

  /// Bug report success message
  ///
  /// In en, this message translates to:
  /// **'Bug report submitted successfully!'**
  String get bugReportSubmitted;

  /// Feedback dialog text
  ///
  /// In en, this message translates to:
  /// **'We\'d love to hear your thoughts:'**
  String get wedLoveHearThoughts;

  /// Feedback placeholder
  ///
  /// In en, this message translates to:
  /// **'Your feedback...'**
  String get yourFeedbackPlaceholder;

  /// Feedback success message
  ///
  /// In en, this message translates to:
  /// **'Feedback sent successfully!'**
  String get feedbackSentSuccessfully;

  /// Contact us header title
  ///
  /// In en, this message translates to:
  /// **'Get in Touch'**
  String get getInTouch;

  /// Contact us header description
  ///
  /// In en, this message translates to:
  /// **'We\'d love to hear from you. Send us a message and we\'ll respond as soon as possible.'**
  String get getInTouchDescription;

  /// Email contact option
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get emailContact;

  /// Phone contact option
  ///
  /// In en, this message translates to:
  /// **'Phone'**
  String get phoneContact;

  /// Address contact option
  ///
  /// In en, this message translates to:
  /// **'Address'**
  String get addressContact;

  /// Support email address
  ///
  /// In en, this message translates to:
  /// **'support@taskapp.com'**
  String get supportEmail;

  /// Support phone number
  ///
  /// In en, this message translates to:
  /// **'+1 (555) 123-4567'**
  String get supportPhone;

  /// Support address
  ///
  /// In en, this message translates to:
  /// **'123 Main St, City, State 12345'**
  String get supportAddress;

  /// Send message button text
  ///
  /// In en, this message translates to:
  /// **'Send Message'**
  String get sendMessageButton;

  /// Account lock info message
  ///
  /// In en, this message translates to:
  /// **'Name and email are locked to your current account for security.'**
  String get nameAndEmailLocked;

  /// Name field label
  ///
  /// In en, this message translates to:
  /// **'Name *'**
  String get nameFieldLabel;

  /// Email field label
  ///
  /// In en, this message translates to:
  /// **'Email *'**
  String get emailFieldLabel;

  /// Message field label
  ///
  /// In en, this message translates to:
  /// **'Message *'**
  String get messageFieldLabel;

  /// Loading text
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingText;

  /// Locked field hint
  ///
  /// In en, this message translates to:
  /// **'Locked to current user'**
  String get lockedToCurrentUser;

  /// Name field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your name'**
  String get enterYourName;

  /// Email field placeholder
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get enterYourEmail;

  /// Message field placeholder
  ///
  /// In en, this message translates to:
  /// **'Type your message here...'**
  String get typeYourMessageHere;

  /// Name validation error for authenticated users
  ///
  /// In en, this message translates to:
  /// **'Account name not found. Please update your profile.'**
  String get accountNameNotFound;

  /// Name minimum length validation
  ///
  /// In en, this message translates to:
  /// **'Name must be at least 2 characters'**
  String get nameMinLength;

  /// Email validation error for authenticated users
  ///
  /// In en, this message translates to:
  /// **'Account email not found. Please update your profile.'**
  String get accountEmailNotFound;

  /// Invalid email validation message for contact
  ///
  /// In en, this message translates to:
  /// **'Please enter a valid email address'**
  String get pleaseEnterValidEmailContact;

  /// Success dialog button text
  ///
  /// In en, this message translates to:
  /// **'Great!'**
  String get great;

  /// Debug message for Firestore user profile error
  ///
  /// In en, this message translates to:
  /// **'Error getting user profile from Firestore: {error}'**
  String errorGettingUserProfile(String error);

  /// Debug message for successful user data loading
  ///
  /// In en, this message translates to:
  /// **'Loaded user data - Name: {name}, Email: {email}'**
  String loadedUserData(String name, String email);

  /// Debug message for user data loading error
  ///
  /// In en, this message translates to:
  /// **'Error loading user data: {error}'**
  String errorLoadingUserData(String error);

  /// Error message for message validation failure
  ///
  /// In en, this message translates to:
  /// **'Message validation failed: {validationError}'**
  String messageValidationFailed(String validationError);

  /// Error message for message length validation
  ///
  /// In en, this message translates to:
  /// **'Message must be at least 10 characters long'**
  String get messageTooShort;

  /// Error message for failed message sending due to connection issues
  ///
  /// In en, this message translates to:
  /// **'Failed to send message. Please check your connection and try again.'**
  String get failedToSendMessageConnection;

  /// Label for storage usage in data usage dialog
  ///
  /// In en, this message translates to:
  /// **'Storage Used:'**
  String get storageUsed;

  /// Label for profile images count in data usage dialog
  ///
  /// In en, this message translates to:
  /// **'Profile Images:'**
  String get profileImages;

  /// Label for account creation date in data usage dialog
  ///
  /// In en, this message translates to:
  /// **'Account Created:'**
  String get accountCreated;

  /// Label for last active date in data usage dialog
  ///
  /// In en, this message translates to:
  /// **'Last Active:'**
  String get lastActive;

  /// Confirmation message for logout dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to logout from this device?'**
  String get confirmLogout;

  /// Loading message during sign out process
  ///
  /// In en, this message translates to:
  /// **'Signing out...'**
  String get signingOut;

  /// Error message when sign out fails
  ///
  /// In en, this message translates to:
  /// **'Error signing out: {error}'**
  String errorSigningOut(String error);

  /// Label for completed tasks count in data usage dialog
  ///
  /// In en, this message translates to:
  /// **'Completed Tasks:'**
  String get completedTasks;

  /// Label for pending tasks count in data usage dialog
  ///
  /// In en, this message translates to:
  /// **'Pending Tasks:'**
  String get pendingTasks;

  /// Close button text
  ///
  /// In en, this message translates to:
  /// **'Close'**
  String get close;

  /// Account management section header
  ///
  /// In en, this message translates to:
  /// **'Account Management'**
  String get accountManagement;

  /// Edit profile subtitle
  ///
  /// In en, this message translates to:
  /// **'Update name, photo, and personal details'**
  String get updateProfileDetails;

  /// Change password subtitle
  ///
  /// In en, this message translates to:
  /// **'Update your account password for security'**
  String get updatePasswordForSecurity;

  /// Account data option title
  ///
  /// In en, this message translates to:
  /// **'Account Data'**
  String get accountData;

  /// Account data subtitle
  ///
  /// In en, this message translates to:
  /// **'View your account storage and data usage'**
  String get viewAccountStorage;

  /// Logout subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign out of your account on this device'**
  String get signOutOfAccount;

  /// Delete account option title
  ///
  /// In en, this message translates to:
  /// **'Delete Account'**
  String get deleteAccount;

  /// Delete account subtitle
  ///
  /// In en, this message translates to:
  /// **'Permanently delete your account and all data'**
  String get permanentlyDeleteAccount;

  /// User status indicator
  ///
  /// In en, this message translates to:
  /// **'Active'**
  String get active;

  /// Warning text in delete account dialog
  ///
  /// In en, this message translates to:
  /// **'This action will permanently remove:'**
  String get deleteAccountWarning;

  /// Profile deletion warning item
  ///
  /// In en, this message translates to:
  /// **'• Your profile and personal settings'**
  String get deleteProfileSettings;

  /// Tasks deletion warning item
  ///
  /// In en, this message translates to:
  /// **'• All {taskCount} tasks and their data'**
  String deleteAllTasks(String taskCount);

  /// Account access deletion warning item
  ///
  /// In en, this message translates to:
  /// **'• Account access and login credentials'**
  String get deleteAccountAccess;

  /// Preferences deletion warning item
  ///
  /// In en, this message translates to:
  /// **'• All stored preferences and history'**
  String get deletePreferencesHistory;

  /// Irreversible action warning
  ///
  /// In en, this message translates to:
  /// **'This action cannot be undone'**
  String get actionCannotBeUndone;

  /// Continue button in delete confirmation
  ///
  /// In en, this message translates to:
  /// **'Continue to Delete'**
  String get continueToDelete;

  /// Final confirmation dialog title
  ///
  /// In en, this message translates to:
  /// **'Final Confirmation'**
  String get finalConfirmation;

  /// Final delete confirmation instruction
  ///
  /// In en, this message translates to:
  /// **'For security, please enter your password and type \"DELETE\" to confirm:'**
  String get finalDeleteInstruction;

  /// Password field hint
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get enterPassword;

  /// Confirmation field label
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get confirmation;

  /// Confirmation field hint
  ///
  /// In en, this message translates to:
  /// **'Type DELETE here'**
  String get typeDeleteHere;

  /// Detailed delete warning
  ///
  /// In en, this message translates to:
  /// **'⚠️ This will permanently delete:\n• Your profile and settings\n• All tasks and data\n• Account access'**
  String get deleteWarningDetails;

  /// Password validation error
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterPassword;

  /// Confirmation validation error
  ///
  /// In en, this message translates to:
  /// **'Please type \"DELETE\" to confirm'**
  String get pleaseTypeDelete;

  /// Final delete button text
  ///
  /// In en, this message translates to:
  /// **'Delete Forever'**
  String get deleteForever;

  /// Account deletion progress message
  ///
  /// In en, this message translates to:
  /// **'Deleting your account...'**
  String get deletingAccount;

  /// Deletion progress subtitle
  ///
  /// In en, this message translates to:
  /// **'This may take a few moments'**
  String get mayTakeFewMoments;

  /// Account deletion success message
  ///
  /// In en, this message translates to:
  /// **'Account deleted successfully'**
  String get accountDeletedSuccessfully;

  /// Password error message
  ///
  /// In en, this message translates to:
  /// **'Incorrect password. Please try again.'**
  String get incorrectPassword;

  /// Rate limit error message
  ///
  /// In en, this message translates to:
  /// **'Too many attempts. Please try again later.'**
  String get tooManyAttempts;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network error. Please check your connection.'**
  String get networkError;

  /// Generic account deletion error
  ///
  /// In en, this message translates to:
  /// **'Failed to delete account: {error}'**
  String failedToDeleteAccount(String error);

  /// Message when recent login is required for account deletion
  ///
  /// In en, this message translates to:
  /// **'Please sign out and back in, then try again.'**
  String get signOutAndBackIn;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'January'**
  String get january;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'February'**
  String get february;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'March'**
  String get march;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'April'**
  String get april;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'May'**
  String get may;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'June'**
  String get june;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'July'**
  String get july;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'August'**
  String get august;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'September'**
  String get september;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'October'**
  String get october;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'November'**
  String get november;

  /// Month name
  ///
  /// In en, this message translates to:
  /// **'December'**
  String get december;

  /// Filter bottom sheet title
  ///
  /// In en, this message translates to:
  /// **'Filter & Search Tasks'**
  String get filterTasksTitle;

  /// Clear all filters button text
  ///
  /// In en, this message translates to:
  /// **'Clear All'**
  String get clearAll;

  /// Status filter section title
  ///
  /// In en, this message translates to:
  /// **'Status'**
  String get status;

  /// All tasks filter option
  ///
  /// In en, this message translates to:
  /// **'All Tasks'**
  String get allTasks;

  /// All priorities filter option
  ///
  /// In en, this message translates to:
  /// **'All Priorities'**
  String get allPriorities;

  /// High priority filter option
  ///
  /// In en, this message translates to:
  /// **'High Priority'**
  String get highPriority;

  /// Medium priority filter option
  ///
  /// In en, this message translates to:
  /// **'Medium Priority'**
  String get mediumPriority;

  /// Low priority filter option
  ///
  /// In en, this message translates to:
  /// **'Low Priority'**
  String get lowPriority;

  /// All dates filter option
  ///
  /// In en, this message translates to:
  /// **'All Dates'**
  String get allDates;

  /// Due today filter option
  ///
  /// In en, this message translates to:
  /// **'Due Today'**
  String get dueToday;

  /// Custom range filter option
  ///
  /// In en, this message translates to:
  /// **'Custom Range'**
  String get customRange;

  /// Custom date range section title
  ///
  /// In en, this message translates to:
  /// **'Custom Date Range'**
  String get customDateRange;

  /// Clear custom range tooltip
  ///
  /// In en, this message translates to:
  /// **'Clear custom range'**
  String get clearCustomRange;

  /// Select date range button text
  ///
  /// In en, this message translates to:
  /// **'Select Date Range'**
  String get selectDateRange;

  /// Category filter section title
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// All categories filter option
  ///
  /// In en, this message translates to:
  /// **'All Categories'**
  String get allCategories;

  /// Work category filter option
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// Personal category filter option
  ///
  /// In en, this message translates to:
  /// **'Personal'**
  String get personal;

  /// Shopping category filter option
  ///
  /// In en, this message translates to:
  /// **'Shopping'**
  String get shopping;

  /// Health category filter option
  ///
  /// In en, this message translates to:
  /// **'Health'**
  String get health;

  /// Education category filter option
  ///
  /// In en, this message translates to:
  /// **'Education'**
  String get education;

  /// Save current filters section title
  ///
  /// In en, this message translates to:
  /// **'Save Current Filters'**
  String get saveCurrentFilters;

  /// Apply filters button text
  ///
  /// In en, this message translates to:
  /// **'Apply Filters'**
  String get applyFilters;

  /// Search tasks section title
  ///
  /// In en, this message translates to:
  /// **'Search Tasks'**
  String get searchTasksTitle;

  /// Search input hint text
  ///
  /// In en, this message translates to:
  /// **'Search by task name or description...'**
  String get searchByTaskNameOrDescription;

  /// Saved presets section title
  ///
  /// In en, this message translates to:
  /// **'Saved Presets'**
  String get savedPresets;

  /// Delete preset dialog title
  ///
  /// In en, this message translates to:
  /// **'Delete Preset'**
  String get deletePreset;

  /// Delete preset confirmation dialog content
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to delete the preset \"{presetName}\"?'**
  String deletePresetConfirmation(String presetName);

  /// Error message when preset name is empty
  ///
  /// In en, this message translates to:
  /// **'Please enter a preset name'**
  String get pleaseEnterPresetName;

  /// Success message when preset is saved
  ///
  /// In en, this message translates to:
  /// **'Preset \"{name}\" saved successfully!'**
  String presetSavedSuccessfully(String name);

  /// Message when preset is applied
  ///
  /// In en, this message translates to:
  /// **'Applied preset \"{presetName}\"'**
  String appliedPreset(String presetName);

  /// Message when preset is deleted
  ///
  /// In en, this message translates to:
  /// **'Preset \"{name}\" removed'**
  String presetRemoved(String name);

  /// Empty state title when no tasks exist
  ///
  /// In en, this message translates to:
  /// **'No Tasks Yet'**
  String get noTasksYet;

  /// Empty state subtitle when no tasks exist
  ///
  /// In en, this message translates to:
  /// **'Create your first task to get started with productivity!'**
  String get createFirstTask;

  /// Empty state title when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No Search Results'**
  String get noSearchResults;

  /// Empty state subtitle when search returns no results
  ///
  /// In en, this message translates to:
  /// **'No tasks match your search query. Try different keywords.'**
  String get noTasksMatchSearch;

  /// Clear search action button text
  ///
  /// In en, this message translates to:
  /// **'Clear Search'**
  String get clearSearch;

  /// Empty state title when filters return no results
  ///
  /// In en, this message translates to:
  /// **'No Matching Tasks'**
  String get noMatchingTasks;

  /// Empty state subtitle when search and filters return no results
  ///
  /// In en, this message translates to:
  /// **'No tasks match your search and filter criteria.'**
  String get noTasksMatchCriteria;

  /// Empty state subtitle when filters return no results
  ///
  /// In en, this message translates to:
  /// **'Try adjusting your filters to see more tasks.'**
  String get adjustFilters;

  /// Clear filters action button text
  ///
  /// In en, this message translates to:
  /// **'Clear Filters'**
  String get clearFilters;

  /// Message when no tasks are available to display
  ///
  /// In en, this message translates to:
  /// **'No tasks to display'**
  String get noTasksToDisplay;

  /// Message encouraging user to add first task
  ///
  /// In en, this message translates to:
  /// **'Add a new task to get started'**
  String get addNewTaskToGetStarted;

  /// Hint text for refresh functionality
  ///
  /// In en, this message translates to:
  /// **'Pull down to refresh or add a new task'**
  String get pullDownToRefresh;

  /// Label for due date in task details
  ///
  /// In en, this message translates to:
  /// **'Due:'**
  String get dueLabel;

  /// Button text to mark task as pending
  ///
  /// In en, this message translates to:
  /// **'Mark as Pending'**
  String get markAsPending;

  /// Button text to mark task as completed
  ///
  /// In en, this message translates to:
  /// **'Mark as Completed'**
  String get markAsCompleted;

  /// Hint text for task title input field
  ///
  /// In en, this message translates to:
  /// **'Enter task title'**
  String get enterTaskTitle;

  /// Validation error message for empty task title
  ///
  /// In en, this message translates to:
  /// **'Please enter a title'**
  String get pleaseEnterTitle;

  /// Label for task description field
  ///
  /// In en, this message translates to:
  /// **'Task Description (Optional)'**
  String get taskDescriptionOptional;

  /// Hint text for task description input field
  ///
  /// In en, this message translates to:
  /// **'Enter task description (optional)'**
  String get enterTaskDescriptionOptional;

  /// Label for due date field
  ///
  /// In en, this message translates to:
  /// **'Due Date (Optional)'**
  String get dueDateOptional;

  /// Placeholder text for due date selection
  ///
  /// In en, this message translates to:
  /// **'Select due date'**
  String get selectDueDate;

  /// Button text to update an existing task
  ///
  /// In en, this message translates to:
  /// **'Update Task'**
  String get updateTask;

  /// Success message when task is updated
  ///
  /// In en, this message translates to:
  /// **'Task updated successfully!'**
  String get taskUpdatedSuccessfully;

  /// Success message when task is added
  ///
  /// In en, this message translates to:
  /// **'Task added successfully!'**
  String get taskAddedSuccessfully;

  /// Error message when task creation fails
  ///
  /// In en, this message translates to:
  /// **'Failed to add task'**
  String get failedToAddTask;

  /// Generic error message with error details
  ///
  /// In en, this message translates to:
  /// **'An error occurred: {error}'**
  String anErrorOccurred(String error);

  /// Greeting message with user's name
  ///
  /// In en, this message translates to:
  /// **'Hello, {name}! 👋'**
  String helloFriend(String name);

  /// Default greeting message when no name is available
  ///
  /// In en, this message translates to:
  /// **'Hello, Friend! 👋'**
  String get helloFriendDefault;

  /// Success rate label
  ///
  /// In en, this message translates to:
  /// **'Success Rate'**
  String get successRate;

  /// Categories label
  ///
  /// In en, this message translates to:
  /// **'Categories'**
  String get categories;

  /// Daily average label
  ///
  /// In en, this message translates to:
  /// **'Daily Avg'**
  String get dailyAvg;

  /// Recent activity section title
  ///
  /// In en, this message translates to:
  /// **'Recent Activity'**
  String get recentActivity;

  /// Empty state message for recent activity
  ///
  /// In en, this message translates to:
  /// **'No recent activity'**
  String get noRecentActivity;

  /// Achievements section title
  ///
  /// In en, this message translates to:
  /// **'Achievements 🏆'**
  String get achievements;

  /// First task achievement title
  ///
  /// In en, this message translates to:
  /// **'First Task'**
  String get firstTask;

  /// First task achievement description
  ///
  /// In en, this message translates to:
  /// **'Create your first task'**
  String get firstTaskDesc;

  /// Finisher achievement title
  ///
  /// In en, this message translates to:
  /// **'Finisher'**
  String get finisher;

  /// Finisher achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete your first task'**
  String get finisherDesc;

  /// Productive achievement title
  ///
  /// In en, this message translates to:
  /// **'Productive'**
  String get productive;

  /// Productive achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete 5 tasks'**
  String get productiveDesc;

  /// Task master achievement title
  ///
  /// In en, this message translates to:
  /// **'Task Master'**
  String get taskMaster;

  /// Task master achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete 20 tasks'**
  String get taskMasterDesc;

  /// Lightning achievement title
  ///
  /// In en, this message translates to:
  /// **'Lightning'**
  String get lightning;

  /// Lightning achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete 50 tasks'**
  String get lightningDesc;

  /// Organizer achievement title
  ///
  /// In en, this message translates to:
  /// **'Organizer'**
  String get organizer;

  /// Organizer achievement description
  ///
  /// In en, this message translates to:
  /// **'Use 3 different categories'**
  String get organizerDesc;

  /// Achiever achievement title
  ///
  /// In en, this message translates to:
  /// **'Achiever'**
  String get achiever;

  /// Achiever achievement description
  ///
  /// In en, this message translates to:
  /// **'Maintain 80% completion rate'**
  String get achieverDesc;

  /// Streak achievement title
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// Streak achievement description
  ///
  /// In en, this message translates to:
  /// **'Complete tasks for 7 days'**
  String get streakDesc;

  /// Achievements progress text
  ///
  /// In en, this message translates to:
  /// **'Progress: {earned}/{total} achievements unlocked'**
  String achievementsProgress(int earned, int total);

  /// Activity message for completed task
  ///
  /// In en, this message translates to:
  /// **'Completed \"{title}\"'**
  String completedTask(String title);

  /// Activity message for created task
  ///
  /// In en, this message translates to:
  /// **'Created \"{title}\"'**
  String createdTask(String title);

  /// Account information section title
  ///
  /// In en, this message translates to:
  /// **'Account Information'**
  String get accountInformation;

  /// Member since label
  ///
  /// In en, this message translates to:
  /// **'Member Since'**
  String get memberSince;

  /// Not available text
  ///
  /// In en, this message translates to:
  /// **'Not available'**
  String get notAvailable;

  /// Unknown value text
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// Time ago in months (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} month ago'**
  String monthAgo(int count);

  /// Time ago in months (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} months ago'**
  String monthsAgo(int count);

  /// Time ago in years (singular)
  ///
  /// In en, this message translates to:
  /// **'{count} year ago'**
  String yearAgo(int count);

  /// Time ago in years (plural)
  ///
  /// In en, this message translates to:
  /// **'{count} years ago'**
  String yearsAgo(int count);

  /// Productivity insights section title
  ///
  /// In en, this message translates to:
  /// **'Productivity Insights'**
  String get productivityInsights;

  /// Completion rate label
  ///
  /// In en, this message translates to:
  /// **'Completion Rate'**
  String get completionRate;

  /// Daily average label
  ///
  /// In en, this message translates to:
  /// **'Daily Average'**
  String get dailyAverage;

  /// Task distribution section title
  ///
  /// In en, this message translates to:
  /// **'Task Distribution'**
  String get taskDistribution;

  /// By category subsection title
  ///
  /// In en, this message translates to:
  /// **'By Category'**
  String get byCategory;

  /// By priority subsection title
  ///
  /// In en, this message translates to:
  /// **'By Priority'**
  String get byPriority;

  /// Weekly progress section title
  ///
  /// In en, this message translates to:
  /// **'Weekly Progress'**
  String get weeklyProgress;

  /// All activity dialog title
  ///
  /// In en, this message translates to:
  /// **'All Activity'**
  String get allActivity;

  /// Empty state message for all activity dialog
  ///
  /// In en, this message translates to:
  /// **'No activity to show'**
  String get noActivityToShow;

  /// Test notifications section title
  ///
  /// In en, this message translates to:
  /// **'Test Notifications'**
  String get testNotifications;

  /// Test notification features description
  ///
  /// In en, this message translates to:
  /// **'Test notification features:'**
  String get testNotificationFeatures;

  /// Data and privacy section title
  ///
  /// In en, this message translates to:
  /// **'Data & Privacy'**
  String get dataAndPrivacy;

  /// Privacy policy subtitle
  ///
  /// In en, this message translates to:
  /// **'Learn about our privacy practices'**
  String get learnAboutPrivacyPractices;

  /// Clear cache subtitle
  ///
  /// In en, this message translates to:
  /// **'Free up storage space'**
  String get freeUpStorageSpace;

  /// Reset settings subtitle
  ///
  /// In en, this message translates to:
  /// **'Reset all settings to default'**
  String get resetAllSettingsToDefault;

  /// Settings reset success message
  ///
  /// In en, this message translates to:
  /// **'Settings reset successfully'**
  String get settingsResetSuccessfully;

  /// Welcome back title for login screen
  ///
  /// In en, this message translates to:
  /// **'Welcome Back'**
  String get welcomeBack;

  /// Sign in subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign in to continue'**
  String get signInToContinue;

  /// Sign up subtitle
  ///
  /// In en, this message translates to:
  /// **'Sign up to start'**
  String get signUpToStart;

  /// Saved accounts dropdown hint
  ///
  /// In en, this message translates to:
  /// **'Select saved account'**
  String get selectSavedAccount;

  /// Manual email entry option
  ///
  /// In en, this message translates to:
  /// **'Enter email manually'**
  String get enterEmailManually;

  /// Full name field label
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// Remember me checkbox text
  ///
  /// In en, this message translates to:
  /// **'Remember Me'**
  String get rememberMe;

  /// Sign in button text
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get signIn;

  /// Name validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your name'**
  String get pleaseEnterYourName;

  /// Email validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your email'**
  String get pleaseEnterYourEmail;

  /// Password validation message
  ///
  /// In en, this message translates to:
  /// **'Please enter your password'**
  String get pleaseEnterYourPassword;

  /// Password length validation message
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get passwordMustBeAtLeast6Characters;

  /// User not found error message
  ///
  /// In en, this message translates to:
  /// **'No account found with this email'**
  String get noAccountFoundWithThisEmail;

  /// Invalid credentials error message
  ///
  /// In en, this message translates to:
  /// **'Invalid email or password. Please check your credentials and try again.'**
  String get invalidEmailOrPassword;

  /// Email already in use error message
  ///
  /// In en, this message translates to:
  /// **'An account already exists with this email'**
  String get accountAlreadyExistsWithThisEmail;

  /// Weak password error message
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get passwordIsTooWeak;

  /// Invalid email format error message
  ///
  /// In en, this message translates to:
  /// **'Invalid email address'**
  String get invalidEmailAddress;

  /// Network error message
  ///
  /// In en, this message translates to:
  /// **'Network connection failed. Please check your internet connection.'**
  String get networkConnectionFailed;

  /// Rate limit error message
  ///
  /// In en, this message translates to:
  /// **'Too many failed attempts. Please try again later.'**
  String get tooManyFailedAttempts;

  /// Generic authentication error message
  ///
  /// In en, this message translates to:
  /// **'Authentication failed: {error}'**
  String authenticationFailed(String error);

  /// Account saved success message
  ///
  /// In en, this message translates to:
  /// **'Account saved and synced with Firebase'**
  String get accountSavedAndSyncedWithFirebase;
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
