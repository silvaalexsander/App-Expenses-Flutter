// ignore_for_file: prefer_const_literals_to_create_immutables, prefer_const_constructors, unused_local_variable
import 'package:expenses/components/chart_bar.dart';
import 'package:intl/intl.dart';
import 'package:expenses/models/transaction.dart';
import 'package:flutter/material.dart';

class Chart extends StatelessWidget {
  const Chart(this.recentTransactions, {super.key});

  final List<Transaction> recentTransactions;

  List<Map<String, Object>> get groupedTransactions {
    return List.generate(7, (index) {
      final weekDay = DateTime.now().subtract(
        Duration(days: index),
      );

      double totalSum = 0.0;

      for (var i = 0; i < recentTransactions.length; i++) {
        bool sameDay = recentTransactions[i].date.day == weekDay.day;
        bool sameMonth = recentTransactions[i].date.month == weekDay.month;
        bool sameYear = recentTransactions[i].date.year == weekDay.year;
        if (sameYear && sameDay && sameMonth) {
          totalSum += recentTransactions[i].value;
        }
      }

      return {
        'day': DateFormat.E().format(weekDay)[0],
        'value': totalSum,
      };
    });
  }

  double get _weekTotalValue {
    return groupedTransactions.fold(0.0, (sum, tr) {
      return sum + (tr['value'] as double);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 6,
      margin: EdgeInsets.all(20),
      child: Row(
        children: groupedTransactions.map((tr) {
          return ChartBar(
            label: tr['day'] as String,
            value: tr['value'] as double,
            percentage: (tr['value'] as double) / _weekTotalValue,
          );
        }).toList(),
      ),
    );
  }
}
