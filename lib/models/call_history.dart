// ignore_for_file: public_member_api_docs, sort_constructors_first
class CallHistory {
  final List<History> history;

  CallHistory({
    required this.history,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'history': history.map((x) => x.toMap()).toList(),
    };
  }

  factory CallHistory.fromMap(Map<String, dynamic> map) {
    return CallHistory(
      history: List<History>.from(
        (map['history'] as List<int>).map<History>(
          (x) => History.fromMap(x as Map<String, dynamic>),
        ),
      ),
    );
  }
}

class History {
  final String caller;
  final String reciever;
  final String callerProfilepic;
  final String recieverProfilepic;
  final String callerName;
  final String recieverName;
  final DateTime timesent;
  final bool hasPicked;
  final String id;
  History({
    required this.caller,
    required this.reciever,
    required this.callerProfilepic,
    required this.recieverProfilepic,
    required this.callerName,
    required this.recieverName,
    required this.timesent,
    required this.hasPicked,
    required this.id,
  });

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'caller': caller,
      'reciever': reciever,
      'callerProfilepic': callerProfilepic,
      'recieverProfilepic': recieverProfilepic,
      'callerName': callerName,
      'recieverName': recieverName,
      'timesent': timesent.millisecondsSinceEpoch,
      'hasPicked': hasPicked,
      'id': id,
    };
  }

  factory History.fromMap(Map<String, dynamic> map) {
    return History(
      caller: map['caller'] as String,
      reciever: map['reciever'] as String,
      callerProfilepic: map['callerProfilepic'] as String,
      recieverProfilepic: map['recieverProfilepic'] as String,
      callerName: map['callerName'] as String,
      recieverName: map['recieverName'] as String,
      timesent: DateTime.fromMillisecondsSinceEpoch(map['timesent'] as int),
      hasPicked: map['hasPicked'] as bool,
      id: map['id'] as String,
    );
  }
}
