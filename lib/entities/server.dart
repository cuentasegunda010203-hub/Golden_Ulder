// Copyright 2022-2023 Marlon "Eiss" Lorram. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// Packages
import 'package:samp_query/samp_query.dart';

/// An object that represents an individual information of a Server.
///
/// Each instance of [ServerInfo] holds data about a specific server, including its hostname, address, gamemode,
/// and player count.
class ServerInfo {
  /// Hostname of the server.
  final String hostname;

  /// Address of the server [ip:port].
  final String address;

  /// Gamemode of the server.
  final String gamemode;

  /// Current amount of players online on the server.
  final int players;

  /// Maximum amount of players that can join the server.
  final int maxPlayers;

  /// Language reported by the server (may be empty).
  final String language;

  /// Whether the server is password protected.
  final bool hasPassword;

  /// Approximate round-trip time of the query in milliseconds.
  final int? pingMs;

  ServerInfo(
    this.hostname,
    this.address,
    this.gamemode,
    this.players,
    this.maxPlayers, {
    this.language = '',
    this.hasPassword = false,
    this.pingMs,
  });

  factory ServerInfo.fromInfo(Info info, {int? pingMs}) {
    return ServerInfo(
      info.hostname,
      info.address,
      info.gamemode,
      info.players,
      info.maxPlayers,
      language: info.language,
      hasPassword: info.password != 0,
      pingMs: pingMs,
    );
  }

  /// Player occupancy from 0.0 to 1.0.
  double get fill => maxPlayers <= 0 ? 0 : (players / maxPlayers).clamp(0.0, 1.0);

  /// Connection quality from 0 (unknown) to 4 (excellent), for the signal bars.
  int get signalLevel {
    final p = pingMs;
    if (p == null) return 0;
    if (p < 60) return 4;
    if (p < 110) return 3;
    if (p < 180) return 2;
    return 1;
  }
}
