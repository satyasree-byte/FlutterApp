import 'package:flutter/material.dart';

class StatItem {
  final String value;
  final String label;
  final IconData icon;
  const StatItem({required this.value, required this.label, required this.icon});
}

class ReasonItem {
  final IconData icon;
  final String title;
  final String description;
  final Color color;
  const ReasonItem({
    required this.icon,
    required this.title,
    required this.description,
    required this.color,
  });
}


const List<StatItem> whyChooseStats = [
  StatItem(value: '1-on-1', label: 'Real Expert Sessions', icon: Icons.person_rounded),
  StatItem(value: '24 hrs', label: 'Response Guarantee', icon: Icons.timer_rounded),
  StatItem(value: '4', label: 'Focused Service Areas', icon: Icons.category_rounded),
  StatItem(value: '5+ yrs', label: 'Active in Industry', icon: Icons.workspace_premium_rounded),
];

const List<ReasonItem> whyChooseReasons = [
  ReasonItem(
    icon: Icons.person_search_rounded,
    title: 'Real Experts, Not Bots',
    description: 'Every session is with a professional who has actually worked in your target field — not an algorithm, not a generic counsellor.',
    color: Color(0xFF7C3AED),
  ),
  ReasonItem(
    icon: Icons.psychology_rounded,
    title: 'Practical AI Training',
    description: 'We teach you how to use ChatGPT, Gemini, Copilot, and other AI tools effectively — with hands-on practice, not just theory.',
    color: Color(0xFF0EA5E9),
  ),
  ReasonItem(
    icon: Icons.flag_rounded,
    title: 'Guidance That Gets It',
    description: 'Career advice built around CBSE/ICSE boards, local hiring realities, and what actually gets results here — not generic advice copy-pasted from abroad.',
    color: Color(0xFF10B981),
  ),
  ReasonItem(
    icon: Icons.bolt_rounded,
    title: 'Fast, Focused Sessions',
    description: 'No long courses, no fluff. One focused session gives you a clear next step — whether it\'s stream selection, a job switch, or learning a new tool.',
    color: Color(0xFFF59E0B),
  ),
  ReasonItem(
    icon: Icons.lock_open_rounded,
    title: 'No Lock-ins',
    description: 'Pay only for what you need. Single sessions, no subscriptions, no hidden fees — start with one conversation and go from there.',
    color: Color(0xFFEF4444),
  ),
  ReasonItem(
    icon: Icons.devices_rounded,
    title: '100% Online',
    description: 'Book and attend from anywhere. WhatsApp, video call, or email — you choose how you want to connect with your expert.',
    color: Color(0xFFEC4899),
  ),
];

