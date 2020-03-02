import 'package:graphql/client.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/utils.dart';

final HttpLink _httpLink = HttpLink(
    uri: 'http://localhost:8080/graphql',
    headers: {
      "Accept": "application/json",
      "Content-Type": "application/json"
    });

final Link _link = _httpLink;

final GraphQLClient client = GraphQLClient(
  cache: InMemoryCache(),
  link: _link,
);

class GraphQLApi {
  static void resetCache() {
    client.cache.reset();
  }

  static Future<String> login(String username, String password) async {
    var ts = DateTime.now().millisecondsSinceEpoch;
    var options = QueryOptions(document: r"""
      query($username:String!,$password:String!,$timestamp:Long!){
        UserQuery{
          login(username:$username,password:$password,timestamp:$timestamp)
        }
      }
  """, variables: {
      "username": username,
      "password":
          "$username$password".md5().join((ts ~/ 1000).toString()).md5(),
      "timestamp": ts
    });
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    return result.data["UserQuery"]["login"];
  }

  static Future<List<ServiceType>> getServiceTypes() async {
    var options = QueryOptions(document: r"""
      query{
        ServiceQuery{
          serviceTypes{
            id
            name
          }
        }
      }
    """);
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    return ((result.data["ServiceQuery"]["serviceTypes"] as List<dynamic>)
        .map((e) => ServiceType.fromDynamic(e))).toList();
  }

  static Future<List<Service>> getServicesByServiceTypeId(int id) async {
    var options = QueryOptions(document: r"""
      query($id:Int!){
        ServiceQuery{
          serviceType(id:$id){
            services{
              id
              name
              describe
              icon
            }
          }
        }
      }
    """, variables: {"id": id});
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    return ((result.data["ServiceQuery"]["serviceType"]["services"]
            as List<dynamic>)
        .map((e) => Service.fromDynamic(e))
        .toList());
  }

  static Future<AuthUser> getAuthUser(String token) async {
    var options = QueryOptions(document: r"""
      query($token:String!){
        UserQuery{
          auth(token:$token){
            UserQuery{
              info{
                phone
                  info{
                    id
                    name
                    userName
                    nickName
                    sex
                    describe
                    headImage
                    region{
                      id
                      mername
                    }
                  }
              }
            }
          }
        }
      }
    """, variables: {"token": token});
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    return AuthUser.fromDynamic(
        result.data["UserQuery"]["auth"]["UserQuery"]["info"]);
  }

  static Future<List<ServiceInfo>> getServiceInfos(
      String token, int serviceId, int offset, int len) async {
    var options = QueryOptions(document: r"""
      query($token:String!,$serviceId:Int!,$offset:Int!,$len:Int!){
        UserQuery{
          auth(token:$token){
            ServiceQuery{
              service(id:$serviceId){
                staffs(offset:$offset,len:$len){
                  id
                  price
                  serviceStaff{
                    id
                    publicInfo{
                      name
                    }
                    tags
                    starCount
                    orderCount
                    score
                  }
                }
              }
            }
          }
        }
      }
    """, variables: {
      "token": token,
      "serviceId": serviceId,
      "len": len,
      "offset": offset
    });
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    return ((result.data["UserQuery"]["auth"]["ServiceQuery"]["service"]
            ["staffs"] as List<dynamic>)
        .map((e) => ServiceInfo.fromDynamic(e))
        .toList());
  }

  static Future<int> getServiceInfoCount(String token, int serviceId) async {
    var options = QueryOptions(document: r"""
      query($token:String!,$serviceId:Int!){
        UserQuery{
          auth(token:$token){
            ServiceQuery{
              service(id:$serviceId){
                staffCount
              }
            }
          }
        }
      }
    """, variables: {"token": token, "serviceId": serviceId});
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    return result.data["UserQuery"]["auth"]["ServiceQuery"]["service"]
        ["staffCount"];
  }

  static Future<ServiceStaff> getStaff(String token, int staffId) async {
    var options = QueryOptions(document: r"""
      query ($token: String!, $staffId: Int!) {
        UserQuery {
          auth(token: $token) {
            StaffQuery {
              staff(id: $staffId) {
                id
                publicInfo {
                  name
                  describe
                }
                score
                tags
                orderCount
                services {
                  id
                  service {
                    id
                    name
                    describe
                    serviceType{
                      id
                      name
                    }
                  }
                  price
                  serviceStaff{
                    id
                  }
                }
                starCount
                isStared
              }
            }
          }
        }
      }
    """, variables: {"token": token, "staffId": staffId});
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    return ServiceStaff.fromDynamic(
        result.data["UserQuery"]["auth"]["StaffQuery"]["staff"]);
  }

