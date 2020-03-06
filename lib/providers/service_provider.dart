import 'package:flutter/foundation.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/graphql.dart';

class ServiceState with ChangeNotifier {
  List<ServiceType> _serviceTypes = [];
  List<ServiceType> get serviceTypes {
    GraphQLApi.getServiceTypes().then((value) {
      if (_serviceTypes.length != value.length) {
        _serviceTypes = value;
        notifyListeners();
      }
    });
    return _serviceTypes;
  }

  var _selectedServiceTypeIndex = 0;
  int get selectedServiceTypeIndex => _selectedServiceTypeIndex;
  ServiceType get selectedServiceType {
    if (_selectedServiceTypeIndex < _serviceTypes.length)
      return _serviceTypes[_selectedServiceTypeIndex];
    return null;
  }

  void selectServiceType(int index) {
    _selectedServiceTypeIndex = index;
    notifyListeners();
  }

  int _selectedServiceId = -1;
  Map<int, List<Service>> _serviceMap = {};
  List<Service> get services {
    var serviceType = selectedServiceType;
    if (serviceType == null) return [];
    if (_serviceMap.containsKey(serviceType.id)) {
      return _serviceMap[serviceType.id];
    }
    GraphQLApi.getServicesByServiceTypeId(serviceType.id).then((value) {
      _serviceMap[serviceType.id] = value;
      value.forEach((element) {
        element.serviceType = serviceType;
      });
      notifyListeners();
    }).catchError(print);
    return [];
  }

  Service get selectedService => services[_selectedServiceId];
  void selectService(int id) {
    _selectedServiceId = id;
    _cacheServiceInfos.clear();
    _serviceInfoCount = -1;
    notifyListeners();
  }

  var _serviceInfoCount = -1;
  int serviceInfoCount(String token) {
    if (_serviceInfoCount == -1) {
      GraphQLApi.getServiceInfoCount(token, _selectedServiceId).then((value) {
        _serviceInfoCount = value;
        notifyListeners();
      }).catchError(print);
      return 0;
    }
    return _serviceInfoCount;
  }

  Map<int, ServiceInfo> _cacheServiceInfos = {};
  Future<ServiceInfo> getServiceInfo(String token, int offset,
      {int len = 10}) async {
    if (!_cacheServiceInfos.containsKey(offset)) {
      var infos = await GraphQLApi.getServiceInfos(
          token, _selectedServiceId, offset, len);
      int index = 0;
      for (var info in infos) {
        _cacheServiceInfos[offset + index] = info;
        index++;
      }
    }
    return _cacheServiceInfos[offset];
  }

  int _selectedServiceInfoId;
  int get selectedServiceInfoId => _selectedServiceInfoId;
  void selectServiceInfo(ServiceInfo serviceInfo) {
    _selectedServiceInfoId = serviceInfo.id;
    _selectedServiceStaffId = serviceInfo.serviceStaff.id;
    notifyListeners();
  }

  Future<ServiceInfo> get selectedServiceInfo =>
      GraphQLApi.getServiceInfo(_selectedServiceInfoId);

  var _selectedServiceStaffId = 0;
  int get selectedServiceStaffId => _selectedServiceStaffId;
  void selectServiceStaff(int id) {
    _selectedServiceStaffId = id;
    notifyListeners();
  }

  Future<ServiceStaff> getSelectedServiceStaff(String token) async =>
      GraphQLApi.getStaff(token, _selectedServiceStaffId);

  Future<void> starServiceStaff(String token) async {
    await GraphQLApi.changeStarStaff(token, _selectedServiceStaffId, null);
    notifyListeners();
  }
}
