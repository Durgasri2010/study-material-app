import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

void main() {
  runApp(const StudyMaterialApp());
}

class StudyMaterialApp extends StatelessWidget {
  const StudyMaterialApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Student Study Material App',
      theme: ThemeData(
        primarySwatch: Colors.indigo,
        useMaterial3: true,
      ),
      home: const DashboardScreen(),
    );
  }
}

// Data Model for Study Material with URL support
class MaterialItem {
  final String title;
  final String description;
  final String category;
  final String type; // PDF, Video, Link
  final String url;  // Real Web/PDF URL

  MaterialItem({
    required this.title,
    required this.description,
    required this.category,
    required this.type,
    required this.url,
  });
}

// Data Model for Subject
class Subject {
  final String name;
  final String code;
  final List<MaterialItem> materials;

  Subject({
    required this.name,
    required this.code,
    required this.materials,
  });
}

// Sample Data with functional demo URLs
final List<Subject> sampleSubjects = [
  Subject(
    name: 'Mobile Application Development',
    code: 'MAD-301',
    materials: [
      MaterialItem(
        title: 'Unit 1: Introduction to Flutter & Dart',
        description: 'Official Flutter documentation and beginner guide.',
        category: 'Unit-wise materials',
        type: 'PDF',
        url: 'https://flutter.dev/docs',
      ),
      MaterialItem(
        title: '2024 Board Question Paper',
        description: 'Sample examination paper in PDF format.',
        category: 'Previous examination materials',
        type: 'PDF',
        url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      ),
      MaterialItem(
        title: 'Dart Language Essentials',
        description: 'Dart official language tour and tutorials.',
        category: 'Reference materials',
        type: 'Video',
        url: 'https://dart.dev/guides/language/language-tour',
      ),
      MaterialItem(
        title: 'Model Question Bank',
        description: 'Sample practice document.',
        category: 'Question banks',
        type: 'PDF',
        url: 'https://www.w3.org/WAI/ER/tests/xhtml/testfiles/resources/pdf/dummy.pdf',
      ),
    ],
  ),
  Subject(
    name: 'Web Technologies',
    code: 'WT-302',
    materials: [
      MaterialItem(
        title: 'Unit 1: HTML5 & CSS3 Basics',
        description: 'MDN Web Docs for HTML and CSS learning.',
        category: 'Unit-wise materials',
        type: 'Link',
        url: 'https://developer.mozilla.org',
      ),
      MaterialItem(
        title: 'JavaScript Reference Manual',
        description: 'Complete JavaScript guide.',
        category: 'Reference materials',
        type: 'Link',
        url: 'https://javascript.info',
      ),
    ],
  ),
  Subject(
    name: 'Database Management Systems',
    code: 'DBMS-303',
    materials: [
      MaterialItem(
        title: 'SQL Queries Cheat Sheet',
        description: 'SQL tutorial and syntax reference.',
        category: 'Unit-wise materials',
        type: 'PDF',
        url: 'https://www.w3schools.com/sql/',
      ),
    ],
  ),
];

