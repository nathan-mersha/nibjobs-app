import 'package:flutter/material.dart';
import 'package:nibjobs/rsr/theme/color.dart';
import 'package:nibjobs/themes/nib_custom_icons_icons.dart';
import 'package:nibjobs/widget/BottomNavigationBar/bottom_curved_Painter.dart';

class CustomBottomNavigationBar extends StatefulWidget {
  final Function(int)? onIconPresedCallback;
  final bool? isFavPageSelected;
  final bool? isSubCategoryPageSelected;

  CustomBottomNavigationBar(
      {Key? key,
      this.isFavPageSelected = false,
      this.isSubCategoryPageSelected = false,
      this.onIconPresedCallback})
      : super(key: key);

  @override
  _CustomBottomNavigationBarState createState() =>
      _CustomBottomNavigationBarState();
}

class _CustomBottomNavigationBarState extends State<CustomBottomNavigationBar>
    with TickerProviderStateMixin {
  int _selectedIndex = 0;

  AnimationController? _xController;
  AnimationController? _yController;

  @override
  void initState() {
    if (widget.isFavPageSelected!) {
      _selectedIndex = 2;
    } else if (widget.isSubCategoryPageSelected!) {
      _selectedIndex = 3;
    }

    _xController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);
    _yController = AnimationController(
        vsync: this, animationBehavior: AnimationBehavior.preserve);

    Listenable.merge([_xController, _yController]).addListener(() {
      setState(() {});
    });

    super.initState();
  }

  @override
  void didChangeDependencies() {
    _xController!.value =
        _indexToPosition(_selectedIndex) / MediaQuery.of(context).size.width;
    _yController!.value = 1.0;

    super.didChangeDependencies();
  }

  double _indexToPosition(int index) {
    // Calculate button positions based off of their
    // index (works with `MainAxisAlignment.spaceAround`)
    const buttonCount = 4.0;
    final appWidth = MediaQuery.of(context).size.width;
    final buttonsWidth = _getButtonContainerWidth();
    final startX = (appWidth - buttonsWidth) / 2;
    return startX +
        index.toDouble() * buttonsWidth / buttonCount +
        buttonsWidth / (buttonCount * 2.0);
  }

  @override
  void dispose() {
    _xController!.dispose();
    _yController!.dispose();
    super.dispose();
  }

  Widget _icon(IconData icon, bool isEnable, int index) {
    return Expanded(
      child: InkWell(
        borderRadius: const BorderRadius.all(Radius.circular(50)),
        onTap: () {
          _handlePressed(index);
        },
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 500),
          alignment: isEnable ? Alignment.topCenter : Alignment.center,
          child: AnimatedContainer(
              height: isEnable ? 40 : 20,
              duration: const Duration(milliseconds: 300),
              alignment: Alignment.center,
              decoration: BoxDecoration(
                  color: isEnable ? CustomColor.PRIM_DARK : Colors.transparent,
                  shape: BoxShape.circle),
              child: Opacity(
                opacity: isEnable ? _yController!.value : 1,
                child: Icon(icon,
                    color: isEnable
                        ? CustomColor.GRAY_DARK
                        : Theme.of(context).iconTheme.color),
              )),
        ),
      ),
    );
  }

  Widget _buildBackground() {
    const inCurve = ElasticOutCurve(0.38);
    return CustomPaint(
      painter: BackgroundCurvePainter(
          _xController!.value * MediaQuery.of(context).size.width,
          Tween<double>(
            begin: Curves.easeInExpo.transform(_yController!.value),
            end: inCurve.transform(_yController!.value),
          ).transform(_yController!.velocity.sign * 0.5 + 0.5),
          Theme.of(context).bottomAppBarColor),
    );
  }

  double _getButtonContainerWidth() {
    double width = MediaQuery.of(context).size.width;
    if (width > 400.0) {
      width = 400.0;
    }
    return width;
  }

  void _handlePressed(int index) {
    if (_selectedIndex == index || _xController!.isAnimating) return;
    widget.onIconPresedCallback!(index);
    setState(() {
      _selectedIndex = index;
    });

    _yController!.value = 1.0;
    _xController!.animateTo(
        _indexToPosition(index) / MediaQuery.of(context).size.width,
        duration: Duration(milliseconds: 620));
    Future.delayed(
      Duration(milliseconds: 500),
      () {
        _yController!.animateTo(1.0, duration: Duration(milliseconds: 1200));
      },
    );
    _yController!.animateTo(0.0, duration: Duration(milliseconds: 300));
  }

  @override
  Widget build(BuildContext context) {
    final appSize = MediaQuery.of(context).size;
    const height = 60.0;
    return SizedBox(
      width: appSize.width,
      height: 60,
      child: Stack(
        children: [
          Positioned(
            left: 0,
            bottom: 0,
            width: appSize.width,
            height: height - 10,
            child: _buildBackground(),
          ),
          Positioned(
            left: (appSize.width - _getButtonContainerWidth()) / 2,
            top: 0,
            width: _getButtonContainerWidth(),
            height: height,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: <Widget>[
                _icon(NibCustomIcons.home, _selectedIndex == 0, 0),
                _icon(NibCustomIcons.companies, _selectedIndex == 1, 1),
                _icon(NibCustomIcons.favorite, _selectedIndex == 2, 2),
                _icon(NibCustomIcons.category, _selectedIndex == 3, 3),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
