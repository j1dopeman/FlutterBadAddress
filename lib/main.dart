import 'package:flutter/material.dart';
import 'package:error/models/session.dart';
import 'package:error/services/DBProvider.dart';

void main() => runApp(SummaryScreen());

class SummaryScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final appTitle = "Data Summary";
    final int sessionIdArg = 1;
    final Future<List<Session>> sessions = DBProvider.db.getAllSessions();

    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Error Demo',
      home: Scaffold(
        appBar: AppBar(
          title: Text(appTitle),
        ),
        body: MainBody(
          sessions: sessions,
          initialSessionId: sessionIdArg,
        ),
      ),
    );
  }
}

class MainBody extends StatefulWidget {
  final int initialSessionId;
  final Future<List<Session>> sessions;

  MainBody({
    Key key,
    @required this.initialSessionId,
    @required this.sessions,
  }) : super(key: key);

  @override
  _MainBodyState createState() => _MainBodyState();
}

class _MainBodyState extends State<MainBody> {
  int sessionId;

  @override
  void initState() {
    sessionId = widget.initialSessionId;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Column(children: <Widget>[
      Container(
        height: 200.0,
        child: SessionArea(
          widget.sessions,
          sessionId,
          (val) => setState(() {
                sessionId = val;
              }),
        ),
      ),
    ]);
  }
}

class SessionArea extends StatelessWidget {
  SessionArea(this.sessionsFuture, this.sessionId, this.selectSession,
      {Key key})
      : super(key: key);
  final Future<List<Session>> sessionsFuture;
  final int sessionId;
  final Function selectSession;

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Session>>(
      future: sessionsFuture, // a previously-obtained Future or null
      builder: (BuildContext context, AsyncSnapshot<List<Session>> snapshot) {
        switch (snapshot.connectionState) {
          case ConnectionState.none:
            return Text('Nothing going on.');
          case ConnectionState.active:
          case ConnectionState.waiting:
            return Text('Awaiting result...');
          case ConnectionState.done:
            if (snapshot.hasError) return Text('Error: ${snapshot.error}');

            return ListView.builder(
              itemCount: snapshot.data.length,
              itemBuilder: (BuildContext context, int index) {
                return ListTile(
                  title: Text(snapshot.data[index].userId),
                  subtitle: Text(sessionToJson(snapshot.data[index])),
                  selected: sessionId == snapshot.data[index].sessionId,
                  onTap: () => selectSession(snapshot.data[index].sessionId),
                );
              },
            );
        }
        return null; // unreachable
      },
    );
  }
}
