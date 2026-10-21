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
    final name = _nameController.text.trim();
    Navigator.of(context).push(
      MaterialPageRoute<void>(
        builder: (_) => ModeSelectionScreen(playerName: name),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            final horizontalPadding = constraints.maxWidth < 380 ? 22.0 : 28.0;
            return Center(
              child: ConstrainedBox(
                constraints: const BoxConstraints(maxWidth: 560),
                child: SingleChildScrollView(
                  padding: EdgeInsets.symmetric(
                    horizontal: horizontalPadding,
                    vertical: 24,
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        const BrandMark(),
                        SizedBox(height: constraints.maxHeight < 650 ? 28 : 42),
                        _HeroCard(compact: constraints.maxHeight < 650),
                        const SizedBox(height: 27),
                        const Text(
                          'Mulai dari namamu',
                          style: TextStyle(
                            color: ink,
                            fontSize: 19,
                            fontWeight: FontWeight.w800,
                            letterSpacing: -0.5,
                          ),
                        ),
                        const SizedBox(height: 7),
                        const Text(
                          'Biar kami tahu siapa yang sedang beraksi.',
                          style: TextStyle(color: mutedInk, fontSize: 13),
                        ),
                        const SizedBox(height: 18),
                        TextFormField(
                          controller: _nameController,
                          onChanged: (_) => setState(() {}),
                          textCapitalization: TextCapitalization.words,
                          textInputAction: TextInputAction.go,
                          onFieldSubmitted: (_) => _continueToModes(),
                          decoration: InputDecoration(
                            hintText: 'Nama lengkap',
                            prefixIcon: const Icon(
                              Icons.person_outline_rounded,
                              color: forest,
                            ),
                            filled: true,
                            fillColor: Colors.white,
                            contentPadding: const EdgeInsets.symmetric(
                              vertical: 17,
                              horizontal: 16,
                            ),
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                              borderSide: const BorderSide(color: lineColor),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                              borderSide: const BorderSide(color: lineColor),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(17),
                              borderSide: const BorderSide(
                                color: forest,
                                width: 1.5,
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
                        const SizedBox(height: 14),
                        PrimaryActionButton(
                          label: 'Pilih mode kuis',
                          onPressed: _continueToModes,
                        ),
                        const SizedBox(height: 18),
                        const Center(
                          child: Text(
                            '6 pertanyaan  ·  sekitar 3 menit',
                            style: TextStyle(
                              color: mutedInk,
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                            ),
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
    );
  }
}

class _HeroCard extends StatelessWidget {
  const _HeroCard({required this.compact});

  final bool compact;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: EdgeInsets.all(compact ? 22 : 25),
      decoration: BoxDecoration(
        color: ink,
        borderRadius: BorderRadius.circular(26),
      ),
      child: Stack(
        children: [
          Positioned(
            right: -17,
            top: -25,
            child: Container(
              width: compact ? 100 : 124,
              height: compact ? 100 : 124,
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white.withValues(alpha: 0.08),
                  width: 22,
                ),
              ),
            ),
          ),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 11,
                  vertical: 7,
                ),
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: const Text(
                  'KUIS SANTAI, OTAK TERASAH',
                  style: TextStyle(
                    color: Color(0xFFB7DCCB),
                    fontSize: 9,
                    fontWeight: FontWeight.w800,
                    letterSpacing: 1.2,
                  ),
                ),
              ),
              SizedBox(height: compact ? 17 : 22),
              Text(
                'Seberapa luas\nwawasanmu?',
                style: TextStyle(
                  color: Colors.white,
                  fontSize: compact ? 29 : 34,
                  height: 1.12,
                  letterSpacing: -1.1,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: 10),
              const Text(
                'Jawab cepat, percaya diri, dan lihat\nhasil terbaikmu.',
                style: TextStyle(
                  color: Color(0xFFC1D0CA),
                  fontSize: 13,
                  height: 1.5,
                ),
              ),
              SizedBox(height: compact ? 18 : 22),
              Row(
                children: [
                  const Icon(Icons.bolt_rounded, color: mango, size: 19),
                  const SizedBox(width: 6),
                  Flexible(
                    child: Text(
                      '6 soal pilihan ganda',
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                        color: Colors.white.withValues(alpha: 0.9),
                        fontSize: 12,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ],
      ),
    );
  }
}
