import 'package:flutter/material.dart';
import '../models/task_model.dart';
import '../services/firebase_service.dart';
import '../services/task_notification_manager.dart';
import '../utils/responsive_utils.dart';
import '../l10n/app_localizations.dart';

class AddTaskScreen extends StatefulWidget {
  final TaskItemModel? existingTask;

  const AddTaskScreen({super.key, this.existingTask});

  @override
  _AddTaskScreenState createState() => _AddTaskScreenState();
}

class _AddTaskScreenState extends State<AddTaskScreen> {
  final _formKey = GlobalKey<FormState>();
  final _titleController = TextEditingController();
  final _descriptionController = TextEditingController();

  String _selectedCategory = 'Personal';
  String _selectedPriority = 'medium';
  DateTime? _selectedDate;
  bool _isLoading = false;

  bool get _isTaskCompleted => widget.existingTask?.isCompleted ?? false;

  final List<String> _categories = [
    'Personal',
    'Work',
    'Shopping',
    'Health',
    'Education',
  ];
  final List<String> _priorities = ['low', 'medium', 'high'];

  String _getLocalizedCategory(BuildContext context, String category) {
    switch (category.toLowerCase()) {
      case 'personal':
        return AppLocalizations.of(context)!.personal;
      case 'work':
        return AppLocalizations.of(context)!.work;
      case 'shopping':
        return AppLocalizations.of(context)!.shopping;
      case 'health':
        return AppLocalizations.of(context)!.health;
      case 'education':
        return AppLocalizations.of(context)!.education;
      default:
        return category;
    }
  }

  String _getLocalizedPriority(BuildContext context, String priority) {
    switch (priority.toLowerCase()) {
      case 'high':
        return AppLocalizations.of(context)!.high;
      case 'medium':
        return AppLocalizations.of(context)!.medium;
      case 'low':
        return AppLocalizations.of(context)!.low;
      default:
        return priority;
    }
  }

  @override
  void initState() {
    super.initState();
    _initializeFormFields();
  }

  void _initializeFormFields() {
    if (widget.existingTask != null) {
      final task = widget.existingTask!;
      _titleController.text = task.title;
      _descriptionController.text = task.description.isNotEmpty
          ? task.description
          : '';
      _selectedCategory = task.category;
      _selectedPriority = task.priority;
      _selectedDate = task.dueDate;
    }
  }

  @override
  Widget build(BuildContext context) {
    final isSmallScreen = ResponsiveUtils.isVerySmallScreen(context);
    final horizontalPadding = ResponsiveUtils.getHorizontalPadding(context);

    return Scaffold(
      backgroundColor: const Color(0xFFF8FAFC),
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        backgroundColor: const Color(0xFFF8FAFC),
        elevation: 0,
        toolbarHeight: ResponsiveUtils.getAppBarHeight(context),
        title: Text(
          widget.existingTask != null
              ? AppLocalizations.of(context)!.editTask
              : AppLocalizations.of(context)!.addNewTask,
          style: TextStyle(
            color: const Color(0xFF1E293B),
            fontWeight: FontWeight.bold,
            fontSize: isSmallScreen ? 18 : 20,
          ),
        ),
        iconTheme: IconThemeData(
          color: const Color(0xFF1E293B),
          size: isSmallScreen ? 20 : 24,
        ),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(context).unfocus(),
        child: SingleChildScrollView(
          padding: EdgeInsets.all(horizontalPadding),
          child: Form(
            key: _formKey,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Task Title
                Text(
                  AppLocalizations.of(context)!.taskTitle,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                TextFormField(
                  controller: _titleController,
                  enabled: !_isTaskCompleted,
                  autofocus: false,
                  enableInteractiveSelection: true,
                  style: TextStyle(fontSize: isSmallScreen ? 14 : 16),
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(context)!.enterTaskTitle,
                    hintStyle: TextStyle(fontSize: isSmallScreen ? 13 : 14),
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(
                        isSmallScreen ? 8 : 12,
                      ),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: _isTaskCompleted
                        ? Colors.grey.shade100
                        : Colors.white,
                    contentPadding: EdgeInsets.all(isSmallScreen ? 12 : 16),
                  ),
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return AppLocalizations.of(context)!.pleaseEnterTitle;
                    }
                    return null;
                  },
                ),

                SizedBox(
                  height: ResponsiveUtils.getVerticalSpacing(context) * 1.25,
                ),

                // Task Description
                Text(
                  AppLocalizations.of(context)!.taskDescriptionOptional,
                  style: TextStyle(
                    fontSize: isSmallScreen ? 14 : 16,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF1E293B),
                  ),
                ),
                SizedBox(height: isSmallScreen ? 6 : 8),
                TextFormField(
                  controller: _descriptionController,
                  enabled: !_isTaskCompleted,
                  autofocus: false,
                  enableInteractiveSelection: true,
                  maxLines: 3,
                  decoration: InputDecoration(
                    hintText: AppLocalizations.of(
                      context,
                    )!.enterTaskDescriptionOptional,
                    border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(12),
                      borderSide: BorderSide.none,
                    ),
                    filled: true,
                    fillColor: _isTaskCompleted
                        ? Colors.grey.shade100
                        : Colors.white,
                    contentPadding: const EdgeInsets.all(16),
                  ),
                  // Removed validator to make description optional
                ),

