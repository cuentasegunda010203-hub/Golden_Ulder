// Copyright 2022-2023 Marlon "Eiss" Lorram. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Dart
import 'dart:async';

// Internal
import 'package:artplay_launcher/bloc/bloc.dart';
import 'package:artplay_launcher/config/app_config.dart';
import 'package:artplay_launcher/services/server_service.dart';
import 'package:artplay_launcher/state/server_state_event.dart';

// Packages
import 'package:logging/logging.dart';
import 'package:rxdart/rxdart.dart';

/// This Bloc provides server information.
///
/// It loads the data once when created and then refreshes it periodically
/// (see [AppConfig.refreshInterval]). The UI can also request a manual
/// refresh with [refresh].
class ServerBloc extends Bloc {
  final log = Logger('ServerBloc');
  final ServerService _serverService;

  /// Subject to manage the state of the server.
  final _serverState =
      BehaviorSubject<ServerState>.seeded(ServerInitial(), sync: true);

  /// Subject to manage server load events.
  final _serverEvent = PublishSubject<ServerEvent>();

  StreamSubscription<ServerEvent>? _eventSubscription;
  Timer? _autoRefresh;
  bool _isFetching = false;

  ServerBloc(
    this._serverService, {
    Duration? refreshInterval = AppConfig.refreshInterval,
  }) {
    _init(refreshInterval);
  }

  void _init(Duration? refreshInterval) {
    /// Listen to servers load events
    _handleServersEvents();

    /// First load
    _serverEvent.add(LoadServersEvent());

    /// Periodic refresh
    if (refreshInterval != null) {
      _autoRefresh = Timer.periodic(
        refreshInterval,
        (_) => _serverEvent.add(RefreshServersEvent()),
      );
    }
  }

  /// Handles server load events.
  /// Depending on the event type, it either fetches server info
  /// or refreshes the servers.
  void _handleServersEvents() {
    _eventSubscription = _serverEvent.listen((ServerEvent event) {
      if (event is LoadServersEvent) {
        _fetchServersInfo();
      } else if (event is RefreshServersEvent) {
        _refreshServers();
      }
    });
  }

  /// Refreshes the servers by re-fetching the server info.
  void _refreshServers() {
    _fetchServersInfo();
  }

  /// Fetches server info.
  /// Updates the server state based on the fetched info.
  Future<void> _fetchServersInfo() async {
    // Avoid overlapping queries (an offline server can take several seconds).
    if (_isFetching) return;
    _isFetching = true;

    _serverState.add(
      ServerLoadInProgress(serverInfos: _serverState.value.serverInfos),
    );

    try {
      final serverInfos = await _serverService.fetchServersInfo();
      if (_serverState.isClosed) return;

      if (serverInfos.isEmpty) {
        _serverState.add(ServerLoadFailure());
      } else {
        _serverState.add(ServerLoadSuccess(serverInfos: serverInfos));
      }
    } catch (e, st) {
      log.warning('Failed to load servers', e, st);
      if (!_serverState.isClosed) {
        _serverState.add(ServerLoadFailure());
      }
    } finally {
      _isFetching = false;
    }
  }

  @override
  void dispose() {
    _autoRefresh?.cancel();
    _eventSubscription?.cancel();
    _serverEvent.close();
    _serverState.close();

    super.dispose();
  }

  /// Stream containing the current state of the server load.
  Stream<ServerState> get stateStream => _serverState.stream;

  /// Latest state (never null: starts as [ServerInitial]).
  ServerState get currentState => _serverState.value;

  /// Function to load servers. Adds a server state to the state subject.
  void Function(ServerEvent) get loadServers => _serverEvent.sink.add;

  /// Asks for a fresh query right now.
  void refresh() => _serverEvent.add(RefreshServersEvent());
}
