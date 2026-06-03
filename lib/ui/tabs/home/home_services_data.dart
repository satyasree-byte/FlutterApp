import 'package:flutter/material.dart';
import 'dart:math';

// ── Auto-updates daily — no manual change needed ──────────────
int get weeklySlots {
  final now = DateTime.now();
  final seed = now.year * 10000 + now.month * 100 + now.day;
  return Random(seed).nextInt(4) + 2; // always 2–5, changes every day
}

class ServiceData {
  final String title;
  final String tagline;
  final String grade;
  final IconData icon;
  final Color color;
  final List<String> bullets;

  const ServiceData({
    required this.title,
    required this.tagline,
    required this.grade,
    required this.icon,
    required this.color,
    required this.bullets,
  });
}

const List<ServiceData> homeServices = [
  ServiceData(
    title: 'Career Guidance After Class 10 & 12',
    tagline: 'Stream Selection · JEE · NEET · What To Do After 12th',
    grade: 'Class 9–12',
    icon: Icons.school_rounded,
    color: Color(0xFF7C3AED),
    bullets: [
      'Confused about Science vs Commerce vs Arts? Talk to a mentor who has been there',
      'Personalised career counselling after Class 10 — not a generic brochure',
      '"What to do after 12th" answered by a real expert, not YouTube videos',
      'JEE, NEET, CLAT, NDA strategy built around your actual strengths',
      'Learn how to use ChatGPT and AI tools to study smarter and score higher',
      'For parents: understand your child\'s options before making the wrong choice',
    ],
  ),
  ServiceData(
    title: 'Get Your First IT Job',
    tagline: 'Fresher Resume · Mock Interview · Campus Placement 2026',
    grade: 'UG / Degree',
    icon: Icons.account_balance_rounded,
    color: Color(0xFF0EA5E9),
    bullets: [
      '"No experience" is not a problem — we help you build a portfolio that gets calls',
      'Resume reviewed by someone who has actually hired freshers at TCS, Infosys, and product companies',
      'Mock interviews modelled on TCS, Infosys, Wipro, and product company rounds',
      'Learn how to use AI to write code, build projects, and stand out on GitHub',
      'LinkedIn profile optimisation that gets recruiter messages — not silence',
      'Know exactly what hiring managers look for in 2026 — not outdated advice from 3 years ago',
    ],
  ),
  ServiceData(
    title: 'Learn AI Tools That Get Real Results',
    tagline: 'ChatGPT · Gemini · Copilot · No Coding Needed',
    grade: 'All Levels',
    icon: Icons.psychology_rounded,
    color: Color(0xFF10B981),
    bullets: [
      'Learn how to use ChatGPT effectively — prompts that actually work',
      'Use AI to write emails, reports, and content 10x faster',
      'Hands-on with Gemini, Copilot, Perplexity — tools top professionals use daily',
      'No coding required — for students, teachers, business owners, and job seekers',
      'Stop using AI wrong: avoid hallucinations, verify outputs, get reliable answers',
      'Build your own AI workflow for studying, working, or running a business',
    ],
  ),
  ServiceData(
    title: 'Switch to a Tech Career with Expert Help',
    tagline: 'QA Automation · SDET · AI/ML Career Switch · Upskilling 2026',
    grade: 'Working Pro',
    icon: Icons.verified_rounded,
    color: Color(0xFFF59E0B),
    bullets: [
      'Feeling stuck in your current job? Plan your switch with someone who made it',
      'QA automation roadmap: Selenium, Playwright, Cypress — in the right order',
      'Resume rewrite targeting SDET, QA Lead, and automation roles at top companies',
      'Learn AI-powered testing tools replacing manual QA in 2026',
      'Mock interviews with real scenario-based questions from top tech companies',
      'Career switch to AI / ML — practical steps, not just theory or YouTube courses',
    ],
  ),
];
