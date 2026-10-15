// Day 5 · Demo 4 — NotifierProvider for complex state
// Run: flutter run -t lib/day5_demos/demo4_notifier_provider.dart
//
// When state has several operations (add, toggle, remove…), put them in a
// Notifier class. Widgets just call methods; all the logic lives in one place.
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class Task {
  const Task({required this.id, required this.title, this.isDone = false});

  final int id;
  final String title;
  final bool isDone;

  // State must be IMMUTABLE: we never change a Task, we make a new copy.
  Task copyWith({bool? isDone}) => Task(id: id, title: title, isDone: isDone ?? this.isDone);
}

// The Notifier owns the state and the logic. No widgets, no BuildContext.
class TaskListNotifier extends Notifier<List<Task>> {
  int _nextId = 3;

  // build() returns the starting state.
  @override
  List<Task> build() => const [
        Task(id: 1, title: 'Revise Dart classes'),
        Task(id: 2, title: 'Finish Contact Book homework', isDone: true),
      ];

  void add(String title) {
    // Create a NEW list. `state.add(...)` would change the old list in place,
    // and Riverpod wouldn't notice anything changed.
    state = [...state, Task(id: _nextId++, title: title)];
  }

  void toggle(int id) {
    state = [
      for (final task in state)
        if (task.id == id) task.copyWith(isDone: !task.isDone) else task,
    ];
  }

  void remove(int id) {
    state = state.where((task) => task.id != id).toList();
  }
}

final taskListProvider = NotifierProvider<TaskListNotifier, List<Task>>(TaskListNotifier.new);

// A derived value: recalculated automatically whenever the task list changes.
final remainingCountProvider = Provider<int>((ref) {
  return ref.watch(taskListProvider).where((task) => !task.isDone).length;
});

void main() => runApp(const ProviderScope(child: MaterialApp(home: TaskScreen())));

// ConsumerStatefulWidget: like StatefulWidget, but with `ref`.
// We need State here only for the TextEditingController.
class TaskScreen extends ConsumerStatefulWidget {
  const TaskScreen({super.key});

  @override
  ConsumerState<TaskScreen> createState() => _TaskScreenState();
}

class _TaskScreenState extends ConsumerState<TaskScreen> {
  final _controller = TextEditingController();

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _addTask() {
    final title = _controller.text.trim();
    if (title.isEmpty) return;
    // .notifier gives the Notifier object, so we can call its methods.
    ref.read(taskListProvider.notifier).add(title);
    _controller.clear();
  }

  @override
  Widget build(BuildContext context) {
    final tasks = ref.watch(taskListProvider);
    final remaining = ref.watch(remainingCountProvider);

    return Scaffold(
      appBar: AppBar(title: Text('Tasks · $remaining left')),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _controller,
                    decoration: const InputDecoration(labelText: 'New task', border: OutlineInputBorder()),
                    onSubmitted: (_) => _addTask(),
                  ),
                ),
                const SizedBox(width: 8),
                IconButton.filled(onPressed: _addTask, icon: const Icon(Icons.add)),
              ],
            ),
          ),
          Expanded(
            child: ListView.builder(
              itemCount: tasks.length,
              itemBuilder: (context, index) {
                final task = tasks[index];
                return CheckboxListTile(
                  value: task.isDone,
                  title: Text(
                    task.title,
                    style: TextStyle(decoration: task.isDone ? TextDecoration.lineThrough : null),
                  ),
                  onChanged: (_) => ref.read(taskListProvider.notifier).toggle(task.id),
                  secondary: IconButton(
                    icon: const Icon(Icons.delete_outline),
                    onPressed: () => ref.read(taskListProvider.notifier).remove(task.id),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}
