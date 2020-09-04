import 'package:flutter/material.dart';
import 'package:movie/actions/adapt.dart';
import 'package:movie/models/base_api_model/movie_stream_link.dart';
import 'package:movie/style/themestyle.dart';

import '../../../../../../widgets/arrow_clipper.dart';

class VideoSourceMenu extends StatelessWidget {
  final List<MovieStreamLink> links;
  final int selectedLinkId;
  final Function(MovieStreamLink) onTap;
  final Function moreTap;
  final Function streamLinkRequestTap;
  const VideoSourceMenu(
      {this.links,
      this.onTap,
      this.selectedLinkId,
      this.streamLinkRequestTap,
      this.moreTap});
  @override
  Widget build(BuildContext context) {
    final _theme = ThemeStyle.getTheme(context);
    final _backGroundColor = _theme.brightness == Brightness.light
        ? const Color(0xFF25272E)
        : _theme.primaryColorDark;
    final double _width = 160;
    final double _arrowSize = 20.0;
    final double _menuHeight = 180.0;
    return Positioned(
      bottom: 80,
      left: Adapt.px(275) - _width / 2,
      width: _width,
      child: Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Align(
                alignment: Alignment.bottomCenter,
                child: ClipPath(
                  clipper: ArrowClipper(),
                  child: Container(
                    width: _arrowSize,
                    height: _arrowSize,
                    color: _backGroundColor,
                  ),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(bottom: 20.0),
              child: Container(
                padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                height: _menuHeight,
                decoration: BoxDecoration(
                  color: _backGroundColor,
                  borderRadius: BorderRadius.circular(10),
                ),
                child: links.length > 0
                    ? _LinkSourcePanel(
                        links: links.take(3).toList(),
                        selectedLink: selectedLinkId,
                        onTap: onTap,
                        moreTap: moreTap,
                      )
                    : Center(
                        child: SizedBox(
                          width: 120,
                          child: FlatButton(
                            onPressed: streamLinkRequestTap,
                            child: Text(
                              'request stream link',
                              textAlign: TextAlign.center,
                              style: TextStyle(color: const Color(0xFFFFFFFF)),
                            ),
                          ),
                        ),
                      ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkCell extends StatelessWidget {
  final bool selected;
  final MovieStreamLink data;
  final Function(MovieStreamLink) onTap;
  const _LinkCell({this.data, this.onTap, this.selected});
  @override
  Widget build(BuildContext context) {
    final _textStyle =
        const TextStyle(color: const Color(0xFFFFFFFF), fontSize: 14);
    return InkWell(
      onTap: () => onTap(data),
      child: Container(
        padding: EdgeInsets.symmetric(horizontal: 8),
        decoration: selected
            ? BoxDecoration(
                borderRadius: BorderRadius.circular(5),
                border: Border.all(color: const Color(0xFFFFFFFF)))
            : null,
        height: 35,
        child: Row(
          children: [
            Text(
              data.language.name,
              style: _textStyle,
            ),
            Spacer(),
            Text(
              data.quality.name,
              style: _textStyle,
            ),
          ],
        ),
      ),
    );
  }
}

class _LinkSourcePanel extends StatelessWidget {
  final List<MovieStreamLink> links;
  final int selectedLink;
  final Function(MovieStreamLink) onTap;
  final Function moreTap;
  const _LinkSourcePanel({
    this.links,
    this.selectedLink,
    this.onTap,
    this.moreTap,
  });
  @override
  Widget build(BuildContext context) {
    return Column(crossAxisAlignment: CrossAxisAlignment.end, children: [
      Expanded(
        child: ListView.separated(
          physics: BouncingScrollPhysics(),
          padding: EdgeInsets.zero,
          separatorBuilder: (_, __) => SizedBox(height: 5),
          itemBuilder: (_, index) {
            final _link = links[index];
            return _LinkCell(
              data: _link,
              selected: _link.sid == selectedLink,
              onTap: onTap,
            );
          },
          itemCount: links.length,
        ),
      ),
      SizedBox(height: 10),
      GestureDetector(
        onTap: moreTap,
        child: Container(
          padding: EdgeInsets.all(4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(5),
            border: Border.all(
              color: const Color(0xFFFFFFFF),
            ),
          ),
          child: Text(
            'More',
            style: TextStyle(
              fontSize: 10,
              color: const Color(0xFFFFFFFF),
            ),
          ),
        ),
      ),
    ]);
  }
}
