import 'package:flutter/material.dart';
import 'package:badges/badges.dart' as badges;
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jasaku_app/screens/chat/chat_list_screen.dart';
import 'package:jasaku_app/screens/profile/profile_screen.dart';
import 'package:jasaku_app/screens/product/product_list_screen.dart';
import 'package:jasaku_app/screens/service/service_detail_screen.dart';
import 'package:jasaku_app/screens/search/search_screen.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold( 
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        title: Text(
          'JASAKU',
          style: TextStyle(
            fontSize: 24,
            fontWeight: FontWeight.bold,
            color: Colors.blue,
          ),
        ),
        actions: [
          IconButton(
            padding: EdgeInsets.all(8),
            icon: SizedBox(
              width: 40,
              height: 40,
              child: badges.Badge(
                showBadge: true,
                badgeContent: Text('3', style: TextStyle(color: Colors.white, fontSize: 9)),
                position: badges.BadgePosition.topEnd(top: -4, end: -6),
                child: Icon(Icons.chat, color: Colors.black87, size: 22),
              ),
            ),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ChatListScreen()));
            },
          ),
          IconButton(
            icon: Icon(Icons.person, color: Colors.black87),
            onPressed: () {
              Navigator.push(context, MaterialPageRoute(builder: (context) => ProfileScreen()));
            },
          ),
        ],
      ),
      body: Builder(
        builder: (context) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Search Bar
                _buildSearchBar(context),
                SizedBox(height: 20),

                // Banner/Featured Service
                Container(
                  width: double.infinity,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.lightBlue],
                      begin: Alignment.topLeft,
                      end: Alignment.bottomRight,
                    ),
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'Desain Logo Minimalis & Modern',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      SizedBox(height: 8),
                      Text(
                        'Website • UI/UX • 3D Print',
                        style: TextStyle(color: Colors.white70),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 20),

                // Categories
                Text(
                  'Categories',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    _buildCategoryItem(context, 'Website', Icons.language),
                    _buildCategoryItem(context, 'UI/UX', Icons.design_services),
                    _buildCategoryItem(context, '3D Print', Icons.print),
                    _buildCategoryItem(context, 'Logo', Icons.brush),
                  ],
                ),
                SizedBox(height: 30),

                // Services List
                Text(
                  'Recommended Services',
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 12),
                _buildServiceItem(
                  context,
                  'Design Logo Murah & Terbaik - Bebas Revisi',
                  'Fadhil Jofan Syahputra',
                  300,
                  4.9,
                  266,
                  'Rp 50.000',
                ),
                _buildServiceItem(
                  context,
                  'Design Website HTML CSS JS PHP',
                  'Hanan Rasyad Sadad',
                  800,
                  4.9,
                  760,
                  'Rp 500.000',
                ),
                _buildServiceItem(
                  context,
                  'Logo Minimalis UMKM, FASHION, TOKO ONLINE...',
                  'Alman Wicaksono',
                  250,
                  4.1,
                  150,
                  'Rp 75.000',
                ),
                _buildServiceItem(
                  context,
                  'Professional Motion Graphics Editing',
                  'Tirta Affandi',
                  321,
                  4.1,
                  150,
                  'Rp 300.000',
                ),
              ],
            ),
          );
        },
      ),
      bottomNavigationBar: _buildBottomNavigationBar(context, 0),
    );
  }

  Widget _buildSearchBar(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => SearchScreen()),
        );
      },
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: Colors.grey[100],
          borderRadius: BorderRadius.circular(25),
        ),
        child: Row(
          children: [
            SizedBox(width: 16),
            Icon(Icons.search, color: Colors.grey),
            SizedBox(width: 12),
            Text(
              'Search services...',
              style: TextStyle(
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCategoryItem(BuildContext context, String title, IconData icon) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            builder: (context) => ProductListScreen(category: title),
          ),
        );
      },
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: Colors.blue.withOpacity(0.1),
              borderRadius: BorderRadius.circular(30),
            ),
            child: Icon(icon, color: Colors.blue, size: 30),
          ),
          SizedBox(height: 8),
          Text(
            title,
            style: TextStyle(fontSize: 12),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }

  Widget _buildServiceItem(BuildContext context, String title, String seller, int sold, double rating, int reviews, String price) {
    return Card(
      margin: EdgeInsets.only(bottom: 16),
      child: InkWell(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
              builder: (context) => ServiceDetailScreen(),
            ),
          );
        },
        child: Padding(
          padding: EdgeInsets.all(12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Service Image
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  color: Colors.grey[200],
                  borderRadius: BorderRadius.circular(8),
                ),
                child: Icon(Icons.design_services, color: Colors.grey, size: 40),
              ),
              SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      title,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 14,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    SizedBox(height: 4),
                    Text(
                      seller,
                      style: TextStyle(
                        color: Colors.grey[600],
                        fontSize: 12,
                      ),
                    ),
                    SizedBox(height: 8),
                    Row(
                      children: [
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.green,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Verified',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                        SizedBox(width: 6),
                        Container(
                          padding: EdgeInsets.symmetric(horizontal: 6, vertical: 2),
                          decoration: BoxDecoration(
                            color: Colors.orange,
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Text(
                            'Fast Resp',
                            style: TextStyle(color: Colors.white, fontSize: 10),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          'Terjual $sold',
                          style: TextStyle(fontSize: 12, color: Colors.grey),
                        ),
                        Row(
                          children: [
                            RatingBar.builder(
                              initialRating: rating,
                              minRating: 1,
                              direction: Axis.horizontal,
                              allowHalfRating: true,
                              itemCount: 5,
                              itemSize: 12,
                              itemBuilder: (context, _) => Icon(
                                Icons.star,
                                color: Colors.amber,
                              ),
                              onRatingUpdate: (rating) {},
                              ignoreGestures: true,
                            ),
                            SizedBox(width: 4),
                            Text(
                              '$rating ($reviews)',
                              style: TextStyle(fontSize: 12),
                            ),
                          ],
                        ),
                      ],
                    ),
                    SizedBox(height: 8),
                    Text(
                      price,
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 16,
                        color: Colors.blue,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildBottomNavigationBar(BuildContext context, int currentIndex) {
    return BottomNavigationBar(
      currentIndex: currentIndex,
      type: BottomNavigationBarType.fixed,
      items: [
        BottomNavigationBarItem(
          icon: Icon(Icons.home),
          label: 'Home',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.search),
          label: 'Browse',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.shopping_cart),
          label: 'Orders',
        ),
      ],
      onTap: (index) {
        if (index == 1) { // Search tab
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => SearchScreen()),
          );
        }
        // Handle other tabs...
      },
    );
  }
}