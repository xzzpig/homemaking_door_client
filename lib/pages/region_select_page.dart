import 'package:flutter/material.dart';
import 'package:homemaking_door/beans.dart';
import 'package:homemaking_door/graphql.dart';
import 'package:homemaking_door/widgets/future_widget.dart';

class RegionSelectPage extends StatefulWidget {
  static String routeName = "/selectRegion";

  @override
  _RegionSelectPageState createState() => _RegionSelectPageState();
}

class _RegionSelectPageState extends State<RegionSelectPage> {
  List<int> selectedRegion;

  @override
  Widget build(BuildContext context) {
    if (selectedRegion == null) {
      selectedRegion = [null, null, null];
      int initRegion = ModalRoute.of(context).settings.arguments;
      if (initRegion != null) {
        GraphQLApi.getRegion(initRegion).then((value) {
          setState(() {
            selectedRegion = [
              value.parent.parent.id,
              value.parent.id,
              value.id
            ];
          });
        });
      }
    }
    return Scaffold(
        appBar: AppBar(
          title: Text("选择区域"),
          actions: <Widget>[
            selectedRegion != null && selectedRegion[2] != null
                ? InkWell(
                    child: Padding(
                      padding: const EdgeInsets.all(16),
                      child: Center(child: Text("完成")),
                    ),
                    onTap: () {
                      Navigator.pop(context, selectedRegion[2]);
                    },
                  )
                : Container(),
          ],
        ),
        body: Row(
          children: <Widget>[
            Expanded(
                child: FutureWidget<List<Region>>(
              future: GraphQLApi.getSubRegions(),
              builder: (context, regions) => ListView.builder(
                  itemCount: regions.length,
                  itemBuilder: (context, index) {
                    Region region = regions[index];
                    return InkWell(
                      onTap: () {
                        setState(() {
                          selectedRegion[0] = region.id;
                          selectedRegion[1] = null;
                          selectedRegion[2] = null;
                        });
                      },
                      child: Container(
                        color: selectedRegion[0] == region.id
                            ? Colors.white
                            : null,
                        padding: EdgeInsets.all(8),
                        child: Center(child: Text(region.name)),
                      ),
                    );
                  }),
            )),
            Container(
              width: .5,
              color: Colors.grey,
            ),
            Expanded(
                child: selectedRegion[0] == null
                    ? Container()
                    : FutureWidget<List<Region>>(
                        future: GraphQLApi.getSubRegions(
                            regionId: selectedRegion[0]),
                        builder: (context, regions) => ListView.builder(
                            itemCount: regions.length,
                            itemBuilder: (context, index) {
                              Region region = regions[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedRegion[1] = region.id;
                                    selectedRegion[2] = null;
                                  });
                                },
                                child: Container(
                                  color: selectedRegion[1] == region.id
                                      ? Colors.white
                                      : null,
                                  padding: EdgeInsets.all(8),
                                  child: Center(child: Text(region.name)),
                                ),
                              );
                            }),
                      )),
            Container(
              width: .5,
              color: Colors.grey,
            ),
            Expanded(
                child: selectedRegion[1] == null
                    ? Container()
                    : FutureWidget<List<Region>>(
                        future: GraphQLApi.getSubRegions(
                            regionId: selectedRegion[1]),
                        builder: (context, regions) => ListView.builder(
                            itemCount: regions.length,
                            itemBuilder: (context, index) {
                              Region region = regions[index];
                              return InkWell(
                                onTap: () {
                                  setState(() {
                                    selectedRegion[2] = region.id;
                                  });
                                },
                                child: Container(
                                  color: selectedRegion[2] == region.id
                                      ? Colors.white
                                      : null,
                                  padding: EdgeInsets.all(8),
                                  child: Center(child: Text(region.name)),
                                ),
                              );
                            }),
                      )),
          ],
        ));
  }
}
