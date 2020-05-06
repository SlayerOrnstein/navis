import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:navis/utils/helper_utils.dart';
import 'package:worldstate_api_model/entities.dart';

class NewsWidget extends StatelessWidget {
  const NewsWidget({@required this.news});

  final OrbiterNews news;

  Widget _imageBuilder(BuildContext context, ImageProvider imageProvider) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: <Widget>[
        Expanded(
          child: Container(
            decoration: BoxDecoration(
              image: DecorationImage(image: imageProvider, fit: BoxFit.cover),
            ),
          ),
        )
      ],
    );
  }

  Widget _placeholder(BuildContext context, String url) =>
      const Center(child: CircularProgressIndicator());

  Widget _errorWidget(BuildContext context, String url, Object error) {
    return Center(
      child: Column(
        children: <Widget>[
          Icon(Icons.error),
          const Text('Unable to load image')
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final currentLocale = Intl.getCurrentLocale() ?? 'en';

    return InkWell(
      onTap: () => launchLink(news.link),
      child: Stack(
        children: <Widget>[
          CachedNetworkImage(
            imageUrl: news.proxyImage,
            fit: BoxFit.cover,
            imageBuilder: _imageBuilder,
            placeholder: _placeholder,
            errorWidget: _errorWidget,
          ),
          Align(
            alignment: Alignment.bottomCenter,
            child: Container(
              height: 55.6,
              width: MediaQuery.of(context).size.width,
              decoration:
                  const BoxDecoration(color: Color.fromRGBO(34, 34, 34, .4)),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: <Widget>[
                  const SizedBox(height: 8.0),
                  Text(
                    '[${news.timestamp} ago] ${news.translations[currentLocale]}',
                    textAlign: TextAlign.center,
                    style: Theme.of(context)
                        .textTheme
                        .headline6
                        .copyWith(color: Colors.white, fontSize: 15),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
