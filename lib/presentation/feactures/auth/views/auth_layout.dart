import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/presentation/bloc/blocs.dart';
import '/presentation/feactures/auth/widgets/widgets.dart';
import '/presentation/resources/resources.dart';
import '/presentation/routes/app_router.dart';
import '/presentation/widgets/widgets.dart';

class AuthLayout extends StatelessWidget {
  final AuthView authView;
  final Widget rightPanelContent;
  final String? emailForOtp;

  const AuthLayout({
    super.key,
    required this.authView,
    required this.rightPanelContent,
    this.emailForOtp,
  });

  _LayoutDimensions _getLayoutDimensions(
    BoxConstraints constraints,
    AuthView view,
  ) {
    bool showLeftPanel = constraints.maxWidth > 800;
    int leftPanelFlex = 3;
    int rightPanelFlex = 2;
    double cardMaxHeight = 650;
    double rightPanelMobileHeightFactor = 0.6;

    if (showLeftPanel) {
      if (view == AuthView.register) {
        leftPanelFlex = 2;
        rightPanelFlex = 3;
      }
    }

    switch (view) {
      case AuthView.login:
        cardMaxHeight = 650;
        rightPanelMobileHeightFactor = 0.6;
        break;
      case AuthView.register:
        cardMaxHeight = 780;
        rightPanelMobileHeightFactor = 0.68;
        break;
      case AuthView.forgotPasswordEmail:
        cardMaxHeight = 600;
        rightPanelMobileHeightFactor = 0.55;
        break;
      case AuthView.forgotPasswordOtp:
        cardMaxHeight = 620;
        rightPanelMobileHeightFactor = 0.6;
        break;
    }

    double rightPanelMobileMaxHeight =
        constraints.maxHeight * rightPanelMobileHeightFactor;

    if (view == AuthView.register && !showLeftPanel) {
      rightPanelMobileMaxHeight = 620;
    } else if (_isAuthRelatedView(view) && !showLeftPanel) {
      rightPanelMobileMaxHeight = 550;
    }

    return _LayoutDimensions(
      showLeftPanel: showLeftPanel,
      leftPanelFlex: leftPanelFlex,
      rightPanelFlex: rightPanelFlex,
      cardMaxHeight: cardMaxHeight,
      rightPanelMobileMaxHeight: rightPanelMobileMaxHeight,
    );
  }

  bool _isAuthRelatedView(AuthView view) {
    return view == AuthView.login ||
        view == AuthView.forgotPasswordEmail ||
        view == AuthView.forgotPasswordOtp;
  }

  double _getIconSize(AuthView view) {
    return _isAuthRelatedView(view) ? 32 : 28;
  }

  double _getIconContainerSize(AuthView view) {
    return _isAuthRelatedView(view) ? 100 : 80;
  }

  String _getTitle(BuildContext context, AuthView view) {
    final l10n = AppLocalizations.of(context)!;
    switch (view) {
      case AuthView.login:
        return l10n.loginTitle;
      case AuthView.register:
        return l10n.registerTitle;
      case AuthView.forgotPasswordEmail:
        return l10n.forgotPasswordEmailTitle;
      case AuthView.forgotPasswordOtp:
        return l10n.forgotPasswordOtpTitle;
    }
  }

