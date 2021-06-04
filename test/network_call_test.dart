import 'package:demo/helpers/http_service.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  String _api = '';
  test('return no city found error', () async {
    final result = await HttpService.getRequest(apiKey: _api, city: 'Londo');
    expect(result['message'], 'city not found');
  });
  test('return London Weather', () async {
    final result = await HttpService.getRequest(apiKey: _api, city: 'London');
    expect(result['name'], 'London');
  });
  test('wrong api key error ', () async {
    final result = await HttpService.getRequest(apiKey: _api, city: 'London');
    expect(result['message'],
        'Invalid API key. Please see http://openweathermap.org/faq#error401 for more info.');
  });
}
