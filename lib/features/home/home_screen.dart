import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  int _currentIndex = 0;

  final List<String> _titles = [
    'Home',
    'Unit Converter',
    'Currency',
    'Notes',
    'Tasks',
  ];

  final List<Widget> _screens = [
  const HomeDashboard(),
  const Placeholder(child: Center(child: Text('Unit Converter'))),
  const Placeholder(child: Center(child: Text('Currency'))),
  const Placeholder(child: Center(child: Text('Notes'))),
  const Placeholder(child: Center(child: Text('Tasks'))),
];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'Smart Utilities',
          style: TextStyle(fontWeight: FontWeight.bold),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.dark_mode_outlined),
            onPressed: () {
              // Theme toggle will be added later if needed
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(content: Text('Theme toggle coming soon')),
              );
            },
          ),
        ],
      ),
      body: _screens[_currentIndex],
      bottomNavigationBar: NavigationBar(
        selectedIndex: _currentIndex,
        onDestinationSelected: (index) {
          setState(() => _currentIndex = index);
        },
        destinations: const [
  NavigationDestination(
    icon: Icon(Icons.home_outlined),
    selectedIcon: Icon(Icons.home), 
    label: 'Home',
  ),
  NavigationDestination(
    icon: Icon(Icons.swap_horiz_outlined),
    selectedIcon: Icon(Icons.swap_horiz), 
    label: 'Converter'
  ),
  NavigationDestination(
    icon: Icon(Icons.currency_exchange_outlined),
    selectedIcon: Icon(Icons.currency_exchange), 
    label: 'Currency'
  ),
  NavigationDestination(
    icon: Icon(Icons.note_outlined), 
    selectedIcon: Icon(Icons.note), 
    label: 'Notes'
  ),
  NavigationDestination(
    icon: Icon(Icons.checklist_outlined), 
    selectedIcon: Icon(Icons.checklist), 
    label: 'Tasks'
  ),
],
      ),
    );
  }
}

// ==================== Beautiful Dashboard ====================

class HomeDashboard extends StatelessWidget {
  const HomeDashboard({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          // Greeting
          Text(
            'Good morning, Ninja! 👋',
            style: theme.textTheme.headlineMedium?.copyWith(
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'Your everyday tools in one place',
            style: theme.textTheme.bodyLarge?.copyWith(
              color: theme.textTheme.bodySmall?.color,
            ),
          ),
          const SizedBox(height: 32),

          // Tools Grid
          GridView.builder(
            shrinkWrap: true,
            physics: const NeverScrollableScrollPhysics(),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 16,
              mainAxisSpacing: 16,
              childAspectRatio: 1.1,
            ),
          itemCount: 5,
          itemBuilder: (context, index) {
            final tools = [
              {
                'title': 'Unit Converter',
                'icon': Icons.swap_horiz,
                'color': Colors.deepPurple,
                'route': '/converter',
              },
              {
                'title': 'Currency Converter',
                'icon': Icons.currency_exchange,
                'color': Colors.green,
                'route': '/currency',
              },
              {
                'title': 'My Notes',
                'icon': Icons.note_alt,
                'color': Colors.orange,
                'route': '/notes',
              },
              {
                'title': 'Tasks & Checklist',
                'icon': Icons.checklist,
                'color': Colors.pink,
                'route': '/tasks',
              },
              {
                'title': 'BMI Calculator',
                'icon': Icons.monitor_weight,
                'color': Colors.blue,
                'route': '/bmi',
              },
            ];

            final tool = tools[index];

            return GestureDetector(
             onTap: () {
final route = tool['route'] as String?;
  if (route == '/converter') {
    context.push('/converter');
  } else if (route == '/currency') {
    context.push('/currency');
  } else if (route == '/notes') {
    context.push('/notes');
  } else if (route == '/tasks') {
    context.push('/tasks');
  } else if (route == '/bmi') {
    context.push('/bmi');
  } else {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text('${tool["title"]} coming soon')),
    );
  }
},
                child: Card(
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: Container(
                    padding: const EdgeInsets.all(20),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      gradient: LinearGradient(
                        begin: Alignment.topLeft,
                        end: Alignment.bottomRight,
                        colors: [
                          (tool['color'] as Color).withOpacity(0.15),
                          Colors.transparent,
                        ],
                      ),
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          tool['icon'] as IconData,
                          size: 48,
                          color: tool['color'] as Color,
                        ),
                        const SizedBox(height: 16),
                        Text(
                          tool['title'] as String,
                          style: const TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ),
                ),
              );
            },
          ),

          const SizedBox(height: 32),

          // Quick Tips Card
          Card(
            elevation: 1,
            shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Row(
                children: [
                  const Icon(Icons.lightbulb_outline, color: Colors.amber, size: 32),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: const [
                        Text(
                          'Pro Tip',
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 4),
                        Text(
                          'All tools work offline except Currency Converter which needs internet.',
                          style: TextStyle(fontSize: 13),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}