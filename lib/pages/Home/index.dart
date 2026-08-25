import 'package:flutter/material.dart';
import 'package:hm_shop/api/home.dart';
import 'package:hm_shop/components/Home/HmCategory.dart';
import 'package:hm_shop/components/Home/HmHot.dart';
import 'package:hm_shop/components/Home/HmMoreList.dart';
import 'package:hm_shop/components/Home/HmSlider.dart';
import 'package:hm_shop/components/Home/HmSuggestion.dart';
import '../../viewmodels/home.dart';

class HomeView extends StatefulWidget {
  const HomeView({super.key});

  @override
  State<HomeView> createState() => _HomeViewState();
}

class _HomeViewState extends State<HomeView> {
  // 特惠推荐
  SpecialRecommendResult _specialRecommendResult = SpecialRecommendResult(
    id: "",
    title: "title",
    subTypes: [],
  );

  // 热榜推荐
  SpecialRecommendResult _inVogueResult = SpecialRecommendResult(
    id: "",
    title: "",
    subTypes: [],
  );

  // 一站式推荐
  SpecialRecommendResult _oneStopResult = SpecialRecommendResult(
    id: "",
    title: "",
    subTypes: [],
  );

  // 推荐列表
  List<GoodDetailItem> _recommendList = [];

  // 页码
  int _page = 1;
  bool _isLoading = false; // 当前正在加载状态
  bool _hasMore = true; // 是否还有下一页

  // 分类使用的图
  List<CategoryItem> _categoryList = [];

  // 轮播图使用的图
  List<BannerItem> _bannerList = [
    //   BannerItem(id: "1",
    //       imgUrl: "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meituan/1.jpg"),
    //   BannerItem(id: "2",
    //       imgUrl: "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meituan/2.png"),
    //   BannerItem(id: "3",
    //       imgUrl: "https://yjy-teach-oss.oss-cn-beijing.aliyuncs.com/meituan/3.jpg")
  ];

  // 获得滚动内容
  List<Widget> _getScrollChildren() {
    return [
      // 包裹普通组件的sliver家族组件
      // 轮播图组件
      SliverToBoxAdapter(child: HmSlider(bannerList: _bannerList)),
      // 间距
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      // 分类组件
      SliverToBoxAdapter(child: HmCategory(categoryList: _categoryList)),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      // 推荐组件
      SliverToBoxAdapter(
        child: HmSuggestion(specialRecommendResult: _specialRecommendResult),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      // 爆款组件
      SliverToBoxAdapter(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 10),
          child: Flex(
            direction: Axis.horizontal,
            children: [
              Expanded(
                child: HmHot(result: _inVogueResult, type: "hot"),
              ),
              SizedBox(width: 10),
              Expanded(
                child: HmHot(result: _oneStopResult, type: "step"),
              ),
            ],
          ),
        ),
      ),
      SliverToBoxAdapter(child: SizedBox(height: 10)),
      // 无限滚动组件
      HmMoreList(recommendList: _recommendList),
    ];
  }

  @override
  void initState() {
    super.initState();
    _getBannerList();
    _getCategoryList();
    _getProductList();
    _getInVogueList();
    _getOneStopList();
    _getRecommendList();
  }

  void _getBannerList() async {
    _bannerList = await getBannerListAPI();
    setState(() {});
  }

  void _getCategoryList() async {
    _categoryList = await getCategoryListAPI();
    setState(() {});
  }

  void _getProductList() async {
    _specialRecommendResult = await getProductListAPI();
    setState(() {});
  }

  // 获取热榜推荐列表
  Future<void> _getInVogueList() async {
    _inVogueResult = await getInVogueListAPI();
  }

  // 获取一站式推荐列表
  Future<void> _getOneStopList() async {
    _oneStopResult = await getOneStopListAPI();
  }

  Future<void> _getRecommendList() async {
    // 当已经有请求正在加载 或者已经没有下一页了 就放弃请求
    if (_isLoading || !_hasMore) {
      return;
    }

    _isLoading = true; // 占住位置
    int requestLimit = _page * 8;
    _recommendList = await getRecommendListAPI({"limit": requestLimit});
    _isLoading = false; // 松开位置
    setState(() {});
    // 我要10条 你给10条 说明我要的你都给了 接着认为还有下一页
    // 我要10条 你给9条
    if (_recommendList.length < requestLimit) {
      _hasMore = false;
      return;
    }
    _page++; // _page +=1;
  }

  @override
  Widget build(BuildContext context) {
    return CustomScrollView(slivers: _getScrollChildren()); // 必须是sliver家族的内容
  }
}
