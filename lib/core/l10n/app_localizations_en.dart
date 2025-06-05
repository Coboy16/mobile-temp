// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get selectLanguage => 'Select Language';

  @override
  String get languageEnglish => 'English';

  @override
  String get languageSpanish => 'Spanish';

  @override
  String get languageFrench => 'French';

  @override
  String get loginTitle => 'Sign In';

  @override
  String get registerTitle => 'Create Account';

  @override
  String get forgotPasswordEmailTitle => 'Recover Password';

  @override
  String get forgotPasswordOtpTitle => 'Verify Code';

  @override
  String get loginSubtitle => 'Enter your credentials to access the system';

  @override
  String get registerSubtitle => 'Complete the form to join Ho-Tech';

  @override
  String get forgotPasswordEmailSubtitle =>
      'Enter your email to send a recovery code.';

  @override
  String forgotPasswordOtpSubtitle(String emailAddress) {
    return 'Ingresa el código de 6 dígitos enviado a $emailAddress.';
  }

  @override
  String copyrightNotice(int year) {
    return '© $year Ho-Tech. All rights reserved.';
  }

  @override
  String get loadingMessage => 'Loading...';

  @override
  String get validationSuccessMessage =>
      'Validation successful. Please continue with the process.';

  @override
  String get yourEmailFallback => 'your email';

  @override
  String get errorDialogTitle => 'Error';

  @override
  String get userBlockedDialogTitle => 'Account Locked';

  @override
  String userBlockedDialogMessage(Object minutes) {
    return 'Your account has been temporarily locked. Please try again in $minutes minutes.';
  }

  @override
  String get userAccountBlockedGeneric =>
      'Your account is currently locked. Please try again later.';

  @override
  String get okButtonLabel => 'OK';

  @override
  String get confirmLogoutDialogTitle => 'Confirm Logout';

  @override
  String get confirmLogoutDialogMessage => 'Are you sure you want to log out?';

  @override
  String get cancelButtonLabel => 'Cancel';

  @override
  String get logoutButtonLabel => 'Log Out';

  @override
  String get loggingOutMessage => 'Logging out...';

  @override
  String get registrationErrorDialogTitle => 'Registration Error';

  @override
  String get leftPanelLoginTitle => 'Welcome to Ho-Tech';

  @override
  String get leftPanelLoginSubtitle =>
      'Comprehensive platform for human resources management in hotel sector companies.';

  @override
  String get leftPanelLoginHighlight1Title => 'Request Management';

  @override
  String get leftPanelLoginHighlight1Description =>
      'Manage all types of requests from a single place.';

  @override
  String get leftPanelLoginHighlight2Title => 'Personnel Administration';

  @override
  String get leftPanelLoginHighlight2Description =>
      'Hiring, evaluations, training, and more.';

  @override
  String get leftPanelLoginHighlight3Title => 'Reports and Analysis';

  @override
  String get leftPanelLoginHighlight3Description =>
      'Metrics and indicators to make better decisions.';

  @override
  String get leftPanelRegisterTitle => 'Join Ho-Tech';

  @override
  String get leftPanelRegisterSubtitle =>
      'Register to access simplified and efficient hotel management.';

  @override
  String get leftPanelRegisterHighlight1Title => 'Quick Registration';

  @override
  String get leftPanelRegisterHighlight1Description =>
      'Create your account in a few steps and start transforming your management.';

  @override
  String get leftPanelRegisterHighlight2Title => 'Guaranteed Security';

  @override
  String get leftPanelRegisterHighlight2Description =>
      'Your data is protected with the highest standards.';

  @override
  String get leftPanelRegisterHighlight3Title => 'Immediate Access';

  @override
  String get leftPanelRegisterHighlight3Description =>
      'Once registered, explore all the functionalities that Ho-Tech offers you.';

  @override
  String get leftPanelForgotPasswordTitle => 'Recover Your Access';

  @override
  String get leftPanelForgotPasswordSubtitle =>
      'Follow the steps to reset your password and efficiently manage your human resources again.';

  @override
  String get leftPanelForgotPasswordHighlight1Title => 'Secure Verification';

  @override
  String get leftPanelForgotPasswordHighlight1Description =>
      'Enter your email to receive a verification code and protect your account.';

  @override
  String get leftPanelForgotPasswordHighlight2Title => 'Easy Reset';

  @override
  String get leftPanelForgotPasswordHighlight2Description =>
      'With the OTP code, you can create a new password quickly and securely.';

  @override
  String get leftPanelForgotPasswordHighlight3Title => 'Continuous Support';

  @override
  String get leftPanelForgotPasswordHighlight3Description =>
      'If you have problems, our support team is ready to help you.';

  @override
  String get forgotPasswordEmailFormLabel => 'Email address';

  @override
  String get forgotPasswordEmailFormHint => 'Enter your email address';

  @override
  String get forgotPasswordEmailFormErrorRequired => 'Email is required';

  @override
  String get forgotPasswordEmailFormErrorInvalid => 'Enter a valid email';

  @override
  String get forgotPasswordEmailFormSubmitButton => 'Send recovery code';

  @override
  String get forgotPasswordEmailFormBackToLoginButton => 'Back to Sign In';

  @override
  String get forgotPasswordOtpFormValidatorError => 'The code must be 6 digits';

  @override
  String get forgotPasswordOtpFormSubmitButton => 'Verify Code';

  @override
  String get forgotPasswordOtpFormDidNotReceiveCode =>
      'Didn\'t receive the code? ';

  @override
  String get forgotPasswordOtpFormResendCodeButton => 'Resend code';

  @override
  String get forgotPasswordOtpFormEnterDifferentEmailButton =>
      'Enter a different email';

  @override
  String get loginFormUsernameLabel => 'Username';

  @override
  String get loginFormUsernameHint => 'Enter your username';

  @override
  String get loginFormUsernameErrorRequired => 'Username is required';

  @override
  String get loginFormPasswordLabel => 'Password';

  @override
  String get loginFormPasswordHint => 'Enter your password';

  @override
  String get loginFormPasswordErrorRequired => 'Password is required';

  @override
  String get loginFormPasswordErrorMinLength =>
      'Password must be at least 6 characters';

  @override
  String get loginFormForgotPasswordButton => 'Forgot your password?';

  @override
  String get loginFormLoginButton => 'Sign In';

  @override
  String get loginFormLoginWithGoogleButton => 'Sign In with Google';

  @override
  String get loginFormNoAccountPrompt => 'Don\'t have an account? ';

  @override
  String get loginFormCreateAccountButton => 'Create account';

  @override
  String get otpFormValidatorError => 'The code must be 6 digits';

  @override
  String get otpFormDefaultSubmitButton => 'Verify Code';

  @override
  String get otpFormDidNotReceiveCodePrompt => 'Didn\'t receive the code? ';

  @override
  String get otpFormDefaultResendButton => 'Resend code';

  @override
  String get registerFormFirstNameLabel => 'First Name';

  @override
  String get registerFormFirstNameHint => 'Enter your first name';

  @override
  String get registerFormFirstNameErrorRequired => 'First name is required';

  @override
  String get registerFormPaternalLastNameLabel => 'Paternal Last Name';

  @override
  String get registerFormPaternalLastNameHint =>
      'Enter your paternal last name';

  @override
  String get registerFormPaternalLastNameErrorRequired =>
      'Paternal last name is required';

  @override
  String get registerFormMaternalLastNameLabel => 'Maternal Last Name';

  @override
  String get registerFormMaternalLastNameHint =>
      'Enter your maternal last name';

  @override
  String get registerFormMaternalLastNameErrorRequired =>
      'Maternal last name is required';

  @override
  String get registerFormEmailLabel => 'Email';

  @override
  String get registerFormEmailHint => 'Enter your email';

  @override
  String get registerFormEmailErrorRequired => 'Email is required';

  @override
  String get registerFormEmailErrorInvalid => 'Enter a valid email';

  @override
  String get registerFormPasswordLabel => 'Password';

  @override
  String get registerFormPasswordHint => 'Enter your password';

  @override
  String get registerFormPasswordErrorRequired => 'Password is required';

  @override
  String get registerFormPasswordErrorMinLength => 'Minimum 8 characters';

  @override
  String get registerFormPasswordErrorUppercase =>
      'Must contain at least one uppercase letter';

  @override
  String get registerFormPasswordErrorDigit =>
      'Must contain at least one digit';

  @override
  String get registerFormPasswordErrorSpecialChar =>
      'Must contain at least one special character';

  @override
  String get registerFormConfirmPasswordLabel => 'Confirm Password';

  @override
  String get registerFormConfirmPasswordHint => 'Re-enter your password';

  @override
  String get registerFormConfirmPasswordErrorRequired =>
      'Confirm your password';

  @override
  String get registerFormConfirmPasswordErrorMismatch =>
      'Passwords do not match';

  @override
  String get registerFormContinueButton => 'Continue';

  @override
  String get registerFormCreateAccountWithGoogleButton =>
      'Create account with Google';

  @override
  String get registerFormAlreadyHaveAccountPrompt =>
      'Already have an account? ';

  @override
  String get registerFormLoginButton => 'Sign In';

  @override
  String get loadingMessageDefault => 'Loading...';

  @override
  String get formValidationCompleteCorrectly =>
      'Please complete the form correctly.';

  @override
  String get googleSignInCancelled => 'Google sign-in cancelled by user.';

  @override
  String get registerWithGoogleSuccessMessage =>
      'Registration with Google successful! Logging you in...';

  @override
  String get otpVerificationSuccessMessageRegister =>
      'OTP verified successfully. Proceeding with registration...';

  @override
  String otpResendSuccessMessage(Object email) {
    return 'A new OTP has been resent to $email.';
  }

  @override
  String get registrationCompleteMessage =>
      'Registration complete! Logging you in...';

  @override
  String get autoLoginFailedMessage => 'Automatic login failed';

  @override
  String get autoLoginFailedAfterRegisterMessage =>
      'Failed to log in after registration';

  @override
  String get autoLoginFailedAfterGoogleRegisterMessage =>
      'Failed to log in with Google after registration';

  @override
  String otpVerificationDescriptionForRegistration(Object email) {
    return 'We\'ve sent a verification code to your email $email. Please enter it below to complete your registration.';
  }

  @override
  String get otpVerificationButtonForRegistration => 'Verify & Register';

  @override
  String get otpVerificationResendButtonForRegistration => 'Resend Code';

  @override
  String get otpRequestLoadingMessage => 'Requesting OTP...';

  @override
  String get otpVerificationLoadingMessage => 'Verifying OTP...';

  @override
  String get registerLoadingMessage => 'Registering user...';

  @override
  String get loginLoadingMessage => 'Logging in...';

  @override
  String otpSentSuccessMessage(Object email) {
    return 'OTP sent successfully to $email.';
  }

  @override
  String get errorEmailNotProvidedMessage =>
      'Error: Email not provided for OTP verification.';

  @override
  String get otpVerificationSuccessMessage => 'OTP verified successfully!';

  @override
  String get passwordChangeSuccessMessage =>
      'Password changed successfully! Please log in.';

  @override
  String newPasswordFormTitleFor(Object email) {
    return 'Set New Password for $email';
  }

  @override
  String get newPasswordFormNewLabel => 'New Password';

  @override
  String get newPasswordFormNewHint => 'Enter your new password';

  @override
  String get newPasswordFormNewErrorRequired => 'New password is required';

  @override
  String get newPasswordFormConfirmLabel => 'Confirm New Password';

  @override
  String get newPasswordFormConfirmHint => 'Confirm your new password';

  @override
  String get newPasswordFormConfirmErrorRequired =>
      'Please confirm your new password';

  @override
  String get newPasswordFormSubmitButton => 'Change Password';

  @override
  String get leftPanelSetNewPasswordTitle => 'Secure Your Account';

  @override
  String get leftPanelSetNewPasswordSubtitle =>
      'Choose a strong, unique password to protect your hotel management data.';

  @override
  String get leftPanelSetNewPasswordHighlight1Title => 'Strong Password';

  @override
  String get leftPanelSetNewPasswordHighlight1Description =>
      'Use a mix of letters, numbers, and symbols for better security.';

  @override
  String get leftPanelSetNewPasswordHighlight2Title => 'Avoid Reuse';

  @override
  String get leftPanelSetNewPasswordHighlight2Description =>
      'Don\'t use passwords you\'ve used on other sites.';

  @override
  String get leftPanelSetNewPasswordHighlight3Title => 'Confirmation';

  @override
  String get leftPanelSetNewPasswordHighlight3Description =>
      'Ensure your new password is confirmed энергия (energy) and saved securely.';

  @override
  String get setNewPasswordTitle => 'Set New Password';

  @override
  String setNewPasswordSubtitle(Object email) {
    return 'Create a new secure password for your account associated with $email.';
  }

  @override
  String get forgotPasswordEmailVerificationLoadingMessage =>
      'Verifying email...';

  @override
  String get forgotPasswordOtpVerificationLoadingMessage => 'Verifying OTP...';

  @override
  String get forgotPasswordChangeLoadingMessage => 'Updating password...';

  @override
  String get settingsTitle => 'Settings';

  @override
  String get settingsSubtitle => 'Manage your preferences and system settings';

  @override
  String get backButton => 'Back';

  @override
  String get accountTab => 'Account';

  @override
  String get appearanceTab => 'Appearance';

  @override
  String get userInfoTitle => 'User Information';

  @override
  String get userInfoSubtitle =>
      'Basic information about your account and user preferences';

  @override
  String get appearanceContentPlaceholder => 'Appearance Content Here';

  @override
  String get activeSessionDialogTitle => 'Active Session Detected';

  @override
  String get activeSessionDialogMessage =>
      'You already have an active session on another device or browser. Do you want to close the previous session and continue with the current login?';

  @override
  String get keepSessionButtonLabel => 'Keep Session';

  @override
  String get closeSessionButtonLabel => 'Close Previous Session';

  @override
  String get invalidOtpMessage =>
      'The code you entered is not valid. Please check it and try again.';

  @override
  String get logoutConfirmTitle => 'Sign Out';

  @override
  String get logoutConfirmMessage =>
      'Are you sure you want to sign out? You will need to sign in again to access the system.';

  @override
  String get logout => 'Sign Out';

  @override
  String get cancel => 'Cancel';

  @override
  String get passwordRecoveryErrorTitle => 'Email Not Found';

  @override
  String get passwordRecoveryErrorMessage =>
      'This email address is not registered in the system. Please verify and try again.';

  @override
  String get accept => 'Understood';

  @override
  String get accountBlockedTitle => 'Account Temporarily Blocked';

  @override
  String get accountBlockedMessage =>
      'Your account has been temporarily blocked for security reasons. Please try again after 2 hours or contact the administrator if you need immediate assistance.';

  @override
  String get invalidCredentialsTitle => 'Invalid Credentials';

  @override
  String get invalidCredentialsMessage =>
      'Incorrect username or password. Please verify your information and try again.';

  @override
  String get userAlreadyExistsTitle => 'User Already Exists';

  @override
  String get emailAlreadyRegisteredError =>
      'This email is already registered. Please log in.';

  @override
  String get passwordMismatchTitle => 'Passwords Don\'t Match';

  @override
  String get passwordMismatchMessage =>
      'The passwords entered do not match. Please verify and try again.';

  @override
  String get registrationErrorTitle => 'Registration Error';

  @override
  String get registrationErrorMessage =>
      'Could not complete the registration. Please try again.';

  @override
  String get otpVerificationErrorTitle => 'Incorrect Code';

  @override
  String get autoLoginFailedTitle => 'Auto Login Failed';

  @override
  String get formValidationErrorTitle => 'Incomplete Form';

  @override
  String get googleSignInCancelledTitle => 'Registration Cancelled';

  @override
  String get passwordChangeSuccessTitle => 'Password Updated';

  @override
  String get emailNotProvidedErrorTitle => 'Email Required';

  @override
  String get otpVerificationSuccessTitle => 'Code Verified';

  @override
  String get operationErrorTitle => 'Error';

  @override
  String get authLoginErrorTitle => 'Authentication Error';

  @override
  String get googleLoginErrorTitle => 'Google Error';

  @override
  String get loginSuccessTitle => 'Welcome!';

  @override
  String get loginSuccessMessage =>
      'You have successfully signed in. Redirecting to the system...';

  @override
  String get loginSuccessGoogleMessage =>
      'Google sign-in successful. Accessing the system...';

  @override
  String get returnToLoginTitle => 'Going Back';

  @override
  String get returnToLoginMessage => 'Returning to the login screen.';

  @override
  String get deleteAccountTitle => 'Delete Account';

  @override
  String get deleteAccountMessage =>
      'Are you sure? This action is irreversible and all your data will be permanently deleted.';

  @override
  String get deleteConfirm => 'Yes, Delete';

  @override
  String get accountDeletedSuccessTitle => 'Account Deleted';

  @override
  String get userIdNotAvailableError =>
      'User ID not available to delete the account.';

  @override
  String get invalidEmailFormatTitle => 'Invalid Email Format';

  @override
  String get invalidEmailFormatMessage =>
      'The email format entered is not valid. Please check that it has the correct format (example: user@domain.com) and try again.';

  @override
  String get confirmLogoutTitle => 'Confirm Logout';

  @override
  String get confirmLogoutMessage =>
      'Are you sure you want to log out? You will be redirected to the login screen.';

  @override
  String get logoutButton => 'Log Out';
}
