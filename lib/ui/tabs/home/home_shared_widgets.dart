import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import '../services/bookServiceForm.dart';
import 'home_services_data.dart';
import '../../../data/language_notifier.dart';

// ── Service tile card ─────────────────────────────────────────
class ServiceTile extends StatefulWidget {
  final ServiceData service;
  final bool active;
  final VoidCallback onTap;
  const ServiceTile({Key? key, required this.service, required this.active, required this.onTap})
      : super(key: key);

  @override
  State<ServiceTile> createState() => _ServiceTileState();
}

class _ServiceTileState extends State<ServiceTile> {
  bool _hovered = false;

  @override
  Widget build(BuildContext context) {
    final s = widget.service;
    final highlight = widget.active || _hovered;
    return MouseRegion(
      onEnter: (_) => setState(() => _hovered = true),
      onExit: (_) => setState(() => _hovered = false),
      child: GestureDetector(
        onTap: widget.onTap,
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 250),
          curve: Curves.easeOut,
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            color: highlight ? s.color.withOpacity(0.18) : Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(22),
            border: Border.all(
              color: highlight ? s.color.withOpacity(0.8) : Colors.white.withOpacity(0.1),
              width: widget.active ? 2 : 1.2,
            ),
            boxShadow: highlight
                ? [BoxShadow(color: s.color.withOpacity(0.3), blurRadius: 28, offset: const Offset(0, 10))]
                : [],
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.all(12),
                decoration: BoxDecoration(
                  color: s.color.withOpacity(highlight ? 0.28 : 0.15),
                  borderRadius: BorderRadius.circular(14),
                ),
                child: Icon(s.icon, color: s.color, size: 28),
              ),
              const SizedBox(height: 16),
              Text(s.title,
                  style: GoogleFonts.poppins(
                      color: Colors.white, fontSize: 16, fontWeight: FontWeight.w700)),
              const SizedBox(height: 6),
              Text(s.tagline,
                  style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
              const SizedBox(height: 16),
              Text(
                widget.active ? 'Selected  ✓' : 'Explore →',
                style: GoogleFonts.poppins(
                  color: widget.active ? s.color : Colors.white38,
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// ── Expanded content panel ────────────────────────────────────
class ContentPanel extends StatelessWidget {
  final ServiceData service;
  final bool isDesktop;
  const ContentPanel({Key? key, required this.service, this.isDesktop = false}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final s = service;
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(isDesktop ? 40 : 28),
      decoration: BoxDecoration(
        color: s.color.withOpacity(0.08),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: s.color.withOpacity(0.35), width: 1.5),
      ),
      child: isDesktop
          ? Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  width: 280,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: s.color.withOpacity(0.2),
                          borderRadius: BorderRadius.circular(16),
                        ),
                        child: Icon(s.icon, color: s.color, size: 36),
                      ),
                      const SizedBox(height: 20),
                      Text(s.title,
                          style: GoogleFonts.poppins(
                              color: Colors.white, fontSize: 24, fontWeight: FontWeight.w800)),
                      const SizedBox(height: 8),
                      Text(s.tagline,
                          style: GoogleFonts.poppins(color: Colors.white54, fontSize: 14)),
                      const SizedBox(height: 28),
                      _bookButton(context, s.color),
                    ],
                  ),
                ),
                const SizedBox(width: 40),
                Container(width: 1, color: s.color.withOpacity(0.2)),
                const SizedBox(width: 40),
                Expanded(
                  child: Wrap(
                    spacing: 16,
                    runSpacing: 14,
                    children: s.bullets.map((b) => _bullet(b, s.color)).toList(),
                  ),
                ),
              ],
            )
          : Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Container(
                      padding: const EdgeInsets.all(12),
                      decoration: BoxDecoration(
                        color: s.color.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Icon(s.icon, color: s.color, size: 28),
                    ),
                    const SizedBox(width: 14),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(s.title,
                              style: GoogleFonts.poppins(
                                  color: Colors.white, fontSize: 18, fontWeight: FontWeight.w800)),
                          Text(s.tagline,
                              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12)),
                        ],
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 20),
                ...s.bullets.map((b) => Padding(
                      padding: const EdgeInsets.only(bottom: 10),
                      child: _bullet(b, s.color),
                    )),
                const SizedBox(height: 24),
                _bookButton(context, s.color),
              ],
            ),
    );
  }

  Widget _bullet(String text, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: const EdgeInsets.only(top: 7, right: 10),
          width: 6,
          height: 6,
          decoration: BoxDecoration(shape: BoxShape.circle, color: color),
        ),
        Flexible(
          child: Text(text,
              style: GoogleFonts.poppins(
                  color: Colors.white.withOpacity(0.8), fontSize: 14, height: 1.6)),
        ),
      ],
    );
  }

  Widget _bookButton(BuildContext context, Color color) {
    return Container(
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [color, color.withOpacity(0.7)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(color: color.withOpacity(0.4), blurRadius: 18, offset: const Offset(0, 6))
        ],
      ),
      child: Material(
        color: Colors.transparent,
        child: InkWell(
          borderRadius: BorderRadius.circular(30),
          onTap: () => Navigator.push(context, MaterialPageRoute(builder: (_) => BookingForm())),
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 28, vertical: 14),
            child: Text('Book a Session  →',
                style: GoogleFonts.poppins(
                    color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          ),
        ),
      ),
    );
  }
}

