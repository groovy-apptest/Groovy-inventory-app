import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:groovy_inventory/features/transactions/models/transaction_history_model.dart';
import 'package:groovy_inventory/features/transactions/repository/transactions_repository.dart';

final _repo = Provider((ref) => TransactionsRepository());

final selectedFilterProvider = NotifierProvider<SelectedFilterNotifier, String?>(
  SelectedFilterNotifier.new,
);

class SelectedFilterNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

final searchQueryProvider = NotifierProvider<SearchQueryNotifier, String?>(
  SearchQueryNotifier.new,
);

class SearchQueryNotifier extends Notifier<String?> {
  @override
  String? build() => null;

  void set(String? value) => state = value;
}

final transactionHistoryProvider =
    AsyncNotifierProvider<TransactionHistoryNotifier, TransactionHistoryState>(
      TransactionHistoryNotifier.new,
    );

class TransactionHistoryState {
  final List<TransactionHistoryModel> transactions;
  final int total;
  final int page;
  final bool hasMore;

  const TransactionHistoryState({
    this.transactions = const [],
    this.total = 0,
    this.page = 1,
    this.hasMore = true,
  });

  TransactionHistoryState copyWith({
    List<TransactionHistoryModel>? transactions,
    int? total,
    int? page,
    bool? hasMore,
  }) {
    return TransactionHistoryState(
      transactions: transactions ?? this.transactions,
      total: total ?? this.total,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
    );
  }
}

class TransactionHistoryNotifier extends AsyncNotifier<TransactionHistoryState> {
  static const _limit = 20;

  @override
  Future<TransactionHistoryState> build() async {
    final filter = ref.watch(selectedFilterProvider);
    final search = ref.watch(searchQueryProvider);
    return _fetch(filter: filter, search: search, page: 1);
  }

  Future<TransactionHistoryState> _fetch({
    String? filter,
    String? search,
    required int page,
  }) async {
    final result = await ref.read(_repo).getHistory(
      transactionType: filter,
      search: search,
      page: page,
      limit: _limit,
    );
    return TransactionHistoryState(
      transactions: result.transactions,
      total: result.total,
      page: page,
      hasMore: result.transactions.length >= _limit,
    );
  }

  Future<void> loadMore() async {
    final current = state.value;
    if (current == null || !current.hasMore) return;

    final filter = ref.read(selectedFilterProvider);
    final search = ref.read(searchQueryProvider);
    final nextPage = current.page + 1;

    final result = await ref.read(_repo).getHistory(
      transactionType: filter,
      search: search,
      page: nextPage,
      limit: _limit,
    );

    state = AsyncData(current.copyWith(
      transactions: [...current.transactions, ...result.transactions],
      total: result.total,
      page: nextPage,
      hasMore: result.transactions.length >= _limit,
    ));
  }
}
