import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/core/widgets/app_bar.dart';
import 'package:groovy_inventory/core/widgets/material_picker_sheet.dart';
import 'package:groovy_inventory/features/dashboard/providers/dashboard_provider.dart';
import 'package:groovy_inventory/features/inventory/models/material_model.dart';
import 'package:groovy_inventory/features/inventory/providers/inventory_provider.dart';

class AdjustmentScreen extends ConsumerStatefulWidget {
  const AdjustmentScreen({super.key});

  @override
  ConsumerState<AdjustmentScreen> createState() => _AdjustmentScreenState();
}

class _AdjustmentScreenState extends ConsumerState<AdjustmentScreen> {
  final _formKey = GlobalKey<FormState>();
  final _quantityController = TextEditingController();
  final _referenceController = TextEditingController();
  final _remarksController = TextEditingController();

  MaterialModel? _selectedMaterial;
  String _adjustmentType = 'ADJUSTMENT_IN';
  bool _isLoading = false;
  bool _isLoadingRef = false;

  @override
  void initState() {
    super.initState();
    _loadReferenceNo();
  }

  @override
  void dispose() {
    _quantityController.dispose();
    _referenceController.dispose();
    _remarksController.dispose();
    super.dispose();
  }

  Future<void> _loadReferenceNo() async {
    setState(() => _isLoadingRef = true);
    try {
      final refNo = await ref.read(inventoryRepoProvider).getNextReferenceNo();
      _referenceController.text = refNo;
    } catch (_) {}
    if (mounted) setState(() => _isLoadingRef = false);
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;
    if (_selectedMaterial == null) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text('Please select a material'),
          backgroundColor: AppColors.error,
        ),
      );
      return;
    }

    setState(() => _isLoading = true);
    try {
      await ref
          .read(inventoryRepoProvider)
          .recordAdjustment(
            materialId: _selectedMaterial!.id,
            adjustmentType: _adjustmentType,
            quantity: double.parse(_quantityController.text),
            referenceNo: _referenceController.text,
            remarks: _remarksController.text,
          );

      ref.invalidate(recentTransactionsProvider);

      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Adjustment recorded successfully'),
            backgroundColor: AppColors.success,
          ),
        );
        context.pop();
      }
    } catch (e) {
      if (mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(e.toString().replaceFirst('Exception: ', '')),
            backgroundColor: AppColors.error,
          ),
        );
      }
    } finally {
      if (mounted) setState(() => _isLoading = false);
    }
  }

  Future<void> _showMaterialPicker() async {
    final material = await showMaterialPickerSheet(context);
    if (!mounted || material == null) return;
    setState(() => _selectedMaterial = material);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Stock Adjustment',
        bottomText: 'Adjust inventory stock',
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const SizedBox(height: 4),

              // Adjustment Type Toggle
              _SectionLabel(text: 'Adjustment Type'),
              const SizedBox(height: 8),
              Container(
                decoration: BoxDecoration(
                  color: AppColors.card,
                  borderRadius: BorderRadius.circular(16),
                  border: Border.all(
                    color: AppColors.outlineVariant.withValues(alpha: 0.5),
                  ),
                ),
                child: Row(
                  children: [
                    Expanded(
                      child: _TypeChip(
                        label: 'Adjustment In',
                        icon: Icons.add_rounded,
                        isSelected: _adjustmentType == 'ADJUSTMENT_IN',
                        color: AppColors.success,
                        onTap: () =>
                            setState(() => _adjustmentType = 'ADJUSTMENT_IN'),
                      ),
                    ),
                    Expanded(
                      child: _TypeChip(
                        label: 'Adjustment Out',
                        icon: Icons.remove_rounded,
                        isSelected: _adjustmentType == 'ADJUSTMENT_OUT',
                        color: AppColors.error,
                        onTap: () =>
                            setState(() => _adjustmentType = 'ADJUSTMENT_OUT'),
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(height: 20),

              // Material Selector
              _SectionLabel(text: 'Material'),
              const SizedBox(height: 8),
              GestureDetector(
                onTap: _showMaterialPicker,
                child: Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    color: AppColors.card,
                    borderRadius: BorderRadius.circular(16),
                    border: Border.all(
                      color: _selectedMaterial != null
                          ? AppColors.primary.withValues(alpha: 0.5)
                          : AppColors.outlineVariant.withValues(alpha: 0.5),
                    ),
                  ),
                  child: _selectedMaterial != null
                      ? Row(
                          children: [
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    _selectedMaterial!.materialName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  const SizedBox(height: 2),
                                  Text(
                                    '${_selectedMaterial!.materialCode} · ${_selectedMaterial!.uom}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.swap_horiz_rounded,
                              color: AppColors.onSurfaceVariant,
                            ),
                          ],
                        )
                      : const Row(
                          children: [
                            Icon(
                              Icons.inventory_2_outlined,
                              color: AppColors.onSurfaceVariant,
                            ),
                            SizedBox(width: 12),
                            Text(
                              'Select a material',
                              style: TextStyle(
                                fontSize: 15,
                                color: AppColors.onSurfaceVariant,
                              ),
                            ),
                            Spacer(),
                            Icon(
                              Icons.chevron_right,
                              color: AppColors.outlineVariant,
                            ),
                          ],
                        ),
                ),
              ),

              const SizedBox(height: 20),

              // Quantity
              _SectionLabel(text: 'Quantity'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _quantityController,
                keyboardType: const TextInputType.numberWithOptions(
                  decimal: true,
                ),
                validator: (v) {
                  if (v == null || v.isEmpty) return 'Enter quantity';
                  final num = double.tryParse(v);
                  if (num == null || num <= 0) return 'Enter a valid quantity';
                  return null;
                },
                decoration: _inputDecoration(
                  hint: 'Enter quantity',
                  suffix: _selectedMaterial != null
                      ? Text(
                          _selectedMaterial!.uom,
                          style: const TextStyle(
                            color: AppColors.onSurfaceVariant,
                            fontWeight: FontWeight.w600,
                          ),
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              // Reference No
              _SectionLabel(text: 'Reference No'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _referenceController,
                decoration: _inputDecoration(
                  hint: 'Reference number',
                  suffix: _isLoadingRef
                      ? const SizedBox(
                          width: 18,
                          height: 18,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      : null,
                ),
              ),

              const SizedBox(height: 20),

              // Remarks (required for adjustments)
              _SectionLabel(text: 'Remarks'),
              const SizedBox(height: 8),
              TextFormField(
                controller: _remarksController,
                maxLines: 3,
                validator: (v) => v == null || v.isEmpty
                    ? 'Remarks are required for adjustments'
                    : null,
                decoration: _inputDecoration(hint: 'Reason for adjustment'),
              ),

              const SizedBox(height: 32),

              // Submit
              SizedBox(
                width: double.infinity,
                height: 52,
                child: ElevatedButton(
                  onPressed: _isLoading ? null : _submit,
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primary,
                    foregroundColor: Colors.white,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(26),
                    ),
                    elevation: 0,
                  ),
                  child: _isLoading
                      ? const SizedBox(
                          width: 22,
                          height: 22,
                          child: CircularProgressIndicator(
                            strokeWidth: 2,
                            color: Colors.white,
                          ),
                        )
                      : const Text(
                          'Record Adjustment',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                ),
              ),
              const SizedBox(height: 16),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration({required String hint, Widget? suffix}) {
    return InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
      filled: true,
      fillColor: AppColors.card,
      suffixIcon: suffix != null
          ? Padding(padding: const EdgeInsets.only(right: 12), child: suffix)
          : null,
      suffixIconConstraints: const BoxConstraints(minHeight: 0, minWidth: 0),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: BorderSide(
          color: AppColors.outlineVariant.withValues(alpha: 0.5),
        ),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.primary),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(16),
        borderSide: const BorderSide(color: AppColors.error),
      ),
    );
  }
}

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.text});

  final String text;

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: const TextStyle(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: AppColors.onSurfaceVariant,
      ),
    );
  }
}

class _TypeChip extends StatelessWidget {
  const _TypeChip({
    required this.label,
    required this.icon,
    required this.isSelected,
    required this.color,
    required this.onTap,
  });

  final String label;
  final IconData icon;
  final bool isSelected;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 14),
        decoration: BoxDecoration(
          color: isSelected ? color.withValues(alpha: 0.1) : Colors.transparent,
          borderRadius: BorderRadius.circular(14),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              icon,
              size: 18,
              color: isSelected ? color : AppColors.onSurfaceVariant,
            ),
            const SizedBox(width: 6),
            Text(
              label,
              style: TextStyle(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: isSelected ? color : AppColors.onSurfaceVariant,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
