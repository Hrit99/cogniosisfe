import 'package:cogniosis/listing_widget.dart';
import 'package:flutter/material.dart';

class Video {
  final Duration duration;
  final String url;

  Video({
    required this.duration,
    required this.url,
  });
}

class VideoContent {
  final String title;
  final String author;
  final String image;
  final List<Video> videos;

  VideoContent({
    required this.title,
    required this.author,
    required this.image,
    required this.videos,
  });
}

class VideoProvider with ChangeNotifier {
  final List<VideoContent> _videos = [
    VideoContent(
      title: 'Meditation Session',
      author: 'Jane Doe',
      image: 'assets/nebula.jpeg',
      videos: [
        Video(duration: Duration(minutes: 20), url: 'https://example.com/video1.mp4'),
        Video(duration: Duration(minutes: 30), url: 'https://example.com/video2.mp4'),
      ],
    ),
    VideoContent(
      title: 'Yoga for Beginners',
      author: 'John Smith',
      image: 'assets/nebula.jpeg',
      videos: [
        Video(duration: Duration(minutes: 15), url: 'https://example.com/video3.mp4'),
        Video(duration: Duration(minutes: 25), url: 'https://example.com/video4.mp4'),
      ],
    ),
    VideoContent(
      title: 'Advanced Yoga',
      author: 'Emily Johnson',
      image: 'assets/nebula.jpeg',
      videos: [
        Video(duration: Duration(minutes: 40), url: 'https://example.com/video5.mp4'),
        Video(duration: Duration(minutes: 50), url: 'https://example.com/video6.mp4'),
      ],
    ),
    // Add more video content as needed
  ];

  List<MediaItem> getVideos() {
    return _videos.map((videoContent) => MediaItem(
      image: videoContent.image,
      title: videoContent.title,
      duration: videoContent.videos.first.duration.toString(),
      author: videoContent.author,
    )).toList();
  }
}
