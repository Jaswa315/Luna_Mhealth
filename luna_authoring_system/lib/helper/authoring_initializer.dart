import 'package:flutter/material.dart';
import 'package:global_configuration/global_configuration.dart';
import 'package:luna_core/utils/logging.dart';
import 'package:luna_core/utils/version_manager.dart' as vm;

/// Class to provide helper methods to inialize the Luna authoring system
class AuthoringInitializer {

  /// Setup method for the Luna Authoring System
  /// Sets up singletons such as version manager and logmanager
  /// Initializes the app and loads configuration
  static initialzieAuthoring() async{
    WidgetsFlutterBinding.ensureInitialized();
    
    await GlobalConfiguration().loadFromAsset("app_settings");
    // initialize log manager
    await LogManager.createInstance();
    // initialize Version manager
    vm.VersionManager().setVersion();

  }

}