  static Future<void> changeStarStaff(
      String token, int staffId, bool star) async {
    var options = MutationOptions(document: r"""
mutation($token:String!,$staffId:Int!,$star:Boolean){
  starStaff(token:$token,staff:$staffId,star:$star)
}
    """, variables: {"token": token, "staffId": staffId, "star": star});
    var result = await client.mutate(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    resetCache();
  }

  static Future<List<Order>> getOrders(
      String token, int state, String searchText, int offset, int len) async {
    var options = QueryOptions(document: r"""
      query ($token: String!, $state: Int,$searchText:String, $offset: Int!, $len: Int!) {
        UserQuery {
          auth(token: $token) {
            UserQuery {
              info {
                orders(state: $state,searchText:$searchText, offset: $offset, len: $len) {
                  id
                  serviceInfo {
                    id
                    service {
                      id
                      name
                    }
                  }
                  state
                  staff {
                    id
                    publicInfo {
                      name
                    }
                  }
                  time
                  address {
                    id
                    region {
                      mername
                    }
                    detail
                  }
                  price
                  actions
                }
              }
            }
          }
        }
      }
    """, variables: {
      "token": token,
      "state": state,
      "searchText": searchText,
      "offset": offset,
      "len": len
    });
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    var res = (result.data["UserQuery"]["auth"]["UserQuery"]["info"]["orders"]
            as List<dynamic>)
        .map((e) => Order.fromDynamic(e))
        .toList();
    return res;
  }

  static Future<int> getOrderCount(
      String token, int state, String searchText) async {
    var options = QueryOptions(document: r"""
      query ($token: String!, $state: Int,$searchText:String) {
        UserQuery {
          auth(token: $token) {
            UserQuery {
              info {
                orderCount(state: $state,searchText:$searchText)
              }
            }
          }
        }
      }
    """, variables: {"token": token, "state": state, "searchText": searchText});
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    return result.data["UserQuery"]["auth"]["UserQuery"]["info"]["orderCount"];
  }

  static Future<Address> getDefaultAddress(String token) async {
    var options = QueryOptions(document: r"""
      query ($token: String!) {
        UserQuery {
          auth(token: $token) {
            UserQuery {
              info {
                defaultAddress {
                  id
                  detail
                  region {
                    id
                    mername
                  }
                }
              }
            }
          }
        }
      }
    """, variables: {"token": token});
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    var res = Address.fromDynamic(result.data["UserQuery"]["auth"]["UserQuery"]
        ["info"]["defaultAddress"]);
    return res;
  }

  static Future<List<Address>> getAddresses(String token) async {
    var options = QueryOptions(document: r"""
      query ($token: String!) {
        UserQuery {
          auth(token: $token) {
            UserQuery {
              info {
                addresses{
                  id
                  region{
                    id
                    mername
                  }
                  detail
                }
              }
            }
          }
        }
      }
    """, variables: {"token": token});
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    var res = (result.data["UserQuery"]["auth"]["UserQuery"]["info"]
            ["addresses"] as List<dynamic>)
        .map((e) => Address.fromDynamic(e))
        .toList();
    return res;
  }

  static Future<String> getPhone(String token) async {
    var options = QueryOptions(document: r"""
      query ($token: String!) {
        UserQuery {
          auth(token: $token) {
            UserQuery {
              info {
                phone
              }
            }
          }
        }
      }
    """, variables: {"token": token});
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    var res = result.data["UserQuery"]["auth"]["UserQuery"]["info"]["phone"]
        .toString();
    return res;
  }

  static Future<ServiceInfo> getServiceInfo(int id) async {
    var options = QueryOptions(document: r"""
      query($id:Int!){
        ServiceQuery{
          serviceInfo(id:$id){
            id
            price
            service{
              id
              serviceType{
                id
                name
              }
              name
              formDefines{
                id
                key
                describe
                type
              }
            }
            serviceStaff{
              id
              publicInfo{
                name
              }
            }
          }
        }
      }
    """, variables: {"id": id});
    var result = await client.query(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    var res =
        ServiceInfo.fromDynamic(result.data["ServiceQuery"]["serviceInfo"]);
    return res;
  }

  static Future<void> createOrder(String token, int serviceInfo, String form,
      DateTime time, int address) async {
    var options = MutationOptions(document: r"""
      mutation($token:String!,$orderInput:OrderInput!){
        createOrder(token:$token,orderInput:$orderInput)
      }
    """, variables: {
      "token": token,
      "orderInput": {
        "serviceInfo": serviceInfo,
        "form": form,
        "time": time.millisecondsSinceEpoch,
        "address": address
      }
    });
    var result = await client.mutate(options);
    if (result.hasErrors) {
      throw GraphQLException(result.errors[0]);
    }
    resetCache();
  }
}

class GraphQLException {
  GraphQLError raw;
  String message;
  String location;

  GraphQLException(GraphQLError err) {
    this.raw = err;
    var data = err.message.split(":");
    this.message = data[1].trim();
    this.location = data[0].split("(")[1].split(")")[0];
  }

  @override
  String toString() {
    return "$location:$message";
  }
}