// ── Expert Network Section ────────────────────────────────────
class ExpertCard extends StatelessWidget {
  final bool isDesktop;
  const ExpertCard({Key? key, this.isDesktop = false}) : super(key: key);

  static const _experts = [
    _ExpertDomain(
      icon: Icons.school_rounded,
      color: Color(0xFF7C3AED),
      role: 'School & Career Counsellor',
      domain: 'Class 9–12 · Stream Selection · Entrance Exams',
      tag: 'Education Specialist',
    ),
    _ExpertDomain(
      icon: Icons.account_balance_rounded,
      color: Color(0xFF0EA5E9),
      role: 'Campus Placement Mentor',
      domain: 'Fresher Resumes · Mock Interviews · First IT Job',
      tag: 'IT Industry Professional',
    ),
    _ExpertDomain(
      icon: Icons.psychology_rounded,
      color: Color(0xFF10B981),
      role: 'AI & Tech Skills Coach',
      domain: 'ChatGPT · Gemini · Copilot · AI for Work',
      tag: 'AI Practitioner',
    ),
    _ExpertDomain(
      icon: Icons.verified_rounded,
      color: Color(0xFFF59E0B),
      role: 'QA & Career Switch Coach',
      domain: 'Automation · SDET · Career Transition',
      tag: 'QA Lead / SDET',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        ValueListenableBuilder<bool>(
          valueListenable: isHinglish,
          builder: (_, hi, __) => RichText(
            textAlign: TextAlign.center,
            text: TextSpan(
              style: hi
                  ? GoogleFonts.hindMadurai(
                      fontSize: isDesktop ? 36 : 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white)
                  : GoogleFonts.poppins(
                      fontSize: isDesktop ? 36 : 24,
                      fontWeight: FontWeight.w800,
                      color: Colors.white),
              children: [
                TextSpan(text: hi ? 'बात करो ' : 'You Talk to '),
                TextSpan(
                  text: hi ? 'असली Experts से' : 'Real Experts',
                  style: const TextStyle(color: Colors.amberAccent),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: isDesktop ? 36 : 24),

        // Expert domain cards
        isDesktop
            ? Row(
                children: _experts.asMap().entries.map((e) => Expanded(
                  child: Padding(
                    padding: EdgeInsets.only(right: e.key < _experts.length - 1 ? 16 : 0),
                    child: _domainCard(e.value),
                  ),
                )).toList(),
              )
            : Column(
                children: _experts.map((e) => Padding(
                  padding: const EdgeInsets.only(bottom: 12),
                  child: _domainCard(e),
                )).toList(),
              ),

      ],
    );
  }

  Widget _domainCard(_ExpertDomain e) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: e.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: e.color.withOpacity(0.25), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: e.color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(e.icon, color: e.color, size: 20),
              ),
              const SizedBox(width: 10),
              Expanded(
                child: Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: e.color.withOpacity(0.12),
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Text(e.tag,
                      style: GoogleFonts.poppins(color: e.color, fontSize: 10, fontWeight: FontWeight.w700)),
                ),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(e.role,
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
          const SizedBox(height: 4),
          Text(e.domain,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11, height: 1.4)),
          const SizedBox(height: 14),
          Row(
            children: [
              Container(width: 7, height: 7,
                  decoration: const BoxDecoration(color: Color(0xFF10B981), shape: BoxShape.circle)),
              const SizedBox(width: 6),
              Text('Available now',
                  style: GoogleFonts.poppins(color: const Color(0xFF10B981), fontSize: 11, fontWeight: FontWeight.w600)),
            ],
          ),
        ],
      ),
    );
  }

}

