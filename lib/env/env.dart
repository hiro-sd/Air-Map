import 'package:envied/envied.dart';

part 'env.g.dart';

@Envied(path: '.env')
abstract class Env {
  @EnviedField(varName: 'KEY', obfuscate: true)
  static String key = _Env.key;

  @EnviedField(varName: 'AMADEUS_API_KEY', obfuscate: true)
  static String amadeusApiKey = _Env.amadeusApiKey;

  @EnviedField(varName: 'AMADEUS_API_SECRET', obfuscate: true)
  static String amadeusApiSecret = _Env.amadeusApiSecret;
}
