import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/features/inventory/models/material_model.dart';
import 'package:groovy_inventory/features/inventory/providers/inventory_provider.dart';

Future<MaterialModel?> showMaterialPickerSheet(BuildContext context) {
  return showModalBottomSheet<MaterialModel>(
    context: context,
    isScrollControlled: true,
    backgroundColor: Colors.transparent,
    builder: (_) => const MaterialPickerSheet(),
  );
}

class MaterialPickerSheet extends ConsumerStatefulWidget {
  const MaterialPickerSheet({super.key});

  @override
  ConsumerState<MaterialPickerSheet> createState() =>
      _MaterialPickerSheetState();
}

class _MaterialPickerSheetState extends ConsumerState<MaterialPickerSheet> {
  final _searchController = TextEditingController();

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final asyncMaterials = ref.watch(materialsProvider);

    return Container(
      height: MediaQuery.of(context).size.height * 0.7,
      decoration: const BoxDecoration(
        color: AppColors.surface,
        borderRadius: BorderRadius.vertical(top: Radius.circular(26)),
      ),
      child: Column(
        children: [
          const SizedBox(height: 12),
          Container(
            width: 40,
            height: 4,
            decoration: BoxDecoration(
              color: AppColors.outlineVariant,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Select Material',
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.w600,
              color: AppColors.onSurface,
            ),
          ),
          const SizedBox(height: 12),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              controller: _searchController,
              onChanged: (v) => ref.read(materialsProvider.notifier).search(v),
              decoration: InputDecoration(
                hintText: 'Search materials...',
                hintStyle: const TextStyle(color: AppColors.onSurfaceVariant),
                prefixIcon: const Icon(
                  Icons.search,
                  color: AppColors.onSurfaceVariant,
                ),
                filled: true,
                fillColor: AppColors.card,
                contentPadding: const EdgeInsets.symmetric(vertical: 12),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(16),
                  borderSide: BorderSide.none,
                ),
              ),
            ),
          ),
          const SizedBox(height: 8),
          Expanded(
            child: asyncMaterials.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (e, _) => const Center(
                child: Text(
                  'Failed to load materials',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
              data: (materials) {
                if (materials.isEmpty) {
                  return const Center(
                    child: Text(
                      'No materials found',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  );
                }
                return ListView.separated(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 16,
                    vertical: 8,
                  ),
                  itemCount: materials.length,
                  separatorBuilder: (_, _) => const SizedBox(height: 8),
                  itemBuilder: (context, index) {
                    final m = materials[index];
                    return GestureDetector(
                      onTap: () => Navigator.pop(context, m),
                      child: Container(
                        padding: const EdgeInsets.all(14),
                        decoration: BoxDecoration(
                          color: AppColors.card,
                          borderRadius: BorderRadius.circular(16),
                          border: Border.all(
                            color: AppColors.outlineVariant.withValues(
                              alpha: 0.4,
                            ),
                          ),
                        ),
                        child: Row(
                          children: [
                            Container(
                              width: 40,
                              height: 40,
                              decoration: BoxDecoration(
                                color: AppColors.primary.withValues(alpha: 0.1),
                                shape: BoxShape.circle,
                              ),
                              alignment: Alignment.center,
                              child: Text(
                                m.materialCode,
                                style: const TextStyle(
                                  fontSize: 9,
                                  fontWeight: FontWeight.w700,
                                  color: AppColors.primaryVariant,
                                ),
                              ),
                            ),
                            const SizedBox(width: 12),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(
                                    m.materialName,
                                    style: const TextStyle(
                                      fontSize: 15,
                                      fontWeight: FontWeight.w600,
                                      color: AppColors.onSurface,
                                    ),
                                  ),
                                  Text(
                                    '${m.materialGroup} · ${m.uom}',
                                    style: const TextStyle(
                                      fontSize: 13,
                                      color: AppColors.onSurfaceVariant,
                                    ),
                                  ),
                                ],
                              ),
                            ),
                            const Icon(
                              Icons.chevron_right,
                              color: AppColors.outlineVariant,
                              size: 20,
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