class _ExpertDomain {
  final IconData icon;
  final Color color;
  final String role;
  final String domain;
  final String tag;
  const _ExpertDomain({
    required this.icon,
    required this.color,
    required this.role,
    required this.domain,
    required this.tag,
  });
}

// ── AI Tools Section ─────────────────────────────────────────
class AiToolsSection extends StatelessWidget {
  final bool isDesktop;
  const AiToolsSection({Key? key, this.isDesktop = false}) : super(key: key);

  static const _tools = [
    _AiTool(Icons.chat_bubble_outline_rounded, 'ChatGPT', 'How to use ChatGPT effectively — prompts, research, writing, problem-solving', Color(0xFF10B981)),
    _AiTool(Icons.auto_awesome_rounded, 'Google Gemini', 'Summarise notes, analyse documents, plan projects in seconds', Color(0xFF0EA5E9)),
    _AiTool(Icons.code_rounded, 'GitHub Copilot', 'Write, debug, and review code 10x faster — even as a beginner', Color(0xFF7C3AED)),
    _AiTool(Icons.manage_search_rounded, 'Perplexity AI', 'Research smarter — get cited answers instead of endless scrolling', Color(0xFF06B6D4)),
    _AiTool(Icons.record_voice_over_rounded, 'AI for Presentations', 'Build slides, demos, and explainer videos using AI in minutes', Color(0xFFEC4899)),
    _AiTool(Icons.auto_fix_high_rounded, 'AI Writing Tools', 'Emails, cover letters, reports — written professionally with AI assistance', Color(0xFFF59E0B)),
  ];

