import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../models/collection_model.dart';
import '../../repositories/collection_repository.dart';
import 'fleet_provider.dart';

class CollectionState {
  final List<CollectionModel> collections;
  final DateTime selectedDate;
  final bool isLoading;

  const CollectionState({
    this.collections = const [],
    required this.selectedDate,
    this.isLoading = false,
  });

  List<CollectionModel> get todayCollections {
    final now = DateTime.now();
    return collections.where((c) =>
      c.date.year == now.year &&
      c.date.month == now.month &&
      c.date.day == now.day
    ).toList();
  }

  double get todayCollectedTotal =>
      todayCollections.fold<double>(0, (sum, c) => sum + c.paidAmount);

  double get todayExpectedTotal =>
      todayCollections.fold<double>(0, (sum, c) => sum + c.expectedAmount);

  double get todayDueTotal =>
      todayCollections.fold<double>(0, (sum, c) => sum + c.dueAmount);

  CollectionState copyWith({
    List<CollectionModel>? collections,
    DateTime? selectedDate,
    bool? isLoading,
  }) {
    return CollectionState(
      collections: collections ?? this.collections,
      selectedDate: selectedDate ?? this.selectedDate,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class CollectionNotifier extends StateNotifier<CollectionState> {
  final CollectionRepository _repo = CollectionRepository();
  final Ref _ref;

  CollectionNotifier(this._ref)
      : super(CollectionState(selectedDate: DateTime.now())) {
    refresh();
  }

  void refresh() {
    state = state.copyWith(isLoading: true);
    final list = _repo.getAll();
    state = state.copyWith(
      collections: list,
      isLoading: false,
    );
  }

  void selectDate(DateTime date) {
    state = state.copyWith(selectedDate: date);
  }

  Future<CollectionModel> recordCollection({
    required String rickshawId,
    required String driverId,
    required String driverName,
    required double expectedAmount,
    required double paidAmount,
    required String recordedBy,
    DateTime? customDate,
  }) async {
    final result = await _repo.recordCollection(
      rickshawId: rickshawId,
      driverId: driverId,
      driverName: driverName,
      expectedAmount: expectedAmount,
      paidAmount: paidAmount,
      recordedBy: recordedBy,
      customDate: customDate,
    );

    refresh();
    _ref.read(fleetProvider.notifier).refresh();
    return result;
  }

  Future<void> deleteCollection(String id) async {
    await _repo.deleteCollection(id);
    refresh();
    _ref.read(fleetProvider.notifier).refresh();
  }
}

final collectionProvider = StateNotifierProvider<CollectionNotifier, CollectionState>((ref) {
  return CollectionNotifier(ref);
});
