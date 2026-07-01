import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../config/app_theme.dart';
import '../../providers/auth_provider.dart';

class LoginPage extends StatelessWidget {
  const LoginPage({super.key});

  @override
  Widget build(BuildContext context) {
    final authProvider = context.watch<AuthProvider>();

    return SafeArea(
      child: SingleChildScrollView(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            children: [
              const SizedBox(height: 60),
              // Logo
              Column(
                children: [
                  Container(
                    width: 120,
                    height: 120,
                    decoration: BoxDecoration(
                      gradient: const LinearGradient(
                        colors: [
                          AppTheme.heroFrom,
                          AppTheme.primaryLight,
                          AppTheme.heroTo,
                        ],
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                      ),
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: const Color(0xFFB4A0C8).withOpacity(0.3),
                          blurRadius: 24,
                          offset: const Offset(0, 8),
                        ),
                      ],
                    ),
                    child: const Center(
                      child: Text('🪐', style: TextStyle(fontSize: 50)),
                    ),
                  ),
                  const SizedBox(height: 20),
                  const Text('欢迎回来 ✨',
                      style: TextStyle(
                          fontSize: 28,
                          fontWeight: FontWeight.w700,
                          color: AppTheme.textMain)),
                  const SizedBox(height: 8),
                  const Text('在宇宙中轻松记账吧 ✨',
                      style: TextStyle(
                          fontSize: 14, color: AppTheme.textSub)),
                ],
              ),
              const SizedBox(height: 40),
              // 表单
              TextField(
                decoration: InputDecoration(
                  hintText: '手机号 / 邮箱',
                  hintStyle: const TextStyle(color: AppTheme.textSub),
                  filled: true,
                  fillColor: const Color(0xFFFAFBFE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFE8E0F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFE8E0F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppTheme.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                controller: TextEditingController(text: '138****8888'),
              ),
              const SizedBox(height: 12),
              TextField(
                obscureText: true,
                decoration: InputDecoration(
                  hintText: '密码',
                  hintStyle: const TextStyle(color: AppTheme.textSub),
                  filled: true,
                  fillColor: const Color(0xFFFAFBFE),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFE8E0F0)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide:
                        const BorderSide(color: Color(0xFFE8E0F0)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: const BorderSide(
                        color: AppTheme.primary, width: 1.5),
                  ),
                  contentPadding: const EdgeInsets.symmetric(
                      horizontal: 16, vertical: 14),
                ),
                controller: TextEditingController(text: '········'),
              ),
              // 忘记密码
              Align(
                alignment: Alignment.centerRight,
                child: Padding(
                  padding: const EdgeInsets.only(top: 8, bottom: 20),
                  child: GestureDetector(
                    onTap: () {},
                    child: const Text('忘记密码？',
                        style: TextStyle(
                            fontSize: 13, color: AppTheme.primary)),
                  ),
                ),
              ),
              // 登录按钮
              GestureDetector(
                onTap: () {
                  authProvider.login('138****8888', 'password');
                },
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  decoration: BoxDecoration(
                    gradient: const LinearGradient(
                      colors: [AppTheme.primary, AppTheme.primaryDark],
                    ),
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: AppTheme.primary.withOpacity(0.3),
                        blurRadius: 12,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Center(
                    child: authProvider.isLoading
                        ? const SizedBox(
                            width: 20,
                            height: 20,
                            child: CircularProgressIndicator(
                                strokeWidth: 2, color: Colors.white))
                        : const Text('登 录',
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                                fontWeight: FontWeight.w600)),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              const Row(
                children: [
                  Expanded(child: Divider(color: Color(0xFFE0D4F0))),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Text('其他方式快速登录',
                        style: TextStyle(
                            fontSize: 13, color: AppTheme.textSub)),
                  ),
                  Expanded(child: Divider(color: Color(0xFFE0D4F0))),
                ],
              ),
              const SizedBox(height: 20),
              // 社交登录
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  _buildSocialBtn('QQ', const Color(0xFF12B7F5)),
                  const SizedBox(width: 20),
                  _buildSocialBtn('微信', const Color(0xFF07C160)),
                  const SizedBox(width: 20),
                  _buildSocialBtn('手机', AppTheme.primary),
                ],
              ),
              const SizedBox(height: 32),
              // 注册链接
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Text('还没有账号？',
                      style: TextStyle(
                          fontSize: 14, color: AppTheme.textSub)),
                  GestureDetector(
                    onTap: () {},
                    child: const Text('立即注册',
                        style: TextStyle(
                            fontSize: 14,
                            color: AppTheme.primary,
                            fontWeight: FontWeight.w600)),
                  ),
                ],
              ),
              const SizedBox(height: 40),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSocialBtn(String label, Color color) {
    IconData icon;
    switch (label) {
      case 'QQ':
        icon = Icons.chat_bubble_outline;
        break;
      case '微信':
        icon = Icons.wechat;
        break;
      default:
        icon = Icons.phone_android;
    }
    return Container(
      width: 48,
      height: 48,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: const Color(0xFFFAFBFE),
        border: Border.all(color: const Color(0xFFE8E0F0)),
      ),
      child: Center(
        child: Icon(icon, size: 22, color: color),
      ),
    );
  }
}
