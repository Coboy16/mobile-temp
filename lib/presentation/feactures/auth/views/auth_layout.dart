import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:responsive_framework/responsive_framework.dart';

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

  bool _isAuthRelatedView(AuthView view) {
    return view == AuthView.login ||
        view == AuthView.forgotPasswordEmail ||
        view == AuthView.forgotPasswordOtp ||
        view == AuthView.setNewPassword;
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
      case AuthView.setNewPassword:
        return l10n.setNewPasswordTitle;
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
      case AuthView.setNewPassword:
        return l10n.setNewPasswordSubtitle(email ?? l10n.yourEmailFallback);
    }
  }

  double _getDesktopCardMaxHeight(AuthView view) {
    switch (view) {
      case AuthView.login:
        return 650;
      case AuthView.register:
        return 780;
      case AuthView.forgotPasswordEmail:
        return 600;
      case AuthView.forgotPasswordOtp:
        return 620;
      case AuthView.setNewPassword:
        return 650;
    }
  }

  @override
  Widget build(BuildContext context) {
    final l10n = AppLocalizations.of(context)!;
    final responsive = ResponsiveBreakpoints.of(context);

    final title = _getTitle(context, authView);
    final subtitle = _getSubtitle(context, authView, emailForOtp);
    final bool isDesktop = responsive.isDesktop;

    Widget mainVisualContent = LayoutBuilder(
      builder: (context, constraints) {
        Widget cardSection = Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ResponsiveVisibility(
                visible: !isDesktop,
                child: _buildMobileHeaderIcon(context, authView),
              ),
              _buildMainCard(context, title, subtitle, responsive),
            ],
          ),
        );

        if (!isDesktop) {
          return SingleChildScrollView(
            physics: const ClampingScrollPhysics(),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight: constraints.maxHeight,
                minWidth: constraints.maxWidth,
              ),
              child: cardSection,
            ),
          );
        }
        return cardSection;
      },
    );

    return Scaffold(
      backgroundColor:
          isDesktop
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
          BlocListener<ForgotPasswordBloc, ForgotPasswordState>(
            listener: (context, state) {},
          ),
        ],
        child: Stack(
          children: [
            mainVisualContent,
            Align(
              alignment: Alignment.topRight,
              child: Padding(
                padding: const EdgeInsets.only(top: 16.0, right: 16.0),
                child: SafeArea(child: LanguageSelectorOverlay()),
              ),
            ),
            BlocBuilder<AuthBloc, AuthState>(
              builder: (context, authState) {
                final currentAuthBlocState = context.watch<AuthBloc>().state;
                final googleState = context.watch<AuthGoogleBloc>().state;
                final checkLockStatusState =
                    context.watch<CheckLockStatusBloc>().state;
                final registerBlocState = context.watch<RegisterBloc>().state;
                final googleIdTokenBlocState =
                    context.watch<GoogleIdTokenBloc>().state;
                final otpVerificationState =
                    context.watch<OtpVerificationBloc>().state;
                final forgotPasswordState =
                    context.watch<ForgotPasswordBloc>().state;

                final bool isLoading =
                    currentAuthBlocState is AuthLoading ||
                    currentAuthBlocState is AuthValidationInProgress ||
                    googleState is AuthGoogleLoading ||
                    checkLockStatusState is CheckLockStatusLoading ||
                    registerBlocState is RegisterLoading ||
                    googleIdTokenBlocState is GoogleIdTokenLoading ||
                    otpVerificationState is OtpRequestInProgress ||
                    otpVerificationState is OtpVerifyInProgress ||
                    forgotPasswordState
                        is ForgotPasswordEmailVerificationInProgress ||
                    forgotPasswordState
                        is ForgotPasswordOtpVerificationInProgress ||
                    forgotPasswordState is ForgotPasswordChangeInProgress;

                if (isLoading) {
                  String loadingMessage = l10n.loadingMessageDefault;
                  // Determinar el mensaje de carga específico
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
                  } else if (forgotPasswordState
                      is ForgotPasswordEmailVerificationInProgress) {
                    // CORREGIDO
                    loadingMessage =
                        l10n.forgotPasswordEmailVerificationLoadingMessage;
                  } else if (forgotPasswordState
                      is ForgotPasswordOtpVerificationInProgress) {
                    // CORREGIDO
                    loadingMessage =
                        l10n.forgotPasswordOtpVerificationLoadingMessage;
                  } else if (forgotPasswordState
                      is ForgotPasswordChangeInProgress) {
                    // CORREGIDO
                    loadingMessage = l10n.forgotPasswordChangeLoadingMessage;
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
    String title,
    String subtitle,
    ResponsiveBreakpointsData responsive,
  ) {
    final double desktopCardMaxHeight = _getDesktopCardMaxHeight(authView);
    final bool isDesktop = responsive.isDesktop;

    int leftPanelFlex = 3;
    int rightPanelFlex = 2;
    if (isDesktop) {
      if (authView == AuthView.register) {
        leftPanelFlex = 2;
        rightPanelFlex = 3;
      }
    }

    return ConstrainedBox(
      constraints: BoxConstraints(
        maxWidth: 1200,
        maxHeight: isDesktop ? desktopCardMaxHeight : double.infinity,
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
              ResponsiveVisibility(
                visible: isDesktop,
                child: Expanded(
                  flex: leftPanelFlex,
                  child: LeftPanel(authView: authView),
                ),
              ),
              _buildRightPanel(
                context,
                title,
                subtitle,
                responsive,
                rightPanelFlex,
                desktopCardMaxHeight,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildRightPanel(
    BuildContext context,
    String title,
    String subtitle,
    ResponsiveBreakpointsData responsive,
    int flex,
    double desktopCardMaxHeight,
  ) {
    final l10n = AppLocalizations.of(context)!;
    final bool isDesktop = responsive.isDesktop;

    return Expanded(
      flex: isDesktop ? flex : 1,
      child: ConstrainedBox(
        constraints: BoxConstraints(
          maxWidth: 1200,
          maxHeight: isDesktop ? desktopCardMaxHeight : double.infinity,
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
            horizontal:
                ResponsiveValue<double>(
                  context,
                  defaultValue: AppDimensions.panelPadding * 1.5,
                  conditionalValues: [
                    Condition.equals(name: MOBILE, value: 20.0),
                  ],
                ).value,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment:
                ResponsiveValue<MainAxisAlignment>(
                  context,
                  defaultValue: MainAxisAlignment.center,
                  conditionalValues: [
                    Condition.equals(
                      name: MOBILE,
                      value: MainAxisAlignment.center,
                    ),
                  ],
                ).value,
            mainAxisSize:
                ResponsiveValue<MainAxisSize>(
                  context,
                  defaultValue: MainAxisSize.max,
                  conditionalValues: [
                    Condition.equals(name: MOBILE, value: MainAxisSize.min),
                  ],
                ).value,
            children: [
              if (!isDesktop &&
                  (authView == AuthView.register ||
                      authView == AuthView.forgotPasswordOtp ||
                      authView == AuthView.setNewPassword ||
                      authView == AuthView.forgotPasswordEmail))
                const SizedBox(height: AppDimensions.itemSpacing),
              if (!isDesktop && authView == AuthView.login)
                const SizedBox(height: 20),

              Text(
                title,
                style: TextStyle(
                  color: Theme.of(context).colorScheme.onSurface,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                ),
              ),
              SizedBox(
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: AppDimensions.itemSpacing * 0.2,
                      conditionalValues: [
                        Condition.equals(name: MOBILE, value: 4.0),
                      ],
                    ).value,
              ),
              Text(
                subtitle,
                style: const TextStyle(
                  color: AppColors.greyTextColor,
                  fontSize: 16,
                ),
              ),
              SizedBox(
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: AppDimensions.largeSpacing * 0.7,
                      conditionalValues: [
                        Condition.equals(
                          name: MOBILE,
                          value:
                              (authView == AuthView.login ||
                                      authView == AuthView.forgotPasswordEmail)
                                  ? AppDimensions.itemSpacing * 1.0
                                  : AppDimensions.largeSpacing - 15,
                        ),
                      ],
                    ).value,
              ),
              rightPanelContent,
              SizedBox(
                height:
                    ResponsiveValue<double>(
                      context,
                      defaultValue: AppDimensions.largeSpacing * 1.2, // Desktop
                      conditionalValues: [
                        Condition.equals(name: MOBILE, value: 0),
                      ],
                    ).value,
              ),
              if (!(!isDesktop && authView == AuthView.register))
                Padding(
                  padding: EdgeInsets.only(
                    top:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: 0,
                          conditionalValues: [
                            Condition.equals(
                              name: MOBILE,
                              value:
                                  (authView != AuthView.register &&
                                          authView !=
                                              AuthView
                                                  .setNewPassword) // CORREGIDO
                                      ? AppDimensions.itemSpacing
                                      : 0,
                            ),
                          ],
                        ).value,
                    bottom:
                        ResponsiveValue<double>(
                          context,
                          defaultValue: 0,
                          conditionalValues: [
                            Condition.equals(
                              name: MOBILE,
                              value:
                                  (authView != AuthView.register &&
                                          authView != AuthView.setNewPassword)
                                      ? 25
                                      : 0, // CORREGIDO
                            ),
                          ],
                        ).value,
                  ),
                  child: Align(
                    alignment: Alignment.center,
                    child: Text(
                      l10n.copyrightNotice(DateTime.now().year),
                      style: const TextStyle(
                        color: AppColors.greyTextColor,
                        fontSize: 12,
                      ),
                    ),
                  ),
                ),
              if (!isDesktop && authView == AuthView.register)
                const SizedBox(height: 10),
            ],
          ),
        ),
      ),
    );
  }
}
