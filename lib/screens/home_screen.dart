import 'package:flutter/material.dart';

import '../widgets/quiz_components.dart';
import 'analytics_screen.dart';
import 'mode_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  int _avatarIndex = 0;

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continueToModes() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ModeSelectionScreen(
          playerName: _nameController.text.trim(),
          avatarIndex: _avatarIndex,
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final scheme = Theme.of(context).colorScheme;
    return Scaffold(
      backgroundColor: scheme.surface,
      body: QuizGameBackground(
        child: SafeArea(
          child: LayoutBuilder(
            builder: (context, constraints) {
              final compact = constraints.maxHeight < 700;
              return Center(
                child: ConstrainedBox(
                  constraints: const BoxConstraints(maxWidth: 500),
                  child: SingleChildScrollView(
                    padding: EdgeInsets.fromLTRB(
                      constraints.maxWidth < 380 ? 24 : 32,
                      compact ? 18 : 30,
                      constraints.maxWidth < 380 ? 24 : 32,
                      24,
                    ),
                    child: Form(
                      key: _formKey,
                      child: Column(
                        children: [
                          const BrandMark(),
                          Align(
                            alignment: Alignment.centerRight,
                            child: TextButton.icon(
                              onPressed: () => Navigator.of(context).push(
                                MaterialPageRoute<void>(
                                  builder: (_) => const AnalyticsScreen(),
                                ),
                              ),
                              icon: const Icon(
                                Icons.insights_rounded,
                                size: 18,
                              ),
                              label: const Text('Analitik'),
                            ),
                          ),
                          SizedBox(height: compact ? 28 : 48),
                          _QuizTitleCard(compact: compact),
                          SizedBox(height: compact ? 25 : 34),
                          Text(
                            'Seberapa luas\nwawasanmu?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: scheme.onSurface,
                              fontSize: compact ? 26 : 31,
                              height: 1.1,
                              letterSpacing: -0.7,
                              fontWeight: FontWeight.w800,
                            ),
                          ),
                          const SizedBox(height: 8),
                          Text(
                            'Masukkan namamu, lalu bersiap untuk bermain!',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 13,
                              height: 1.4,
                            ),
                          ),
                          SizedBox(height: compact ? 22 : 30),
                          TextFormField(
                            controller: _nameController,
                            textCapitalization: TextCapitalization.words,
                            textInputAction: TextInputAction.go,
                            onFieldSubmitted: (_) => _continueToModes(),
                            decoration: InputDecoration(
                              hintText: 'Nama pemain',
                              hintStyle: TextStyle(
                                color: scheme.onSurfaceVariant,
                              ),
                              prefixIcon: Icon(
                                Icons.person_rounded,
                                color: scheme.primary,
                              ),
                              filled: true,
                              fillColor: scheme.surfaceContainer,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: scheme.outlineVariant,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: scheme.outlineVariant,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: BorderSide(
                                  color: scheme.primary,
                                  width: 2,
                                ),
                              ),
                            ),
                            validator: (value) {
                              if (value == null || value.trim().isEmpty) {
                                return 'Nama perlu diisi sebelum mulai.';
                              }
                              if (value.trim().length < 2) {
                                return 'Masukkan nama minimal 2 karakter.';
                              }
                              return null;
                            },
                          ),
                          const SizedBox(height: 18),
                          AvatarPicker(
                            selectedIndex: _avatarIndex,
                            onSelected: (index) =>
                                setState(() => _avatarIndex = index),
                          ),
                          const SizedBox(height: 16),
                          PrimaryActionButton(
                            label: 'Pilih mode kuis',
                            icon: Icons.play_arrow_rounded,
                            onPressed: _continueToModes,
                          ),
                          const SizedBox(height: 18),
                          Text(
                            '30 SOAL  ·  BANYAK KESERUAN',
                            style: TextStyle(
                              color: scheme.onSurfaceVariant,
                              fontSize: 10,
                              letterSpacing: 1.4,
                              fontWeight: FontWeight.w900,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          ),
        ),
      ),
    );
  }
}

class _QuizTitleCard extends StatelessWidget {
  const _QuizTitleCard({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return ConstrainedBox(
      constraints: const BoxConstraints(maxWidth: 420, maxHeight: 230),
      child: AspectRatio(
        aspectRatio: compact ? 1.7 : 2.2,
        child: Image.asset(
          'assets/images/quiz_illustration.png',
          fit: BoxFit.contain,
          semanticLabel: 'Ilustrasi kartu quiz berwarna putih dengan doodle',
        ),
      ),
    );
  }
}
