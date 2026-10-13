import 'package:flutter/material.dart';
import '../../../core/constants/app_constants.dart';
import '../../../core/theme/app_colors.dart';
import '../../../core/theme/app_text_styles.dart';
import '../../../shared/widgets/app_button.dart';
import '../../../shared/widgets/app_card.dart';
import '../../../shared/widgets/app_text_field.dart';
import '../../history/models/history_entry.dart';
import '../../history/services/history_service.dart';
import '../models/bmi_calculation_result.dart';
import '../models/measurement_system.dart';
import '../services/bmi_calculator_service.dart';
import '../widgets/bmi_result_card.dart';
import '../widgets/sex_selector.dart';
import '../widgets/unit_toggle.dart';

class CalculatorScreen extends StatefulWidget {
  final HistoryService historyService;
  final VoidCallback onOpenSettings;
  final MeasurementSystem initialSystem;

  const CalculatorScreen({
    super.key,
    required this.historyService,
    required this.onOpenSettings,
    this.initialSystem = MeasurementSystem.metric,
  });

  @override
  State<CalculatorScreen> createState() => _CalculatorScreenState();
}

class _CalculatorScreenState extends State<CalculatorScreen> {
  final _service = const BmiCalculatorService();
  final _formKey = GlobalKey<FormState>();
  final _scrollController = ScrollController();

  late MeasurementSystem _system;

  // Controllers - Metric
  final _heightCmController = TextEditingController();
  final _weightKgController = TextEditingController();

  // Controllers - Imperial
  final _heightFtController = TextEditingController();
  final _heightInController = TextEditingController();
  final _weightLbsController = TextEditingController();

  // General Controllers
  final _ageController = TextEditingController();
  String? _selectedSex;

  // Validation errors
  String? _heightError;
  String? _heightInError;
  String? _weightError;
  String? _ageError;

  // Calculation Result state
  BmiCalculationResult? _result;
  bool _isCalculating = false;

  @override
  void initState() {
    super.initState();
    _system = widget.initialSystem;
  }

