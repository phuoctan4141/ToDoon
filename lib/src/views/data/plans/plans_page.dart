import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:todoon/src/constants/language.dart';
import 'package:todoon/src/constants/states.dart';
import 'package:todoon/src/constants/strings.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/controllers/settings/themes.dart';
import 'package:todoon/src/models/plan/plan_export.dart';
import 'package:todoon/src/views/data/plans/components/add_plan.dart';
import 'package:todoon/src/views/data/plans/components/edit_plan.dart';
import 'package:todoon/src/views/data/plans/components/menu_plan.dart';
import 'package:todoon/src/views/data/plans/components/plan_title.dart';
import 'package:todoon/src/views/data/tasks/tasks_page.dart';
import 'package:todoon/src/views/settings/settings_page.dart';
import 'package:todoon/src/views/widgets/drawer_widget.dart';
import 'package:todoon/src/views/widgets/empty_icon_widget.dart';
import 'package:todoon/src/views/widgets/wrong_widget.dart';

class PlansPage extends StatefulWidget {
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
    fetandhandleData();
  }

  @override
  void dispose() {
    scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
      ),
      // ignore: prefer_const_constructors
      drawer: DrawerWidget(
        notHome: false,
      ),
      body: _bodyPlans(context),
      floatingActionButton: _floatingActionButton(context),
    );
  }

  /////////////////////////////
  // View Widgets  ////////////
  // View Widgets /////////////
  /////////////////////////////

  Widget routeSettings(BuildContext context) {
    return IconButton(
      tooltip: Language.instance.Settings_Title,
      onPressed: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // ignore: prefer_const_constructors
            builder: (context) => SettingsPage(),
          ),
        ).then((_) => fetandhandleData()); // Navigator
      }, // onPressed
      icon: const Icon(Icons.settings),
    );
  }

  // Load data from _inMemoryCache.
  Widget _bodyPlans(BuildContext context) {
    final plansList = context.read<DataController>().dataModel.getPlansList;

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
      onDismissed: (_) async => dismissPLan(context, plan),
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
            // ignore: prefer_const_constructors
            builder: (context) => TasksPage(plan: plan),
          ),
        ).then((_) => fetandhandleData());
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
    return AlertDialog(
      title: Text(Language.instance.Delete_Plan),
      content: Text(Language.instance.Delete_Sure),
      actionsAlignment: MainAxisAlignment.center,
      actions: <Widget>[
        ElevatedButton.icon(
            style: Themes.instance.DismissButtonStyle,
            onPressed: () => Navigator.of(context).pop(true),
            icon: const Icon(Icons.delete),
            label: Text(Language.instance.Delete_Plan)),
        ElevatedButton.icon(
          onPressed: () => Navigator.of(context).pop(false),
          icon: const Icon(Icons.cancel),
          label: Text(Language.instance.Cancel),
        ),
      ],
    );
  }

  /////////////////////////////
  // View handle  /////////////
  // View handle //////////////
  /////////////////////////////

  void fetandhandleData() {
    final dataController = context.read<DataController>();
    dataController.fetandcreateJsonFile().then((state) => setState(() {
          isLoading = false;

          if (state.compareTo(States.isEXIST) == 0) {
            dataController.loadData().then((_) => setState(() {}));
          }
        }));
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
            if (name.isEmpty) {
              Navigator.of(context).pop(false);
              wrongWidget(context);
            } else {
              dataController.dataModel.createPlan(name: name);
              Navigator.of(context).pop(true);
              await dataController.writeData().then((value) => setState(() {}));
            }
          },
          onCancel: () => Navigator.of(context).pop(false)),
    );
  }

  Future<void> editPlan(BuildContext context, Plan plan) async {
    planController = TextEditingController();
    planController.text = plan.name;
    final dataController = context.read<DataController>();

    await showDialog(
      context: context,
      builder: (BuildContext context) => EditPlan(
          controller: planController,
          onEdit: () async {
            final name = planController.text;
            if (name.isEmpty) {
              Navigator.of(context).pop(false);
              wrongWidget(context);
            } else {
              plan.name = name;
              dataController.dataModel.updatePlan(plan);
              Navigator.of(context).pop(true);
              await dataController.writeData().then((value) => setState(() {}));
            }
          },
          onCancel: () => Navigator.of(context).pop(false)),
    );
  }

  Future<void> dismissPLan(BuildContext context, Plan plan) async {
    final dataController = context.read<DataController>();
    dataController.dataModel.deletePlan(plan);

    await dataController.writeData().then(
          (value) => setState(() {
            // showSnackBar.
            ScaffoldMessenger.of(context).showSnackBar(SnackBar(
              content: Text('${plan.name} ${Language.instance.Plan_Dismissed}'),
              behavior: SnackBarBehavior.floating,
              margin: const EdgeInsets.all(10),
              duration: const Duration(seconds: 1),
            ));
          }),
        );
  }

  Future<void> deletePlan(BuildContext context, Plan plan) async {
    final dataController = context.read<DataController>();

    final isConfirmDelete = await showDialog(
        context: context,
        builder: (BuildContext context) => _confirmDelete(context));

    if (isConfirmDelete ?? false) {
      dataController.dataModel.deletePlan(plan);

      await dataController.writeData().then(
            (value) => setState(() {
              // showSnackBar.
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(
                  content:
                      Text('${Language.instance.Delete_Plan} ${plan.name}'),
                  behavior: SnackBarBehavior.floating,
                  margin: const EdgeInsets.all(10),
                  duration: const Duration(seconds: 1),
                ),
              );
            }),
          );
    }
  }
}
