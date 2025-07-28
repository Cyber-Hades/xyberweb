import 'package:flutter/material.dart';
import '../data/models/onboarding_model.dart';


class OnboardingViewModel extends ChangeNotifier {
  final PageController pageController = PageController();
  int currentIndex = 0;

  final List<OnboardingModel> pages = [
    OnboardingModel(
      title: "Workshops",
      description: "Join hands-on workshops led by industry experts.",
      animationAsset: "assets/lottie/internship.json",
    ),
    OnboardingModel(
      title: "Internships",
      description: "Explore internships with real-world experience.",
      animationAsset: "assets/lottie/workshop.json",
    ),
    OnboardingModel(
      title: "Vendor Collaboration",
      description: "Partner with XyberWeb and grow your business.",
      animationAsset: "assets/lottie/business.json",
    ),
  ];

  void updateIndex(int index) {
    currentIndex = index;
    notifyListeners();
  }

  void nextPage(BuildContext context) {
    if (currentIndex < pages.length - 1) {
      pageController.nextPage(
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeInOut,
      );
    }
  }
}
