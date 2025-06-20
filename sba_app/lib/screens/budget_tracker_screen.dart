import 'package:flutter/material.dart';

class BudgetTrackerScreen extends StatefulWidget {
  const BudgetTrackerScreen({Key? key}) : super(key: key);

  @override
  State<BudgetTrackerScreen> createState() => _BudgetTrackerScreenState();
}

class _BudgetTrackerScreenState extends State<BudgetTrackerScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  double monthlyIncome = 5000.0;
  
  List<BudgetCategory> budgetCategories = [
    BudgetCategory(
      id: 1,
      name: 'Food & Groceries',
      budget: 800,
      spent: 650,
      color: Colors.red.shade400,
    ),
    BudgetCategory(
      id: 2,
      name: 'Rent/Mortgage',
      budget: 1500,
      spent: 1500,
      color: Colors.teal.shade400,
    ),
    BudgetCategory(
      id: 3,
      name: 'Transport',
      budget: 300,
      spent: 280,
      color: Colors.blue.shade400,
    ),
    BudgetCategory(
      id: 4,
      name: 'Utilities',
      budget: 200,
      spent: 180,
      color: Colors.green.shade400,
    ),
    BudgetCategory(
      id: 5,
      name: 'Entertainment',
      budget: 400,
      spent: 520,
      color: Colors.amber.shade400,
    ),
    BudgetCategory(
      id: 6,
      name: 'Healthcare',
      budget: 200,
      spent: 150,
      color: Colors.purple.shade300,
    ),
  ];

  List<Expense> expenses = [
    Expense(
      id: 1,
      title: 'Grocery Shopping',
      amount: 85,
      category: 'Food & Groceries',
      date: DateTime.now().subtract(const Duration(days: 1)),
      hasReceipt: true,
    ),
    Expense(
      id: 2,
      title: 'Monthly Rent',
      amount: 1500,
      category: 'Rent/Mortgage',
      date: DateTime.now().subtract(const Duration(days: 18)),
      hasReceipt: false,
    ),
    Expense(
      id: 3,
      title: 'Movie Night',
      amount: 45,
      category: 'Entertainment',
      date: DateTime.now().subtract(const Duration(days: 2)),
      hasReceipt: true,
    ),
  ];

  final List<String> categoryOptions = [
    'Food & Groceries',
    'Rent/Mortgage',
    'Utilities',
    'Transport',
    'Insurance',
    'Healthcare',
    'Education',
    'Entertainment',
    'Personal Care',
    'Savings & Investments',
    'Donations',
    'Miscellaneous'
  ];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  double get totalBudget => budgetCategories.fold(0, (sum, cat) => sum + cat.budget);
  double get totalSpent => budgetCategories.fold(0, (sum, cat) => sum + cat.spent);
  double get remainingBudget => monthlyIncome - totalSpent;

  Color getStatusColor(double spent, double budget) {
    final percentage = (spent / budget) * 100;
    if (percentage >= 100) return Colors.red;
    if (percentage >= 80) return Colors.orange;
    return Colors.green;
  }

  void _showIncomeModal() {
    final TextEditingController controller = TextEditingController(
      text: monthlyIncome.toString(),
    );

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Update Monthly Income'),
          content: TextField(
            controller: controller,
            keyboardType: TextInputType.number,
            decoration: const InputDecoration(
              labelText: 'Monthly Income',
              prefixText: '\$',
              border: OutlineInputBorder(),
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  monthlyIncome = double.tryParse(controller.text) ?? monthlyIncome;
                });
                Navigator.pop(context);
              },
              child: const Text('Update'),
            ),
          ],
        );
      },
    );
  }

  void _showCategoryModal({BudgetCategory? category}) {
    final TextEditingController budgetController = TextEditingController(
      text: category?.budget.toString() ?? '',
    );
    String selectedCategory = category?.name ?? '';

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: Text(category == null ? 'Add Category' : 'Edit Category'),
              content: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  DropdownButtonFormField<String>(
                    value: selectedCategory.isEmpty ? null : selectedCategory,
                    decoration: const InputDecoration(
                      labelText: 'Category',
                      border: OutlineInputBorder(),
                    ),
                    items: categoryOptions.map((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(value),
                      );
                    }).toList(),
                    onChanged: (String? newValue) {
                      setModalState(() {
                        selectedCategory = newValue ?? '';
                      });
                    },
                  ),
                  const SizedBox(height: 16),
                  TextField(
                    controller: budgetController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Budget Amount',
                      prefixText: '\$',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ],
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (selectedCategory.isNotEmpty && budgetController.text.isNotEmpty) {
                      setState(() {
                        if (category == null) {
                          // Add new category
                          budgetCategories.add(BudgetCategory(
                            id: DateTime.now().millisecondsSinceEpoch,
                            name: selectedCategory,
                            budget: double.parse(budgetController.text),
                            spent: 0,
                            color: Colors.primaries[budgetCategories.length % Colors.primaries.length],
                          ));
                        } else {
                          // Edit existing category
                          final index = budgetCategories.indexWhere((cat) => cat.id == category.id);
                          if (index != -1) {
                            budgetCategories[index] = budgetCategories[index].copyWith(
                              name: selectedCategory,
                              budget: double.parse(budgetController.text),
                            );
                          }
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: Text(category == null ? 'Add' : 'Update'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _showExpenseModal() {
    final TextEditingController titleController = TextEditingController();
    final TextEditingController amountController = TextEditingController();
    String selectedCategory = '';
    DateTime selectedDate = DateTime.now();

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return StatefulBuilder(
          builder: (context, setModalState) {
            return AlertDialog(
              title: const Text('Add Expense'),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    TextField(
                      controller: titleController,
                      decoration: const InputDecoration(
                        labelText: 'Expense Title',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    TextField(
                      controller: amountController,
                      keyboardType: TextInputType.number,
                      decoration: const InputDecoration(
                        labelText: 'Amount',
                        prefixText: '\$',
                        border: OutlineInputBorder(),
                      ),
                    ),
                    const SizedBox(height: 16),
                    DropdownButtonFormField<String>(
                      value: selectedCategory.isEmpty ? null : selectedCategory,
                      decoration: const InputDecoration(
                        labelText: 'Category',
                        border: OutlineInputBorder(),
                      ),
                      items: budgetCategories.map((BudgetCategory category) {
                        return DropdownMenuItem<String>(
                          value: category.name,
                          child: Text(category.name),
                        );
                      }).toList(),
                      onChanged: (String? newValue) {
                        setModalState(() {
                          selectedCategory = newValue ?? '';
                        });
                      },
                    ),
                    const SizedBox(height: 16),
                    ListTile(
                      title: const Text('Date'),
                      subtitle: Text('${selectedDate.day}/${selectedDate.month}/${selectedDate.year}'),
                      trailing: const Icon(Icons.calendar_today),
                      onTap: () async {
                        final DateTime? picked = await showDatePicker(
                          context: context,
                          initialDate: selectedDate,
                          firstDate: DateTime(2020),
                          lastDate: DateTime.now(),
                        );
                        if (picked != null) {
                          setModalState(() {
                            selectedDate = picked;
                          });
                        }
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () => Navigator.pop(context),
                  child: const Text('Cancel'),
                ),
                ElevatedButton(
                  onPressed: () {
                    if (titleController.text.isNotEmpty &&
                        amountController.text.isNotEmpty &&
                        selectedCategory.isNotEmpty) {
                      setState(() {
                        final expense = Expense(
                          id: DateTime.now().millisecondsSinceEpoch,
                          title: titleController.text,
                          amount: double.parse(amountController.text),
                          category: selectedCategory,
                          date: selectedDate,
                          hasReceipt: false,
                        );
                        expenses.add(expense);

                        // Update category spent amount
                        final categoryIndex = budgetCategories
                            .indexWhere((cat) => cat.name == selectedCategory);
                        if (categoryIndex != -1) {
                          budgetCategories[categoryIndex] = budgetCategories[categoryIndex]
                              .copyWith(spent: budgetCategories[categoryIndex].spent + expense.amount);
                        }
                      });
                      Navigator.pop(context);
                    }
                  },
                  child: const Text('Add Expense'),
                ),
              ],
            );
          },
        );
      },
    );
  }

  void _deleteCategory(int id) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text('Delete Category'),
          content: const Text('Are you sure you want to delete this category?'),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text('Cancel'),
            ),
            ElevatedButton(
              onPressed: () {
                setState(() {
                  budgetCategories.removeWhere((cat) => cat.id == id);
                });
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
              child: const Text('Delete'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Budget Tracker'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        bottom: TabBar(
          controller: _tabController,
          labelColor: Colors.blue,
          unselectedLabelColor: Colors.grey,
          indicatorColor: Colors.blue,
          tabs: const [
            Tab(text: 'Overview'),
            Tab(text: 'Expenses'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildOverviewTab(),
          _buildExpensesTab(),
        ],
      ),
    );
  }

  Widget _buildOverviewTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Income Card
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade500, Colors.green.shade600],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Monthly Income',
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                      ),
                    ),
                    const SizedBox(height: 8),
                    Text(
                      '\$${monthlyIncome.toStringAsFixed(0)}',
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 28,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                IconButton(
                  onPressed: _showIncomeModal,
                  icon: const Icon(Icons.edit, color: Colors.white),
                  style: IconButton.styleFrom(
                    backgroundColor: Colors.white.withOpacity(0.2),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

          // Budget Summary Cards
          Row(
            children: [
              Expanded(
                child: _buildSummaryCard(
                  'Total Budget',
                  '\$${totalBudget.toStringAsFixed(0)}',
                  Icons.account_balance_wallet,
                  Colors.blue,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Total Spent',
                  '\$${totalSpent.toStringAsFixed(0)}',
                  Icons.trending_up,
                  Colors.red,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _buildSummaryCard(
                  'Remaining',
                  '\$${remainingBudget.toStringAsFixed(0)}',
                  Icons.pie_chart,
                  remainingBudget >= 0 ? Colors.green : Colors.red,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),

          // Budget Categories
          Container(
            padding: const EdgeInsets.all(20),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      'Budget Categories',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () => _showCategoryModal(),
                      icon: const Icon(Icons.add, size: 16),
                      label: const Text('Add Category'),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        foregroundColor: Colors.white,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 16),
                ...budgetCategories.map((category) => _buildCategoryCard(category)),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExpensesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Text(
                'Recent Expenses',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton.icon(
                onPressed: _showExpenseModal,
                icon: const Icon(Icons.add, size: 16),
                label: const Text('Add Expense'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.blue,
                  foregroundColor: Colors.white,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              boxShadow: [
                BoxShadow(
                  color: Colors.grey.withOpacity(0.1),
                  spreadRadius: 1,
                  blurRadius: 4,
                  offset: const Offset(0, 2),
                ),
              ],
            ),
            child: Column(
              children: expenses.map((expense) => _buildExpenseCard(expense)).toList(),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSummaryCard(String title, String amount, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 4,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(icon, color: color, size: 20),
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  title,
                  style: TextStyle(
                    color: Colors.grey.shade600,
                    fontSize: 12,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 8),
          Text(
            amount,
            style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: Colors.grey.shade800,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryCard(BudgetCategory category) {
    final percentage = (category.spent / category.budget) * 100;
    final isOverBudget = category.spent > category.budget;

    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    width: 16,
                    height: 16,
                    decoration: BoxDecoration(
                      color: category.color,
                      shape: BoxShape.circle,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    category.name,
                    style: const TextStyle(
                      fontWeight: FontWeight.w500,
                      fontSize: 16,
                    ),
                  ),
                  if (isOverBudget) ...[
                    const SizedBox(width: 8),
                    Icon(Icons.warning, color: Colors.red, size: 16),
                  ],
                ],
              ),
              Row(
                children: [
                  Text(
                    '\$${category.spent.toStringAsFixed(0)} / \$${category.budget.toStringAsFixed(0)}',
                    style: TextStyle(
                      color: getStatusColor(category.spent, category.budget),
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _showCategoryModal(category: category),
                    child: Icon(Icons.edit, color: Colors.grey.shade400, size: 16),
                  ),
                  const SizedBox(width: 8),
                  GestureDetector(
                    onTap: () => _deleteCategory(category.id),
                    child: Icon(Icons.delete, color: Colors.grey.shade400, size: 16),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 12),
          LinearProgressIndicator(
            value: percentage / 100,
            backgroundColor: Colors.grey.shade200,
            valueColor: AlwaysStoppedAnimation<Color>(
              isOverBudget
                  ? Colors.red
                  : percentage >= 80
                      ? Colors.orange
                      : Colors.green,
            ),
          ),
          const SizedBox(height: 8),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                '${percentage.toStringAsFixed(1)}% used',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
              Text(
                '\$${(category.budget - category.spent).toStringAsFixed(2)} remaining',
                style: TextStyle(
                  color: Colors.grey.shade600,
                  fontSize: 12,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildExpenseCard(Expense expense) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(color: Colors.grey.shade200),
        ),
      ),
      child: Row(
        children: [
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Text(
                      expense.title,
                      style: const TextStyle(
                        fontWeight: FontWeight.w500,
                        fontSize: 16,
                      ),
                    ),
                    if (expense.hasReceipt) ...[
                      const SizedBox(width: 8),
                      Icon(Icons.receipt, color: Colors.green, size: 16),
                    ],
                  ],
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    Text(
                      expense.category,
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                    Text(
                      ' • ${expense.date.day}/${expense.date.month}/${expense.date.year}',
                      style: TextStyle(
                        color: Colors.grey.shade600,
                        fontSize: 14,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          Text(
            '\$${expense.amount.toStringAsFixed(2)}',
            style: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 16,
            ),
          ),
        ],
      ),
    );
  }
}

// Data Models
class BudgetCategory {
  final int id;
  final String name;
  final double budget;
  final double spent;
  final Color color;

  BudgetCategory({
    required this.id,
    required this.name,
    required this.budget,
    required this.spent,
    required this.color,
  });

  BudgetCategory copyWith({
    int? id,
    String? name,
    double? budget,
    double? spent,
    Color? color,
  }) {
    return BudgetCategory(
      id: id ?? this.id,
      name: name ?? this.name,
      budget: budget ?? this.budget,
      spent: spent ?? this.spent,
      color: color ?? this.color,
    );
  }
}

class Expense {
  final int id;
  final String title;
  final double amount;
  final String category;
  final DateTime date;
  final bool hasReceipt;

  Expense({
    required this.id,
    required this.title,
    required this.amount,
    required this.category,
    required this.date,
    required this.hasReceipt,
  });
}