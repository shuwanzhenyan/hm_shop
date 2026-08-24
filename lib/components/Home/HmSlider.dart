import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import '../../viewmodels/home.dart';

class HmSlider extends StatefulWidget {
  final List<BannerItem> bannerList;

  const HmSlider({super.key, required this.bannerList});

  @override
  State<HmSlider> createState() => _HmSliderState();
}

class _HmSliderState extends State<HmSlider> {
  Widget _getSlider() {
    // 获取屏幕宽度
    final double screenWidth = MediaQuery.of(context).size.width;
    // 第三方轮播图插件CarouselSlider
    return CarouselSlider(
      items: List.generate(widget.bannerList.length, (int index) {
        return Image.network(
          widget.bannerList[index].imgUrl,
          fit: BoxFit.cover,
          width: screenWidth,
        );
      }),
      options: CarouselOptions(
        autoPlayInterval: Duration(seconds: 5),
        height: 300,
        viewportFraction: 1,
        autoPlay: true,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Stack(children: [_getSlider()]);
    // return Container(
    //   height: 300,
    //   color: Colors.blue,
    //   alignment: Alignment.center,
    //   child: Text(
    //       "轮播图", style: TextStyle(color: Colors.white, fontSize: 20)),
    // );
  }
}
