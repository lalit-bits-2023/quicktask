import 'package:flutter/material.dart';
import 'package:parse_server_sdk_flutter/parse_server_sdk_flutter.dart';

class FetchApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Validating User',
      home: FetchDataPage(),
    );
  }
}

class FetchDataPage extends StatefulWidget {
  @override
  _FetchDataPageState createState() => _FetchDataPageState();
}

class _FetchDataPageState extends State<FetchDataPage> {
  List<ParseObject> _data = [];
  @override
  void initState() {
    super.initState();
    _fetchData();
  }

  Future<void> _fetchData() async {
    final query = QueryBuilder(ParseObject('ToDoUser'));
    query.setLimit(10); // Limit the number of results

    try {
      final response = await query.query();

      if (response.success && response.results != null) {
        setState(() {
          //_data = response.results;
        });
      } else {
        //print('Error fetching data: ${response.error.message}');
      }
    } catch (e) {
      print('Error fetching data: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Fetch Data Example'),
      ),
      body: ListView.builder(
        itemCount: _data.length,
        itemBuilder: (context, index) {
          final item = _data[index];
          // Access item properties as needed
          final objectId = item.objectId;
          final name = item.get('name');
          // Return widget to display item
          return ListTile(
            title: Text('$name'),
            subtitle: Text('Object ID: $objectId'),
          );
        },
      ),
    );
  }
}
