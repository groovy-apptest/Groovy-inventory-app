import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/app/theme/app_colors.dart';
import 'package:groovy_inventory/core/widgets/app_bar.dart';
import 'package:groovy_inventory/core/widgets/app_search_box.dart';
import 'package:groovy_inventory/features/transactions/providers/transactions_provider.dart';
import 'package:groovy_inventory/features/transactions/widgets/transaction_card.dart';
import 'package:groovy_inventory/features/transactions/widgets/transaction_filters.dart';

class TransactionsScreen extends ConsumerStatefulWidget {
  const TransactionsScreen({super.key});

  @override
  ConsumerState<TransactionsScreen> createState() => _TransactionsScreenState();
}

class _TransactionsScreenState extends ConsumerState<TransactionsScreen> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(transactionHistoryProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final asyncState = ref.watch(transactionHistoryProvider);

    return Scaffold(
      appBar: const CustomAppBar(
        title: 'Transactions',
        bottomText: 'Stock movements & history',
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.fromLTRB(16, 16, 16, 0),
            child: AppSearchBox(
              onSearch: (value) {
                ref.read(searchQueryProvider.notifier).set(value);
              },
            ),
          ),
          const Padding(
            padding: EdgeInsets.fromLTRB(16, 12, 16, 8),
            child: TransactionFilters(),
          ),
          Expanded(
            child: asyncState.when(
              loading: () => const Center(child: CircularProgressIndicator()),
              error: (error, _) => Center(
                child: Text(
                  'Failed to load transactions',
                  style: TextStyle(color: AppColors.error),
                ),
              ),
              data: (historyState) {
                if (historyState.transactions.isEmpty) {
                  return const Center(
                    child: Text(
                      'No transactions found',
                      style: TextStyle(color: AppColors.onSurfaceVariant),
                    ),
                  );
                }
                return ListView.separated(
                  controller: _scrollController,
                  padding: const EdgeInsets.fromLTRB(16, 8, 16, 24),
                  itemCount:
                      historyState.transactions.length +
                      (historyState.hasMore ? 1 : 0),
                  separatorBuilder: (_, _) => const SizedBox(height: 12),
                  itemBuilder: (context, index) {
                    if (index >= historyState.transactions.length) {
                      return const Center(
                        child: Padding(
                          padding: EdgeInsets.all(16),
                          child: CircularProgressIndicator(),
                        ),
                      );
                    }
                    return TransactionCard(
                      transaction: historyState.transactions[index],
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
