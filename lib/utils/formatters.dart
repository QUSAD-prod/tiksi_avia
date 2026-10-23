import 'package:flutter/material.dart';

const _months = [
  'января', 'февраля', 'марта', 'апреля', 'мая', 'июня', //
  'июля', 'августа', 'сентября', 'октября', 'ноября', 'декабря',
];

const _weekdays = [
  'понедельник', 'вторник', 'среда', 'четверг', //
  'пятница', 'суббота', 'воскресенье',
];

const _weekdaysShort = ['пн', 'вт', 'ср', 'чт', 'пт', 'сб', 'вс'];

DateTime dateOnly(DateTime date) => DateTime(date.year, date.month, date.day);

/// Key of a day in the Realtime Database, e.g. `22-10-2026`.
///
/// The format is shared with already installed app versions, so it must not change.
String dbDateKey(DateTime date) => '${date.day}-${date.month}-${date.year}';

/// `22 октября`
String formatDayMonth(DateTime date) =>
    '${date.day} ${_months[date.month - 1]}';

/// `Четверг, 22 октября`
String formatFullDate(DateTime date) {
  final weekday = _weekdays[date.weekday - 1];
  return '${weekday[0].toUpperCase()}${weekday.substring(1)}, ${formatDayMonth(date)}';
}

/// `чт`
String formatWeekdayShort(DateTime date) => _weekdaysShort[date.weekday - 1];

/// `07:05`
String formatTime(TimeOfDay time) =>
    '${time.hour.toString().padLeft(2, '0')}:${time.minute.toString().padLeft(2, '0')}';

/// Parses `7:05` and `07:05`; older app versions stored hours without padding.
TimeOfDay? parseTime(String value) {
  final parts = value.trim().split(':');
  if (parts.length != 2) return null;
  final hour = int.tryParse(parts[0]);
  final minute = int.tryParse(parts[1]);
  if (hour == null || minute == null) return null;
  if (hour < 0 || hour > 23 || minute < 0 || minute > 59) return null;
  return TimeOfDay(hour: hour, minute: minute);
}

/// Normalizes a stored time for display: `7:05` → `07:05`.
String displayTime(String value) {
  final time = parseTime(value);
  return time == null ? value : formatTime(time);
}

/// `2 ч 35 мин`, `45 мин`, `3 ч`
String formatDuration(Duration duration) {
  final hours = duration.inHours;
  final minutes = duration.inMinutes % 60;
  if (hours == 0) return '$minutes мин';
  if (minutes == 0) return '$hours ч';
  return '$hours ч $minutes мин';
}

/// Russian plural: `pluralize(5, 'рейс', 'рейса', 'рейсов')` → `рейсов`.
String pluralize(int count, String one, String few, String many) {
  final mod10 = count % 10;
  final mod100 = count % 100;
  if (mod10 == 1 && mod100 != 11) return one;
  if (mod10 >= 2 && mod10 <= 4 && (mod100 < 12 || mod100 > 14)) return few;
  return many;
}

String formatFlightsCount(int count) =>
    '$count ${pluralize(count, 'рейс', 'рейса', 'рейсов')}';
