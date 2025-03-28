import 'package:flutter/material.dart';

class ExpandableBottomNavBar extends StatefulWidget {
  final List<IconData> icons;
  final Function(int) onTap;
  final Color? mainButtonColor;
  final Color? mainButtonShadowColor;
  final Color? backgroundColor;
  final Color? selectedItemColor;
  final Color? unselectedItemColor;
  final double? height;
  final double? buttonSize;

  const ExpandableBottomNavBar({
    super.key,
    required this.icons,
    required this.onTap,
    this.mainButtonColor,
    this.mainButtonShadowColor,
    this.backgroundColor,
    this.selectedItemColor,
    this.unselectedItemColor,
    this.height,
    this.buttonSize,
  });

  @override
  State<ExpandableBottomNavBar> createState() => _ExpandableBottomNavBarState();
}

class _ExpandableBottomNavBarState extends State<ExpandableBottomNavBar>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<double> _expandAnimation;
  late Animation<double> _buttonSizeAnimation;
  int _selectedIndex = 0;
  bool _isExpanded = false;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );

    _expandAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );

    _buttonSizeAnimation = Tween<double>(
      begin: widget.buttonSize ?? 80.0,
      end: (widget.buttonSize ?? 80.0) * 0.6,
    ).animate(
      CurvedAnimation(
        parent: _controller,
        curve: Curves.easeInOut,
      ),
    );
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
      if (_isExpanded) {
        _controller.forward();
      } else {
        _controller.reverse();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 115,
      child: Padding(
        padding: const EdgeInsets.all(32.0),
        child: AnimatedBuilder(
          animation: _controller,
          builder: (context, child) {
            return LayoutBuilder(
              builder: (context, constraints) {
                final maxWidth = constraints.maxWidth;
                final effectiveWidth =
                    maxWidth - 32.0; // Account for background padding
                return Stack(
                  alignment: Alignment.center,
                  children: [
                    // Animated background container
                    Positioned(
                      bottom: 0,
                      child: AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: _isExpanded ? 1.0 : 0.0,
                        child: Container(
                          decoration: BoxDecoration(
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.1),
                                spreadRadius: 5,
                                blurRadius: 15,
                              ),
                            ],
                          ),
                          child: ClipRRect(
                            borderRadius: BorderRadius.circular(
                                _isExpanded ? (widget.height ?? 80.0) / 2 : 30),
                            child: AnimatedContainer(
                              decoration: BoxDecoration(
                                color: widget.backgroundColor ?? Colors.white,
                              ),
                              duration: const Duration(milliseconds: 300),
                              width: _isExpanded
                                  ? maxWidth
                                  : _buttonSizeAnimation.value,
                              height: widget.height ?? 80.0,
                            ),
                          ),
                        ),
                      ),
                    ),
                    // Navigation items in a separate layer
                    Positioned(
                      bottom: 0,
                      child: SizedBox(
                        height: widget.height ?? 80.0,
                        width: effectiveWidth, // Use effective width
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            widget.icons.length,
                            (index) {
                              final totalItems = widget.icons.length;
                              final sideMargin = 16.0;
                              final edgePadding = 16.0;
                              final itemSize = 32.0;

                              // Calculate spacing
                              final totalItemsWidth = itemSize * totalItems;
                              final availableSpace = effectiveWidth -
                                  (sideMargin * 2) -
                                  totalItemsWidth -
                                  (sideMargin * 2) -
                                  (edgePadding * 2);
                              final spacing = availableSpace / (totalItems - 1);

                              // Calculate position with smoother animation
                              final centerIndex = (totalItems - 1) / 2;
                              final distanceFromCenter = index - centerIndex;
                              final baseOffset =
                                  distanceFromCenter * (itemSize + spacing);

                              // Add edge padding only for first and last items
                              final isFirstItem = index == 0;
                              final isLastItem = index == totalItems - 1;
                              final edgeOffset = isFirstItem
                                  ? edgePadding
                                  : (isLastItem ? -edgePadding : 0);

                              return AnimatedBuilder(
                                animation: _expandAnimation,
                                builder: (context, child) {
                                  return Transform.translate(
                                    offset: Offset(
                                      (baseOffset + edgeOffset) *
                                          _expandAnimation.value,
                                      0,
                                    ),
                                    child: Opacity(
                                      opacity: _expandAnimation.value,
                                      child: SizedBox(
                                        width: itemSize,
                                        height: itemSize,
                                        child: _buildNavItem(index),
                                      ),
                                    ),
                                  );
                                },
                              );
                            },
                          ),
                        ),
                      ),
                    ),
                    // Center button
                    Positioned(
                      bottom: (widget.height ?? 80.0) / 2 -
                          (_buttonSizeAnimation.value / 2),
                      child: GestureDetector(
                        onTap: _toggleExpansion,
                        child: AnimatedContainer(
                          duration: const Duration(milliseconds: 300),
                          width: _buttonSizeAnimation.value,
                          height: _buttonSizeAnimation.value,
                          decoration: BoxDecoration(
                            color: widget.mainButtonColor ?? Colors.blue,
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: widget.mainButtonShadowColor ??
                                    Colors.blue.withValues(alpha: 0.3),
                                blurRadius: 10,
                                offset: const Offset(0, 5),
                              ),
                            ],
                          ),
                          child: Icon(
                            _isExpanded ? Icons.remove : Icons.add,
                            color: Colors.white,
                            size: _buttonSizeAnimation.value * 0.5,
                          ),
                        ),
                      ),
                    ),
                  ],
                );
              },
            );
          },
        ),
      ),
    );
  }

  Widget _buildNavItem(int index) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _selectedIndex = index;
        });
        widget.onTap(index);
      },
      child: Container(
        alignment: Alignment.center,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          // padding: const EdgeInsets.all(8), // Reduced from 12
          // decoration: BoxDecoration(
          //   color: _selectedIndex == index
          //       ? (widget.selectedItemColor ?? Theme.of(context).primaryColor)
          //       : Colors.transparent,
          //   borderRadius: BorderRadius.circular(12),
          // ),
          child: Icon(
            widget.icons[index],
            color: _selectedIndex == index
                ? widget.selectedItemColor ?? Colors.white
                : (widget.unselectedItemColor ?? Colors.grey),
            size: 20,
          ),
        ),
      ),
    );
  }
}