// 1. Subject Dashboard Screen
class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});

  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  String searchQuery = '';

  @override
  Widget build(BuildContext context) {
    final filteredSubjects = sampleSubjects.where((subject) {
      final query = searchQuery.toLowerCase();
      final matchesSubject = subject.name.toLowerCase().contains(query) ||
          subject.code.toLowerCase().contains(query);
      final matchesMaterial = subject.materials.any((m) =>
          m.title.toLowerCase().contains(query) ||
          m.description.toLowerCase().contains(query));
      return matchesSubject || matchesMaterial;
    }).toList();

    return Scaffold(
      appBar: AppBar(
        title: const Text('Study Material Dashboard'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(12.0),
            child: TextField(
              decoration: InputDecoration(
                hintText: 'Search by subject or keyword...',
                prefixIcon: const Icon(Icons.search),
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10.0),
                ),
              ),
              onChanged: (value) {
                setState(() {
                  searchQuery = value;
                });
              },
            ),
          ),
          Expanded(
            child: filteredSubjects.isEmpty
                ? const Center(child: Text('No subjects or materials found.'))
                : ListView.builder(
                    itemCount: filteredSubjects.length,
                    itemBuilder: (context, index) {
                      final subject = filteredSubjects[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        child: ListTile(
                          leading: CircleAvatar(
                            backgroundColor: Colors.indigo.shade100,
                            child: const Icon(Icons.book, color: Colors.indigo),
                          ),
                          title: Text(
                            subject.name,
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                          subtitle: Text(
                              'Code: ${subject.code} | Materials: ${subject.materials.length}'),
                          trailing:
                              const Icon(Icons.arrow_forward_ios, size: 16),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) =>
                                    SubjectDetailScreen(subject: subject),
                              ),
                            );
                          },
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

// 2 & 3. Material Categories Screen
class SubjectDetailScreen extends StatefulWidget {
  final Subject subject;

  const SubjectDetailScreen({super.key, required this.subject});

  @override
  State<SubjectDetailScreen> createState() => _SubjectDetailScreenState();
}

class _SubjectDetailScreenState extends State<SubjectDetailScreen> {
  String selectedCategory = 'All';

  final List<String> categories = [
    'All',
    'Unit-wise materials',
    'Question banks',
    'Reference materials',
    'Previous examination materials',
  ];

  @override
  Widget build(BuildContext context) {
    final filteredMaterials = selectedCategory == 'All'
        ? widget.subject.materials
        : widget.subject.materials
            .where((m) => m.category == selectedCategory)
            .toList();

    return Scaffold(
      appBar: AppBar(
        title: Text('${widget.subject.code} - ${widget.subject.name}'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Column(
        children: [
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.all(8.0),
            child: Row(
              children: categories.map((category) {
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: ChoiceChip(
                    label: Text(category),
                    selected: selectedCategory == category,
                    onSelected: (selected) {
                      setState(() {
                        selectedCategory = category;
                      });
                    },
                  ),
                );
              }).toList(),
            ),
          ),
          const Divider(),
          Expanded(
            child: filteredMaterials.isEmpty
                ? const Center(child: Text('No materials in this category.'))
                : ListView.builder(
                    itemCount: filteredMaterials.length,
                    itemBuilder: (context, index) {
                      final item = filteredMaterials[index];
                      return Card(
                        margin: const EdgeInsets.symmetric(
                            horizontal: 12.0, vertical: 6.0),
                        child: ListTile(
                          leading: Icon(
                            item.type == 'PDF'
                                ? Icons.picture_as_pdf
                                : item.type == 'Video'
                                    ? Icons.video_library
                                    : Icons.link,
                            color: Colors.indigo,
                          ),
                          title: Text(item.title,
                              style:
                                  const TextStyle(fontWeight: FontWeight.w600)),
                          subtitle: Text('${item.category} • ${item.type}'),
                          trailing: const Icon(Icons.info_outline),
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => MaterialDetailScreen(
                                  material: item,
                                  subjectName: widget.subject.name,
                                ),
                              ),
                            );
                          },
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

// 4. Material Details Screen with Functional Launch Action
class MaterialDetailScreen extends StatelessWidget {
  final MaterialItem material;
  final String subjectName;

  const MaterialDetailScreen({
    super.key,
    required this.material,
    required this.subjectName,
  });

  // Function to launch URL/Document external resource
  Future<void> _openResource(BuildContext context) async {
    final Uri uri = Uri.parse(material.url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    } else {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Could not open link: ${material.url}')),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Material Details'),
        backgroundColor: Colors.indigo,
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Chip(
              label: Text(material.category),
              backgroundColor: Colors.indigo.shade50,
            ),
            const SizedBox(height: 12),
            Text(
              material.title,
              style:
                  const TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            Text(
              'Subject: $subjectName',
              style: TextStyle(color: Colors.grey.shade700, fontSize: 16),
            ),
            const SizedBox(height: 16),
            const Text(
              'Description:',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 6),
            Text(
              material.description,
              style: const TextStyle(fontSize: 15),
            ),
            const Spacer(),
            SizedBox(
              width: double.infinity,
              height: 50,
              child: ElevatedButton.icon(
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.indigo,
                  foregroundColor: Colors.white,
                ),
                icon: Icon(material.type == 'PDF'
                    ? Icons.download
                    : Icons.open_in_new),
                label: Text(
                  material.type == 'PDF'
                      ? 'Open / Download Document'
                      : 'Access Resource',
                  style: const TextStyle(fontSize: 16),
                ),
                onPressed: () => _openResource(context),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
