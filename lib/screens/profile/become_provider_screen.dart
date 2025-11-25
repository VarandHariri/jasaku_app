import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:jasaku_app/models/user_model.dart';
import 'package:jasaku_app/providers/auth_provider.dart';

class BecomeProviderScreen extends StatefulWidget {
  final User user;
  
  const BecomeProviderScreen({Key? key, required this.user}) : super(key: key);

  @override
  _BecomeProviderScreenState createState() => _BecomeProviderScreenState();
}

class _BecomeProviderScreenState extends State<BecomeProviderScreen> {
  final _formKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  bool _isLoading = false;

  void _submitApplication() async {
    if (_formKey.currentState!.validate()) {
      setState(() {
        _isLoading = true;
      });

      try {
        // Update user role menjadi provider
        final authProvider = Provider.of<AuthProvider>(context, listen: false);
        await authProvider.updateUserRole('provider');

        setState(() {
          _isLoading = false;
        });

        Navigator.pop(context, true); // Return true to indicate success
      } catch (e) {
        setState(() {
          _isLoading = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Gagal menjadi penyedia jasa: $e'),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Mulai Menjual Jasa'),
        backgroundColor: Colors.blue,
      ),
      body: Builder(
        builder: (context) {
          final bottomInset = MediaQuery.of(context).viewInsets.bottom;
          return SingleChildScrollView(
            padding: EdgeInsets.fromLTRB(16, 16, 16, 16 + bottomInset),
            child: Form(
              key: _formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Column(
                        children: [
                          Icon(Icons.work_outline, size: 64, color: Colors.blue),
                          SizedBox(height: 16),
                          Text(
                            'Jadi Penyedia Jasa',
                            style: TextStyle(
                              fontSize: 20,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 8),
                          Text(
                            'Tawarkan keahlian Anda dan mulai dapatkan penghasilan dari kampus',
                            textAlign: TextAlign.center,
                            style: TextStyle(color: Colors.grey),
                          ),
                        ],
                      ),
                    ),
                  ),
                  SizedBox(height: 24),
                  
                  // Form description
                  Text(
                    'Deskripsi Jasa Anda',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  SizedBox(height: 8),
                  TextFormField(
                    controller: _descriptionController,
                    maxLines: 5,
                    decoration: InputDecoration(
                      hintText: 'Ceritakan tentang keahlian Anda...\nContoh: "Saya ahli dalam desain PCB, 3D modeling, dan programming. Sudah berpengalaman membuat berbagai project elektronik."',
                      border: OutlineInputBorder(),
                      alignLabelWithHint: true,
                    ),
                    validator: (value) {
                      if (value == null || value.isEmpty) {
                        return 'Silakan isi deskripsi jasa Anda';
                      }
                      if (value.length < 20) {
                        return 'Deskripsi minimal 20 karakter';
                      }
                      return null;
                    },
                  ),
                  SizedBox(height: 16),
                  
                  // Benefits list
                  Text(
                    'Keuntungan menjadi penyedia jasa:',
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  SizedBox(height: 8),
                  _buildBenefitItem('Dapat penghasilan tambahan'),
                  _buildBenefitItem('Bangun portofolio dan reputasi'),
                  _buildBenefitItem('Jaringan dengan mahasiswa lain'),
                  _buildBenefitItem('Pengalaman kerja nyata'),
                  SizedBox(height: 24),
                  
                  // Submit button
                  _isLoading
                      ? Center(child: CircularProgressIndicator())
                      : SizedBox(
                          width: double.infinity,
                          child: ElevatedButton(
                            onPressed: _submitApplication,
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              minimumSize: Size(double.infinity, 50),
                            ),
                            child: Text(
                              'MULAI JUAL SEKARANG',
                              style: TextStyle(
                                fontSize: 16,
                                color: Colors.white,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ),
                        ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget _buildBenefitItem(String text) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4.0),
      child: Row(
        children: [
          Icon(Icons.check_circle, color: Colors.green, size: 20),
          SizedBox(width: 8),
          Text(text),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _descriptionController.dispose();
    super.dispose();
  }
}