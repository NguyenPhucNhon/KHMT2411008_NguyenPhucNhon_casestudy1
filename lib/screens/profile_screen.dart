import 'package:flutter/material.dart';

class ProfileScreen extends StatelessWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Cá nhân'),
        centerTitle: true,
        backgroundColor: Colors.white,
        foregroundColor: const Color(0xFF18243A),
        elevation: 0,
      ),
      body: ListView(
        padding: const EdgeInsets.all(20),
        children: [
          const CircleAvatar(
            radius: 36,
            backgroundColor: Color(0xFFDCE9FF),
            child: Icon(Icons.person, size: 42, color: Color(0xFF2878E8)),
          ),
          const SizedBox(height: 12),
          const Center(
            child: Text(
              'Nguyễn Văn A',
              style: TextStyle(fontWeight: FontWeight.bold, fontSize: 17),
            ),
          ),
          const Center(
            child: Text(
              'nguyenvana@example.com',
              style: TextStyle(color: Color(0xFF8993A4)),
            ),
          ),
          const SizedBox(height: 24),
          ...[
            (Icons.person_outline, 'Thông tin cá nhân'),
            (Icons.settings_outlined, 'Cài đặt ngân sách'),
            (Icons.list_alt_outlined, 'Danh mục chi tiêu'),
            (Icons.cloud_upload_outlined, 'Sao lưu dữ liệu'),
            (Icons.lock_outline, 'Đổi mật khẩu'),
          ].map(
            (item) => ListTile(
              leading: Icon(item.$1, color: const Color(0xFF475467)),
              title: Text(item.$2),
              trailing: const Icon(Icons.chevron_right),
              contentPadding: EdgeInsets.zero,
              onTap: () {},
            ),
          ),
          const Divider(),
          ListTile(
            leading: const Icon(Icons.logout, color: Color(0xFFFF3947)),
            title: const Text(
              'Đăng xuất',
              style: TextStyle(color: Color(0xFFFF3947)),
            ),
            contentPadding: EdgeInsets.zero,
            onTap: () {},
          ),
        ],
      ),
    );
  }
}
