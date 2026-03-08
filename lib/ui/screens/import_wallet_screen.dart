import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../widgets/glass_card.dart';
import '../widgets/gradient_scaffold.dart';
import '../widgets/neon_button.dart';
import '../mock_data.dart';
import 'dashboard_screen.dart';

class ImportWalletScreen extends StatefulWidget {
  const ImportWalletScreen({super.key});

  @override
  State<ImportWalletScreen> createState() => _ImportWalletScreenState();
}

class _ImportWalletScreenState extends State<ImportWalletScreen> {
  int _wordCount = 12;
  final List<TextEditingController> _controllers = [];
  final List<FocusNode> _focusNodes = [];
  List<String> _suggestions = [];
  int _activeSuggestionIndex = -1;

  @override
  void initState() {
    super.initState();
    _initControllers();
  }

  void _initControllers() {
    // Dispose existing
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    _controllers.clear();
    _focusNodes.clear();

    for (int i = 0; i < _wordCount; i++) {
      final controller = TextEditingController();
      final focusNode = FocusNode();

      controller.addListener(() {
        _updateSuggestions(controller.text, i);
      });

      focusNode.addListener(() {
        if (focusNode.hasFocus) {
          setState(() {
            _activeSuggestionIndex = i;
            _updateSuggestions(controller.text, i);
          });
        }
      });

      _controllers.add(controller);
      _focusNodes.add(focusNode);
    }
  }

  void _updateSuggestions(String text, int index) {
    if (text.isEmpty) {
      setState(() => _suggestions = []);
      return;
    }

    final filtered = MockData.seedSuggestions
        .where((w) => w.startsWith(text.toLowerCase()))
        .take(6)
        .toList();

    setState(() {
      _suggestions = filtered;
      _activeSuggestionIndex = index;
    });
  }

  void _selectSuggestion(String word) {
    if (_activeSuggestionIndex >= 0 &&
        _activeSuggestionIndex < _controllers.length) {
      _controllers[_activeSuggestionIndex].text = word;
      setState(() => _suggestions = []);

      // Move to next field
      if (_activeSuggestionIndex < _wordCount - 1) {
        FocusScope.of(
          context,
        ).requestFocus(_focusNodes[_activeSuggestionIndex + 1]);
      }
    }
  }

  @override
  void dispose() {
    for (final c in _controllers) {
      c.dispose();
    }
    for (final f in _focusNodes) {
      f.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return GradientScaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(CupertinoIcons.back),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text('Import Wallet'),
      ),
      body: SafeArea(
        child: Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 12),

                    // ── Info Card ──
                    GlassCard(
                      padding: const EdgeInsets.all(16),
                      borderRadius: 14,
                      opacity: 0.06,
                      child: Row(
                        children: [
                          Container(
                            width: 40,
                            height: 40,
                            decoration: BoxDecoration(
                              shape: BoxShape.circle,
                              color: AppColors.neonCyan.withValues(alpha: 0.12),
                            ),
                            child: const Icon(
                              CupertinoIcons.lock_shield,
                              color: AppColors.neonCyan,
                              size: 20,
                            ),
                          ),
                          const SizedBox(width: 14),
                          Expanded(
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Recovery Phrase',
                                  style: Theme.of(context).textTheme.labelLarge,
                                ),
                                const SizedBox(height: 4),
                                Text(
                                  'Enter your secret recovery phrase to restore your wallet.',
                                  style: Theme.of(context).textTheme.bodySmall,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ).animate().fadeIn(duration: 400.ms),

                    const SizedBox(height: 20),

                    // ── Word Count Toggle ──
                    _buildWordCountToggle(),

                    const SizedBox(height: 20),

                    // ── Suggestion Chips ──
                    if (_suggestions.isNotEmpty) _buildSuggestionChips(),

                    // ── Seed Phrase Grid ──
                    _buildSeedGrid(),

                    const SizedBox(height: 24),
                  ],
                ),
              ),
            ),

