import 'dart:convert';

import 'package:flutter/services.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_datetime_picker/flutter_datetime_picker.dart';
import 'package:todoon/src/constants/strings.dart';

class LanguageData {
  /// Language & country code. e.g. `en_US`.
  /// This should match the name of the file.
  final String code;

  /// Locate to format a datetime. e.g. `en`.
  /// This helps us display DateTimePick with locate formatting.
  /// This should match the left-most letter of the code.
  final String locate;

  /// Language name. e.g. `English (United States)`.
  /// Must be in the same language.
  final String name;

  /// Name of the country. e.g. `United States`.
  /// Must be in the same language.
  final String country;

  const LanguageData({
    required this.code,
    required this.locate,
    required this.name,
    required this.country,
  });

  factory LanguageData.fromJson(dynamic json) => LanguageData(
        code: json['code'],
        locate: json['locate'],
        name: json['name'],
        country: json['country'],
      );

  Map<String, String> toJson() => {
        'code': code,
        'locate': locate,
        'name': name,
        'country': country,
      };

  @override
  int get hashCode => code.hashCode;

  @override
  bool operator ==(Object other) {
    if (other is LanguageData) {
      return code == other.code;
    }
    return false;
  }
}

/// Provides the [String] labels localized for the [current] language to show inside the UI.
class Language extends Strings with ChangeNotifier {
  /// [Language] object singleton instance.
  static final Language instance = Language();

  /// Must be called before [runApp].
  static Future<void> initialize({
    required LanguageData language,
  }) =>
      instance.set(value: language);

  /// Returns all the available languages after reading the assets.
  Future<Set<LanguageData>> get available async {
    final data = await rootBundle.loadString('assets/languages/index.json');
    return Set.from(json.decode(data).map((e) => LanguageData.fromJson(e)));
  }

  /// Updates the [current] language & notifies the listeners.
  Future<void> set({required LanguageData value}) async {
    final data = await rootBundle.loadString(
      'assets/languages/translations/${value.code}.json',
      cache: true,
    );

    final map = json.decode(data);
    Add = map['Add']!;
    Add_Plan = map['Add_Plan']!;
    Add_Task = map['Add_Task']!;
    Alert = map['Alert']!;
    Allow = map['Allow']!;
    Allow_Content = map['Allow_Content']!;
    Allow_Notifications = map['Allow_Notifications']!;
    Back = map['Back']!;
    Cancel = map['Cancel']!;
    Complete = map['Complete']!;
    Date = map['Date']!;
    Delete_Plan = map['Delete_Plan']!;
    Delete_Sure = map['Delete_Sure']!;
    Delete_Task = map['Delete_Task']!;
    Description = map['Description']!;
    Detete = map['Detete']!;
    Dismiss_Plan = map['Dismiss_Plan']!;
    Dismiss_Sure = map['Dismiss_Sure']!;
    Dismiss_Task = map['Dismiss_Task']!;
    Dismissed = map['Dismissed']!;
    Dont_Allow = map['Dont_Allow']!;
    Edit = map['Edit']!;
    Edit_Plan = map['Edit_Plan']!;
    Edit_Sure = map['Edit_Sure']!;
    Edit_Task = map['Edit_Task']!;
    Name_Plan = map['Name_Plan']!;
    New_Plan = map['New_Plan']!;
    New_Task = map['New_Task']!;
    No_Plans = map['No_Plans']!;
    No_Tasks = map['No_Tasks']!;
    Off = map['Off']!;
    OK = map['OK']!;
    On = map['On']!;
    Out_Of = map['Out_Of']!;
    Plan = map['Plan']!;
    Plan_Dismissed = map['Plan_Dismissed']!;
    Plans = map['Plans']!;
    Quick_Add_Plan = map['Quick_Add_Plan']!;
    Quick_Add_Task = map['Quick_Add_Task']!;
    Refresh = map['Refresh']!;
    Reminder = map['Reminder']!;
    Search = map['Search']!;
    Setting_Azure_Title = map['Setting_Azure_Title']!;
    Setting_Bleed_Title = map['Setting_Bleed_Title']!;
    Setting_Colors_Title = map['Setting_Colors_Title']!;
    Setting_Dark_Title = map['Setting_Dark_Title']!;
    Setting_Language_Title = map['Setting_Language_Title']!;
    Setting_Light_Title = map['Setting_Light_Title']!;
    Setting_System_Title = map['Setting_System_Title']!;
    Setting_Theme_Title = map['Setting_Theme_Title']!;
    Settings_Title = map['Settings_Title']!;
    Show_Menu = map['Show_Menu']!;
    Task = map['Task']!;
    Task_Dismissed = map['Task_Dismissed']!;
    Tasks = map['Tasks']!;
    Wrong = map['Wrong']!;

    current = value;
    notifyListeners();
  }

  LocaleType get getLocaleType {
    return LocaleType.values
        .firstWhere((element) => element.name == current.locate);
  }

  /// Currently selected & displayed [Language].
  late LanguageData current;

  @override
  // ignore: must_call_super
  void dispose() {}
}
