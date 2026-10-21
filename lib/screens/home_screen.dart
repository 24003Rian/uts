import 'package:flutter/material.dart';

import '../widgets/quiz_components.dart';
import 'mode_selection_screen.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  final _nameController = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  @override
  void dispose() {
    _nameController.dispose();
    super.dispose();
  }

  void _continueToModes() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) =>
            ModeSelectionScreen(playerName: _nameController.text.trim()),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: paper,
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
                          SizedBox(height: compact ? 28 : 48),
                          _QuizTitleCard(compact: compact),
                          SizedBox(height: compact ? 25 : 34),
                          Text(
                            'Seberapa luas\nwawasanmu?',
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: ink,
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
                              color: mutedInk,
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
                              hintStyle: const TextStyle(color: mutedInk),
                              prefixIcon: const Icon(
                                Icons.person_rounded,
                                color: deepBlue,
                              ),
                              filled: true,
                              fillColor: Colors.white,
                              contentPadding: const EdgeInsets.symmetric(
                                vertical: 18,
                                horizontal: 18,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: lineColor,
                                  width: 1.5,
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: lineColor,
                                  width: 1.5,
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(18),
                                borderSide: const BorderSide(
                                  color: forest,
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
                          const SizedBox(height: 16),
                          PrimaryActionButton(
                            label: 'Pilih mode kuis',
                            icon: Icons.play_arrow_rounded,
                            onPressed: _continueToModes,
                          ),
                          const SizedBox(height: 18),
                          const Text(
                            '6 SOAL  ·  BANYAK KESERUAN',
                            style: TextStyle(
                              color: mutedInk,
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
    return SizedBox(
      height: compact ? 190 : 230,
      child: Image.asset(
        'assets/images/quiz_illustration.png',
        fit: BoxFit.contain,
        semanticLabel: 'Ilustrasi kartu quiz berwarna putih dengan doodle',
      ),
    );
  }
}
