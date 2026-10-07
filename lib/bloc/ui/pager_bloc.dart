// Copyright 2022-2023 Marlon "Eiss" Lorram. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:artplay_launcher/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Pages reachable from the side navigation.
///
/// Using an enum (instead of raw int indexes) avoids the index mismatch the
/// previous version had between the nav bar and the page switch.
enum AppPage { home, servers, settings }

// This BLoC manages the logic related to page navigation.
class PagerBloc extends Bloc {
  final BehaviorSubject<AppPage> _currentPage =
      BehaviorSubject<AppPage>.seeded(AppPage.home);

  Stream<AppPage> get pageStream => _currentPage.stream;

  AppPage get currentPage => _currentPage.value;

  /// Method to change the current page.
  void changePage(AppPage page) {
    _currentPage.add(page);
  }

  @override
  void dispose() {
    _currentPage.close();
    super.dispose();
  }
}