  static const _outcomes = [
    _Outcome('Score Higher in Exams', 'Use AI to break down hard topics, create revision plans, and get instant explanations — personalised to your syllabus.', Icons.bolt_rounded, Color(0xFF7C3AED)),
    _Outcome('Get Shortlisted Faster', 'AI-optimised resume and LinkedIn that match what recruiters are actually searching for — get found, not filtered out.', Icons.work_outline_rounded, Color(0xFF0EA5E9)),
    _Outcome('Work 10x More Efficiently', 'Learn to use AI tools daily so you finish in hours what others take days to do — and stand out in your organisation.', Icons.speed_rounded, Color(0xFF10B981)),
    _Outcome('Switch Careers with Confidence', 'A clear roadmap, the right skills, and an expert who has already made the move — so you are not figuring it out alone.', Icons.trending_up_rounded, Color(0xFFF59E0B)),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // ── Heading ──
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.poppins(
                fontSize: isDesktop ? 36 : 24, fontWeight: FontWeight.w800, color: Colors.white),
            children: const [
              TextSpan(text: 'How to Use '),
              TextSpan(text: 'AI Tools Effectively', style: TextStyle(color: Colors.amberAccent)),
            ],
          ),
        ),
        SizedBox(height: isDesktop ? 36 : 24),

        // ── Tool cards ──
        isDesktop
            ? Wrap(
                spacing: 16,
                runSpacing: 16,
                children: _tools
                    .map((t) => SizedBox(
                          width: 260,
                          child: _toolCard(t),
                        ))
                    .toList(),
              )
            : Column(children: _tools.map((t) => Padding(padding: const EdgeInsets.only(bottom: 12), child: _toolCard(t))).toList()),

        SizedBox(height: isDesktop ? 56 : 40),

        // ── What you get heading ──
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.poppins(
                fontSize: isDesktop ? 36 : 24, fontWeight: FontWeight.w800, color: Colors.white),
            children: const [
              TextSpan(text: 'Real Results, '),
              TextSpan(text: 'Not Just Advice', style: TextStyle(color: Colors.amberAccent)),
            ],
          ),
        ),
        SizedBox(height: isDesktop ? 36 : 24),

        // ── Outcome cards ──
        isDesktop
            ? Row(
                children: _outcomes
                    .map((o) => Expanded(
                          child: Padding(
                            padding: EdgeInsets.only(right: _outcomes.last == o ? 0 : 16),
                            child: _outcomeCard(o),
                          ),
                        ))
                    .toList(),
              )
            : Column(
                children: _outcomes
                    .map((o) => Padding(
                          padding: const EdgeInsets.only(bottom: 12),
                          child: _outcomeCard(o),
                        ))
                    .toList(),
              ),
      ],
    );
  }

  Widget _toolCard(_AiTool t) {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: t.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: t.color.withOpacity(0.25), width: 1.2),
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: t.color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(t.icon, color: t.color, size: 22),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(t.name,
                    style: GoogleFonts.poppins(
                        color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700)),
                const SizedBox(height: 3),
                Text(t.description,
                    style: GoogleFonts.poppins(color: Colors.white54, fontSize: 11, height: 1.4)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _outcomeCard(_Outcome o) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: o.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: o.color.withOpacity(0.25), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: o.color.withOpacity(0.18),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(o.icon, color: o.color, size: 22),
          ),
          const SizedBox(height: 14),
          Text(o.title,
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(o.description,
              style: GoogleFonts.poppins(color: Colors.white54, fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }
}

class _AiTool {
  final IconData icon;
  final String name;
  final String description;
  final Color color;
  const _AiTool(this.icon, this.name, this.description, this.color);
}

class _Outcome {
  final String title;
  final String description;
  final IconData icon;
  final Color color;
  const _Outcome(this.title, this.description, this.icon, this.color);
}

// ── Free Resources Section ────────────────────────────────────
class HomeResourcesSection extends StatefulWidget {
  final bool isDesktop;
  const HomeResourcesSection({Key? key, this.isDesktop = false}) : super(key: key);

  @override
  State<HomeResourcesSection> createState() => _HomeResourcesSectionState();
}

class _HomeResourcesSectionState extends State<HomeResourcesSection> {
  int? _expanded;

  static const _articles = [
    _Article(
      icon: Icons.school_rounded,
      color: Color(0xFF7C3AED),
      title: 'What to Do After Class 12 — Honest Guide 2026',
      teaser: 'Most students spend months confused about this. Science, Commerce, Arts — the real story behind each path nobody tells you.',
      readTime: '5 min read',
      content: [
        'Look, nobody tells you this straight — so let me.',
        'Most students after Class 12 are not confused because they don\'t have options. They\'re confused because they have too many, and every adult around them has a different opinion.',
        'Your relatives say engineering. Your friends say BBA is easy. YouTube says start a startup. Your parents say "just get a government job." And somewhere in the middle of all that noise, you have to make a decision that will shape the next 4 years of your life.',
        'Here\'s what actually matters:',
        '→ If you took Science and genuinely enjoy problem-solving, JEE and NEET are worth considering — but only if you can give them a real shot. A half-hearted JEE attempt followed by a low-tier private engineering college is not the path. Be honest with yourself.',
        '→ If you took Commerce and you\'re good with numbers, CA is one of the most respected qualifications you can hold. Hard, yes. But it opens doors that a regular BCom simply does not.',
        '→ If you took Arts, stop feeling like you made a mistake. Law (CLAT), journalism, design, psychology — these fields are growing. The stigma is from a different era.',
        '→ If you\'re not sure what you want — that\'s completely normal. A lot of students who rush into engineering or medicine because it "sounds safe" end up switching after 2 years anyway. Taking time to talk to someone actually working in that field is worth more than a month of YouTube research.',
        'One session with someone who has actually been through this — not a counsellor reading from a brochure, but a real person — cuts through the confusion faster than a month of research.',
        'That\'s exactly what we do at Eduvise.',
      ],
    ),
    _Article(
      icon: Icons.psychology_rounded,
      color: Color(0xFF10B981),
      title: 'How to Use ChatGPT Effectively in 2026 — What Actually Works',
      teaser: 'Most people use ChatGPT wrong. They get bad answers, lose trust, and stop. Here\'s how to actually get results from it every day.',
      readTime: '6 min read',
      content: [
        'I\'ve watched a lot of people try ChatGPT for the first time. They type something like "tell me about marketing" and get a 500-word essay that\'s technically correct and completely useless.',
        'Then they say "AI is overhyped" and close the tab.',
        'That\'s not a ChatGPT problem. That\'s a prompting problem.',
        'Here\'s the difference between a bad prompt and a good one:',
        'Bad: "How do I prepare for a job interview?"',
        'Good: "I have an interview at Infosys next week for a fresher software developer role. I have done 2 college projects in Python. Give me 5 questions they are likely to ask, and tell me how to answer them based on my background."',
        'The second prompt gives ChatGPT context. And context is everything.',
        '→ Always tell it who you are. Student, professional, what field, what level.',
        '→ Always tell it what you want to do with the answer. "Explain this so I can teach it to someone" gets a different answer than "explain this so I can use it at work tomorrow."',
        '→ If the first answer is not good, push back. Say "that\'s too generic, give me something more specific to my situation" or "make it shorter." ChatGPT responds well to feedback in the same conversation.',
        'One thing people get wrong: they treat it like a search engine. It\'s not. It\'s more like a very well-read colleague who needs context from you to be useful.',
        'For students: use it to break down tough concepts, not to write your assignments. The moment you stop thinking and just paste its output, you stop learning.',
        'For professionals: use it to draft emails, prepare for meetings, summarise long documents. It saves hours every week once you build it into your workflow.',
        'The people who are getting real value from AI in 2026 are not the ones with the fanciest tools. They\'re the ones who learned how to ask better questions.',
      ],
    ),
    _Article(
      icon: Icons.work_rounded,
      color: Color(0xFF0EA5E9),
      title: 'How to Get Your First IT Job With No Experience — 2026',
      teaser: 'The "no experience, no job" trap is real. But there\'s a way out — and it\'s not another certification course.',
      readTime: '7 min read',
      content: [
        'Here\'s the trap most freshers fall into:',
        'You apply to 200 companies on Naukri. You hear nothing. You think "maybe I need one more certification." You do a 3-month course. You apply again. Still nothing. You start to wonder if something is wrong with you.',
        'Nothing is wrong with you. The approach is wrong.',
        'Companies like TCS, Infosys, and Wipro hire thousands of freshers every year through campus drives and their own portals. But they get hundreds of applications for every slot. Your resume needs to stand out in 10 seconds.',
        'Here\'s what actually gets calls in 2026:',
        '→ Your GitHub matters more than your GPA. One real project with clean code tells a recruiter more than a 8.5 CGPA with no practical work. Pick one small project, build it properly, put it on GitHub, and link it on your resume.',
        '→ Your LinkedIn headline is wasted space for most freshers. Instead of "Computer Science Student at XYZ College," write "Aspiring Java Developer | Built 2 projects in Spring Boot | Looking for first IT role in Bangalore." Recruiters search LinkedIn. Make it searchable.',
        '→ Referrals still work better than cold applications. If you know anyone — a senior, a cousin, a family friend — working at any IT company, ask them to forward your resume internally. Not for a job, just a forward. That alone doubles your chance of getting a call.',
        '→ Mock interviews are not optional. Most freshers who fail interviews don\'t fail because they don\'t know the answers. They fail because they\'ve never practiced saying the answers out loud to another person. It feels completely different from knowing it in your head.',
        'The honest truth: landing your first IT job is a skill in itself — completely separate from your technical skills. And no college teaches it.',
        'That\'s the gap we help close — one session at a time.',
      ],
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.poppins(
                fontSize: widget.isDesktop ? 36 : 24,
                fontWeight: FontWeight.w800,
                color: Colors.white),
            children: const [
              TextSpan(text: 'Free Guides — '),
              TextSpan(text: 'Real Answers', style: TextStyle(color: Colors.amberAccent)),
            ],
          ),
        ),
        SizedBox(height: widget.isDesktop ? 36 : 24),
        ...List.generate(_articles.length, (i) {
          final a = _articles[i];
          final open = _expanded == i;
          return Padding(
            padding: const EdgeInsets.only(bottom: 14),
            child: _ArticleCard(
              article: a,
              isOpen: open,
              onTap: () => setState(() => _expanded = open ? null : i),
            ),
          );
        }),
      ],
    );
  }
}

