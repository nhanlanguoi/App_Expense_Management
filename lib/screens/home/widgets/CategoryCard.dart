import 'package:flutter/material.dart';

class CategoryCard extends StatefulWidget {
  final String title;
  final IconData icon;
  final Color iconColor;

  const CategoryCard({
    super.key,
    required this.title,
    required this.icon,
    required this.iconColor,
  });

  @override
  State<CategoryCard> createState() => _CategoryCardState();
}

class _CategoryCardState extends State<CategoryCard> {
  bool isExpanded = false;

  void toggle() {
    setState(() {
      isExpanded = !isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedContainer(
      duration: const Duration(milliseconds: 500),
      curve: Curves.easeInOutCubic,
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
      decoration: BoxDecoration(
        color: const Color(0xFFF4F6F8),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: isExpanded
              ? Colors.deepPurple.withOpacity(0.4)
              : Colors.grey.withOpacity(0.2),
          width: 2,
        ),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 12,
            offset: const Offset(0, 6),
          ),
        ],
      ),

      child: Column(
        children: [

          /// HEADER
          GestureDetector(
            onTap: toggle,
            child: Row(
              children: [
                AnimatedContainer(
                  duration: const Duration(milliseconds: 400),
                  width: 50,
                  height: 50,
                  decoration: BoxDecoration(
                    color: widget.iconColor.withOpacity(isExpanded ? 0.25 : 0.15),
                    shape: BoxShape.circle,
                  ),
                  child: Icon(
                    widget.icon,
                    color: widget.iconColor,
                    size: 26,
                  ),
                ),

                const SizedBox(width: 16),

                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        widget.title,
                        style: const TextStyle(
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'BeVietnamPro',
                        ),
                      ),

                      AnimatedOpacity(
                        duration: const Duration(milliseconds: 300),
                        opacity: isExpanded ? 1 : 0,
                        child: const Text(
                          "Đang chỉnh sửa...",
                          style: TextStyle(
                            color: Colors.deepPurple,
                            fontSize: 13,
                          ),
                        ),
                      )
                    ],
                  ),
                ),

                const Icon(Icons.edit, color: Colors.grey)
              ],
            ),
          ),

          /// EXPAND CONTENT
          ClipRect(
            child: AnimatedAlign(
              duration: const Duration(milliseconds: 500),
              curve: Curves.easeInOutCubic,
              alignment: Alignment.topCenter,
              heightFactor: isExpanded ? 1 : 0,
              child: Column(
                children: [

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CHỌN BIỂU TƯỢNG",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      Icon(Icons.home),
                      Icon(Icons.medical_services),
                      Icon(Icons.shopping_bag),
                      Icon(Icons.sports_esports),
                      Icon(Icons.flight),
                      Icon(Icons.card_giftcard),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.centerLeft,
                    child: Text(
                      "CHỌN MÀU SẮC",
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        color: Colors.grey.shade600,
                        fontSize: 13,
                      ),
                    ),
                  ),

                  const SizedBox(height: 10),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: const [
                      CircleAvatar(backgroundColor: Colors.red),
                      CircleAvatar(backgroundColor: Colors.orange),
                      CircleAvatar(backgroundColor: Colors.amber),
                      CircleAvatar(backgroundColor: Colors.green),
                      CircleAvatar(backgroundColor: Colors.blue),
                      CircleAvatar(backgroundColor: Colors.deepPurple),
                      CircleAvatar(backgroundColor: Colors.pink),
                    ],
                  ),

                  const SizedBox(height: 20),

                  Row(
                    children: [

                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            color: Colors.grey.shade300,
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(child: Text("Hủy")),
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Container(
                          height: 45,
                          decoration: BoxDecoration(
                            gradient: const LinearGradient(
                              colors: [
                                Color(0xFF9B5CF6),
                                Color(0xFF6C3CF5),
                              ],
                            ),
                            borderRadius: BorderRadius.circular(25),
                          ),
                          child: const Center(
                            child: Text(
                              "Lưu thay đổi",
                              style: TextStyle(color: Colors.white),
                            ),
                          ),
                        ),
                      )
                    ],
                  )
                ],
              ),
            ),
          )
        ],
      ),
    );
  }
}