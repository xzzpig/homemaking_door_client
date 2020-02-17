import 'package:flutter/foundation.dart';
import 'package:homemaking_door/beans.dart';

class ServiceState with ChangeNotifier {
  List<ServiceType> get serviceTypes => [
        ServiceType(0, "aaa"),
        ServiceType(1, "bbb"),
        ServiceType(2, "ccc"),
        ServiceType(3, "ddd")
      ];

  var _selectedServiceTypeIndex = 0;
  int get selectedServiceTypeIndex => _selectedServiceTypeIndex;
  void selectServiceType(int index) {
    _selectedServiceTypeIndex = index;
    notifyListeners();
  }

  int _selectedServiceId = -1;
  List<Service> get services => [
        Service(name: "eee", describe: "fff"),
        Service(name: "eee", describe: "fff"),
        Service(name: "eee", describe: "fff"),
        Service(name: "eee", describe: "fff")
      ];
  Service get selectedService => services[_selectedServiceId];
  void selectService(int id) {
    _selectedServiceId = id;
    notifyListeners();
  }

  List<ServiceInfo> get serviceInfos => [
        ServiceInfo(
            service: Service(
                name: "hahh",
                serviceType: ServiceType(0, "hifoaw"),
                describe: "faiowfujiaw;"),
            price: 50,
            serviceStaff: ServiceStaff(
                publicInfo: PublicUser(name: "aaa", headImage: ""),
                score: 3,
                tags: ['aa', 'bb'],
                orderCount: 10)),
        ServiceInfo(
            service: Service(
                name: "hahh",
                serviceType: ServiceType(0, "hifoaw"),
                describe: "faiowfujiaw;"),
            price: 50,
            serviceStaff: ServiceStaff(
                publicInfo: PublicUser(name: "aaa", headImage: ""),
                score: 3,
                tags: ['aa', 'bb'],
                orderCount: 10)),
        ServiceInfo(
            service: Service(
                name: "hahh",
                serviceType: ServiceType(0, "hifoaw"),
                describe: "faiowfujiaw;"),
            price: 50,
            serviceStaff: ServiceStaff(
                publicInfo: PublicUser(name: "aaa", headImage: ""),
                score: 3,
                tags: ['aa', 'bb'],
                orderCount: 10)),
      ];
  var _selectedServiceInfoIndex = 0;
  int get selectedServiceInfoIndex => _selectedServiceInfoIndex;
  ServiceInfo get selectedServiceInfo => serviceInfos[selectedServiceInfoIndex];
  void selectServiceInfo(int index) {
    _selectedServiceInfoIndex = index;
    notifyListeners();
  }

  var _selectedServiceStaffId = 0;
  int get selectedServiceStaffId => _selectedServiceStaffId;
  ServiceStaff get selectedServiceStaff => ServiceStaff(
      id: 0,
      publicInfo: PublicUser(name: "aaa", describe: "hhh"),
      score: 3,
      tags: ["bb", "cc"],
      starCount: 3,
      isStared: true,
      orderCount: 5,
      assessments: [],
      services: serviceInfos);
  void starServiceStaff(int id){
    selectedServiceStaff.isStared=!selectedServiceStaff.isStared;
    notifyListeners();
  }
}