class _ArticleCard extends StatelessWidget {
  final _Article article;
  final bool isOpen;
  final VoidCallback onTap;
  const _ArticleCard({required this.article, required this.isOpen, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final a = article;
    return AnimatedContainer(
      duration: const Duration(milliseconds: 300),
      curve: Curves.easeOut,
      decoration: BoxDecoration(
        color: isOpen ? a.color.withOpacity(0.08) : Colors.white.withOpacity(0.03),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(
          color: isOpen ? a.color.withOpacity(0.4) : Colors.white.withOpacity(0.08),
          width: isOpen ? 1.5 : 1,
        ),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Header — always visible
          InkWell(
            onTap: onTap,
            borderRadius: BorderRadius.circular(18),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: a.color.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(a.icon, color: a.color, size: 20),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(a.title,
                            style: GoogleFonts.poppins(
                                color: Colors.white, fontSize: 14, fontWeight: FontWeight.w700, height: 1.4)),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.schedule_rounded, color: Colors.white38, size: 12),
                            const SizedBox(width: 4),
                            Text(a.readTime,
                                style: GoogleFonts.poppins(color: Colors.white38, fontSize: 11)),
                          ],
                        ),
                      ],
                    ),
                  ),
                  const SizedBox(width: 10),
                  AnimatedRotation(
                    turns: isOpen ? 0.5 : 0,
                    duration: const Duration(milliseconds: 300),
                    child: Icon(Icons.keyboard_arrow_down_rounded,
                        color: isOpen ? a.color : Colors.white38, size: 22),
                  ),
                ],
              ),
            ),
          ),

          // Expanded content
          if (isOpen) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 4),
              child: Text(a.teaser,
                  style: GoogleFonts.poppins(
                      color: a.color.withOpacity(0.9), fontSize: 13,
                      fontStyle: FontStyle.italic, height: 1.5)),
            ),
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 12, 20, 20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Container(height: 1, color: a.color.withOpacity(0.15)),
                  const SizedBox(height: 16),
                  ...a.content.map((para) => Padding(
                        padding: const EdgeInsets.only(bottom: 12),
                        child: Text(para,
                            style: GoogleFonts.poppins(
                                color: para.startsWith('→')
                                    ? Colors.white.withOpacity(0.85)
                                    : Colors.white60,
                                fontSize: 13,
                                height: 1.7,
                                fontWeight: para.startsWith('→')
                                    ? FontWeight.w600
                                    : FontWeight.normal)),
                      )),
                ],
              ),
            ),
          ],
        ],
      ),
    );
  }
}

