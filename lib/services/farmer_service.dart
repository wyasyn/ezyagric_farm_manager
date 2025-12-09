import '../models/farmer.dart';
import '../utils/constants.dart';
import 'storage_service.dart';

class FarmerService {
  Future<List<Farmer>> getAllFarmers() async {
    final data = await StorageService.getList(AppConstants.farmersKey);
    return data.map((json) => Farmer.fromJson(json)).toList();
  }

  Future<Farmer?> getFarmerById(String id) async {
    final farmers = await getAllFarmers();
    try {
      return farmers.firstWhere((f) => f.id == id);
    } catch (e) {
      return null;
    }
  }

  Future<void> addFarmer(Farmer farmer) async {
    final farmers = await getAllFarmers();
    farmers.add(farmer);
    await StorageService.saveList(
      AppConstants.farmersKey,
      farmers.map((f) => f.toJson()).toList(),
    );
  }

  Future<void> updateFarmer(Farmer farmer) async {
    final farmers = await getAllFarmers();
    final index = farmers.indexWhere((f) => f.id == farmer.id);
    if (index != -1) {
      farmers[index] = farmer;
      await StorageService.saveList(
        AppConstants.farmersKey,
        farmers.map((f) => f.toJson()).toList(),
      );
    }
  }

  Future<void> deleteFarmer(String id) async {
    final farmers = await getAllFarmers();
    farmers.removeWhere((f) => f.id == id);
    await StorageService.saveList(
      AppConstants.farmersKey,
      farmers.map((f) => f.toJson()).toList(),
    );
  }
}
