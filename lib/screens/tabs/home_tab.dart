import 'dart:async';

import 'package:flutter/material.dart';
import 'package:two_factor_authentication/services/otp_service.dart';
import '../../api/models/otp_token.dart';
import '../../widgets/otp_card.dart';
import '../../widgets/empty_state_widget.dart';

class HomeTab extends StatelessWidget {
  final List<OTPToken> accounts;
  final List<String> pinnedAccountNames;
  final Function(OTPToken) onDelete;
  final Function(OTPToken) onEdit;
  final Function(OTPToken) onPin;
  final Function(OTPToken) onAccountAdded;
  final VoidCallback onAddPressed;

  const HomeTab({
    super.key,
    required this.accounts,
    required this.pinnedAccountNames,
    required this.onDelete,
    required this.onEdit,
    required this.onPin,
    required this.onAddPressed,
    required this.onAccountAdded,
  });

  @override
  Widget build(BuildContext context) {
    return accounts.isEmpty
        ? EmptyStateWidget(onAddPressed: onAddPressed, onAccountAdded: onAccountAdded)
        : RemainingSecondsContainer(
            child: ListView.builder(
              itemCount: accounts.length,
              itemBuilder: (context, index) {
                return OTPCard(
                  account: accounts[index],
                  onDelete: onDelete,
                  onEdit: onEdit,
                  onPin: onPin,
                  isPinned: pinnedAccountNames.contains(accounts[index].name),
                );
              },
            ),
          );
  }
}

class RemainingSecondsContainer extends StatefulWidget {
  final Widget child;

  const RemainingSecondsContainer({super.key, required this.child});

  @override
  State<RemainingSecondsContainer> createState() => _RemainingSecondsContainerState();
}

class _RemainingSecondsContainerState extends State<RemainingSecondsContainer> {
  late Timer _timer;
  late int _remainingSeconds = OTPService.getRemainingSeconds(now: OTPService.getNow());
  late Function update = (int now) {};

  @override
  void initState() {
    super.initState();
    _startTimer();
  }

  @override
  void dispose() {
    _timer.cancel();
    super.dispose();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      setState(() {
        _remainingSeconds--;
        if (_remainingSeconds <= 0) {
          _remainingSeconds = 30;
          update(OTPService.getNow());
        }
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return RemainingSecondsProvider(remainingSeconds: _remainingSeconds, update: update, child: widget.child);
  }
}

class RemainingSecondsProvider extends InheritedWidget {
  final int remainingSeconds;
  final Function update;
  const RemainingSecondsProvider({
    super.key,
    required this.remainingSeconds,
    required this.update,
    required super.child,
  });

  static RemainingSecondsProvider of(BuildContext context) {
    return context.dependOnInheritedWidgetOfExactType<RemainingSecondsProvider>() ??
        RemainingSecondsProvider(
          remainingSeconds: 30,
          update: (int now) {},
          child: const SizedBox(),
        );
  }

  @override
  bool updateShouldNotify(RemainingSecondsProvider oldWidget) {
    return oldWidget.remainingSeconds != remainingSeconds;
  }
}

class RemainingSecondsConsumer<T extends RemainingSecondsProvider> extends StatelessWidget {
  const RemainingSecondsConsumer({
    super.key,
    required this.builder,
  });

  final Widget Function(BuildContext context, T value) builder;

  @override
  Widget build(BuildContext context) {
    return builder(
      context,
      RemainingSecondsProvider.of(context) as T,
    );
  }
}