class _Article {
  final IconData icon;
  final Color color;
  final String title;
  final String teaser;
  final String readTime;
  final List<String> content;
  const _Article({
    required this.icon,
    required this.color,
    required this.title,
    required this.teaser,
    required this.readTime,
    required this.content,
  });
}

// ── How It Works Section ──────────────────────────────────────
class HowItWorksSection extends StatelessWidget {
  final bool isDesktop;
  const HowItWorksSection({Key? key, this.isDesktop = false}) : super(key: key);

  static const _steps = [
    _Step(
      number: '01',
      icon: Icons.touch_app_rounded,
      color: Color(0xFF7C3AED),
      title: 'Book a Free Session',
      description: 'Fill a short form — name, what you need, and when. Takes under 2 minutes. No payment upfront.',
    ),
    _Step(
      number: '02',
      icon: Icons.person_search_rounded,
      color: Color(0xFF0EA5E9),
      title: 'We Match You to an Expert',
      description: 'We pair you with someone who has actually worked in your target field — not a generalist.',
    ),
    _Step(
      number: '03',
      icon: Icons.video_call_rounded,
      color: Color(0xFF10B981),
      title: 'Your 1-on-1 Session',
      description: 'Meet on WhatsApp, Zoom, or Google Meet. One focused conversation. Real, actionable direction.',
    ),
    _Step(
      number: '04',
      icon: Icons.bolt_rounded,
      color: Color(0xFFF59E0B),
      title: 'Walk Away with a Clear Next Step',
      description: 'No vague advice. You leave knowing exactly what to do next — and how to do it.',
    ),
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        RichText(
          textAlign: TextAlign.center,
          text: TextSpan(
            style: GoogleFonts.poppins(
                fontSize: isDesktop ? 36 : 24,
                fontWeight: FontWeight.w800,
                color: Colors.white),
            children: const [
              TextSpan(text: 'How It '),
              TextSpan(text: 'Works', style: TextStyle(color: Colors.amberAccent)),
            ],
          ),
        ),
        SizedBox(height: isDesktop ? 40 : 28),
        isDesktop
            ? Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: _steps.asMap().entries.map((entry) {
                  final i = entry.key;
                  final s = entry.value;
                  return Expanded(
                    child: Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child: _stepCard(s)),
                        if (i < _steps.length - 1)
                          Padding(
                            padding: const EdgeInsets.only(top: 36),
                            child: Icon(Icons.arrow_forward_rounded,
                                color: Colors.white12, size: 22),
                          ),
                      ],
                    ),
                  );
                }).toList(),
              )
            : Column(
                children: _steps.map((s) => Padding(
                  padding: const EdgeInsets.only(bottom: 14),
                  child: _stepCard(s),
                )).toList(),
              ),
      ],
    );
  }

  Widget _stepCard(_Step s) {
    return Container(
      padding: const EdgeInsets.all(22),
      decoration: BoxDecoration(
        color: s.color.withOpacity(0.07),
        borderRadius: BorderRadius.circular(18),
        border: Border.all(color: s.color.withOpacity(0.2), width: 1.2),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(s.number,
                  style: GoogleFonts.poppins(
                      color: s.color.withOpacity(0.35),
                      fontSize: 36,
                      fontWeight: FontWeight.w900,
                      height: 1)),
              const Spacer(),
              Container(
                padding: const EdgeInsets.all(10),
                decoration: BoxDecoration(
                  color: s.color.withOpacity(0.18),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Icon(s.icon, color: s.color, size: 20),
              ),
            ],
          ),
          const SizedBox(height: 14),
          Text(s.title,
              style: GoogleFonts.poppins(
                  color: Colors.white, fontSize: 15, fontWeight: FontWeight.w700)),
          const SizedBox(height: 6),
          Text(s.description,
              style: GoogleFonts.poppins(
                  color: Colors.white54, fontSize: 12, height: 1.5)),
        ],
      ),
    );
  }
}

