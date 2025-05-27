import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_es.dart';
import 'app_localizations_fr.dart';

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
    Locale('es'),
    Locale('fr'),
  ];

  /// Label for language selection prompt
  ///
  /// In en, this message translates to:
  /// **'Select Language'**
  String get selectLanguage;

  /// No description provided for @languageEnglish.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get languageEnglish;

  /// No description provided for @languageSpanish.
  ///
  /// In en, this message translates to:
  /// **'Spanish'**
  String get languageSpanish;

  /// No description provided for @languageFrench.
  ///
  /// In en, this message translates to:
  /// **'French'**
  String get languageFrench;

  /// Title for the login screen
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginTitle;

  /// Title for the registration screen
  ///
  /// In en, this message translates to:
  /// **'Create Account'**
  String get registerTitle;

  /// Title for the forgot password (email input) screen
  ///
  /// In en, this message translates to:
  /// **'Recover Password'**
  String get forgotPasswordEmailTitle;

  /// Title for the forgot password (OTP input) screen
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get forgotPasswordOtpTitle;

  /// Subtitle instruction on the login screen
  ///
  /// In en, this message translates to:
  /// **'Enter your credentials to access the system'**
  String get loginSubtitle;

  /// Subtitle instruction on the registration screen
  ///
  /// In en, this message translates to:
  /// **'Complete the form to join Ho-Tech'**
  String get registerSubtitle;

  /// Subtitle instruction on the forgot password (email input) screen
  ///
  /// In en, this message translates to:
  /// **'Enter your email to send a recovery code.'**
  String get forgotPasswordEmailSubtitle;

  /// No description provided for @forgotPasswordOtpSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Ingresa el código de 6 dígitos enviado a {emailAddress}.'**
  String forgotPasswordOtpSubtitle(String emailAddress);

  /// No description provided for @copyrightNotice.
  ///
  /// In en, this message translates to:
  /// **'© {year} Ho-Tech. All rights reserved.'**
  String copyrightNotice(int year);

  /// Generic loading message
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingMessage;

  /// Message shown when a validation step (like OTP) succeeds
  ///
  /// In en, this message translates to:
  /// **'Validation successful. Please continue with the process.'**
  String get validationSuccessMessage;

  /// No description provided for @yourEmailFallback.
  ///
  /// In en, this message translates to:
  /// **'your email'**
  String get yourEmailFallback;

  /// No description provided for @errorDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Error'**
  String get errorDialogTitle;

  /// No description provided for @userBlockedDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Account Locked'**
  String get userBlockedDialogTitle;

  /// No description provided for @userBlockedDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'Your account has been temporarily locked. Please try again in {minutes} minutes.'**
  String userBlockedDialogMessage(Object minutes);

  /// No description provided for @userAccountBlockedGeneric.
  ///
  /// In en, this message translates to:
  /// **'Your account is currently locked. Please try again later.'**
  String get userAccountBlockedGeneric;

  /// No description provided for @okButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'OK'**
  String get okButtonLabel;

  /// Title for the logout confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Confirm Logout'**
  String get confirmLogoutDialogTitle;

  /// Message for the logout confirmation dialog
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get confirmLogoutDialogMessage;

  /// Label for the cancel button
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancelButtonLabel;

  /// Label for the logout button
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logoutButtonLabel;

  /// Message shown while logging out
  ///
  /// In en, this message translates to:
  /// **'Logging out...'**
  String get loggingOutMessage;

  /// No description provided for @registrationErrorDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Registration Error'**
  String get registrationErrorDialogTitle;

  /// No description provided for @leftPanelLoginTitle.
  ///
  /// In en, this message translates to:
  /// **'Welcome to Ho-Tech'**
  String get leftPanelLoginTitle;

  /// No description provided for @leftPanelLoginSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Comprehensive platform for human resources management in hotel sector companies.'**
  String get leftPanelLoginSubtitle;

  /// No description provided for @leftPanelLoginHighlight1Title.
  ///
  /// In en, this message translates to:
  /// **'Request Management'**
  String get leftPanelLoginHighlight1Title;

  /// No description provided for @leftPanelLoginHighlight1Description.
  ///
  /// In en, this message translates to:
  /// **'Manage all types of requests from a single place.'**
  String get leftPanelLoginHighlight1Description;

  /// No description provided for @leftPanelLoginHighlight2Title.
  ///
  /// In en, this message translates to:
  /// **'Personnel Administration'**
  String get leftPanelLoginHighlight2Title;

  /// No description provided for @leftPanelLoginHighlight2Description.
  ///
  /// In en, this message translates to:
  /// **'Hiring, evaluations, training, and more.'**
  String get leftPanelLoginHighlight2Description;

  /// No description provided for @leftPanelLoginHighlight3Title.
  ///
  /// In en, this message translates to:
  /// **'Reports and Analysis'**
  String get leftPanelLoginHighlight3Title;

  /// No description provided for @leftPanelLoginHighlight3Description.
  ///
  /// In en, this message translates to:
  /// **'Metrics and indicators to make better decisions.'**
  String get leftPanelLoginHighlight3Description;

  /// No description provided for @leftPanelRegisterTitle.
  ///
  /// In en, this message translates to:
  /// **'Join Ho-Tech'**
  String get leftPanelRegisterTitle;

  /// No description provided for @leftPanelRegisterSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Register to access simplified and efficient hotel management.'**
  String get leftPanelRegisterSubtitle;

  /// No description provided for @leftPanelRegisterHighlight1Title.
  ///
  /// In en, this message translates to:
  /// **'Quick Registration'**
  String get leftPanelRegisterHighlight1Title;

  /// No description provided for @leftPanelRegisterHighlight1Description.
  ///
  /// In en, this message translates to:
  /// **'Create your account in a few steps and start transforming your management.'**
  String get leftPanelRegisterHighlight1Description;

  /// No description provided for @leftPanelRegisterHighlight2Title.
  ///
  /// In en, this message translates to:
  /// **'Guaranteed Security'**
  String get leftPanelRegisterHighlight2Title;

  /// No description provided for @leftPanelRegisterHighlight2Description.
  ///
  /// In en, this message translates to:
  /// **'Your data is protected with the highest standards.'**
  String get leftPanelRegisterHighlight2Description;

  /// No description provided for @leftPanelRegisterHighlight3Title.
  ///
  /// In en, this message translates to:
  /// **'Immediate Access'**
  String get leftPanelRegisterHighlight3Title;

  /// No description provided for @leftPanelRegisterHighlight3Description.
  ///
  /// In en, this message translates to:
  /// **'Once registered, explore all the functionalities that Ho-Tech offers you.'**
  String get leftPanelRegisterHighlight3Description;

  /// No description provided for @leftPanelForgotPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Recover Your Access'**
  String get leftPanelForgotPasswordTitle;

  /// No description provided for @leftPanelForgotPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Follow the steps to reset your password and efficiently manage your human resources again.'**
  String get leftPanelForgotPasswordSubtitle;

  /// No description provided for @leftPanelForgotPasswordHighlight1Title.
  ///
  /// In en, this message translates to:
  /// **'Secure Verification'**
  String get leftPanelForgotPasswordHighlight1Title;

  /// No description provided for @leftPanelForgotPasswordHighlight1Description.
  ///
  /// In en, this message translates to:
  /// **'Enter your email to receive a verification code and protect your account.'**
  String get leftPanelForgotPasswordHighlight1Description;

  /// No description provided for @leftPanelForgotPasswordHighlight2Title.
  ///
  /// In en, this message translates to:
  /// **'Easy Reset'**
  String get leftPanelForgotPasswordHighlight2Title;

  /// No description provided for @leftPanelForgotPasswordHighlight2Description.
  ///
  /// In en, this message translates to:
  /// **'With the OTP code, you can create a new password quickly and securely.'**
  String get leftPanelForgotPasswordHighlight2Description;

  /// No description provided for @leftPanelForgotPasswordHighlight3Title.
  ///
  /// In en, this message translates to:
  /// **'Continuous Support'**
  String get leftPanelForgotPasswordHighlight3Title;

  /// No description provided for @leftPanelForgotPasswordHighlight3Description.
  ///
  /// In en, this message translates to:
  /// **'If you have problems, our support team is ready to help you.'**
  String get leftPanelForgotPasswordHighlight3Description;

  /// No description provided for @forgotPasswordEmailFormLabel.
  ///
  /// In en, this message translates to:
  /// **'Email address'**
  String get forgotPasswordEmailFormLabel;

  /// No description provided for @forgotPasswordEmailFormHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email address'**
  String get forgotPasswordEmailFormHint;

  /// No description provided for @forgotPasswordEmailFormErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get forgotPasswordEmailFormErrorRequired;

  /// No description provided for @forgotPasswordEmailFormErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get forgotPasswordEmailFormErrorInvalid;

  /// No description provided for @forgotPasswordEmailFormSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Send recovery code'**
  String get forgotPasswordEmailFormSubmitButton;

  /// No description provided for @forgotPasswordEmailFormBackToLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Back to Sign In'**
  String get forgotPasswordEmailFormBackToLoginButton;

  /// No description provided for @forgotPasswordOtpFormValidatorError.
  ///
  /// In en, this message translates to:
  /// **'The code must be 6 digits'**
  String get forgotPasswordOtpFormValidatorError;

  /// No description provided for @forgotPasswordOtpFormSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get forgotPasswordOtpFormSubmitButton;

  /// No description provided for @forgotPasswordOtpFormDidNotReceiveCode.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get forgotPasswordOtpFormDidNotReceiveCode;

  /// No description provided for @forgotPasswordOtpFormResendCodeButton.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get forgotPasswordOtpFormResendCodeButton;

  /// No description provided for @forgotPasswordOtpFormEnterDifferentEmailButton.
  ///
  /// In en, this message translates to:
  /// **'Enter a different email'**
  String get forgotPasswordOtpFormEnterDifferentEmailButton;

  /// No description provided for @loginFormUsernameLabel.
  ///
  /// In en, this message translates to:
  /// **'Username'**
  String get loginFormUsernameLabel;

  /// No description provided for @loginFormUsernameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your username'**
  String get loginFormUsernameHint;

  /// No description provided for @loginFormUsernameErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Username is required'**
  String get loginFormUsernameErrorRequired;

  /// No description provided for @loginFormPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get loginFormPasswordLabel;

  /// No description provided for @loginFormPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get loginFormPasswordHint;

  /// No description provided for @loginFormPasswordErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get loginFormPasswordErrorRequired;

  /// No description provided for @loginFormPasswordErrorMinLength.
  ///
  /// In en, this message translates to:
  /// **'Password must be at least 6 characters'**
  String get loginFormPasswordErrorMinLength;

  /// No description provided for @loginFormForgotPasswordButton.
  ///
  /// In en, this message translates to:
  /// **'Forgot your password?'**
  String get loginFormForgotPasswordButton;

  /// No description provided for @loginFormLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get loginFormLoginButton;

  /// No description provided for @loginFormLoginWithGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In with Google'**
  String get loginFormLoginWithGoogleButton;

  /// No description provided for @loginFormNoAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Don\'t have an account? '**
  String get loginFormNoAccountPrompt;

  /// No description provided for @loginFormCreateAccountButton.
  ///
  /// In en, this message translates to:
  /// **'Create account'**
  String get loginFormCreateAccountButton;

  /// No description provided for @otpFormValidatorError.
  ///
  /// In en, this message translates to:
  /// **'The code must be 6 digits'**
  String get otpFormValidatorError;

  /// No description provided for @otpFormDefaultSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Verify Code'**
  String get otpFormDefaultSubmitButton;

  /// No description provided for @otpFormDidNotReceiveCodePrompt.
  ///
  /// In en, this message translates to:
  /// **'Didn\'t receive the code? '**
  String get otpFormDidNotReceiveCodePrompt;

  /// No description provided for @otpFormDefaultResendButton.
  ///
  /// In en, this message translates to:
  /// **'Resend code'**
  String get otpFormDefaultResendButton;

  /// No description provided for @registerFormFirstNameLabel.
  ///
  /// In en, this message translates to:
  /// **'First Name'**
  String get registerFormFirstNameLabel;

  /// No description provided for @registerFormFirstNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your first name'**
  String get registerFormFirstNameHint;

  /// No description provided for @registerFormFirstNameErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'First name is required'**
  String get registerFormFirstNameErrorRequired;

  /// No description provided for @registerFormPaternalLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Paternal Last Name'**
  String get registerFormPaternalLastNameLabel;

  /// No description provided for @registerFormPaternalLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your paternal last name'**
  String get registerFormPaternalLastNameHint;

  /// No description provided for @registerFormPaternalLastNameErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Paternal last name is required'**
  String get registerFormPaternalLastNameErrorRequired;

  /// No description provided for @registerFormMaternalLastNameLabel.
  ///
  /// In en, this message translates to:
  /// **'Maternal Last Name'**
  String get registerFormMaternalLastNameLabel;

  /// No description provided for @registerFormMaternalLastNameHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your maternal last name'**
  String get registerFormMaternalLastNameHint;

  /// No description provided for @registerFormMaternalLastNameErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Maternal last name is required'**
  String get registerFormMaternalLastNameErrorRequired;

  /// No description provided for @registerFormEmailLabel.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get registerFormEmailLabel;

  /// No description provided for @registerFormEmailHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your email'**
  String get registerFormEmailHint;

  /// No description provided for @registerFormEmailErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Email is required'**
  String get registerFormEmailErrorRequired;

  /// No description provided for @registerFormEmailErrorInvalid.
  ///
  /// In en, this message translates to:
  /// **'Enter a valid email'**
  String get registerFormEmailErrorInvalid;

  /// No description provided for @registerFormPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Password'**
  String get registerFormPasswordLabel;

  /// No description provided for @registerFormPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your password'**
  String get registerFormPasswordHint;

  /// No description provided for @registerFormPasswordErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Password is required'**
  String get registerFormPasswordErrorRequired;

  /// No description provided for @registerFormPasswordErrorMinLength.
  ///
  /// In en, this message translates to:
  /// **'Minimum 8 characters'**
  String get registerFormPasswordErrorMinLength;

  /// No description provided for @registerFormPasswordErrorUppercase.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one uppercase letter'**
  String get registerFormPasswordErrorUppercase;

  /// No description provided for @registerFormPasswordErrorDigit.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one digit'**
  String get registerFormPasswordErrorDigit;

  /// No description provided for @registerFormPasswordErrorSpecialChar.
  ///
  /// In en, this message translates to:
  /// **'Must contain at least one special character'**
  String get registerFormPasswordErrorSpecialChar;

  /// No description provided for @registerFormConfirmPasswordLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm Password'**
  String get registerFormConfirmPasswordLabel;

  /// No description provided for @registerFormConfirmPasswordHint.
  ///
  /// In en, this message translates to:
  /// **'Re-enter your password'**
  String get registerFormConfirmPasswordHint;

  /// No description provided for @registerFormConfirmPasswordErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Confirm your password'**
  String get registerFormConfirmPasswordErrorRequired;

  /// No description provided for @registerFormConfirmPasswordErrorMismatch.
  ///
  /// In en, this message translates to:
  /// **'Passwords do not match'**
  String get registerFormConfirmPasswordErrorMismatch;

  /// No description provided for @registerFormContinueButton.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get registerFormContinueButton;

  /// No description provided for @registerFormCreateAccountWithGoogleButton.
  ///
  /// In en, this message translates to:
  /// **'Create account with Google'**
  String get registerFormCreateAccountWithGoogleButton;

  /// No description provided for @registerFormAlreadyHaveAccountPrompt.
  ///
  /// In en, this message translates to:
  /// **'Already have an account? '**
  String get registerFormAlreadyHaveAccountPrompt;

  /// No description provided for @registerFormLoginButton.
  ///
  /// In en, this message translates to:
  /// **'Sign In'**
  String get registerFormLoginButton;

  /// No description provided for @loadingMessageDefault.
  ///
  /// In en, this message translates to:
  /// **'Loading...'**
  String get loadingMessageDefault;

  /// No description provided for @formValidationCompleteCorrectly.
  ///
  /// In en, this message translates to:
  /// **'Please complete the form correctly.'**
  String get formValidationCompleteCorrectly;

  /// No description provided for @googleSignInCancelled.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in cancelled by user.'**
  String get googleSignInCancelled;

  /// No description provided for @registerWithGoogleSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Registration with Google successful! Logging you in...'**
  String get registerWithGoogleSuccessMessage;

  /// No description provided for @otpVerificationSuccessMessageRegister.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully. Proceeding with registration...'**
  String get otpVerificationSuccessMessageRegister;

  /// No description provided for @otpResendSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'A new OTP has been resent to {email}.'**
  String otpResendSuccessMessage(Object email);

  /// No description provided for @registrationCompleteMessage.
  ///
  /// In en, this message translates to:
  /// **'Registration complete! Logging you in...'**
  String get registrationCompleteMessage;

  /// No description provided for @autoLoginFailedMessage.
  ///
  /// In en, this message translates to:
  /// **'Automatic login failed'**
  String get autoLoginFailedMessage;

  /// No description provided for @autoLoginFailedAfterRegisterMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to log in after registration'**
  String get autoLoginFailedAfterRegisterMessage;

  /// No description provided for @autoLoginFailedAfterGoogleRegisterMessage.
  ///
  /// In en, this message translates to:
  /// **'Failed to log in with Google after registration'**
  String get autoLoginFailedAfterGoogleRegisterMessage;

  /// No description provided for @otpVerificationDescriptionForRegistration.
  ///
  /// In en, this message translates to:
  /// **'We\'ve sent a verification code to your email {email}. Please enter it below to complete your registration.'**
  String otpVerificationDescriptionForRegistration(Object email);

  /// No description provided for @otpVerificationButtonForRegistration.
  ///
  /// In en, this message translates to:
  /// **'Verify & Register'**
  String get otpVerificationButtonForRegistration;

  /// No description provided for @otpVerificationResendButtonForRegistration.
  ///
  /// In en, this message translates to:
  /// **'Resend Code'**
  String get otpVerificationResendButtonForRegistration;

  /// No description provided for @emailAlreadyRegisteredError.
  ///
  /// In en, this message translates to:
  /// **'This email is already registered. Please try logging in or use a different email.'**
  String get emailAlreadyRegisteredError;

  /// No description provided for @otpRequestLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Requesting OTP...'**
  String get otpRequestLoadingMessage;

  /// No description provided for @otpVerificationLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Verifying OTP...'**
  String get otpVerificationLoadingMessage;

  /// No description provided for @registerLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Registering user...'**
  String get registerLoadingMessage;

  /// No description provided for @loginLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Logging in...'**
  String get loginLoadingMessage;

  /// No description provided for @otpSentSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'OTP sent successfully to {email}.'**
  String otpSentSuccessMessage(Object email);

  /// No description provided for @errorEmailNotProvidedMessage.
  ///
  /// In en, this message translates to:
  /// **'Error: Email not provided for OTP verification.'**
  String get errorEmailNotProvidedMessage;

  /// No description provided for @otpVerificationSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'OTP verified successfully!'**
  String get otpVerificationSuccessMessage;

  /// No description provided for @passwordChangeSuccessMessage.
  ///
  /// In en, this message translates to:
  /// **'Password changed successfully! Please log in.'**
  String get passwordChangeSuccessMessage;

  /// No description provided for @newPasswordFormTitleFor.
  ///
  /// In en, this message translates to:
  /// **'Set New Password for {email}'**
  String newPasswordFormTitleFor(Object email);

  /// No description provided for @newPasswordFormNewLabel.
  ///
  /// In en, this message translates to:
  /// **'New Password'**
  String get newPasswordFormNewLabel;

  /// No description provided for @newPasswordFormNewHint.
  ///
  /// In en, this message translates to:
  /// **'Enter your new password'**
  String get newPasswordFormNewHint;

  /// No description provided for @newPasswordFormNewErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'New password is required'**
  String get newPasswordFormNewErrorRequired;

  /// No description provided for @newPasswordFormConfirmLabel.
  ///
  /// In en, this message translates to:
  /// **'Confirm New Password'**
  String get newPasswordFormConfirmLabel;

  /// No description provided for @newPasswordFormConfirmHint.
  ///
  /// In en, this message translates to:
  /// **'Confirm your new password'**
  String get newPasswordFormConfirmHint;

  /// No description provided for @newPasswordFormConfirmErrorRequired.
  ///
  /// In en, this message translates to:
  /// **'Please confirm your new password'**
  String get newPasswordFormConfirmErrorRequired;

  /// No description provided for @newPasswordFormSubmitButton.
  ///
  /// In en, this message translates to:
  /// **'Change Password'**
  String get newPasswordFormSubmitButton;

  /// No description provided for @leftPanelSetNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Secure Your Account'**
  String get leftPanelSetNewPasswordTitle;

  /// No description provided for @leftPanelSetNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Choose a strong, unique password to protect your hotel management data.'**
  String get leftPanelSetNewPasswordSubtitle;

  /// No description provided for @leftPanelSetNewPasswordHighlight1Title.
  ///
  /// In en, this message translates to:
  /// **'Strong Password'**
  String get leftPanelSetNewPasswordHighlight1Title;

  /// No description provided for @leftPanelSetNewPasswordHighlight1Description.
  ///
  /// In en, this message translates to:
  /// **'Use a mix of letters, numbers, and symbols for better security.'**
  String get leftPanelSetNewPasswordHighlight1Description;

  /// No description provided for @leftPanelSetNewPasswordHighlight2Title.
  ///
  /// In en, this message translates to:
  /// **'Avoid Reuse'**
  String get leftPanelSetNewPasswordHighlight2Title;

  /// No description provided for @leftPanelSetNewPasswordHighlight2Description.
  ///
  /// In en, this message translates to:
  /// **'Don\'t use passwords you\'ve used on other sites.'**
  String get leftPanelSetNewPasswordHighlight2Description;

  /// No description provided for @leftPanelSetNewPasswordHighlight3Title.
  ///
  /// In en, this message translates to:
  /// **'Confirmation'**
  String get leftPanelSetNewPasswordHighlight3Title;

  /// No description provided for @leftPanelSetNewPasswordHighlight3Description.
  ///
  /// In en, this message translates to:
  /// **'Ensure your new password is confirmed энергия (energy) and saved securely.'**
  String get leftPanelSetNewPasswordHighlight3Description;

  /// No description provided for @setNewPasswordTitle.
  ///
  /// In en, this message translates to:
  /// **'Set New Password'**
  String get setNewPasswordTitle;

  /// No description provided for @setNewPasswordSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Create a new secure password for your account associated with {email}.'**
  String setNewPasswordSubtitle(Object email);

  /// No description provided for @forgotPasswordEmailVerificationLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Verifying email...'**
  String get forgotPasswordEmailVerificationLoadingMessage;

  /// No description provided for @forgotPasswordOtpVerificationLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Verifying OTP...'**
  String get forgotPasswordOtpVerificationLoadingMessage;

  /// No description provided for @forgotPasswordChangeLoadingMessage.
  ///
  /// In en, this message translates to:
  /// **'Updating password...'**
  String get forgotPasswordChangeLoadingMessage;

  /// No description provided for @settingsTitle.
  ///
  /// In en, this message translates to:
  /// **'Settings'**
  String get settingsTitle;

  /// No description provided for @settingsSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Manage your preferences and system settings'**
  String get settingsSubtitle;

  /// No description provided for @backButton.
  ///
  /// In en, this message translates to:
  /// **'Back'**
  String get backButton;

  /// No description provided for @accountTab.
  ///
  /// In en, this message translates to:
  /// **'Account'**
  String get accountTab;

  /// No description provided for @appearanceTab.
  ///
  /// In en, this message translates to:
  /// **'Appearance'**
  String get appearanceTab;

  /// No description provided for @userInfoTitle.
  ///
  /// In en, this message translates to:
  /// **'User Information'**
  String get userInfoTitle;

  /// No description provided for @userInfoSubtitle.
  ///
  /// In en, this message translates to:
  /// **'Basic information about your account and user preferences'**
  String get userInfoSubtitle;

  /// No description provided for @appearanceContentPlaceholder.
  ///
  /// In en, this message translates to:
  /// **'Appearance Content Here'**
  String get appearanceContentPlaceholder;

  /// No description provided for @activeSessionDialogTitle.
  ///
  /// In en, this message translates to:
  /// **'Active Session Detected'**
  String get activeSessionDialogTitle;

  /// No description provided for @activeSessionDialogMessage.
  ///
  /// In en, this message translates to:
  /// **'You already have an active session on another device or browser. Do you want to close the previous session and continue with the current login?'**
  String get activeSessionDialogMessage;

  /// No description provided for @keepSessionButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Keep Session'**
  String get keepSessionButtonLabel;

  /// No description provided for @closeSessionButtonLabel.
  ///
  /// In en, this message translates to:
  /// **'Close Previous Session'**
  String get closeSessionButtonLabel;

  /// No description provided for @invalidOtpMessage.
  ///
  /// In en, this message translates to:
  /// **'The code you entered is not valid. Please check it and try again.'**
  String get invalidOtpMessage;
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
      <String>['en', 'es', 'fr'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'es':
      return AppLocalizationsEs();
    case 'fr':
      return AppLocalizationsFr();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
