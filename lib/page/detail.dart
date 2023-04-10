import 'package:carousel_slider/carousel_slider.dart';
import 'package:danggnn/page/chat_screen.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import '../utils/data_utils.dart';
import 'package:danggnn/utils/lineClass.dart';

class DetailContentView extends StatefulWidget {
  Map<String, dynamic> data;

  DetailContentView({Key? key, required this.data}) : super(key: key);

  @override
  State<DetailContentView> createState() => _DetailContentViewState();
}

class _DetailContentViewState extends State<DetailContentView>
    with SingleTickerProviderStateMixin {

  final int getKakaoNumber = Get.arguments; // 현재 접속자의 kakao id

  Size? size;
  late List<String> imgList;
  late int kNumber; //작성자의 카카오 id

  int? _current;
  double scrollpositionToAlpha = 0;
  ScrollController _controller = ScrollController();
  late AnimationController _animationController;
  late Animation _colorTween;
  late bool isMyFavoriteContent;

  @override
  void initState() {
    super.initState();
    // contentsRepository = ContentsRepository();
    isMyFavoriteContent = false;
    _animationController = AnimationController(vsync: this);
    _colorTween = ColorTween(begin: Colors.white, end: Colors.black)
        .animate(_animationController);

    _controller.addListener(() {
      setState(() {
        if (_controller.offset > 255) {
          scrollpositionToAlpha = 255;
        } else {
          scrollpositionToAlpha = _controller.offset;
        }

        _animationController.value = scrollpositionToAlpha / 255;
      });
    });
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    size = MediaQuery.of(context).size; // 기기 해상도 가져오기
    _current = 0;
    imgList = [widget.data["uploadImageurl"]!];
  }

  Widget _makeIcon(IconData icon) {
    return AnimatedBuilder(
      animation: _colorTween,
      builder: (context, child) => Icon(
        icon,
        color: _colorTween.value,
      ),
    );
  }

  PreferredSizeWidget _appbarWidget() {
    return AppBar(
      iconTheme: IconThemeData(
        color: Colors.black,
      ),
      leading: IconButton(
        onPressed: () {
          Navigator.pop(context);
        },
        icon: _makeIcon(Icons.arrow_back),
      ),
      backgroundColor: Colors.white.withAlpha(scrollpositionToAlpha.toInt()),
      elevation: 0,
      actions: [
        IconButton(
          onPressed: () {},
          icon: _makeIcon(Icons.share),
          color: Colors.white,
        ),
        IconButton(
            onPressed: () {},
            icon: _makeIcon(Icons.more_vert),
            color: Colors.white),
      ],
    );
  }

  Widget _makeSliderImage() {
    return Container(
      child: Stack(
        children: [
          Hero(
            tag: widget.data["id"]!,
            child: CarouselSlider(
              options: CarouselOptions(
                  height: size?.width,
                  initialPage: 0,
                  enableInfiniteScroll: false,
                  viewportFraction: 1.0,
                  enlargeCenterPage: false,
                  onPageChanged: (index, reason) {
                    setState(() {
                      _current = index;
                    });
                  }),
              items: imgList.map((i) {
                return Container(
                  width: size?.width,
                  color: Colors.red,
                  child: Image.network(
                    widget.data["uploadImageurl"]!,
                    fit: BoxFit.fill,
                  ),
                );
              }).toList(),
            ),
          ),
          Positioned(
            bottom: 0,
            left: 0,
            right: 0,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(imgList.length, (index) {
                return Container(
                  width: 8.0,
                  height: 8.0,
                  margin: EdgeInsets.symmetric(vertical: 10.0, horizontal: 5.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    color: _current == index
                        ? Colors.white
                        : Colors.white.withOpacity(0.1),
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
      // ),
    );
  }

  Widget _sellerSimpleInfo() {
    return Padding(
      padding: const EdgeInsets.all(15.0),
      child: Row(
        children: [
          CircleAvatar(
            radius: 25,
            backgroundImage: Image.asset("assets/images/user.png").image,
          ),
          SizedBox(
            width: 10,
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                // "dd",
                DataUtils.kakaoNumberHide(widget.data["kakaoNumber"]),
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 16,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  // 나중에 필요할 수 있음
  // Widget _line() {
  //   return Container(
  //     margin: const EdgeInsets.symmetric(horizontal: 15),
  //     height: 1,
  //     color: Colors.grey.withOpacity(0.3),
  //   );
  // }

  Widget _contentDetail() {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            height: 20,
          ),
          Text(
            widget.data["title"]!,
            style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
          ),
          SizedBox(
            height: 15,
          ),
          Text(
            widget.data["contentsOfSell"]!,
            style: TextStyle(height: 1.5, fontSize: 15),
          ),
          SizedBox(
            height: 15,
          ),
        ],
      ),
    );
  }

  Widget _bodyWidget() {
    return CustomScrollView(
      controller: _controller,
      slivers: [
        SliverList(
          delegate: SliverChildListDelegate([
            _makeSliderImage(),
            _sellerSimpleInfo(),
            // _line(),
            lineMake(),
            _contentDetail(),
            // _line(),
            // lineMake(),
          ]),
        ),
      ],
    );
  }

  Widget _bottomBarWidget() {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 0),
      height: 55,
      width: size?.width,
      child: Column(
        children: [
          lineMakePartOfPrice(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 15),
            child: Row(
              children: [
                Column(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text(
                        DataUtils.calcStringToWon(widget.data["price"]!),
                        style: TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 20),
                      ),
                    ),
                  ],
                ),
                Expanded(
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      (widget.data["kakaoNumber"] !=
                              getKakaoNumber) // 해당 게시글 사용자의 카카오 == 현재 접속자의 카카오
                          ? GestureDetector(
                              onTap: () {
                                Get.to(ChatScreen(),
                                arguments: [widget.data["kakaoNumber"], getKakaoNumber]);
                              },
                              child: Container(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 8),
                                decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(6.5),
                                  color: Color(0xfff08f4f),
                                ),
                                child: const Text(
                                  "채팅으로 거래하기",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontWeight: FontWeight.bold,
                                      fontSize: 16),
                                ),
                              ),
                            )
                          : Container(
                              padding: const EdgeInsets.symmetric(
                                  horizontal: 10, vertical: 8),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.5),
                                color: Color(0xffc68151),
                              ),
                              child: const Text(
                                "채팅으로 거래하기",
                                style: TextStyle(
                                    color: Color(0xff545460),
                                    fontWeight: FontWeight.bold,
                                    fontSize: 16),
                              ),
                            ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      extendBodyBehindAppBar: true,
      appBar: _appbarWidget(),
      body: _bodyWidget(),
      bottomNavigationBar: _bottomBarWidget(),
    );
  }
}
