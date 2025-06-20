import 'package:flutter/material.dart';
import 'dart:math' as math;

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({Key? key}) : super(key: key);

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen>
    with TickerProviderStateMixin {
  late AnimationController _scoreAnimationController;
  late AnimationController _chartAnimationController;
  late Animation<double> _scoreAnimation;
  late Animation<double> _chartAnimation;

  // Sample data - replace with actual data from your app
  final double monthlyIncome = 5000.0;
  final int budgetHealthScore = 78;
  final double totalSpent = 3430.0;
  final double totalBudget = 3400.0;
  final int daysRemaining = 12;

  final List<MonthlySpending> monthlyTrends = [
    MonthlySpending('Jan', 2800),
    MonthlySpending('Feb', 3200),
    MonthlySpending('Mar', 2950),
    MonthlySpending('Apr', 3400),
    MonthlySpending('May', 3100),
    MonthlySpending('Jun', 3430),
  ];

  final List<SpendingCategory> spendingDistribution = [
    SpendingCategory('Food & Groceries', 650, Colors.red.shade400),
    SpendingCategory('Rent/Mortgage', 1500, Colors.teal.shade400),
    SpendingCategory('Transport', 280, Colors.blue.shade400),
    SpendingCategory('Utilities', 180, Colors.green.shade400),
    SpendingCategory('Entertainment', 520, Colors.amber.shade400),
    SpendingCategory('Healthcare', 150, Colors.purple.shade300),
    SpendingCategory('Others', 150, Colors.orange.shade400),
  ];

  final List<SpendingPattern> weeklyPatterns = [
    SpendingPattern('Mon', 45),
    SpendingPattern('Tue', 38),
    SpendingPattern('Wed', 52),
    SpendingPattern('Thu', 41),
    SpendingPattern('Fri', 78),
    SpendingPattern('Sat', 95),
    SpendingPattern('Sun', 67),
  ];

  @override
  void initState() {
    super.initState();
    _scoreAnimationController = AnimationController(
      duration: const Duration(milliseconds: 2000),
      vsync: this,
    );
    _chartAnimationController = AnimationController(
      duration: const Duration(milliseconds: 1500),
      vsync: this,
    );

    _scoreAnimation = Tween<double>(
      begin: 0,
      end: budgetHealthScore.toDouble(),
    ).animate(CurvedAnimation(
      parent: _scoreAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _chartAnimation = Tween<double>(
      begin: 0,
      end: 1,
    ).animate(CurvedAnimation(
      parent: _chartAnimationController,
      curve: Curves.easeOutCubic,
    ));

    _scoreAnimationController.forward();
    _chartAnimationController.forward();
  }

  @override
  void dispose() {
    _scoreAnimationController.dispose();
    _chartAnimationController.dispose();
    super.dispose();
  }

  Color _getScoreColor(double score) {
    if (score >= 80) return Colors.green;
    if (score >= 60) return Colors.orange;
    return Colors.red;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade50,
      appBar: AppBar(
        title: const Text('Analytics'),
        backgroundColor: Colors.white,
        foregroundColor: Colors.black,
        elevation: 0,
        actions: [
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: () {
              _scoreAnimationController.reset();
              _chartAnimationController.reset();
              _scoreAnimationController.forward();
              _chartAnimationController.forward();
            },
          ),
        ],
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _buildBudgetHealthScore(),
            const SizedBox(height: 24),
            _buildMonthlyTrendChart(),
            const SizedBox(height: 24),
            _buildSpendingDistribution(),
            const SizedBox(height: 24),
            _buildSpendingPatterns(),
            const SizedBox(height: 24),
            _buildSavingsOptimizer(),
            const SizedBox(height: 24),
            _buildBehaviorSuggestions(),
          ],
        ),
      ),
    );
  }

  Widget _buildBudgetHealthScore() {
    return Container(
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.health_and_safety, color: _getScoreColor(budgetHealthScore.toDouble())),
              const SizedBox(width: 8),
              const Text(
                'Budget Health Score',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: _scoreAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(120, 120),
                      painter: ScoreCirclePainter(
                        score: _scoreAnimation.value,
                        color: _getScoreColor(_scoreAnimation.value),
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AnimatedBuilder(
                      animation: _scoreAnimation,
                      builder: (context, child) {
                        return Text(
                          '${_scoreAnimation.value.toInt()}/100',
                          style: TextStyle(
                            fontSize: 32,
                            fontWeight: FontWeight.bold,
                            color: _getScoreColor(_scoreAnimation.value),
                          ),
                        );
                      },
                    ),
                    const SizedBox(height: 8),
                    Text(
                      _getScoreMessage(budgetHealthScore),
                      style: TextStyle(
                        fontSize: 14,
                        color: Colors.grey.shade600,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Container(
                      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.orange.shade50,
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(color: Colors.orange.shade200),
                      ),
                      child: Text(
                        'At current pace: \$${(totalSpent + (totalSpent / (30 - daysRemaining) * daysRemaining)).toStringAsFixed(0)} by month end',
                        style: TextStyle(
                          fontSize: 12,
                          color: Colors.orange.shade700,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildMonthlyTrendChart() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.blue.shade600),
              const SizedBox(width: 8),
              const Text(
                'Monthly Spending Trend',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          SizedBox(
            height: 200,
            child: AnimatedBuilder(
              animation: _chartAnimation,
              builder: (context, child) {
                return CustomPaint(
                  size: Size(MediaQuery.of(context).size.width - 72, 200),
                  painter: LineChartPainter(
                    data: monthlyTrends,
                    animation: _chartAnimation.value,
                  ),
                );
              },
            ),
          ),
          const SizedBox(height: 16),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              _buildTrendStat('Avg Monthly', '\$${(monthlyTrends.fold(0.0, (sum, item) => sum + item.amount) / monthlyTrends.length).toStringAsFixed(0)}', Colors.blue),
              _buildTrendStat('This Month', '\$${monthlyTrends.last.amount.toStringAsFixed(0)}', Colors.green),
              _buildTrendStat('vs Last Month', '${((monthlyTrends.last.amount - monthlyTrends[monthlyTrends.length - 2].amount) / monthlyTrends[monthlyTrends.length - 2].amount * 100).toStringAsFixed(1)}%', 
                monthlyTrends.last.amount > monthlyTrends[monthlyTrends.length - 2].amount ? Colors.red : Colors.green),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingDistribution() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.pie_chart, color: Colors.purple.shade600),
              const SizedBox(width: 8),
              const Text(
                'Spending Distribution',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                flex: 2,
                child: AnimatedBuilder(
                  animation: _chartAnimation,
                  builder: (context, child) {
                    return CustomPaint(
                      size: const Size(150, 150),
                      painter: DonutChartPainter(
                        data: spendingDistribution,
                        animation: _chartAnimation.value,
                      ),
                    );
                  },
                ),
              ),
              Expanded(
                flex: 3,
                child: Column(
                  children: spendingDistribution.take(5).map((category) {
                    final percentage = (category.amount / totalSpent * 100);
                    return Padding(
                      padding: const EdgeInsets.symmetric(vertical: 4),
                      child: Row(
                        children: [
                          Container(
                            width: 12,
                            height: 12,
                            decoration: BoxDecoration(
                              color: category.color,
                              shape: BoxShape.circle,
                            ),
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              category.name,
                              style: const TextStyle(fontSize: 12),
                            ),
                          ),
                          Text(
                            '${percentage.toStringAsFixed(1)}%',
                            style: const TextStyle(
                              fontSize: 12,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ],
                      ),
                    );
                  }).toList(),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildSpendingPatterns() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.teal.shade600),
              const SizedBox(width: 8),
              const Text(
                'Spending Patterns',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.red.shade50,
              borderRadius: BorderRadius.circular(8),
              border: Border.all(color: Colors.red.shade200),
            ),
            child: Row(
              children: [
                Icon(Icons.warning_amber, color: Colors.red.shade600, size: 20),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Anomaly detected: \$520 entertainment expense is 35% higher than usual',
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.red.shade700,
                    ),
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'Weekly Spending Intensity',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: weeklyPatterns.map((pattern) {
              final intensity = pattern.amount / 100; // Normalize to 0-1
              return Column(
                children: [
                  Container(
                    width: 30,
                    height: 60,
                    decoration: BoxDecoration(
                      color: Colors.grey.shade200,
                      borderRadius: BorderRadius.circular(4),
                    ),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: AnimatedContainer(
                        duration: Duration(milliseconds: 800 + (weeklyPatterns.indexOf(pattern) * 100)),
                        width: 30,
                        height: 60 * intensity * _chartAnimation.value,
                        decoration: BoxDecoration(
                          color: intensity > 0.7 ? Colors.red.shade400 : 
                                 intensity > 0.5 ? Colors.orange.shade400 : Colors.green.shade400,
                          borderRadius: BorderRadius.circular(4),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(
                    pattern.day,
                    style: TextStyle(
                      fontSize: 12,
                      color: Colors.grey.shade600,
                    ),
                  ),
                ],
              );
            }).toList(),
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: Colors.blue.shade50,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Text(
              'You typically spend 40% more on weekends. Consider planning weekend activities with set budgets.',
              style: TextStyle(
                fontSize: 12,
                color: Colors.blue.shade700,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSavingsOptimizer() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.savings, color: Colors.green.shade600),
              const SizedBox(width: 8),
              const Text(
                'Savings Optimizer',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              gradient: LinearGradient(
                colors: [Colors.green.shade50, Colors.green.shade100],
                begin: Alignment.topLeft,
                end: Alignment.bottomRight,
              ),
              borderRadius: BorderRadius.circular(12),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  'Smart Optimization Suggestion',
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                    color: Colors.green.shade800,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Reducing dining out by 20% could save \$1,248/year',
                  style: TextStyle(
                    fontSize: 14,
                    color: Colors.green.shade700,
                  ),
                ),
                const SizedBox(height: 12),
                Row(
                  children: [
                    Icon(Icons.lightbulb, color: Colors.green.shade600, size: 16),
                    const SizedBox(width: 4),
                    Text(
                      'That\'s enough for a vacation fund!',
                      style: TextStyle(
                        fontSize: 12,
                        color: Colors.green.shade600,
                        fontStyle: FontStyle.italic,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          const SizedBox(height: 16),
          const Text(
            'What-if Scenarios',
            style: TextStyle(
              fontSize: 14,
              fontWeight: FontWeight.w500,
            ),
          ),
          const SizedBox(height: 12),
          _buildOptimizationCard('Entertainment', 20, 1248, Colors.amber),
          _buildOptimizationCard('Food & Groceries', 15, 936, Colors.red),
          _buildOptimizationCard('Transport', 25, 840, Colors.blue),
        ],
      ),
    );
  }

  Widget _buildOptimizationCard(String category, int percentage, int annualSaving, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 8),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade200),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        children: [
          Container(
            width: 12,
            height: 12,
            decoration: BoxDecoration(
              color: color,
              shape: BoxShape.circle,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Text(
              'Reduce $category by $percentage%',
              style: const TextStyle(fontSize: 12),
            ),
          ),
          Text(
            'Save \$${annualSaving}/year',
            style: TextStyle(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: Colors.green.shade600,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildBehaviorSuggestions() {
    return Container(
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.grey.withOpacity(0.1),
            spreadRadius: 1,
            blurRadius: 8,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Icon(Icons.psychology, color: Colors.indigo.shade600),
              const SizedBox(width: 8),
              const Text(
                'AI Behavior Insights',
                style: TextStyle(
                  fontSize: 18,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          _buildSuggestionCard(
            'Overspending Alert',
            'You\'ve exceeded your Entertainment budget for 3 consecutive months.',
            'Try reducing your eating out budget next month by 15%',
            Icons.restaurant,
            Colors.red,
          ),
          _buildSuggestionCard(
            'Great Progress!',
            'You\'ve stayed within your Transport budget for 6 months.',
            'Keep up the good work! Consider allocating saved funds to your emergency fund.',
            Icons.directions_car,
            Colors.green,
          ),
          _buildSuggestionCard(
            'Opportunity Detected',
            'Your utility costs are 20% lower than average.',
            'You could increase your savings rate or invest in energy-efficient appliances.',
            Icons.bolt,
            Colors.blue,
          ),
        ],
      ),
    );
  }

  Widget _buildSuggestionCard(String title, String insight, String suggestion, IconData icon, Color color) {
    return Container(
      margin: const EdgeInsets.only(bottom: 12),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: color.withOpacity(0.05),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: color.withOpacity(0.2)),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              color: color.withOpacity(0.1),
              borderRadius: BorderRadius.circular(8),
            ),
            child: Icon(icon, color: color, size: 20),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.bold,
                    color: color,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  insight,
                  style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey.shade700,
                  ),
                ),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: color.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    suggestion,
                    style: TextStyle(
                      fontSize: 11,
                      color: color,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildTrendStat(String label, String value, Color color) {
    return Column(
      children: [
        Text(
          value,
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: color,
          ),
        ),
        Text(
          label,
          style: TextStyle(
            fontSize: 12,
            color: Colors.grey.shade600,
          ),
        ),
      ],
    );
  }

  String _getScoreMessage(int score) {
    if (score >= 80) return 'Excellent budget management!';
    if (score >= 60) return 'Good, but room for improvement';
    return 'Consider reviewing your spending habits';
  }
}

// Custom Painters
class ScoreCirclePainter extends CustomPainter {
  final double score;
  final Color color;

  ScoreCirclePainter({required this.score, required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 10;

    // Background circle
    final backgroundPaint = Paint()
      ..color = Colors.grey.shade200
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    canvas.drawCircle(center, radius, backgroundPaint);

    // Progress arc
    final progressPaint = Paint()
      ..color = color
      ..strokeWidth = 8
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final sweepAngle = (score / 100) * 2 * math.pi;
    canvas.drawArc(
      Rect.fromCircle(center: center, radius: radius),
      -math.pi / 2,
      sweepAngle,
      false,
      progressPaint,
    );
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class LineChartPainter extends CustomPainter {
  final List<MonthlySpending> data;
  final double animation;

  LineChartPainter({required this.data, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    if (data.isEmpty) return;

    final paint = Paint()
      ..color = Colors.blue
      ..strokeWidth = 3
      ..style = PaintingStyle.stroke
      ..strokeCap = StrokeCap.round;

    final pointPaint = Paint()
      ..color = Colors.blue
      ..style = PaintingStyle.fill;

    final maxAmount = data.map((e) => e.amount).reduce(math.max);
    final minAmount = data.map((e) => e.amount).reduce(math.min);
    final range = maxAmount - minAmount;

    final path = Path();
    final points = <Offset>[];

    for (int i = 0; i < data.length; i++) {
      final x = (i / (data.length - 1)) * size.width;
      final normalizedY = (data[i].amount - minAmount) / range;
      final y = size.height - (normalizedY * size.height * 0.8) - size.height * 0.1;
      
      points.add(Offset(x, y));
      
      if (i == 0) {
        path.moveTo(x, y);
      } else {
        path.lineTo(x, y);
      }
    }

    // Draw animated path
    final animatedPath = Path();
    final pathMetrics = path.computeMetrics();
    for (var pathMetric in pathMetrics) {
      final extractPath = pathMetric.extractPath(0, pathMetric.length * animation);
      animatedPath.addPath(extractPath, Offset.zero);
    }

    canvas.drawPath(animatedPath, paint);

    // Draw points
    for (int i = 0; i < (points.length * animation).round(); i++) {
      canvas.drawCircle(points[i], 4, pointPaint);
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

class DonutChartPainter extends CustomPainter {
  final List<SpendingCategory> data;
  final double animation;

  DonutChartPainter({required this.data, required this.animation});

  @override
  void paint(Canvas canvas, Size size) {
    final center = Offset(size.width / 2, size.height / 2);
    final radius = size.width / 2 - 20;
    final innerRadius = radius * 0.6;

    final total = data.fold(0.0, (sum, item) => sum + item.amount);
    double startAngle = -math.pi / 2;

    for (var category in data) {
      final sweepAngle = (category.amount / total) * 2 * math.pi * animation;
      
      final paint = Paint()
        ..color = category.color
        ..style = PaintingStyle.stroke
        ..strokeWidth = radius - innerRadius
        ..strokeCap = StrokeCap.butt;

      canvas.drawArc(
        Rect.fromCircle(center: center, radius: (radius + innerRadius) / 2),
        startAngle,
        sweepAngle,
        false,
        paint,
      );

      startAngle += (category.amount / total) * 2 * math.pi;
    }
  }

  @override
  bool shouldRepaint(covariant CustomPainter oldDelegate) => true;
}

// Data Models
class MonthlySpending {
  final String month;
  final double amount;

  MonthlySpending(this.month, this.amount);
}

class SpendingCategory {
  final String name;
  final double amount;
  final Color color;

  SpendingCategory(this.name, this.amount, this.color);
}

class SpendingPattern {
  final String day;
  final double amount;

  SpendingPattern(this.day, this.amount);
}