// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for French (`fr`).
class AppLocalizationsFr extends AppLocalizations {
  AppLocalizationsFr([String locale = 'fr']) : super(locale);

  @override
  String get selectLanguage => 'Sélectionner la langue';

  @override
  String get languageEnglish => 'Anglais';

  @override
  String get languageSpanish => 'Espagnol';

  @override
  String get languageFrench => 'Français';

  @override
  String get loginTitle => 'Se connecter';

  @override
  String get registerTitle => 'Créer un compte';

  @override
  String get forgotPasswordEmailTitle => 'Récupérer le mot de passe';

  @override
  String get forgotPasswordOtpTitle => 'Vérifier le code';

  @override
  String get loginSubtitle => 'Entrez vos identifiants pour accéder au système';

  @override
  String get registerSubtitle =>
      'Complétez le formulaire pour rejoindre Ho-Tech';

  @override
  String get forgotPasswordEmailSubtitle =>
      'Entrez votre e-mail pour envoyer un code de récupération.';

  @override
  String forgotPasswordOtpSubtitle(String emailAddress) {
    return 'Entrez le code à 6 chiffres envoyé à $emailAddress.';
  }

  @override
  String copyrightNotice(int year) {
    return '© $year Ho-Tech. Tous droits réservés.';
  }

  @override
  String get loadingMessage => 'Chargement...';

  @override
  String get validationSuccessMessage =>
      'Validation réussie. Veuillez poursuivre le processus.';

  @override
  String get yourEmailFallback => 'votre e-mail';

  @override
  String get errorDialogTitle => 'Erreur';

  @override
  String get userBlockedDialogTitle => 'Compte Bloqué';

  @override
  String userBlockedDialogMessage(Object minutes) {
    return 'Votre compte a été temporairement bloqué. Veuillez réessayer dans $minutes minutes.';
  }

  @override
  String get userAccountBlockedGeneric =>
      'Votre compte est bloqué. Veuillez réessayer plus tard.';

  @override
  String get okButtonLabel => 'Accepter';

  @override
  String get confirmLogoutDialogTitle => 'Confirmer la Déconnexion';

  @override
  String get confirmLogoutDialogMessage =>
      'Êtes-vous sûr de vouloir vous déconnecter ?';

  @override
  String get cancelButtonLabel => 'Annuler';

  @override
  String get logoutButtonLabel => 'Se Déconnecter';

  @override
  String get loggingOutMessage => 'Déconnexion en cours...';

  @override
  String get registrationErrorDialogTitle => 'Erreur d\'Inscription';

  @override
  String get leftPanelLoginTitle => 'Bienvenue chez Ho-Tech';

  @override
  String get leftPanelLoginSubtitle =>
      'Plateforme complète pour la gestion des ressources humaines dans les entreprises du secteur hôtelier.';

  @override
  String get leftPanelLoginHighlight1Title => 'Gestion des demandes';

  @override
  String get leftPanelLoginHighlight1Description =>
      'Gérez tous types de demandes depuis un seul endroit.';

  @override
  String get leftPanelLoginHighlight2Title => 'Administration du personnel';

  @override
  String get leftPanelLoginHighlight2Description =>
      'Embauches, évaluations, formations et plus encore.';

  @override
  String get leftPanelLoginHighlight3Title => 'Rapports et Analyses';

  @override
  String get leftPanelLoginHighlight3Description =>
      'Métriques et indicateurs pour prendre de meilleures décisions.';

  @override
  String get leftPanelRegisterTitle => 'Rejoignez Ho-Tech';

  @override
  String get leftPanelRegisterSubtitle =>
      'Inscrivez-vous pour accéder à une gestion hôtelière simplifiée et efficace.';

  @override
  String get leftPanelRegisterHighlight1Title => 'Inscription Rapide';

  @override
  String get leftPanelRegisterHighlight1Description =>
      'Créez votre compte en quelques étapes et commencez à transformer votre gestion.';

  @override
  String get leftPanelRegisterHighlight2Title => 'Sécurité Garantie';

  @override
  String get leftPanelRegisterHighlight2Description =>
      'Vos données sont protégées avec les plus hauts standards.';

  @override
  String get leftPanelRegisterHighlight3Title => 'Accès Immédiat';

