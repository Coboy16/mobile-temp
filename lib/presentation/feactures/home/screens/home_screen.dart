import 'package:flutter/material.dart';

import 'package:flutter_bloc/flutter_bloc.dart';

import '/presentation/feactures/check_payment/check.dart';
import '/presentation/feactures/request/request.dart';
import '/presentation/widgets/widgets.dart';
import '/presentation/bloc/blocs.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // --- Sidebar a la izquierda ---
          const SidebarWidget(),

          // --- Contenido Principal a la derecha ---
          Expanded(
            child: Column(
              children: [
                const HeaderWidget(),

                // --- Contenido principal ---
                Expanded(
                  child: BlocBuilder<NavegationBarBloc, NavegationBarState>(
                    builder:
                        (context, state) => _getViewNavegation(state.index),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _getViewNavegation(int index) {
    switch (index) {
      case 0:
        return const RequestScreen();
      case 1:
        return const CheckPaymentScreen();
      default:
        return const CheckPaymentScreen(); //NO PAGE - 404
    }
  }
}
