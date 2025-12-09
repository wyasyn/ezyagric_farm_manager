import '../models/farm.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

class FarmService {
  Future<List<Farm>> getAllFarms() async {
    final data = await StorageService.getList(AppConstants.farmsKey);
    return data.map((json) => Farm.fromJson(json)).toList();
  }

  Future<List<Farm>> getFarmsByFarmerId(String farmerId) async {
    final farms = await getAllFarms();
    return farms.where((f) => f.farmerId == farmerId).toList();
  }

  Future<Farm?> getFarmById(String id) async {
    final farms = await getAllFarms();
    try {
      return farms.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addFarm(Farm farm) async {
    final farms = await getAllFarms();
    farms.add(farm);
    await StorageService.saveList(
      AppConstants.farmsKey,
      farms.map((f) => f.toJson()).toList(),
    );
  }

  Future<void> updateFarm(Farm farm) async {
    final farms = await getAllFarms();
    final index = farms.indexWhere((f) => f.id == farm.id);
    if (index != -1) {
      farms[index] = farm;
      await StorageService.saveList(
        AppConstants.farmsKey,
        farms.map((f) => f.toJson()).toList(),
      );
    }
  }

  Future<void> deleteFarm(String id) async {
    final farms = await getAllFarms();
    farms.removeWhere((f) => f.id == id);
    await StorageService.saveList(
      AppConstants.farmsKey,
      farms.map((f) => f.toJson()).toList(),
    );
  }
}