  @override
  String get leftPanelRegisterHighlight3Description =>
      'Une fois inscrit, explorez toutes les fonctionnalités que Ho-Tech vous offre.';

  @override
  String get leftPanelForgotPasswordTitle => 'Récupérez Votre Accès';

  @override
  String get leftPanelForgotPasswordSubtitle =>
      'Suivez les étapes pour réinitialiser votre mot de passe et gérer à nouveau efficacement vos ressources humaines.';

  @override
  String get leftPanelForgotPasswordHighlight1Title => 'Vérification Sécurisée';

  @override
  String get leftPanelForgotPasswordHighlight1Description =>
      'Entrez votre e-mail pour recevoir un code de vérification et protéger votre compte.';

  @override
  String get leftPanelForgotPasswordHighlight2Title =>
      'Réinitialisation Facile';

  @override
  String get leftPanelForgotPasswordHighlight2Description =>
      'Avec le code OTP, vous pourrez créer un nouveau mot de passe rapidement et en toute sécurité.';

  @override
  String get leftPanelForgotPasswordHighlight3Title => 'Support Continu';

  @override
  String get leftPanelForgotPasswordHighlight3Description =>
      'Si vous avez des problèmes, notre équipe de support est prête à vous aider.';

  @override
  String get forgotPasswordEmailFormLabel => 'Adresse e-mail';

  @override
  String get forgotPasswordEmailFormHint => 'Entrez votre adresse e-mail';

  @override
  String get forgotPasswordEmailFormErrorRequired => 'L\'e-mail est requis';

  @override
  String get forgotPasswordEmailFormErrorInvalid => 'Entrez un e-mail valide';

  @override
  String get forgotPasswordEmailFormSubmitButton =>
      'Envoyer le code de récupération';

  @override
  String get forgotPasswordEmailFormBackToLoginButton =>
      'Retour à la connexion';

  @override
  String get forgotPasswordOtpFormValidatorError =>
      'Le code doit comporter 6 chiffres';

  @override
  String get forgotPasswordOtpFormSubmitButton => 'Vérifier le code';

  @override
  String get forgotPasswordOtpFormDidNotReceiveCode =>
      'Vous n\'avez pas reçu le code ? ';

  @override
  String get forgotPasswordOtpFormResendCodeButton => 'Renvoyer le code';

  @override
  String get forgotPasswordOtpFormEnterDifferentEmailButton =>
      'Saisir un autre e-mail';

  @override
  String get loginFormUsernameLabel => 'Nom d\'utilisateur';

  @override
  String get loginFormUsernameHint => 'Entrez votre nom d\'utilisateur';

  @override
  String get loginFormUsernameErrorRequired =>
      'Le nom d\'utilisateur est requis';

  @override
  String get loginFormPasswordLabel => 'Mot de passe';

  @override
  String get loginFormPasswordHint => 'Entrez votre mot de passe';

  @override
  String get loginFormPasswordErrorRequired => 'Le mot de passe est requis';

  @override
  String get loginFormPasswordErrorMinLength =>
      'Le mot de passe doit comporter au moins 6 caractères';

  @override
  String get loginFormForgotPasswordButton => 'Mot de passe oublié ?';

  @override
  String get loginFormLoginButton => 'Se connecter';

  @override
  String get loginFormLoginWithGoogleButton => 'Se connecter avec Google';

  @override
  String get loginFormNoAccountPrompt => 'Vous n\'avez pas de compte ? ';

  @override
  String get loginFormCreateAccountButton => 'Créer un compte';

  @override
  String get otpFormValidatorError => 'Le code doit comporter 6 chiffres';

  @override
  String get otpFormDefaultSubmitButton => 'Vérifier le code';

  @override
  String get otpFormDidNotReceiveCodePrompt =>
      'Vous n\'avez pas reçu le code ? ';

  @override
  String get otpFormDefaultResendButton => 'Renvoyer le code';

  @override
  String get registerFormFirstNameLabel => 'Prénoms';

  @override
  String get registerFormFirstNameHint => 'Entrez vos prénoms';

  @override
  String get registerFormFirstNameErrorRequired => 'Les prénoms sont requis';

  @override
  String get registerFormPaternalLastNameLabel => 'Nom de famille paternel';

  @override
  String get registerFormPaternalLastNameHint =>
      'Entrez votre nom de famille paternel';