  @override
  void didUpdateWidget(covariant CalculatorScreen oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.initialSystem != widget.initialSystem && _result == null) {
      _handleSystemChange(widget.initialSystem);
    }
  }

  @override
  void dispose() {
    _heightCmController.dispose();
    _weightKgController.dispose();
    _heightFtController.dispose();
    _heightInController.dispose();
    _weightLbsController.dispose();
    _ageController.dispose();
    _scrollController.dispose();
    super.dispose();
  }

  /// Converts inputs seamlessly when switching between Metric and Imperial
  void _handleSystemChange(MeasurementSystem newSystem) {
    if (_system == newSystem) return;

    setState(() {
      if (newSystem == MeasurementSystem.imperial) {
        // Convert metric to imperial
        final cm = double.tryParse(_heightCmController.text.trim());
        if (cm != null && cm > 0) {
          final imperial = _service.convertCmToFeetInches(cm);
          _heightFtController.text = imperial.feet.toString();
          _heightInController.text = imperial.inches.toStringAsFixed(0);
        }
        final kg = double.tryParse(_weightKgController.text.trim());
        if (kg != null && kg > 0) {
          final lbs = _service.convertKgToLbs(kg);
          _weightLbsController.text = lbs.toStringAsFixed(1);
        }
      } else {
        // Convert imperial to metric
        final ft = int.tryParse(_heightFtController.text.trim()) ?? 0;
        final inc = double.tryParse(_heightInController.text.trim()) ?? 0.0;
        if (ft > 0 || inc > 0) {
          final cm = _service.convertFeetInchesToCm(ft, inc);
          _heightCmController.text = cm.toStringAsFixed(1);
        }
        final lbs = double.tryParse(_weightLbsController.text.trim());
        if (lbs != null && lbs > 0) {
          final kg = _service.convertLbsToKg(lbs);
          _weightKgController.text = kg.toStringAsFixed(1);
        }
      }

      _system = newSystem;
      _clearValidationErrors();
    });
  }

  void _clearValidationErrors() {
    _heightError = null;
    _heightInError = null;
    _weightError = null;
    _ageError = null;
  }

  bool _validateInputs() {
    bool isValid = true;
    _clearValidationErrors();

    // Validate Age
    final ageErr = _service.validateAge(_ageController.text);
    if (ageErr != null) {
      _ageError = ageErr;
      isValid = false;
    }

    if (_system == MeasurementSystem.metric) {
      final hErr = _service.validateHeightCm(_heightCmController.text);
      if (hErr != null) {
        _heightError = hErr;
        isValid = false;
      }
      final wErr = _service.validateWeightKg(_weightKgController.text);
      if (wErr != null) {
        _weightError = wErr;
        isValid = false;
      }
    } else {
      final ftErr = _service.validateFeet(_heightFtController.text);
      if (ftErr != null) {
        _heightError = ftErr;
        isValid = false;
      }
      final inErr = _service.validateInches(_heightInController.text);
      if (inErr != null) {
        _heightInError = inErr;
        isValid = false;
      }
      final wErr = _service.validateWeightLbs(_weightLbsController.text);
      if (wErr != null) {
        _weightError = wErr;
        isValid = false;
      }
    }

    setState(() {});
    return isValid;
  }

  Future<void> _calculateBmi() async {
    // Unfocus any active keyboard
    FocusScope.of(context).unfocus();

    if (!_validateInputs()) {
      return;
    }

    setState(() => _isCalculating = true);

    try {
      final age = int.tryParse(_ageController.text.trim());
      BmiCalculationResult calculatedResult;

      if (_system == MeasurementSystem.metric) {
        final cm = double.parse(_heightCmController.text.trim());
        final kg = double.parse(_weightKgController.text.trim());
        calculatedResult = _service.calculateMetric(
          heightCm: cm,
          weightKg: kg,
          age: age,
          sex: _selectedSex,
        );
      } else {
        final ft = int.parse(_heightFtController.text.trim());
        final inc = double.parse(_heightInController.text.trim());
        final lbs = double.parse(_weightLbsController.text.trim());
        calculatedResult = _service.calculateImperial(
          feet: ft,
          inches: inc,
          weightLbs: lbs,
          age: age,
          sex: _selectedSex,
        );
      }

      setState(() {
        _result = calculatedResult;
        _isCalculating = false;
      });

      // Save to local offline history
      await widget.historyService.addEntry(
        HistoryEntry.fromResult(calculatedResult),
      );

      // Smoothly scroll to result
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (_scrollController.hasClients) {
          _scrollController.animateTo(
            _scrollController.position.maxScrollExtent,
            duration: const Duration(milliseconds: 400),
            curve: Curves.easeOutCubic,
          );
        }
      });
    } catch (e) {
      setState(() => _isCalculating = false);
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('Calculation error: ${e.toString()}'),
            backgroundColor: AppColors.error,
          ),
        );
      }
    }
  }

  void _resetForm() {
    setState(() {
      _heightCmController.clear();
      _weightKgController.clear();
      _heightFtController.clear();
      _heightInController.clear();
      _weightLbsController.clear();
      _ageController.clear();
      _selectedSex = null;
      _result = null;
      _clearValidationErrors();
    });

    if (_scrollController.hasClients) {
      _scrollController.animateTo(
        0,
        duration: const Duration(milliseconds: 300),
        curve: Curves.easeOut,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Scaffold(
      appBar: AppBar(
        title: Row(
          children: [
            Container(
              width: 32,
              height: 32,
              decoration: BoxDecoration(
                color: AppColors.softGreen,
                borderRadius: BorderRadius.circular(8),
              ),
              child: const Icon(
                Icons.balance_rounded,
                size: 20,
                color: AppColors.primaryGreen,
              ),
            ),
            const SizedBox(width: 10),
            const Text(
              AppConstants.appName,
              style: TextStyle(
                fontWeight: FontWeight.w800,
                letterSpacing: -0.4,
              ),
            ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.settings_outlined),
            tooltip: 'Settings',
            onPressed: widget.onOpenSettings,
          ),
          const SizedBox(width: 4),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          controller: _scrollController,
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Welcome Section
                Text(
                  AppConstants.appTagline,
                  style: AppTextStyles.displayMedium.copyWith(
                    color: isDark ? AppColors.darkPrimaryText : AppColors.primaryText,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  AppConstants.appSubhead,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: isDark ? AppColors.darkSecondaryText : AppColors.secondaryText,
                  ),
                ),

                const SizedBox(height: 20),

                // Unit System Toggle
                UnitToggle(
                  currentSystem: _system,
                  onSystemChanged: _handleSystemChange,
                ),

                const SizedBox(height: 20),

                // Inputs Card
                AppCard(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // Height Input
                      if (_system == MeasurementSystem.metric)
                        AppTextField(
                          controller: _heightCmController,
                          label: 'Height',
                          hint: 'e.g. 175',
                          unit: 'cm',
                          prefixIcon: Icons.height_rounded,
                          errorText: _heightError,
                          isRequired: true,
                          helperText: 'Valid range: 50 – 260 cm',
                          onChanged: (_) {
                            if (_heightError != null) {
                              setState(() => _heightError = null);
                            }
                          },
                        )
                      else
                        Row(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Expanded(
                              flex: 3,
                              child: AppTextField(
                                controller: _heightFtController,
                                label: 'Feet',
                                hint: '5',
                                unit: 'ft',
                                prefixIcon: Icons.height_rounded,
                                errorText: _heightError,
                                isRequired: true,
                                onChanged: (_) {
                                  if (_heightError != null) {
                                    setState(() => _heightError = null);
                                  }
                                },
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              flex: 3,
                              child: AppTextField(
                                controller: _heightInController,
                                label: 'Inches',
                                hint: '9',
                                unit: 'in',
                                errorText: _heightInError,
                                isRequired: true,
                                onChanged: (_) {
                                  if (_heightInError != null) {
                                    setState(() => _heightInError = null);
                                  }
                                },
                              ),
                            ),
                          ],
                        ),

                      const SizedBox(height: 18),

                      // Weight Input
                      if (_system == MeasurementSystem.metric)
                        AppTextField(
                          controller: _weightKgController,
                          label: 'Weight',
                          hint: 'e.g. 70.5',
                          unit: 'kg',
                          prefixIcon: Icons.monitor_weight_outlined,
                          errorText: _weightError,
                          isRequired: true,
                          helperText: 'Valid range: 10 – 450 kg',
                          onChanged: (_) {
                            if (_weightError != null) {
                              setState(() => _weightError = null);
                            }
                          },
                        )
                      else
                        AppTextField(
                          controller: _weightLbsController,
                          label: 'Weight',
                          hint: 'e.g. 155',
                          unit: 'lbs',
                          prefixIcon: Icons.monitor_weight_outlined,
                          errorText: _weightError,
                          isRequired: true,
                          helperText: 'Valid range: 22 – 992 lbs',
                          onChanged: (_) {
                            if (_weightError != null) {
                              setState(() => _weightError = null);
                            }
                          },
                        ),

                      const SizedBox(height: 18),

                      // Age Input with medical guideline context
                      AppTextField(
                        controller: _ageController,
                        label: 'Age in Years (Optional)',
                        hint: 'e.g. 28',
                        unit: 'yrs',
                        prefixIcon: Icons.cake_outlined,
                        errorText: _ageError,
                        helperText:
                            'Standard adult BMI guidelines apply to age 20 and older.',
                        onChanged: (_) {
                          if (_ageError != null) {
                            setState(() => _ageError = null);
                          }
                        },
                      ),

                      const SizedBox(height: 18),

                      // Contextual Sex Selector
                      SexSelector(
                        selectedSex: _selectedSex,
                        onSexChanged: (sex) => setState(() => _selectedSex = sex),
                      ),
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // Primary & Secondary Actions
                AppButton(
                  label: 'Calculate My BMI',
                  icon: Icons.calculate_rounded,
                  isLoading: _isCalculating,
                  onPressed: _calculateBmi,
                ),

                const SizedBox(height: 10),

                Center(
                  child: TextButton.icon(
                    onPressed: _resetForm,
                    icon: const Icon(Icons.refresh_rounded, size: 16),
                    label: const Text('Reset Form'),
                    style: TextButton.styleFrom(
                      foregroundColor: isDark
                          ? AppColors.darkSecondaryText
                          : AppColors.secondaryText,
                    ),
                  ),
                ),

                // Result Section
                if (_result != null) ...[
                  const SizedBox(height: 24),
                  BmiResultCard(
                    result: _result!,
                    onRecalculate: () {
                      _scrollController.animateTo(
                        0,
                        duration: const Duration(milliseconds: 300),
                        curve: Curves.easeOut,
                      );
                    },
                  ),
                  const SizedBox(height: 32),
                ] else ...[
                  const SizedBox(height: 24),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }
}
  }
}
