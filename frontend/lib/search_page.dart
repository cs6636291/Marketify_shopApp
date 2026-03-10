import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:marketify_app/product_list.dart'; 

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  TextEditingController searchController = TextEditingController();
  List<String> history = [];
  List<dynamic> suggestions = []; 

  @override
  void initState() {
    super.initState();
    _loadHistory();
  }

  _loadHistory() async {
    final prefs = await SharedPreferences.getInstance();
    setState(() {
      history = prefs.getStringList('search_history') ?? [];
    });
  }

  _saveHistory(String query) async {
    if (query.isEmpty) return;
    final prefs = await SharedPreferences.getInstance();
    history.remove(query);
    history.insert(0, query);
    if (history.length > 5) history.removeLast(); 
    await prefs.setStringList('search_history', history);
  }

  _fetchSuggestions(String query) async {
    if (query.isEmpty) {
      setState(() => suggestions = []);
      return;
    }
    try {
      final url = Uri.parse(
          "http://10.0.2.2/my_shop/search_products.php?query=${Uri.encodeComponent(query)}");
      
      final response = await http.get(url);
      if (response.statusCode == 200) {
        setState(() {
          suggestions = json.decode(response.body);
        });
      }
    } catch (e) {
      debugPrint("Error fetching suggestions: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        elevation: 0,
        iconTheme: const IconThemeData(color: Colors.black),
        title: TextField(
          controller: searchController,
          autofocus: true,
          textInputAction: TextInputAction.search,
          style: const TextStyle(color: Colors.black),
          decoration: const InputDecoration(
            hintText: "ค้นหาสินค้า...",
            border: InputBorder.none,
          ),
          onChanged: (value) {
            _fetchSuggestions(value);
          },
          onSubmitted: (value) {
            if (value.isNotEmpty) {
              _saveHistory(value);
              _performFinalSearch(value);
            }
          },
        ),
      ),
      body: searchController.text.isEmpty
          ? _buildHistory() 
          : _buildSuggestions(), 
    );
  }

  Widget _buildHistory() {
    if (history.isEmpty) {
      return const Center(child: Text("ไม่มีประวัติการค้นหา"));
    }
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Padding(
          padding: EdgeInsets.all(15),
          child: Text("ประวัติการค้นหา", style: TextStyle(fontWeight: FontWeight.bold)),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: history.length,
            itemBuilder: (context, index) => ListTile(
              leading: const Icon(Icons.history, color: Colors.grey),
              title: Text(history[index]),
              onTap: () {
                searchController.text = history[index];
                _performFinalSearch(history[index]);
              },
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildSuggestions() {
    return ListView.builder(
      itemCount: suggestions.length,
      itemBuilder: (context, index) {
        final product = suggestions[index];
        return ListTile(
          leading: const Icon(Icons.search, color: Colors.redAccent),
          title: Text(product['name'] ?? ""), 
          onTap: () {
            String selectedName = product['name'];
            setState(() {
              searchController.text = selectedName;
              suggestions = [];
            });
            _saveHistory(selectedName);
            _performFinalSearch(selectedName);
          },
        );
      },
    );
  }

  void _performFinalSearch(String query) {
    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => ProductList(searchKeyword: query),
      ),
    );
  }
}