// ignore_for_file: no_leading_underscores_for_local_identifiers

import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/routes/routes.dart';
import 'package:todoon/src/views/data/plans/components/alert_delete_plan.dart';
import 'package:todoon/src/views/data/plans/components/plans_components.dart';
import 'package:todoon/src/views/data/tasks/tasks_page.dart';
import 'package:todoon/src/views/widgets/drawer_widget.dart';
import 'package:todoon/src/views/widgets/empty_icon_widget.dart';
import 'package:todoon/src/views/widgets/wrong_widget.dart';

class PlansPage extends StatefulWidget {
  static const routeName = PAGE_HOME;
  const PlansPage({super.key});

  @override
  State<PlansPage> createState() => _PlansPageState();
}

class _PlansPageState extends State<PlansPage> {
  late ScrollController scrollController;
  late TextEditingController planController;
  late bool isLoading = true;

  @override
  void initState() {
    super.initState();

    scrollController = ScrollController();
    fetandhandleData(context);
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Consumer<DataController>(
      builder: (context, dataController, child) {
        final plansList = dataController.dataModel.getPlansList;

        return Scaffold(
          appBar: AppBar(
            title: const Text(Strings.NAME_APP),
            leading: Builder(
              builder: (BuildContext context) {
                return IconButton(
                  icon: const Icon(Icons.menu),
                  onPressed: () {
                    Scaffold.of(context).openDrawer();
                  },
                  tooltip: Language.instance.Show_Menu,
                );
              },
            ),
            actions: [
              _search(context, plansList),
            ],
          ),
          // ignore: prefer_const_constructors
          drawer: DrawerWidget(
            notHome: false,
          ),
          body: _bodyPlans(context),
          floatingActionButton: _floatingActionButton(context),
        );
      },
    );
  }

  /////////////////////////////
  // View Widgets  ////////////
  // View Widgets /////////////
  /////////////////////////////

  Widget _search(BuildContext context, PlansList plansList) {
    return IconButton(
        onPressed: () {
          showSearch(context: context, delegate: PlanSearchDelegate(plansList));
        },
        tooltip: Language.instance.Search,
        icon: const Icon(Icons.search));
  }

