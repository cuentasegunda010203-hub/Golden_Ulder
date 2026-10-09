// Copyright 2022-2023 Marlon "Eiss" Lorram. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

import 'package:artplay_launcher/bloc/bloc.dart';
import 'package:rxdart/rxdart.dart';

/// Pages reachable from the side navigation.
enum AppPage { home, servers, management, downloads, settings }

class PagerBloc extends Bloc {
  final BehaviorSubject<AppPage> _currentPage =
      BehaviorSubject<AppPage>.seeded(AppPage.home);

  Stream<AppPage> get pageStream => _currentPage.stream;

  AppPage get currentPage => _currentPage.value;

  void changePage(AppPage page) {
    _currentPage.add(page);
  }

  @override
  void dispose() {
    _currentPage.close();
    super.dispose();
  }
}
