import 'package:flutter/material.dart';
import 'model.dart';
import 'bloc.dart';
import 'provider.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MovieProvider(
      movieBloc: MovieBloc(API()),
      child: MaterialApp(
        title: 'Flutter Demo',
        theme: ThemeData(
          primarySwatch: Colors.blue,
        ),
        home: MyHomePage(),
      ),
    );
  }
}

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final movieBloc = MovieProvider.of(context);

    return Scaffold(
      appBar: AppBar(
        title: Text('Bloc Example'),
      ),
      body: Column(
        children: <Widget>[
          Container(
            padding: EdgeInsets.all(10.0),
            child: TextField(
              onChanged: movieBloc.query.add,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                hintText: 'Search for a Movie',
              ),
            ),
          ),
          StreamBuilder(
            stream: movieBloc.log,
            builder: (context, snapshot) => Container(
                  child: Text(snapshot?.data ?? ''),
                ),
          ),
          Flexible(
            child: StreamBuilder(
              stream: movieBloc.result,
              builder: (context, snapshot) {
                if (!snapshot.hasData) {
                  return Center(
                    child: CircularProgressIndicator(),
                  );
                }
                return ListView(
                  children: snapshot.data
                      .map<Widget>((item) => ListItem(item))
                      .toList(),
                );
              },
            ),
          ),
        ],
      ),
    );
  }
}

class ListItem extends StatelessWidget {
  final item;
  ListItem(this.item);
  @override
  Widget build(BuildContext context) {
    var imageSrc;
    if (item.posterPath != null) {
      imageSrc = 'https://image.tmdb.org/t/p/w92${item.posterPath}';
    } else {
      imageSrc = '';
    }
    return ListTile(
      leading: CircleAvatar(
        child: Image.network(imageSrc),
      ),
      title: Text(item.title ?? ''),
      subtitle: Text(item.overview ?? ''),
    );
  }
}