  @override
  String get registerFormPaternalLastNameErrorRequired =>
      'Le nom de famille paternel est requis';

  @override
  String get registerFormMaternalLastNameLabel => 'Nom de famille maternel';

  @override
  String get registerFormMaternalLastNameHint =>
      'Entrez votre nom de famille maternel';

  @override
  String get registerFormMaternalLastNameErrorRequired =>
      'Le nom de famille maternel est requis';

  @override
  String get registerFormEmailLabel => 'E-mail';

  @override
  String get registerFormEmailHint => 'Entrez votre e-mail';

  @override
  String get registerFormEmailErrorRequired => 'L\'e-mail est requis';

  @override
  String get registerFormEmailErrorInvalid => 'Entrez un e-mail valide';

  @override
  String get registerFormPasswordLabel => 'Mot de passe';

  @override
  String get registerFormPasswordHint => 'Entrez votre mot de passe';

  @override
  String get registerFormPasswordErrorRequired => 'Le mot de passe est requis';

  @override
  String get registerFormPasswordErrorMinLength => 'Minimum 8 caractères';

  @override
  String get registerFormPasswordErrorUppercase =>
      'Doit contenir au moins une majuscule';

  @override
  String get registerFormPasswordErrorDigit =>
      'Doit contenir au moins un chiffre';

  @override
  String get registerFormPasswordErrorSpecialChar =>
      'Doit contenir au moins un caractère spécial';

  @override
  String get registerFormConfirmPasswordLabel => 'Confirmer le mot de passe';

  @override
  String get registerFormConfirmPasswordHint => 'Retapez votre mot de passe';

  @override
  String get registerFormConfirmPasswordErrorRequired =>
      'Confirmez votre mot de passe';

  @override
  String get registerFormConfirmPasswordErrorMismatch =>
      'Les mots de passe ne correspondent pas';

  @override
  String get registerFormContinueButton => 'Continuer';

  @override
  String get registerFormCreateAccountWithGoogleButton =>
      'Créer un compte avec Google';

  @override
  String get registerFormAlreadyHaveAccountPrompt =>
      'Vous avez déjà un compte ? ';

  @override
  String get registerFormLoginButton => 'Se connecter';

  @override
  String get loadingMessageDefault => 'Loading...';

  @override
  String get formValidationCompleteCorrectly =>
      'Veuillez remplir correctement le formulaire.';

  @override
  String get googleSignInCancelled =>
      'Connexion avec Google annulée par l\'utilisateur.';

  @override
  String get registerWithGoogleSuccessMessage =>
      'Inscription avec Google réussie ! Connexion en cours...';

  @override
  String get otpVerificationSuccessMessageRegister =>
      'OTP vérifié avec succès. Procédure d\'inscription en cours...';

  @override
  String otpResendSuccessMessage(Object email) {
    return 'Un nouveau code OTP a été envoyé à $email.';
  }

  @override
  String get registrationCompleteMessage =>
      'Inscription terminée ! Connexion en cours...';

  @override
  String get autoLoginFailedMessage => 'Échec de la connexion automatique';

  @override
  String get autoLoginFailedAfterRegisterMessage =>
      'Échec de la connexion après l\'inscription';

  @override
  String get autoLoginFailedAfterGoogleRegisterMessage =>
      'Échec de la connexion avec Google après l\'inscription';

  @override
  String otpVerificationDescriptionForRegistration(Object email) {
    return 'Nous avons envoyé un code de vérification à votre adresse e-mail $email. Veuillez le saisir ci-dessous pour finaliser votre inscription.';
  }

  @override
  String get otpVerificationButtonForRegistration => 'Vérifier et S\'inscrire';

  @override
  String get otpVerificationResendButtonForRegistration => 'Renvoyer le Code';

  @override
  String get emailAlreadyRegisteredError =>
      'Cet e-mail est déjà enregistré. Veuillez essayer de vous connecter ou utiliser une autre adresse e-mail.';

  @override
  String get otpRequestLoadingMessage => 'Demande de l\'OTP en cours...';

  @override
  String get otpVerificationLoadingMessage =>
      'Vérification de l\'OTP en cours...';

  @override
  String get registerLoadingMessage =>
      'Enregistrement de l\'utilisateur en cours...';