  // Load data from _inMemoryCache.
  Widget _bodyPlans(BuildContext context) {
    final dataController = Provider.of<DataController>(context, listen: false);
    final plansList = dataController.dataModel.getPlansList;

    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    } else {
      return Center(
        child: plansList.plans.isEmpty
            // ignore: prefer_const_constructors
            ? EmptyIconWidget()
            : Column(
                children: [
                  Expanded(child: _buildPlansList(context, plansList)),
                ],
              ),
      );
    }
  }

  Widget _buildPlansList(BuildContext context, PlansList plansList) {
    return ListView.builder(
        clipBehavior: Clip.antiAlias,
        controller: scrollController,
        shrinkWrap: true,
        itemCount: plansList.plans.length,
        itemBuilder: (context, indexPlan) =>
            _buildPlanTile(context, plansList.plans, indexPlan));
  }

  Widget _buildPlanTile(BuildContext context, List<Plan> plans, int indexPlan) {
    final plan = plans[indexPlan];

    return PlanTitle(
      plan: plan,
      onDismissed: (_) async => dismissPlan(context, plan),
      onTap: () {
        _routePlan(context, plan);
      },
      trailing: _menuPlan(context, plan),
    );
  }

  Widget _floatingActionButton(BuildContext context) {
    return FloatingActionButton(
      onPressed: () async {
        await addNewPlan(context);
      },
      tooltip: Language.instance.Add_Plan,
      child: const Icon(Icons.format_list_bulleted_add),
    );
  }

  Widget _menuPlan(BuildContext context, Plan plan) {
    return MenuPlan(
        onEdit: () => editPlan(context, plan),
        onDelete: () => deletePlan(context, plan));
  }

  // ignore: unused_element
  Widget _confirmDelete(BuildContext context) {
    return const AlertDeletePlan();
  }

  /////////////////////////////
  // View handle  /////////////
  // View handle //////////////
  /////////////////////////////

  void _routePlan(BuildContext context, Plan plan) {
    Navigator.pushNamed(context, TasksPage.routeName, arguments: plan);
  }

  Future<void> fetandhandleData(BuildContext context) async {
    final done = await context.read<DataController>().loadData();

    if (context.mounted && done.compareTo(States.TRUE) == 0) {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<void> addNewPlan(BuildContext context) async {
    planController = TextEditingController();
    final dataController = context.read<DataController>();

    await showDialog(
      context: context,
      builder: (BuildContext context) => AddPLan(
          controller: planController,
          onAdd: () async {
            final name = planController.text;
            final done = await dataController.addNewPlan(name);

            if (context.mounted) {
              if (done.compareTo(States.TRUE) == 0) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
                wrongWidget(context);
              }
            }
          },
          onCancel: () => Navigator.of(context).pop(false)),
    );
  }

  Future<void> editPlan(BuildContext context, Plan plan) async {
    final dataController = context.read<DataController>();
    planController = TextEditingController();
    planController.text = plan.name;

    await showDialog(
      context: context,
      builder: (BuildContext context) => EditPlan(
          controller: planController,
          onEdit: () async {
            final name = planController.text;
            final done = await dataController.editAPlan(plan, name);

            if (context.mounted) {
              if (done.compareTo(States.TRUE) == 0) {
                Navigator.of(context).pop(true);
              } else {
                Navigator.of(context).pop(false);
                wrongWidget(context);
              }
            }
          },
          onCancel: () => Navigator.of(context).pop(false)),
    );
  }

  Future<void> dismissPlan(BuildContext context, Plan plan) async {
    final dataController = context.read<DataController>();
    final done = await dataController.deleteAPlan(plan);

    if (context.mounted && done.compareTo(States.TRUE) == 0) {
      ScaffoldMessenger.of(context).showSnackBar(SnackBar(
        content: Text('${plan.name} ${Language.instance.Plan_Dismissed}'),
        behavior: SnackBarBehavior.floating,
        margin: const EdgeInsets.all(10),
        duration: const Duration(seconds: 1),
      ));
    }
  }

  Future<void> deletePlan(BuildContext context, Plan plan) async {
    final dataController = context.read<DataController>();

    final isConfirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) => _confirmDelete(context));

    if (isConfirmDelete ?? false) {
      final done = await dataController.deleteAPlan(plan);

      if (context.mounted && done.compareTo(States.TRUE) == 0) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text('${Language.instance.Delete_Plan} ${plan.name}'),
            behavior: SnackBarBehavior.floating,
            margin: const EdgeInsets.all(10),
            duration: const Duration(seconds: 1),
          ),
        );
      }
    }
  }
//end code
}

/// Plan search delegate.
class PlanSearchDelegate extends SearchDelegate {
  final PlansList plansList;

  PlanSearchDelegate(this.plansList)
      : super(
          searchFieldLabel: Language.instance.Search,
          keyboardType: TextInputType.text,
          textInputAction: TextInputAction.search,
        );

  @override
  List<Widget>? buildActions(BuildContext context) {
    return [
      IconButton(
          onPressed: () {
            query = '';
          },
          tooltip: Language.instance.Refresh,
          icon: const Icon(Icons.replay))
    ];
  }

  @override
  Widget? buildLeading(BuildContext context) {
    return IconButton(
        onPressed: () {
          close(context, null);
        },
        tooltip: Language.instance.Back,
        icon: const Icon(Icons.arrow_back));
  }

  @override
  Widget buildResults(BuildContext context) {
    List<Plan> matchQuery = [];
    for (var plan in plansList.plans) {
      if (plan.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(plan);
      }
    }
    return ListView.builder(
      itemBuilder: (context, index) {
        var plan = matchQuery[index];
        return ListTile(
          leading: CircleAvatar(child: Text(plan.name[0])),
          title: Text(plan.name),
          onTap: () => Navigator.pushNamed(context, TasksPage.routeName,
              arguments: plan),
        );
      },
      itemCount: matchQuery.length,
    );
  }

  @override
  Widget buildSuggestions(BuildContext context) {
    List<Plan> matchQuery = [];

    for (var plan in plansList.plans) {
      if (plan.name.toLowerCase().contains(query.toLowerCase())) {
        matchQuery.add(plan);
      }
    }

    return ListView.builder(
      itemBuilder: (context, index) {
        var plan = matchQuery[index];
        return ListTile(
          leading: CircleAvatar(child: Text(plan.name[0])),
          title: Text(plan.name),
          onTap: () => Navigator.pushNamed(context, TasksPage.routeName,
              arguments: plan),
        );
      },
      itemCount: matchQuery.length,
    );
  }
//end code
}
