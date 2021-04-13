import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:club_management/utility/session.dart';
import 'package:club_management/utility/member.dart';
import 'package:flutter/material.dart';

final Firestore _firestore = Firestore.instance;

Member getMember(String code, List<Member> members) =>
    members.firstWhere((member) => member.code == code);

List<Session> getAttendance(List<dynamic> codes, List<Session> sessions) =>
    sessions
        .where(
            (session) => codes.any((code) => code.toString() == session.code))
        .toList();

List<Member> getAttendees(List<dynamic> codes, List<Member> members) => members
    .where((member) => codes.any((code) => code.toString() == member.code))
    .toList();

Session getSession(String code, List<Session> sessions) =>
    sessions.firstWhere((session) => session.code == code);

fetchInitialSessions() async {
  //TODO handle all the exceptions
  List<Session> sessionsList = [];
  var sessionsData = _firestore.collection('Sessions').orderBy('BeginTime');

  final snapshot = await sessionsData.getDocuments();
  var sessions = snapshot.documents;
  for (var session in sessions) {
    var beginDateTime = DateTime.fromMillisecondsSinceEpoch(
        session.data['BeginTime'].toInt() * 1000);
    var endDateTime = DateTime.fromMillisecondsSinceEpoch(
        session.data['EndTime'].toInt() * 1000);
//    print(
//        '${session.data['Name']} session Attendees: ${session.data['Attendees']}');
    sessionsList.add(Session(
        title: session.data['Name'],
        code: session.data['Code'],
        location: session.data['Location'],
        room: session.data['Room'],
        attendees: session.data['Attendees'],
        date: beginDateTime,
        beginTime:
            TimeOfDay(hour: beginDateTime.hour, minute: beginDateTime.minute),
        endTime:
            TimeOfDay(hour: endDateTime.hour, minute: endDateTime.minute)));
  }

  return sessionsList;
}

fetchInitialMembers() async {
  //TODO handle all the exceptions
  List<Member> membersList = [];
  var membersData = _firestore.collection('Participants').orderBy('FirstName');

  final snapshot = await membersData.getDocuments();
  var members = snapshot.documents;

  for (var member in members) {
//    print(
//        '${member.data['FirstName']} ${member.data['LastName']} Attendance: ${member.data['Attendance']}');
    membersList.add(Member(
      firstName: member.data['FirstName'],
      lastName: member.data['LastName'],
      email: member.data['Email'],
      code: member.data['Code'],
      rank: member.data['Rank'],
      arabicFirst: member.data['ArabicFirst'],
      arabicLast: member.data['ArabicLast'],
      isCardPrinted: member.data['IsCardPrinted'],
      isCardReceived: member.data['IsCardReceived'],
      attendance: member.data['Attendance'],
    ));
  }

  return membersList;
}

void addSessionFirestore(Session session) => //TODO handle all the exceptions
    _firestore.collection('Sessions').document(session.code).setData({
      'Name': session.title,
      'Attendees': session.attendees,
      'BeginTime': (session.date.millisecondsSinceEpoch / 1000),
      'Code': session.code,
      'EndTime':
          (session.date.add(session.getDuration()).millisecondsSinceEpoch /
              1000),
      'Location': session.location,
      'Room': session.room
    });

void updateSessionFirestore(
        String code, data) => //TODO handle all the exceptions
    _firestore.collection('Sessions').document(code).updateData(data);

void deleteSessionFirestore(String code) => //TODO handle all the exceptions
    _firestore.collection('Sessions').document(code).delete();

void updateMemberFirestore(
        String code, data) => //TODO handle all the exceptions
    _firestore.collection('Participants').document(code).updateData(data);

void deleteMemberFirestore(String code) => //TODO handle all the exceptions
    _firestore.collection('Participants').document(code).delete();

void addMemberFirestore(Member member) => //TODO handle all the exceptions
    _firestore.collection('Participants').document(member.code).setData({
      'FirstName': member.firstName,
      'LastName': member.lastName,
      'ArabicFirst': member.arabicFirst,
      'ArabicLast': member.arabicLast,
      'Code': member.code,
      'email': member.email,
      'Rank': member.rank,
      'IsCardPrinted': member.isCardPrinted,
      'IsCardReceived': member.isCardReceived,
      'Attendance': member.attendance,
    });
