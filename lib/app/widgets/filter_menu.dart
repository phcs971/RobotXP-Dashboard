import 'dart:math';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:get_it/get_it.dart';
import 'package:robotxp_dashboard/app/models/filter_model.dart';
import 'package:robotxp_dashboard/app/stores/home_store.dart';
import 'package:robotxp_dashboard/app/utils.dart';

class FilterMenu extends StatefulWidget {
  const FilterMenu({Key? key}) : super(key: key);

  @override
  State<FilterMenu> createState() => _FilterMenuState();
}

class _FilterMenuState extends State<FilterMenu> {
  final store = GetIt.I<HomeStore>();

  @override
  void initState() {
    super.initState();
    refresh();
    store.controller.addListener(onTab);
  }

  @override
  void dispose() {
    store.controller.removeListener(onTab);
    super.dispose();
  }

  Future refresh() async {
    store.trajPage = 0;
    await store.fetchTrajectories();
  }

  void onTab() {
    if (store.controller.index == 1) {
      refresh();
    }
  }

  Widget buildByDate(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: store.dateFilters.map((filter) {
          final selected =
              (filter is EmptyFilterModel && store.filter == null) ||
                  filter.hashCode == store.filter?.hashCode;
          return Padding(
            padding: const EdgeInsets.symmetric(vertical: 4.0),
            child: DecoratedBox(
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(8),
                color: selected ? RobotColors.primary : null,
                border: Border.all(color: Colors.black),
              ),
              child: ListTile(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                  side: const BorderSide(color: Colors.black),
                ),
                title: Center(
                  child: Text(
                    filter.title.toUpperCase(),
                    style: TextStyle(
                        fontWeight:
                            selected ? FontWeight.bold : FontWeight.normal),
                  ),
                ),
                onTap: () {
                  Navigator.pop(context);
                  store.setFilter(filter);
                },
              ),
            ),
          );
        }).toList(),
      ),
    );
  }

  Widget buildTrajectories(BuildContext context) {
    return Observer(
      builder: (_) => Column(
        children: [
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                children: store.trajectoryFilters.map((filter) {
                  final selected = filter.hashCode == store.filter?.hashCode;
                  return Padding(
                    padding: const EdgeInsets.symmetric(vertical: 4.0),
                    child: DecoratedBox(
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(8),
                        color: selected ? RobotColors.primary : null,
                        border: Border.all(color: Colors.black),
                      ),
                      child: ListTile(
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                          side: const BorderSide(color: Colors.black),
                        ),
                        title: Center(
                          child: Text(
                            filter.title.toUpperCase(),
                            style: TextStyle(
                                fontWeight: selected
                                    ? FontWeight.bold
                                    : FontWeight.normal),
                          ),
                        ),
                        onTap: () {
                          Navigator.pop(context);
                          store.setFilter(filter);
                        },
                      ),
                    ),
                  );
                }).toList(),
              ),
            ),
          ),
          Container(
            width: double.infinity,
            decoration: const BoxDecoration(
              color: Colors.white,
              border: Border(top: BorderSide(color: Colors.black)),
            ),
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                const Spacer(),
                Text(
                  "${store.trajPage * store.trajTake + 1} - ${min((store.trajPage + 1) * store.trajTake, store.trajectoriesCount)} de ${store.trajectoriesCount}",
                ),
                IconButton(
                  onPressed: store.trajPage == 0
                      ? null
                      : () {
                          store.trajPage -= 1;
                          store.fetchTrajectories();
                        },
                  icon: const Icon(Icons.arrow_back_rounded),
                  iconSize: 16,
                ),
                IconButton(
                  onPressed: (store.trajPage + 1) * store.trajTake >=
                          store.trajectoriesCount
                      ? null
                      : () {
                          store.trajPage += 1;
                          store.fetchTrajectories();
                        },
                  icon: const Icon(Icons.arrow_forward_rounded),
                  iconSize: 16,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Drawer(
      width: 304,
      backgroundColor: Colors.white,
      child: SizedBox(
        height: double.infinity,
        width: 304,
        child: Column(
          children: [
            DecoratedBox(
              decoration: const BoxDecoration(
                color: Colors.white,
                border: Border(bottom: BorderSide(color: Colors.black)),
              ),
              child: Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: TabBar(
                  controller: store.controller,
                  tabs: const [Tab(text: "Tempo"), Tab(text: "Trajetoria")],
                  labelColor: RobotColors.primary,
                  unselectedLabelColor: Colors.grey,
                  indicatorColor: RobotColors.primary,
                  labelStyle: const TextStyle(fontWeight: FontWeight.bold),
                  unselectedLabelStyle:
                      const TextStyle(fontWeight: FontWeight.normal),
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: store.controller,
                children: List.generate(
                  2,
                  (index) => [buildByDate, buildTrajectories][index](context),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