            // ── Import Button ──
            Padding(
              padding: const EdgeInsets.fromLTRB(20, 0, 20, 20),
              child: NeonButton(
                label: 'Import Wallet',
                icon: CupertinoIcons.arrow_down_doc_fill,
                onPressed: () {
                  Navigator.of(context).pushAndRemoveUntil(
                    MaterialPageRoute(builder: (_) => const DashboardScreen()),
                    (route) => false,
                  );
                },
              ).animate().fadeIn(delay: 600.ms).slideY(begin: 0.3, end: 0),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildWordCountToggle() {
    return Row(
      children: [
        _ToggleChip(
          label: '12 Words',
          isSelected: _wordCount == 12,
          onTap: () {
            setState(() {
              _wordCount = 12;
              _initControllers();
            });
          },
        ),
        const SizedBox(width: 12),
        _ToggleChip(
          label: '24 Words',
          isSelected: _wordCount == 24,
          onTap: () {
            setState(() {
              _wordCount = 24;
              _initControllers();
            });
          },
        ),
      ],
    ).animate().fadeIn(delay: 200.ms);
  }

  Widget _buildSuggestionChips() {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Wrap(
        spacing: 8,
        runSpacing: 8,
        children: _suggestions.map((word) {
          return GestureDetector(
            onTap: () => _selectSuggestion(word),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 8),
              decoration: BoxDecoration(
                color: AppColors.neonCyan.withValues(alpha: 0.1),
                borderRadius: BorderRadius.circular(20),
                border: Border.all(
                  color: AppColors.neonCyan.withValues(alpha: 0.3),
                ),
              ),
              child: Text(
                word,
                style: const TextStyle(
                  color: AppColors.neonCyan,
                  fontSize: 13,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          );
        }).toList(),
      ).animate().fadeIn(duration: 200.ms),
    );
  }

  Widget _buildSeedGrid() {
    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 3,
        childAspectRatio: 2.5,
        crossAxisSpacing: 10,
        mainAxisSpacing: 10,
      ),
      itemCount: _wordCount,
      itemBuilder: (context, index) {
        return _SeedWordField(
          index: index,
          controller: _controllers[index],
          focusNode: _focusNodes[index],
        ).animate().fadeIn(delay: (300 + index * 30).ms, duration: 300.ms);
      },
    );
  }
}

// ── Toggle Chip ──
class _ToggleChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  const _ToggleChip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: AnimatedContainer(
        duration: const Duration(milliseconds: 250),
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        decoration: BoxDecoration(
          gradient: isSelected ? AppColors.neonGradient : null,
          color: isSelected ? null : AppColors.glassFill,
          borderRadius: BorderRadius.circular(12),
          border: isSelected ? null : Border.all(color: AppColors.glassBorder),
        ),
        child: Text(
          label,
          style: TextStyle(
            color: isSelected ? AppColors.deepIndigo : AppColors.textSecondary,
            fontSize: 14,
            fontWeight: FontWeight.w600,
          ),
        ),
      ),
    );
  }
}

// ── Seed Word Field ──
class _SeedWordField extends StatelessWidget {
  final int index;
  final TextEditingController controller;
  final FocusNode focusNode;

  const _SeedWordField({
    required this.index,
    required this.controller,
    required this.focusNode,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.glassFill,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: AppColors.glassBorder, width: 0.5),
      ),
      child: Row(
        children: [
          Container(
            width: 28,
            alignment: Alignment.center,
            child: Text(
              '${index + 1}',
              style: const TextStyle(
                color: AppColors.textMuted,
                fontSize: 11,
                fontWeight: FontWeight.w600,
              ),
            ),
          ),
          Expanded(
            child: TextField(
              controller: controller,
              focusNode: focusNode,
              style: const TextStyle(
                color: AppColors.textPrimary,
                fontSize: 13,
              ),
              decoration: const InputDecoration(
                border: InputBorder.none,
                enabledBorder: InputBorder.none,
                focusedBorder: InputBorder.none,
                contentPadding: EdgeInsets.symmetric(
                  horizontal: 4,
                  vertical: 10,
                ),
                isDense: true,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