class _Step {
  final String number;
  final IconData icon;
  final Color color;
  final String title;
  final String description;
  const _Step({
    required this.number,
    required this.icon,
    required this.color,
    required this.title,
    required this.description,
  });
}


// ── CTA banner ────────────────────────────────────────────────
class HomeCTABanner extends StatelessWidget {
  const HomeCTABanner({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.symmetric(vertical: 48, horizontal: 40),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFF7C3AED), Color(0xFF0EA5E9)],
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
        ),
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          ValueListenableBuilder<bool>(
            valueListenable: isHinglish,
            builder: (_, hi, __) => Column(
              children: [
                Text(
                  hi
                      ? 'Career Guidance & AI Coaching — एक Free Session Book करो'
                      : 'Online Career Guidance & AI Coaching — Book a Free Session',
                  textAlign: TextAlign.center,
                  style: hi
                      ? GoogleFonts.hindMadurai(
                          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800)
                      : GoogleFonts.poppins(
                          color: Colors.white, fontSize: 30, fontWeight: FontWeight.w800),
                ),
                const SizedBox(height: 10),
                Text(
                  hi
                      ? 'Students, freshers, और working professionals — एक session, clear direction.'
                      : 'Students, freshers, and working professionals — one session, real direction.',
                  textAlign: TextAlign.center,
                  style: hi
                      ? GoogleFonts.hindMadurai(color: Colors.white70, fontSize: 16)
                      : GoogleFonts.poppins(color: Colors.white70, fontSize: 16),
                ),
                const SizedBox(height: 28),
                ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.white,
                    foregroundColor: const Color(0xFF7C3AED),
                    padding: const EdgeInsets.symmetric(horizontal: 40, vertical: 18),
                    shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(50)),
                    textStyle: hi
                        ? GoogleFonts.hindMadurai(fontSize: 16, fontWeight: FontWeight.w700)
                        : GoogleFonts.poppins(fontSize: 16, fontWeight: FontWeight.w700),
                  ),
                  onPressed: () => Navigator.push(
                      context, MaterialPageRoute(builder: (_) => BookingForm())),
                  child: Text(hi ? 'Free Session Book करो →' : 'Book a Free Session →'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
