// ignore_for_file: prefer_final_fields, no_leading_underscores_for_local_identifiers, unused_local_variable, unused_field

import 'package:collection/collection.dart';
import 'package:todoon/src/controllers/data/data_controller.dart';
import 'package:todoon/src/models/plan/plan_export.dart';

enum TaskState { not, com, dead }

/// [Handle] and [Repository] Data.
class DataModel implements PlanModel, TasksModel {
  /// PLan list storage.
  late PlansList _storage = PlansList(plans: []);

  /// Plan list cache.
  late PlansList _inMemoryCache = PlansList(plans: []);

  /// Get [unmodifiable] data for the _storage.
  get getDataStorage => List.unmodifiable(_storage.plans);

  /// Set [unmodifiable] data to the _storage.
  void setStorage(PlansList plansList) {
    _storage = PlansList(plans: List.unmodifiable(plansList.plans));
  }

  ///////////////////////////////
  // _inMemoryCache /////////////
  // _inMemoryCache /////////////
  ///////////////////////////////

  /// Get Plans List for the _inMemoryCache.
  PlansList get getPlansList {
    final plansList = PlansList(plans: List.unmodifiable(_inMemoryCache.plans));
    return plansList;
  }

  /// Set Plans List to the _inMemoryCache.
  void setMemoryCache(PlansList plansList) {
    _inMemoryCache = plansList;
  }

  /// Get Tasks List for the _inMemoryCache.
  TasksList getTasksList(Plan plan) {
    final index = indexPlan(plan);
    if (index == -1) return TasksList(tasks: []);

    final tasksList =
        TasksList(tasks: List.unmodifiable(_inMemoryCache.plans[index].tasks));

    return tasksList;
  }

  /// Not complete tasksList.
  TasksList notTasksList(TasksList taskList) {
    final notTasks = taskList.tasks.where((element) {
      final now = DateTime.now();
      final due = DataController.instance.Iso8601toDateTime(element.date);
      if (due != null) {
        return element.complete == false && due.isAfter(now);
      }
      return element.complete == false;
    }).toList();
    final _tasksList = TasksList(tasks: List.unmodifiable(notTasks));

    return _tasksList;
  }

  /// Complete tasksList.
  TasksList comTasksList(TasksList taskList) {
    final comTasks =
        taskList.tasks.where((element) => element.complete == true).toList();
    final _tasksList = TasksList(tasks: List.unmodifiable(comTasks));

    return _tasksList;
  }

  /// Deadline tasksList.
  TasksList deadTasksList(TasksList taskList) {
    final comTasks = taskList.tasks.where((element) {
      final now = DateTime.now();
      final due = DataController.instance.Iso8601toDateTime(element.date);
      return due?.isBefore(now) == true && element.complete == false;
    }).toList();
    final _tasksList = TasksList(tasks: List.unmodifiable(comTasks));

    return _tasksList;
  }

  /// PLansList Today.
  PlansList get plansListToday {
    final plansToday = getPlansList.plans.where((element) {
      final tasksList = tasksListToday(element.tasks);
      if (tasksList.tasks.isNotEmpty) return true;
      return false;
    }).toList();

    final _plansList = PlansList(plans: List.unmodifiable(plansToday));

    return _plansList;
  }

  /// TasksList Today
  TasksList tasksListToday(List<Task> tasks) {
    final tasksList = TasksList(tasks: getTasksToday(tasks) ?? []);
    return tasksList;
  }

  /// tasks Today.
  List<Task>? getTasksToday(List<Task> tasks) {
    final tasksToday = tasks.where((element) {
      final now = DateTime.now();
      final due = DataController.instance.Iso8601toDateTime(element.date);
      if (due != null &&
          now.year == due.year &&
          now.month == due.month &&
          now.day == due.day &&
          element.complete == false) {
        return true;
      }
      return false;
    }).toList();

    return tasksToday;
  }

  //////////////////////////////
  // Plans handle  /////////////
  // Plans handle //////////////
  //////////////////////////////

  /// Create a plan with ID [Unique].
  @override
  void createPlan({required String name}) {
    // Create Unique ID.
    final id = createUniqueId();
    // Create plan with id.
    final plan = Plan(id: id, name: name, tasks: []);
    // Add plan.
    addPlan(plan);
  }

  /// Get all plan from _inMemoryCache.
  @override
  List<Plan> get getAllPlans {
    return List.unmodifiable(_inMemoryCache.plans);
  }

  /// Get a pLan where ID is.
  @override
  Plan? getPlan(int id) {
    final plans = List.unmodifiable(_inMemoryCache.plans);
    final plan = plans.firstWhereOrNull((element) => element.id == id);
    if (plan != null) {
      return Plan(id: plan.id, name: plan.name, tasks: plan.tasks);
    }
    return null;
  }

  /// Add a plan to the _storage.
  @override
  void addPlan(Plan plan) {
    // Add plan to _inMemoryCache;
    _inMemoryCache.plans.add(plan);
    // Write to _storage.
    setStorage(_inMemoryCache);
  }

  /// Update a plan to the _storage.
  @override
  void updatePlan(Plan plan) {
    final _indexPlan = indexPlan(plan);
    if (_indexPlan == -1) return;
    // Update plan to _inMemoryCache.
    _inMemoryCache.plans[_indexPlan] = plan;
    // Write to _storage.
    setStorage(_inMemoryCache);
  }