                const SizedBox(height: 20),

                // Category Selection
                Text(
                  AppLocalizations.of(context)!.category,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 16),
                  decoration: BoxDecoration(
                    color: _isTaskCompleted
                        ? Colors.grey.shade100
                        : Colors.white,
                    borderRadius: BorderRadius.circular(12),
                  ),
                  child: DropdownButtonFormField<String>(
                    initialValue: _selectedCategory,
                    decoration: const InputDecoration(border: InputBorder.none),
                    items: _categories.map((category) {
                      return DropdownMenuItem(
                        value: category,
                        child: Text(_getLocalizedCategory(context, category)),
                      );
                    }).toList(),
                    onChanged: _isTaskCompleted
                        ? null
                        : (value) {
                            setState(() {
                              _selectedCategory = value!;
                            });
                          },
                  ),
                ),

                const SizedBox(height: 20),

                // Priority Selection
                Text(
                  AppLocalizations.of(context)!.priority,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                Row(
                  children: _priorities.map((priority) {
                    final isSelected = _selectedPriority == priority;
                    return Expanded(
                      child: GestureDetector(
                        onTap: _isTaskCompleted
                            ? null
                            : () {
                                setState(() {
                                  _selectedPriority = priority;
                                });
                              },
                        child: Container(
                          margin: const EdgeInsets.only(right: 8),
                          padding: const EdgeInsets.all(12),
                          decoration: BoxDecoration(
                            color: isSelected
                                ? _getPriorityColor(priority)
                                : (_isTaskCompleted
                                      ? Colors.grey.shade100
                                      : Colors.white),
                            borderRadius: BorderRadius.circular(12),
                            border: Border.all(
                              color: _isTaskCompleted
                                  ? Colors.grey.shade300
                                  : _getPriorityColor(priority),
                              width: 2,
                            ),
                          ),
                          child: Text(
                            _getLocalizedPriority(
                              context,
                              priority,
                            ).toUpperCase(),
                            textAlign: TextAlign.center,
                            style: TextStyle(
                              color: _isTaskCompleted
                                  ? Colors.grey.shade600
                                  : (isSelected
                                        ? Colors.white
                                        : _getPriorityColor(priority)),
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ),
                      ),
                    );
                  }).toList(),
                ),

                const SizedBox(height: 20),

                // Due Date
                Text(
                  AppLocalizations.of(context)!.dueDateOptional,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: Color(0xFF1E293B),
                  ),
                ),
                const SizedBox(height: 8),
                GestureDetector(
                  onTap: _isTaskCompleted ? null : _selectDate,
                  child: Container(
                    padding: const EdgeInsets.all(16),
                    decoration: BoxDecoration(
                      color: _isTaskCompleted
                          ? Colors.grey.shade100
                          : Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Row(
                      children: [
                        const Icon(
                          Icons.calendar_today,
                          color: Color(0xFF3B82F6),
                        ),
                        const SizedBox(width: 12),
                        Text(
                          _selectedDate == null
                              ? AppLocalizations.of(context)!.selectDueDate
                              : '${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}',
                          style: TextStyle(
                            color: _selectedDate == null
                                ? Colors.grey.shade600
                                : const Color(0xFF1E293B),
                          ),
                        ),
                        const Spacer(),
                        if (_selectedDate != null && !_isTaskCompleted)
                          GestureDetector(
                            onTap: () {
                              setState(() {
                                _selectedDate = null;
                              });
                            },
                            child: const Icon(Icons.clear, color: Colors.grey),
                          ),
                      ],
                    ),
                  ),
                ),

                const SizedBox(height: 40),

                // Add/Update Task Button
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _isLoading ? null : _submitTask,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF3B82F6),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: _isLoading
                        ? const CircularProgressIndicator(color: Colors.white)
                        : Text(
                            widget.existingTask != null
                                ? AppLocalizations.of(context)!.updateTask
                                : AppLocalizations.of(context)!.addTask,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                            ),
                          ),
                  ),
                ),

                // Add bottom padding to ensure button is visible above navigation bar
                SizedBox(height: MediaQuery.of(context).padding.bottom + 80),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Color _getPriorityColor(String priority) {
    switch (priority) {
      case 'high':
        return Colors.red;
      case 'medium':
        return Colors.orange;
      case 'low':
        return Colors.green;
      default:
        return Colors.grey;
    }
  }

  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime.now(),
      lastDate: DateTime.now().add(const Duration(days: 365)),
    );

    if (picked != null) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  Future<void> _submitTask() async {
    debugPrint('Submit task called');
    if (!_formKey.currentState!.validate()) {
      debugPrint('Form validation failed');
      return;
    }

    debugPrint('Setting loading state to true');
    setState(() {
      _isLoading = true;
    });

    try {
      if (widget.existingTask != null) {
        // Update existing task
        final updatedTask = widget.existingTask!.copyWith(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          priority: _selectedPriority,
          dueDate: _selectedDate,
        );

        await FirebaseService.updateTask(updatedTask);

        // Handle notifications for the updated task
        await TaskNotificationManager.onTaskUpdated(
          widget.existingTask!,
          updatedTask,
        );

        if (mounted && context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                AppLocalizations.of(context)!.taskUpdatedSuccessfully,
              ),
              backgroundColor: Colors.green,
              duration: Duration(seconds: 2),
            ),
          );

          // Wait a bit before navigating to allow snackbar to show
          await Future.delayed(const Duration(milliseconds: 500));

          if (mounted && context.mounted) {
            debugPrint('Task updated successfully, navigating back');
            // Navigate back to home screen with success result
            Navigator.pop(context, true);
          }
        }
      } else {
        // Add new task
        debugPrint(
          'Creating new task with title: ${_titleController.text.trim()}',
        );
        final task = TaskItemModel(
          title: _titleController.text.trim(),
          description: _descriptionController.text.trim(),
          category: _selectedCategory,
          priority: _selectedPriority,
          createdAt: DateTime.now(),
          dueDate: _selectedDate,
        );

        debugPrint('Calling FirebaseService.addTask');
        final taskId = await FirebaseService.addTask(task);
        debugPrint('FirebaseService.addTask returned: $taskId');

        if (taskId != null) {
          // Handle notifications for the new task
          await TaskNotificationManager.onTaskCreated(
            task.copyWith(id: taskId),
          );

          if (mounted && context.mounted) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  AppLocalizations.of(context)!.taskAddedSuccessfully,
                ),
                backgroundColor: Colors.green,
                duration: Duration(seconds: 2),
              ),
            );

            // Wait a bit before navigating to allow snackbar to show
            await Future.delayed(const Duration(milliseconds: 500));

            if (mounted && context.mounted) {
              debugPrint('Task added successfully, navigating back');
              // Navigate back to home screen with success result
              Navigator.pop(context, true);
            }
          }
        } else {
          _showError(AppLocalizations.of(context)!.failedToAddTask);
        }
      }
    } catch (e) {
      debugPrint('Error submitting task: $e');
      if (mounted) {
        _showError(AppLocalizations.of(context)!.anErrorOccurred(e.toString()));
      }
    } finally {
      // Ensure loading state is reset even if there's an error
      if (mounted) {
        setState(() {
          _isLoading = false;
        });
      }
    }
  }

  void _showError(String message) {
    if (mounted && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          backgroundColor: Colors.red,
          duration: const Duration(seconds: 3),
        ),
      );
    }
  }

  @override
  void dispose() {
    _titleController.dispose();
    _descriptionController.dispose();
    super.dispose();
  }
}
