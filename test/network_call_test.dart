import 'package:demo/helpers/http_service.dart';
import 'package:flutter_test/flutter_test.dart';

main() {
  test('return no city found error', () async {
    final result = await HttpService.getRequest(
        apiKey: '5cec6ddcf992b47d01c3c33559e54a2e', city: 'Londo');
    expect(result['message'], 'city not found');
  });
  test('return London Weather', () async {
    final result = await HttpService.getRequest(
        apiKey: '5cec6ddcf992b47d01c3c33559e54a2e', city: 'London');
    expect(result['name'], 'London');
  });
  test('wrong api key error ', () async {
    final result = await HttpService.getRequest(
        apiKey: '5cec6ddcf992b47d01c3c33559e54a2es', city: 'London');
    expect(result['message'],
        'Invalid API key. Please see http://openweathermap.org/faq#error401 for more info.');
  });
}
