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
  final String description;
  bool isFavourite;

  VideoContent({
    required this.title,
    required this.author,
    required this.image,
    required this.videos,
    required this.isFavourite,
    required this.description,
  });
}



class VideoProvider with ChangeNotifier {
  final List<VideoContent> _videos = [
    VideoContent(
      title: 'Ethereal Awakening',
      author: 'Christopher Lloyd-Clarke',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Relax+Ethereal+Awakening.png',
      isFavourite: false,
      videos: [
        Video(duration: Duration(minutes: 4, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Ethereal-Awakening.mp4'),
        Video(duration: Duration(minutes: 4, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Ethereal-Awakening.mp4'),
        Video(duration: Duration(minutes: 4, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Ethereal-Awakening.mp4'),
        Video(duration: Duration(minutes: 4, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Ethereal-Awakening.mp4'),
        Video(duration: Duration(minutes: 4, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Ethereal-Awakening.mp4'),
      ],
      description: 'This is a relaxation session',
    ),
    VideoContent(
      title: 'Into The Light',
      author: 'Christopher Lloyd-Clarke',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+Relax+-+into+the+light.png',
      isFavourite: false,
      videos: [
        Video(duration: Duration(hours: 1, minutes: 3), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Light+-+Delta.mp4'),
        Video(duration: Duration(hours: 1, minutes: 3), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Into+The+Light+-+Quiet+Seas+Edition+-+Delta.mp4'),
      ],
      description: 'This is a relaxation session',
    ),

    VideoContent(
      title: 'Letting Go',
      author: 'Christopher Lloyd-Clarke',
      image: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/meditation_images/Calm+relax+-+Letting+go.png',
      isFavourite: false,
      videos: [
        Video(duration: Duration(hours: 1, minutes: 2, seconds: 20), url: 'https://aizenstorage.s3.us-east-1.amazonaws.com/cogniosis/mediation/Letting+Go+(Delta).mp4'),
      ],
      description: 'This is a relaxation session',
    ),
    // Add more video content as needed
  ];

  void toggleFavourite(VideoContent videoContent) {
    videoContent.isFavourite = !videoContent.isFavourite;
    notifyListeners();
  }

  List<MediaItem> getVideos() {
    return _videos
        .map((videoContent) => MediaItem(
              image: videoContent.image,
              title: videoContent.title,
              duration:
                  '${videoContent.videos.first.duration.inHours}h ${videoContent.videos.first.duration.inMinutes.remainder(60)}m',
              author: videoContent.author,
              description: videoContent.description,
              isFavourite: videoContent.isFavourite,
              mediaUrls: videoContent.videos.map((video) => video.url).toList(),
              onFavouritePressed: (mediaItem) {
                toggleFavourite(videoContent);
              },
            ))
        .toList();
  }
}
