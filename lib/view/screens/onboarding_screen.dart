import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:lottie/lottie.dart';
import 'package:xyberweb/view/screens/auth_screen.dart';
import '../../view_model/onboarding_view_model.dart';
import 'login_screen.dart';
import 'register_screen.dart';
import 'package:google_fonts/google_fonts.dart';

class OnboardingScreen extends StatelessWidget {
  const OnboardingScreen({super.key});

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;

    return ChangeNotifierProvider(
      create: (_) => OnboardingViewModel(),
      child: Consumer<OnboardingViewModel>(
        builder: (context, viewModel, child) {
          return Scaffold(
            backgroundColor: Colors.white,
            body: Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.06),
              child: Column(
                children: [
                  Expanded(
                    child: PageView.builder(
                      controller: viewModel.pageController,
                      itemCount: viewModel.pages.length,
                      onPageChanged: viewModel.updateIndex,
                      itemBuilder: (context, index) {
                        final page = viewModel.pages[index];
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Lottie.asset(
                              page.animationAsset,
                              height: screenHeight * 0.35,
                            ),
                            SizedBox(height: screenHeight * 0.035),
                            Text(
                              page.title,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth * 0.065,
                                fontWeight: FontWeight.w700,
                                color: Colors.black87,
                                fontFamily: GoogleFonts.poppins().fontFamily,
                              ),
                            ),
                            SizedBox(height: screenHeight * 0.015),
                            Text(
                              page.description,
                              textAlign: TextAlign.center,
                              style: TextStyle(
                                fontSize: screenWidth * 0.045,
                                color: Colors.grey.shade700,
                                height: 1.5,
                                fontFamily: GoogleFonts.roboto().fontFamily,
                              ),
                            ),
                          ],
                        );
                      },
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.02),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: List.generate(
                      viewModel.pages.length,
                          (index) => AnimatedContainer(
                        duration: const Duration(milliseconds: 300),
                        margin: const EdgeInsets.symmetric(horizontal: 4),
                        width: viewModel.currentIndex == index ? 16 : 8,
                        height: 8,
                        decoration: BoxDecoration(
                          color: viewModel.currentIndex == index
                              ? Colors.blueAccent
                              : Colors.grey.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.03),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      TextButton(
                        onPressed: viewModel.currentIndex == viewModel.pages.length - 1
                            ? null
                            : () {
                          Navigator.pushReplacement(
                            context,
                            MaterialPageRoute(builder: (_) => const AuthScreen()),
                          );
                        },
                        child: Text(
                          "Skip",
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            color: viewModel.currentIndex == viewModel.pages.length - 1
                                ? Colors.grey
                                : Colors.blueAccent,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                      ElevatedButton(
                        onPressed: () {
                          if (viewModel.currentIndex == viewModel.pages.length - 1) {
                            Navigator.pushReplacement(
                              context,
                              MaterialPageRoute(builder: (_) => const AuthScreen()),
                            );
                          } else {
                            viewModel.nextPage(context);
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blueAccent,
                          foregroundColor: Colors.white,
                          elevation: 4,
                          shadowColor: Colors.blue.shade100,
                          padding: EdgeInsets.symmetric(
                            horizontal: screenWidth * 0.08,
                            vertical: screenHeight * 0.016,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          viewModel.currentIndex == viewModel.pages.length - 1 ? "Continue" : "Next",
                          style: TextStyle(
                            fontSize: screenWidth * 0.045,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: screenHeight * 0.04),
                ],
              ),
            ),
          );
        },
      ),
    );
  }
}
