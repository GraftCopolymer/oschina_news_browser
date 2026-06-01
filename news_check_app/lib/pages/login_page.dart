import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:news_check_app/pages/oschina_login_page.dart';
import 'package:news_check_app/theme/app_colors.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animController;
  late final Animation<double> _logoFadeIn;
  late final Animation<Offset> _buttonSlideUp;

  @override
  void initState() {
    super.initState();
    _animController = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 1200),
    );
    _logoFadeIn = Tween<double>(begin: 0, end: 1).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.0, 0.6, curve: Curves.easeIn),
      ),
    );
    _buttonSlideUp = Tween<Offset>(
      begin: const Offset(0, 40),
      end: Offset.zero,
    ).animate(
      CurvedAnimation(
        parent: _animController,
        curve: const Interval(0.4, 1.0, curve: Curves.easeOutBack),
      ),
    );
    _animController.forward();
  }

  @override
  void dispose() {
    _animController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        width: double.infinity,
        height: double.infinity,
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            colors: [Color(0xFF0D9488), Color(0xFF1E3A5F)],
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              const Spacer(flex: 2),
              // Logo 和品牌文字
              FadeTransition(
                opacity: _logoFadeIn,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    ClipOval(
                      child: Image.asset(
                        "assets/oschina_logo.png",
                        width: 100,
                        height: 100,
                        fit: BoxFit.cover,
                      ),
                    ),
                    const SizedBox(height: 24),
                    const Text(
                      "开发者资讯",
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      "发现最新的技术资讯",
                      style: TextStyle(
                        color: Colors.white.withAlpha(153),
                        fontSize: 16,
                      ),
                    ),
                  ],
                ),
              ),
              const Spacer(flex: 1),
              // 登录按钮
              SlideTransition(
                position: _buttonSlideUp,
                child: Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 40),
                  child: SizedBox(
                    width: double.infinity,
                    height: 52,
                    child: ElevatedButton(
                      onPressed: () {
                        Get.to(() => OschinaLoginPage(
                          onLoginSuccess: (token) {
                            Get.back();
                            Get.back();
                          },
                        ));
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.white,
                        foregroundColor: AppColors.primary,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(26),
                        ),
                        elevation: 2,
                      ),
                      child: const Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Text(
                            "使用 OSCHINA 登录",
                            style: TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(width: 8),
                          Icon(Icons.arrow_forward),
                        ],
                      ),
                    ),
                  ),
                ),
              ),
              const SizedBox(height: 20),
              Text(
                "使用 OSCHINA 账号一键登录",
                style: TextStyle(
                  color: Colors.white.withAlpha(128),
                  fontSize: 13,
                ),
              ),
              const Spacer(flex: 1),
            ],
          ),
        ),
      ),
    );
  }
}