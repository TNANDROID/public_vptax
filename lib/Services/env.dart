import 'package:envied/envied.dart';
part 'env.g.dart';

@Envied()
abstract class Env {

  @EnviedField(varName: 'endPointUrlLocal', defaultValue: '',obfuscate: true)
  static String endPointUrlLocal = _Env.endPointUrlLocal;

  @EnviedField(varName: 'endPointUrlLiveDemo', defaultValue: '',obfuscate: true)
  static String endPointUrlLiveDemo = _Env.endPointUrlLiveDemo;

  @EnviedField(varName: 'endPointUrlLive', defaultValue: '',obfuscate: true)
  static String endPointUrlLive = _Env.endPointUrlLive;

  @EnviedField(varName: 'returnUrlLocal', defaultValue: '',obfuscate: true)
  static String returnUrlLocal = _Env.returnUrlLocal;

  @EnviedField(varName: 'returnUrlLive', defaultValue: '',obfuscate: true)
  static String returnUrlLive = _Env.returnUrlLive;

  @EnviedField(varName: 'modeLocal', defaultValue: '', obfuscate: true)
  static String modeLocal = _Env.modeLocal;

  @EnviedField(varName: 'modeLive', defaultValue: '', obfuscate: true)
  static String modeLive = _Env.modeLive;

  @EnviedField(varName: 'loginURL', defaultValue: '', obfuscate: true)
  static String loginURL = _Env.loginURL;

  @EnviedField(varName: 'mainURL', defaultValue: '', obfuscate: true)
  static String mainURL = _Env.mainURL;

  @EnviedField(varName: 'openURL', defaultValue: '', obfuscate: true)
  static String openURL = _Env.openURL;

  @EnviedField(varName: 'pdfURL', defaultValue: '', obfuscate: true)
  static String pdfURL = _Env.pdfURL;

  @EnviedField(varName: 'userPassKey', defaultValue: '', obfuscate: true)
  static String userPassKey = _Env.userPassKey;

}