  /// Delete a plan to the _storage.
  @override
  void deletePlan(Plan plan) {
    final _indexPlan = indexPlan(plan);
    if (_indexPlan == -1) return;
    // Delete plan to _inMemoryCache.
    _inMemoryCache.plans.remove(plan);
    // Write to _storage.
    setStorage(_inMemoryCache);
  }

  /// Find an [index] plan for the _inMemoryCache.
  @override
  int indexPlan(Plan plan) {
    final plans = List.unmodifiable(_inMemoryCache.plans);
    return plans.indexWhere((element) => element.id == plan.id);
  }

  //////////////////////////////
  // Tasks handle  /////////////
  // Tasks handle //////////////
  //////////////////////////////

  /// Create a [task] to [plan] with ID [Unique].
  @override
  void createTask(Plan plan,
      {String description = '',
      String date = '',
      String reminder = '',
      bool complete = false,
      bool alert = false}) {
    // Find [plan] in our list of plans.
    final _indexPlan = indexPlan(plan);
    if (_indexPlan == -1) return;

    // Create Unique ID.
    final id = createUniqueId();
    // Create task with id.
    final task =
        Task(id: id, description: description, date: date, reminder: reminder);
    // add task.
    addTask(plan, task);
  }

  /// Get [Tasks] for the plan.
  @override
  List<Task> getAllTask(Plan plan) {
    final index = indexPlan(plan);
    if (index == -1) return [];

    final List<Task> tasks =
        List.unmodifiable(_inMemoryCache.plans[index].tasks);
    return tasks;
  }

  /// Get a task for the plan where ID is.
  @override
  Task? getTask(Plan plan, int id) {
    final _indexPLan = indexPlan(plan);
    if (_indexPLan == -1) return null;
    final tasks = List.unmodifiable(plan.tasks);
    final task = tasks.firstWhereOrNull((element) => element.id == id);
    if (task != null) {
      return Task(
          id: task.id,
          description: task.description,
          date: task.date,
          reminder: task.reminder,
          complete: task.complete,
          alert: task.alert);
    }
    return null;
  }

  @override
  Task? getLastTask(Plan plan) {
    final _indexPLan = indexPlan(plan);
    if (_indexPLan == -1) return null;
    final tasks = List.unmodifiable(plan.tasks);

    return tasks.last;
  }

  /// Add a task to the plan.
  @override
  void addTask(Plan plan, Task task) {
    final _indexPlan = indexPlan(plan);
    if (_indexPlan == -1) return;
    // Add task to _inMemoryCache.
    _inMemoryCache.plans[_indexPlan].tasks.add(task);

    // Write to _storage.
    setStorage(_inMemoryCache);
  }

  /// Delete a task to the plan.
  @override
  void deleteTask(Plan plan, Task task) {
    final _indexPLan = indexPlan(plan);
    if (_indexPLan == -1) return;
    final _indexTask = indexTask(plan, task);
    if (_indexTask == -1) return;

    _inMemoryCache.plans[_indexPLan].tasks.remove(task);
    // Write to _storage.
    setStorage(_inMemoryCache);
  }

  /// Update a task for the plan.
  @override
  int updateTask(Plan plan, Task task) {
    final _indexPLan = indexPlan(plan);
    if (_indexPLan == -1) return 3;
    final _indexTask = indexTask(plan, task);
    if (_indexTask == -1) return 3;

    final _old = _storage.plans[_indexPLan].tasks[_indexTask];

    // If [_old] is [different] from [task], then update.
    if (_old.description != task.description ||
        _old.date != task.date ||
        _old.reminder != task.reminder ||
        _old.complete != task.complete ||
        _old.alert != task.alert) {
      // update task to _inMemoryCache.
      _inMemoryCache.plans[_indexPLan].tasks[_indexTask] = task;
      // Write to _storage.
      setStorage(_inMemoryCache);
      return 1;
    } else {
      return 0;
    }
  }

  /// Find an [index] task for the plan.
  @override
  int indexTask(Plan plan, Task task) {
    final _indexPLan = indexPlan(plan);
    if (_indexPLan == -1) return -1;
    final tasks = List.unmodifiable(plan.tasks);

    return tasks.indexWhere((element) => element.id == task.id);
  }

  void dispose() {
    _storage.plans.clear();
    _inMemoryCache.plans.clear();
  }
}

/// Plan handle.
abstract class PlanModel {
  void createPlan({required String name});
  List<Plan> get getAllPlans;
  Plan? getPlan(int id);
  void addPlan(Plan plan);
  void updatePlan(Plan plan);
  void deletePlan(Plan plan);
  int indexPlan(Plan plan);
}

/// Tasks handle.
abstract class TasksModel {
  void createTask(Plan plan,
      {String description = '',
      String date = '',
      String reminder = '',
      bool complete = false,
      bool alert = false});
  List<Task>? getAllTask(Plan plan);
  Task? getTask(Plan plan, int id);
  Task? getLastTask(Plan plan);
  void addTask(Plan plan, Task task);
  int updateTask(Plan plan, Task task);
  void deleteTask(Plan plan, Task task);
  int indexTask(Plan plan, Task task);
}

/// Check for duplicates and return string.
String checkForDuplicates(Iterable<String> items, String text) {
  final duplicatedCount = items.where((item) => item.contains(text)).length;
  if (duplicatedCount > 0) {
    text += '${duplicatedCount - 1}';
    checkForDuplicates(items, text);
  }

  return text;
}

/// Create Unique ID.
int createUniqueId() => DateTime.now().millisecondsSinceEpoch.remainder(100000);
