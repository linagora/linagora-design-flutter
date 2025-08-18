class CozyConfigManager {
  static final CozyConfigManager _instance = CozyConfigManager._internal();
  factory CozyConfigManager() => _instance;
  CozyConfigManager._internal();

  Future<void> injectCozyScript(String cozyBridgeVersion) =>
      throw UnimplementedError();
  Future<bool> get isInsideCozy => throw UnimplementedError();
  Future<void> initialize() => throw UnimplementedError();
}
