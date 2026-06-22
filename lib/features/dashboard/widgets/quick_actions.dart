import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';

class QuickActions extends StatelessWidget {
  const QuickActions({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Quick Actions',
          style: Theme.of(context).textTheme.titleMedium?.copyWith(
                fontWeight: FontWeight.w700,
                color: AppColors.onSurface,
              ),
        ),
        const SizedBox(height: 14),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.arrow_downward_rounded,
                iconColor: AppColors.success,
                label: 'Receive Material',
                onTap: () {},
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.arrow_upward_rounded,
                iconColor: AppColors.error,
                label: 'Consume Material',
                onTap: () {},
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: _ActionCard(
                icon: Icons.tune_rounded,
                iconColor: const Color(0xFFE68A00),
                label: 'Stock Adjustment',
                onTap: () => context.push('/adjustment'),
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _ActionCard(
                icon: Icons.insert_chart_outlined_rounded,
                iconColor: const Color(0xFF0097A7),
                label: 'Generate Report',
                onTap: () {},
              ),
            ),
          ],
        ),
      ],
    );
  }
}

class _ActionCard extends StatelessWidget {
  const _ActionCard({
    required this.icon,
    required this.iconColor,
    required this.label,
    required this.onTap,
  });

  final IconData icon;
  final Color iconColor;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Material(
      color: AppColors.card,
      borderRadius: BorderRadius.circular(26),
      elevation: 1,
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(26),
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 18),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(26),
            border: Border.all(
              color: AppColors.outlineVariant.withValues(alpha: 0.5),
            ),
          ),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: iconColor.withValues(alpha: 0.12),
                  shape: BoxShape.circle,
                ),
                child: Icon(icon, color: iconColor, size: 22),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Text(
                  label,
                  style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        fontWeight: FontWeight.w600,
                        color: AppColors.onSurface,
                      ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
