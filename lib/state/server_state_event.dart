// Copyright 2022-2023 Marlon "Eiss" Lorram. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Internal
import 'package:artplay_launcher/entities/server.dart';

/// Events
abstract class ServerEvent {}

class LoadServersEvent extends ServerEvent {}

class RefreshServersEvent extends ServerEvent {}

/// State
///
/// [serverInfos] may carry the last known data while a refresh is running,
/// so the UI does not flicker back to an empty screen.
abstract class ServerState {
  final List<ServerInfo>? serverInfos;

  ServerState({this.serverInfos});
}

/// Nothing has been requested yet.
class ServerInitial extends ServerState {
  ServerInitial({super.serverInfos});
}

class ServerLoadInProgress extends ServerState {
  ServerLoadInProgress({super.serverInfos});
}

class ServerLoadSuccess extends ServerState {
  ServerLoadSuccess({required List<ServerInfo> serverInfos})
      : super(serverInfos: serverInfos);
}

/// The server did not answer (offline, wrong address, no network...).
class ServerLoadFailure extends ServerState {
  ServerLoadFailure({super.serverInfos});
}

/// Simplified status used by the UI.
enum ServerStatus { connecting, online, offline }

extension ServerStateX on ServerState {
  /// First (main) server, if any data is available.
  ServerInfo? get primary {
    final list = serverInfos;
    return (list == null || list.isEmpty) ? null : list.first;
  }

  bool get isLoading => this is ServerLoadInProgress || this is ServerInitial;

  ServerStatus get status {
    if (this is ServerLoadSuccess) return ServerStatus.online;
    if (this is ServerLoadFailure) return ServerStatus.offline;
    // Refreshing with previous data -> still considered online.
    return primary != null ? ServerStatus.online : ServerStatus.connecting;
  }
}
