import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';

import '/presentation/bloc/locale_bloc/locale_bloc.dart';

class LanguageSelectorOverlay extends StatefulWidget {
  const LanguageSelectorOverlay({super.key});

  @override
  State<LanguageSelectorOverlay> createState() =>
      _LanguageSelectorOverlayState();
}

class _LanguageSelectorOverlayState extends State<LanguageSelectorOverlay>
    with SingleTickerProviderStateMixin {
  final OverlayPortalController _overlayController = OverlayPortalController();
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  final GlobalKey _buttonKey = GlobalKey();

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 250),
    );
    _slideAnimation = Tween<Offset>(
      begin: const Offset(0.0, 0.3),
      end: Offset.zero,
    ).chain(CurveTween(curve: Curves.easeOut)).animate(_animationController);
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  String _getLanguageName(BuildContext context, Locale locale) {
    final l10n = AppLocalizations.of(context)!;
    switch (locale.languageCode) {
      case 'en':
        return l10n.languageEnglish;
      case 'es':
        return l10n.languageSpanish;
      case 'fr':
        return l10n.languageFrench;
      default:
        return locale.languageCode;
    }
  }

  void _toggleOverlay() {
    if (_overlayController.isShowing) {
      _animationController.reverse().then((_) {
        _overlayController.hide();
      });
    } else {
      context.findRenderObject();
      _overlayController.show();
      _animationController.forward();
    }
  }

  @override
  Widget build(BuildContext context) {
    final localeBloc = BlocProvider.of<LocaleBloc>(context, listen: false);
    final currentLocale = context.select(
      (LocaleBloc bloc) =>
          bloc.state.locale ?? LocaleBloc.supportedLocales.first,
    );

    return OverlayPortal(
      controller: _overlayController,
      overlayChildBuilder: (BuildContext overlayContext) {
        final RenderBox buttonRenderBox =
            _buttonKey.currentContext?.findRenderObject() as RenderBox;
        final buttonPosition = buttonRenderBox.localToGlobal(Offset.zero);
        final buttonSize = buttonRenderBox.size;

        return Stack(
          children: [
            Positioned.fill(
              child: GestureDetector(
                onTap: _toggleOverlay,
                child: Container(color: Colors.transparent),
              ),
            ),
            Positioned(
              top: buttonPosition.dy + buttonSize.height + 5,
              left: buttonPosition.dx,
              width: 180,
              child: FadeTransition(
                opacity: _animationController,
                child: SlideTransition(
                  position: _slideAnimation,
                  child: Material(
                    elevation: 4.0,
                    borderRadius: BorderRadius.circular(8.0),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(vertical: 8.0),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children:
                            AppLocalizations.supportedLocales.map((locale) {
                              final bool isSelected = locale == currentLocale;
                              return InkWell(
                                onTap: () {
                                  if (!isSelected) {
                                    localeBloc.add(ChangeLocale(locale));
                                  }
                                  _toggleOverlay();
                                },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                    horizontal: 16.0,
                                    vertical: 10.0,
                                  ),
                                  child: Row(
                                    children: [
                                      Expanded(
                                        child: Text(
                                          _getLanguageName(context, locale),
                                          style: TextStyle(
                                            fontWeight:
                                                isSelected
                                                    ? FontWeight.bold
                                                    : FontWeight.normal,
                                            color:
                                                isSelected
                                                    ? Theme.of(
                                                      context,
                                                    ).colorScheme.primary
                                                    : null,
                                          ),
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                      if (isSelected)
                                        Icon(
                                          Icons.check,
                                          size: 18.0,
                                          color:
                                              Theme.of(
                                                context,
                                              ).colorScheme.primary,
                                        )
                                      else
                                        const SizedBox(width: 18.0),
                                    ],
                                  ),
                                ),
                              );
                            }).toList(),
                      ),
                    ),
                  ),
                ),
              ),
            ),
          ],
        );
      },
      child: Material(
        key: _buttonKey,
        color: Colors.transparent,
        child: InkWell(
          onTap: _toggleOverlay,
          borderRadius: BorderRadius.circular(8.0),
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 12.0,
              vertical: 8.0,
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(currentLocale.languageCode.toUpperCase()),
                const SizedBox(width: 4.0),
                const Icon(Icons.arrow_drop_down, size: 20.0),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
