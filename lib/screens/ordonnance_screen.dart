import 'package:flutter/material.dart';
import '../service/api_service.dart';

class OrdonnancesScreen extends StatefulWidget {
  final String codePatient;

  const OrdonnancesScreen({Key? key, required this.codePatient})
      : super(key: key);

  @override
  State<OrdonnancesScreen> createState() => _OrdonnancesScreenState();
}

class _OrdonnancesScreenState extends State<OrdonnancesScreen> {
  List<dynamic> ordonnances = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    _fetchOrdonnances();
  }

  Future<void> _fetchOrdonnances() async {
    try {
      final apiService = ApiService();
      final data = await apiService.getPatientOrdonnances(widget.codePatient);
      setState(() {
        ordonnances = data;
        isLoading = false;
      });
    } catch (error) {
      print("Error fetching ordonnances: $error");
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return isLoading
        ? const Center(child: CircularProgressIndicator())
        : ordonnances.isEmpty
            ? Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Image.asset(
                      'images/ordonnance.png', // Replace with your image path
                      height: 150, // Adjust the height as needed
                    ),
                    const SizedBox(height: 20),
                    const Text(
                      "No ordonnances found",
                      style: TextStyle(fontSize: 16, color: Colors.grey),
                    ),
                  ],
                ),
              )
            : ListView.builder(
                padding: const EdgeInsets.all(16.0),
                itemCount: ordonnances.length,
                itemBuilder: (context, index) {
                  final ordonnance = ordonnances[index];
                  return Card(
                    margin: const EdgeInsets.symmetric(vertical: 8.0),
                    child: ListTile(
                      title: Text(
                        ordonnance['description'] ?? "No Description",
                        style: const TextStyle(fontWeight: FontWeight.bold),
                      ),
                      subtitle: Text(
                        "Date: ${ordonnance['date']}",
                      ),
                    ),
                  );
                },
              );
  }
}
