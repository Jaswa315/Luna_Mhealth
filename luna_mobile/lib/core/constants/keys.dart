/// A class that contains keys for different fields in the mobile app
/// Recommending for using patrol
/// https://patrol.leancode.co/effective-patrol
// ignore_for_file: public_member_api_docs
import 'package:flutter/foundation.dart';

class Keys {
  const Keys();

  static const startLearningTitle = Key('startLearningTitle'); // the title of the start learning page
  static const startLearningButton = Key('startLearningButton'); // the button on the home page to start learning
  static const startLearningBackButton = Key('startLearningBackButton'); // back button in the start learning page
  static const backContextButton = Key('backContextButton'); // back button in a module 
  static const homeSettingsButton = Key('homeSettingsButton'); // settings button on home page
}