  String _getSubtitle(BuildContext context, AuthView view, String? email) {
    final l10n = AppLocalizations.of(context)!;
    switch (view) {
      case AuthView.login:
        return l10n.loginSubtitle;
      case AuthView.register:
        return l10n.registerSubtitle;
      case AuthView.forgotPasswordEmail:
        return l10n.forgotPasswordEmailSubtitle;
      case AuthView.forgotPasswordOtp:
        return l10n.forgotPasswordOtpSubtitle(email ?? l10n.yourEmailFallback);
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    return LayoutBuilder(
      builder: (context, constraints) {
        final dimensions = _getLayoutDimensions(constraints, authView);
        final isMobile = !dimensions.showLeftPanel;
        final title = _getTitle(context, authView);
        final subtitle = _getSubtitle(context, authView, emailForOtp);

        return Scaffold(
          backgroundColor:
              dimensions.showLeftPanel
                  ? Theme.of(context).colorScheme.onPrimaryContainer
                  : AppColors.primaryBlue,
          body: MultiBlocListener(
            listeners: [
              BlocListener<AuthBloc, AuthState>(listener: (context, state) {}),
              BlocListener<AuthGoogleBloc, AuthGoogleState>(
                listener: (context, state) {},
              ),
              BlocListener<RegisterBloc, RegisterState>(
                listener: (context, state) {},
              ),
              BlocListener<GoogleIdTokenBloc, GoogleIdTokenState>(
                listener: (context, state) {},
              ),
              BlocListener<OtpVerificationBloc, OtpVerificationState>(
                listener: (context, state) {},
              ),
            ],
            child: Stack(
              children: [
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if (isMobile) _buildMobileHeaderIcon(context, authView),
                      _buildMainCard(
                        context,
                        dimensions,
                        isMobile,
                        title,
                        subtitle,
                      ),
                    ],
                  ),
                ),
                Align(
                  alignment: Alignment.topRight,
                  child: Padding(
                    padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                    child: SafeArea(child: LanguageSelectorOverlay()),
                  ),
                ),
                BlocBuilder<AuthBloc, AuthState>(
                  builder: (context, authState) {
                    final currentAuthBlocState =
                        context.watch<AuthBloc>().state;
                    final googleState = context.watch<AuthGoogleBloc>().state;
                    final checkLockStatusState =
                        context.watch<CheckLockStatusBloc>().state;
                    final registerBlocState =
                        context.watch<RegisterBloc>().state;
                    final googleIdTokenBlocState =
                        context.watch<GoogleIdTokenBloc>().state;
                    final otpVerificationState =
                        context.watch<OtpVerificationBloc>().state;

                    final bool isLoading =
                        currentAuthBlocState is AuthLoading ||
                        currentAuthBlocState is AuthValidationInProgress ||
                        googleState is AuthGoogleLoading ||
                        checkLockStatusState is CheckLockStatusLoading ||
                        registerBlocState is RegisterLoading ||
                        googleIdTokenBlocState is GoogleIdTokenLoading ||
                        otpVerificationState is OtpRequestInProgress ||
                        otpVerificationState is OtpVerifyInProgress;

                    if (isLoading) {
                      String loadingMessage = l10n.loadingMessageDefault;
                      if (otpVerificationState is OtpRequestInProgress) {
                        loadingMessage = l10n.otpRequestLoadingMessage;
                      } else if (otpVerificationState is OtpVerifyInProgress) {
                        loadingMessage = l10n.otpVerificationLoadingMessage;
                      } else if (registerBlocState is RegisterLoading) {
                        loadingMessage = l10n.registerLoadingMessage;
                      } else if (currentAuthBlocState is AuthLoading &&
                          (ModalRoute.of(context)?.settings.name ==
                                  AppRoutes.login ||
                              ModalRoute.of(context)?.settings.name ==
                                  AppRoutes.registerOtp)) {
                        loadingMessage = l10n.loginLoadingMessage;
                      }

                      return CustomLoadingHotech(
                        overlay: true,
                        message: loadingMessage,
                      );
                    }
                    return const SizedBox.shrink();
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  Widget _buildMobileHeaderIcon(BuildContext context, AuthView view) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppDimensions.largeSpacing),
      child: IconCenterWidget(
        size: _getIconContainerSize(view),
        iconSize: _getIconSize(view),
        iconDarkMode: true,
        iconCenterDarkMode:
            MediaQuery.of(context).platformBrightness == Brightness.dark,
      ),
    );
  }

  Widget _buildMainCard(
    BuildContext context,
    _LayoutDimensions dimensions,
    bool isMobile,
    String title,
    String subtitle,
  ) {
    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 1200,
        maxHeight: dimensions.cardMaxHeight,
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: AppDimensions.screenPadding,
        ),
        child: Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(AppDimensions.borderRadius),
          ),
          clipBehavior: Clip.antiAlias,
          child: Row(
            children: [
              if (dimensions.showLeftPanel)
                Expanded(
                  flex: dimensions.leftPanelFlex,
                  child: LeftPanel(authView: authView),
                ),
              _buildRightPanel(context, dimensions, isMobile, title, subtitle),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel(
    BuildContext context,
    _LayoutDimensions dimensions,
    bool isMobile,
    String title,
    String subtitle,
  ) {
    final l10n = AppLocalizations.of(context)!;
    return Expanded(
      flex: dimensions.showLeftPanel ? dimensions.rightPanelFlex : 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1200,
          maxHeight:
              dimensions.showLeftPanel
                  ? dimensions.cardMaxHeight
                  : dimensions.rightPanelMobileMaxHeight,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Theme.of(context).scaffoldBackgroundColor,
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.05),
                blurRadius: 12,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          padding: EdgeInsets.symmetric(
            horizontal: !isMobile ? AppDimensions.panelPadding * 1.5 : 20,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            mainAxisSize: isMobile ? MainAxisSize.min : MainAxisSize.max,
            children: [
              if (isMobile &&
                  (authView == AuthView.register ||
                      authView == AuthView.forgotPasswordOtp ||
                      authView == AuthView.forgotPasswordEmail))
                const SizedBox(height: AppDimensions.itemSpacing),
              isMobile && authView == AuthView.login
                  ? const SizedBox(height: 20)
                  : const SizedBox(height: 0),
              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(height: !isMobile ? AppDimensions.itemSpacing / 2 : 4),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.greyTextColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height:
                    !isMobile
                        ? AppDimensions.largeSpacing * 1.2
                        : (isMobile &&
                                (authView == AuthView.login ||
                                    authView == AuthView.forgotPasswordEmail)
                            ? AppDimensions.itemSpacing * 1
                            : AppDimensions.largeSpacing - 15),
              ),
              rightPanelContent,
              SizedBox(height: isMobile ? 0 : AppDimensions.largeSpacing * 1.2),
              if (!(isMobile && authView == AuthView.register))
                Align(
                  alignment: Alignment.center,
                  child: Padding(
                    padding: EdgeInsets.only(
                      bottom:
                          (isMobile && authView != AuthView.register) ? 25 : 0,
                    ),
                    child: Text(
                      l10n.copyrightNotice(DateTime.now().year),
                      style: const TextStyle(
                        color: AppColors.greyTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              if (isMobile && authView == AuthView.register)
                const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}

class _LayoutDimensions {
  final bool showLeftPanel;
  final int leftPanelFlex;
  final int rightPanelFlex;
  final double cardMaxHeight;
  final double rightPanelMobileMaxHeight;

  _LayoutDimensions({
    required this.showLeftPanel,
    required this.leftPanelFlex,
    required this.rightPanelFlex,
    required this.cardMaxHeight,
    required this.rightPanelMobileMaxHeight,
  });
}
