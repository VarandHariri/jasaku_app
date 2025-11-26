import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:jasaku_app/models/service.dart';
import 'package:jasaku_app/screens/chat/chat_detail_screen.dart';
import 'package:jasaku_app/screens/order/create_order_screen.dart';

// Uses shared `Service` model from `lib/models/service.dart`
class ServiceDetailScreen extends StatelessWidget {
  final Service? service;
  
  const ServiceDetailScreen({Key? key, this.service}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    // Use provided service or default data
    final serviceData = service ?? Service(
      id: 1,
      title: 'Design Logo Murah & Terbaik - Bebas Revisi',
      seller: 'Fadhil Jofan Syahputra',
      price: 50000,
      sold: 300,
      rating: 4.9,
      reviews: 266,
      isVerified: true,
      hasFastResponse: true,
    );

    return Scaffold(
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: 250,
            flexibleSpace: FlexibleSpaceBar(
              background: Container(
                color: _getCategoryColor(serviceData.title),
                child: Icon(
                  _getCategoryIcon(serviceData.title),
                  color: Colors.white,
                  size: 80,
                ),
              ),
            ),
          ),
          SliverToBoxAdapter(
            child: Padding(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title and Seller
                  Text(
                    serviceData.title,
                    style: TextStyle(
                      fontSize: 24,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  Row(
                    children: [
                      CircleAvatar(
                        radius: 16,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.person, size: 16),
                      ),
                      SizedBox(width: 8),
                      Text(serviceData.seller),
                    ],
                  ),
                  SizedBox(height: 16),
                  
                  // Stats
                  Row(
                    children: [
                      _buildStatItem('Terjual', '${serviceData.sold}'),
                      _buildStatItem('Rating', '${serviceData.rating}'),
                      _buildStatItem('Ulasan', '${serviceData.reviews}'),
                    ],
                  ),
                  SizedBox(height: 20),
                  
                  // Price Packages
                  Text(
                    'Paket Harga',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 12),
                  _buildPricePackage('Rp 350.000', 'Basic Package', '1 konsep logo\n2 revisi\nFile PNG & JPG'),
                  _buildPricePackage('Rp 500.000', 'Standard Package', '2 konsep logo\n5 revisi\nFile PNG, JPG, SVG\nSource file AI'),
                  _buildPricePackage('Rp 800.000', 'Premium Package', '3 konsep logo\nUnlimited revisi\nSemua file format\nPriority support'),

                  SizedBox(height: 20),
                  Divider(),

                  // Seller Info
                  Text(
                    'Tentang Penjual',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  ListTile(
                    leading: CircleAvatar(
                      backgroundColor: Colors.blue,
                      child: Text(
                        serviceData.seller.isNotEmpty ? serviceData.seller[0] : 'F', 
                        style: TextStyle(color: Colors.white)
                      ),
                    ),
                    title: Text(serviceData.seller),
                    subtitle: Text('${serviceData.isVerified ? 'Verified Seller' : ''}${serviceData.isVerified && serviceData.hasFastResponse ? ' • ' : ''}${serviceData.hasFastResponse ? 'Fast Response' : ''}'),
                  ),

                  // Reviews
                  SizedBox(height: 20),
                  Text(
                    'Ulasan (${serviceData.reviews})',
                    style: TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  _buildReviewItem('Pandji Prakoso', '29/10/26', 'Hasilnya memuaskan! Desain logo sesuai dengan yang saya inginkan. Proses pengerjaan cepat dan komunikasi lancar. Recommended banget!'),
                  _buildReviewItem('Siti Rahma', '28/10/26', 'Pelayanan sangat profesional. Hasil kerja rapi dan sesuai deadline. Will order again!'),
                ],
              ),
            ),
          ),
        ],
      ),
      // GANTI bagian bottomNavigationBar yang lama dengan ini:
      bottomNavigationBar: Container(
        padding: EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          boxShadow: [
            BoxShadow(
              color: Colors.grey.withOpacity(0.5),
              blurRadius: 5,
              offset: Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            Expanded(
              child: OutlinedButton.icon(
                icon: Icon(Icons.chat),
                label: Text('Chat dan Nego'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => ChatDetailScreen(
                        contactName: serviceData.seller,
                        contactInitial: serviceData.seller.isNotEmpty ? serviceData.seller[0] : 'S',
                        service: serviceData,
                      ),
                    ),
                  );
                },
                style: OutlinedButton.styleFrom(
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
            SizedBox(width: 12),
            Expanded(
              child: ElevatedButton.icon(
                icon: Icon(Icons.shopping_cart),
                label: Text('Order Sekarang'),
                onPressed: () {
                  Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => CreateOrderScreen(service: serviceData),
                    ),
                  );
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  padding: EdgeInsets.symmetric(vertical: 12),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildStatItem(String label, String value) {
    return Expanded(
      child: Column(
        children: [
          Text(
            value,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.blue,
            ),
          ),
          Text(
            label,
            style: TextStyle(
              fontSize: 12,
              color: Colors.grey,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPricePackage(String price, String package, String features) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      price,
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: Colors.blue,
                      ),
                    ),
                    Text(
                      package,
                      style: TextStyle(fontWeight: FontWeight.w500),
                    ),
                  ],
                ),
                ElevatedButton(
                  onPressed: () {},
                  child: Text('Chat dan Nego'),
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.green,
                  ),
                ),
              ],
            ),
            SizedBox(height: 8),
            Text(
              features,
              style: TextStyle(
                fontSize: 12,
                color: Colors.grey[600],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildReviewItem(String name, String date, String review) {
    return Card(
      margin: EdgeInsets.only(bottom: 12),
      child: Padding(
        padding: EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  name,
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                Text(
                  date,
                  style: TextStyle(color: Colors.grey, fontSize: 12),
                ),
              ],
            ),
            SizedBox(height: 8),
            RatingBar.builder(
              initialRating: 5,
              itemSize: 16,
              itemBuilder: (context, _) => Icon(Icons.star, color: Colors.amber),
              onRatingUpdate: (rating) {},
              ignoreGestures: true,
            ),
            SizedBox(height: 8),
            Text(review),
          ],
        ),
      ),
    );
  }

  Color _getCategoryColor(String title) {
    if (title.toLowerCase().contains('logo')) return Colors.purple;
    if (title.toLowerCase().contains('website') || title.toLowerCase().contains('web')) return Colors.blue;
    if (title.toLowerCase().contains('video') || title.toLowerCase().contains('motion')) return Colors.red;
    return Colors.green;
  }

  IconData _getCategoryIcon(String title) {
    if (title.toLowerCase().contains('logo')) return Icons.brush;
    if (title.toLowerCase().contains('website') || title.toLowerCase().contains('web')) return Icons.language;
    if (title.toLowerCase().contains('video') || title.toLowerCase().contains('motion')) return Icons.videocam;
    return Icons.design_services;
  }
}