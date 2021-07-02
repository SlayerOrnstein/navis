import 'package:flutter_test/flutter_test.dart';
import 'package:navis/core/services/videos.dart';

void main() {
  late VideoService videoService;

  setUp(() {
    videoService = VideoService();
  });

  test('Test video retrivial', () async {
    final video = await videoService.getVideoInformation('dQw4w9WgXcQ');

    expect(video?.url, 'https://www.youtube.com/watch?v=dQw4w9WgXcQ');
  });
}