  @override
  String get loginLoadingMessage => 'Connexion en cours...';

  @override
  String otpSentSuccessMessage(Object email) {
    return 'OTP envoyé avec succès à $email.';
  }

  @override
  String get errorEmailNotProvidedMessage =>
      'Erreur : Aucune adresse e-mail fournie pour la vérification OTP.';

  @override
  String get otpVerificationSuccessMessage => 'OTP vérifié avec succès !';

  @override
  String get passwordChangeSuccessMessage =>
      'Mot de passe changé avec succès ! Veuillez vous connecter.';

  @override
  String newPasswordFormTitleFor(Object email) {
    return 'Définir un nouveau mot de passe pour $email';
  }

  @override
  String get newPasswordFormNewLabel => 'Nouveau mot de passe';

  @override
  String get newPasswordFormNewHint => 'Entrez votre nouveau mot de passe';

  @override
  String get newPasswordFormNewErrorRequired =>
      'Le nouveau mot de passe est requis';

  @override
  String get newPasswordFormConfirmLabel => 'Confirmer le nouveau mot de passe';

  @override
  String get newPasswordFormConfirmHint =>
      'Confirmez votre nouveau mot de passe';

  @override
  String get newPasswordFormConfirmErrorRequired =>
      'Veuillez confirmer votre nouveau mot de passe';

  @override
  String get newPasswordFormSubmitButton => 'Changer le mot de passe';

  @override
  String get leftPanelSetNewPasswordTitle => 'Sécurisez Votre Compte';

  @override
  String get leftPanelSetNewPasswordSubtitle =>
      'Choisissez un mot de passe fort et unique pour protéger les données de gestion de votre hôtel.';

  @override
  String get leftPanelSetNewPasswordHighlight1Title => 'Mot de Passe Fort';

  @override
  String get leftPanelSetNewPasswordHighlight1Description =>
      'Utilisez un mélange de lettres, de chiffres et de symboles pour une meilleure sécurité.';

  @override
  String get leftPanelSetNewPasswordHighlight2Title =>
      'Évitez la Réutilisation';

  @override
  String get leftPanelSetNewPasswordHighlight2Description =>
      'N\'utilisez pas de mots de passe que vous avez utilisés sur d\'autres sites.';

  @override
  String get leftPanelSetNewPasswordHighlight3Title => 'Confirmation';

  @override
  String get leftPanelSetNewPasswordHighlight3Description =>
      'Assurez-vous que votre nouveau mot de passe est confirmé et enregistré en toute sécurité.';

  @override
  String get setNewPasswordTitle => 'Définir un Nouveau Mot de Passe';

  @override
  String setNewPasswordSubtitle(Object email) {
    return 'Créez un nouveau mot de passe sécurisé pour votre compte associé à $email.';
  }

  @override
  String get forgotPasswordEmailVerificationLoadingMessage =>
      'Vérification de l\'e-mail en cours...';

  @override
  String get forgotPasswordOtpVerificationLoadingMessage =>
      'Vérification de l\'OTP en cours...';

  @override
  String get forgotPasswordChangeLoadingMessage =>
      'Mise à jour du mot de passe en cours...';

  @override
  String get settingsTitle => 'Paramètres';

  @override
  String get settingsSubtitle => 'Gérez vos préférences et paramètres système';

  @override
  String get backButton => 'Retour';

  @override
  String get accountTab => 'Compte';

  @override
  String get appearanceTab => 'Apparence';

  @override
  String get userInfoTitle => 'Informations utilisateur';

  @override
  String get userInfoSubtitle =>
      'Informations de base sur votre compte et vos préférences utilisateur';

  @override
  String get appearanceContentPlaceholder => 'Contenu de l\'apparence ici';

  @override
  String get activeSessionDialogTitle => 'Session Active Détectée';

  @override
  String get activeSessionDialogMessage =>
      'Vous avez déjà une session active sur un autre appareil ou navigateur. Voulez-vous fermer la session précédente et continuer avec la connexion actuelle?';

  @override
  String get keepSessionButtonLabel => 'Conserver la Session';

  @override
  String get closeSessionButtonLabel => 'Fermer la Session Précédente';

  @override
  String get invalidOtpMessage =>
      'Le code que vous avez saisi n’est pas valide. Veuillez vérifier et réessayer.';
}
