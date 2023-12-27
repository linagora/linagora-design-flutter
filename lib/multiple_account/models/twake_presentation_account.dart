import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';

enum AccountActiveStatus {
  active,
  inactive,
}

abstract class TwakePresentationAccount extends Equatable {
  final String accountName;
  final String accountId;
  final AccountActiveStatus accountActiveStatus;
  final Widget avatar;

  const TwakePresentationAccount({
    required this.accountName,
    required this.accountId,
    required this.avatar,
    this.accountActiveStatus = AccountActiveStatus.inactive,
  });

  bool get isActive => accountActiveStatus == AccountActiveStatus.active;

  @override
  List<Object?> get props => [
        accountName,
        accountId,
        avatar,
        accountActiveStatus,
      ];
}
