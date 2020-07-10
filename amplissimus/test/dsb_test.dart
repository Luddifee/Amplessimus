import 'package:Amplissimus/langs/language.dart';
import 'package:Amplissimus/timetable/timetables.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:Amplissimus/dsbapi.dart';

import 'testlib.dart';

final Map<String, String> dsbTest1Cache = {
  'GetData':
      '{\"d\":\"H4sIAAAAAAAEAOWX3W6bMBSA7yftHSKuS/gxBOjd1G1apaaqlmo301QZfEhQiYmwaTdVfZu9yV5sJm4oP4ayLO00NTco5/98dk4Od2/fTCbaZ2BFyqOMgHY8MY9qsgXHvGCnNM6ERtOkSghzfkoJfBdC3arbz4EWpxzWTGi+lvLJ5E4+hMnORWaQoiijZwm9foy+FV8mPC1rES4rnHKoqU5WSUpq4RspetJ0Uq0437Bjw8CbzZSwUGh4nqVTAgYTDSeRgSnJs4QkQsOMy2QNHIcpTDd0qTWjVpVepL9+UmhpP2cZF8pGfWUppNnvg/g95qBUVEm6LqKwJFU74SVTKk4yevljAx1CQnWRJ5lKrkbacxryc9cWVH07DvYIxI6OMUa6Y3meHrgB0cEObMvyZhGBoF10g4+NpuZsapu2OTH9Y9dVGlfMvkDOc+AFXV7Nrz5BwUEdvJfkIM0WUVul7qEqkfSQlXF76ZYfBWEZ8q8oSxh/QFri2dFmRcj4lWla0xVf98evYPf/Egnm2PAdK/CxG+pBFIsu/NjWMbiublrENy2YAYp8Y0yro4wGax66AfK0qluA+kwGboI8uoHbIHNUN+Jbfw64SeC2LPVw9DYy6HYAqvLed4WqAuvFdeLcdxz6Z4jrO7YTzjzdgjAWRbu27kdIfPV8y4E4QJ6nHgsHmCHzLF8CfRVDZF/MEsZ/NUTGtDrK6FUOkVH0XmSINAVt/17f5vDpRaTNga8yco7X24vKd5tha+87h9uTrKC8u4Uu8A2cYbZdrMsQPC/g0aCq/jFrK2NtE1YmGUiwa7G7kFvjF/KFWIh5sgT2b1fyBXCe0CUb2sg/JKJUSFMxtdvjeuz5soc0ex9vjFNWP9+jpwhZhyL0EYCEOLoeIrSz2Q9OrPZ+Rjj2oeC8C7OCD5HZvvHuRQWXoV8OCToUkrNs+QQTabEflVTluz+WZx2T5UMGFt1hSiFtvC5rc8ENUy43JBO5KA58pEOMZrrjOVgPUBDpQYjQjER+6CBH/NHc/wbNrhqraREAAA==\"}',
  '44a7def4-aaa3-4177-959d-e2921176cde9.htm':
      '<table class=\"mon_head\"> <tr> <td></td> <td></td> <td> GYM. MIT SCHÜLERHEIM ROSENHOF D-91257,P1meml Gymnasium Rosenhof 2019/2020 Stand: 23.06.2020 08:55 </td> </tr></table><div class=\"mon_title\">23.6.2020 Dienstag</div><table class=\"info\" ><tr></tr><tr><td>Betroffene Klassen </td><td>11Q</td></tr></table><table class=\"mon_list\" ><tr></tr><tr><td>11Q</td><td>7</td><td>---</td><td>1sk1</td><td> </td></tr></table>Untis Stundenplan Software',
  '58424b67-1ebf-4152-8c37-17814ef93775.htm':
      '<table class=\"mon_head\"> <tr> <td></td> <td></td> <td> GYM. MIT SCHÜLERHEIM ROSENHOF D-91257,P1meml Gymnasium Rosenhof 2019/2020 Stand: 23.06.2020 08:55 </td> </tr></table><div class=\"mon_title\">24.6.2020 Mittwoch</div><table class=\"info\" ><tr></tr><tr><td>Betroffene Klassen </td><td>05a, 05b, 05c, 05d, Heim</td></tr></table><table class=\"mon_list\" ><tr></tr><tr><td>05abcd</td><td>6</td><td>---</td><td>Ethik</td><td> </td></tr></table>Untis Stundenplan Software',
};

final List<DsbPlan> dsbTest1Expct = [
  DsbPlan(
    TTDay.Tuesday,
    [
      DsbSubstitution('11q', [7], '---', '1sk1', '', true),
    ],
    '23.6.2020 Dienstag',
  ),
  DsbPlan(
    TTDay.Wednesday,
    [],
    '24.6.2020 Mittwoch',
  ),
];

final Map<String, String> dsbTest2Cache = {
  'GetData':
      '{\"d\":\"H4sIAAAAAAAEAOWX3W6bMBSA7yftHSKuS/gxBOjd1G1apaaqlmo301QZfEhQiYmwaTdVfZu9yV5sJm4oP4ayLO00NTco5/98dk4Od2/fTCbaZ2BFyqOMgHY8MY9qsgXHvGCnNM6ERtOkSghzfkoJfBdC3arbz4EWpxzWTGi+lvLJ5E4+hMnORWaQoiijZwm9foy+FV8mPC1rES4rnHKoqU5WSUpq4RspetJ0Uq0437Bjw8CbzZSwUGh4nqVTAgYTDSeRgSnJs4QkQsOMy2QNHIcpTDd0qTWjVpVepL9+UmhpP2cZF8pGfWUppNnvg/g95qBUVEm6LqKwJFU74SVTKk4yevljAx1CQnWRJ5lKrkbacxryc9cWVH07DvYIxI6OMUa6Y3meHrgB0cEObMvyZhGBoF10g4+NpuZsapu2OTH9Y9dVGlfMvkDOc+AFXV7Nrz5BwUEdvJfkIM0WUVul7qEqkfSQlXF76ZYfBWEZ8q8oSxh/QFri2dFmRcj4lWla0xVf98evYPf/Egnm2PAdK/CxG+pBFIsu/NjWMbiublrENy2YAYp8Y0yro4wGax66AfK0qluA+kwGboI8uoHbIHNUN+Jbfw64SeC2LPVw9DYy6HYAqvLed4WqAuvFdeLcdxz6Z4jrO7YTzjzdgjAWRbu27kdIfPV8y4E4QJ6nHgsHmCHzLF8CfRVDZF/MEsZ/NUTGtDrK6FUOkVH0XmSINAVt/17f5vDpRaTNga8yco7X24vKd5tha+87h9uTrKC8u4Uu8A2cYbZdrMsQPC/g0aCq/jFrK2NtE1YmGUiwa7G7kFvjF/KFWIh5sgT2b1fyBXCe0CUb2sg/JKJUSFMxtdvjeuz5soc0ex9vjFNWP9+jpwhZhyL0EYCEOLoeIrSz2Q9OrPZ+Rjj2oeC8C7OCD5HZvvHuRQWXoV8OCToUkrNs+QQTabEflVTluz+WZx2T5UMGFt1hSiFtvC5rc8ENUy43JBO5KA58pEOMZrrjOVgPUBDpQYjQjER+6CBH/NHc/wbNrhqraREAAA==\"}',
  '44a7def4-aaa3-4177-959d-e2921176cde9.htm':
      '<table class=\"mon_head\"> <tr> <td></td> <td></td> <td> null 2019/2020 Stand: 23.06.2020 08:55 </td> </tr></table><div class=\"mon_title\">23.6.2020 Dienstag</div><table class=\"info\" ><tr></tr><tr><td>Betroffene Klassen </td><td>11Q</td></tr></table><table class=\"mon_list\" ><tr></tr></table>Untis Stundenplan Software',
  '58424b67-1ebf-4152-8c37-17814ef93775.htm':
      '<table class=\"mon_head\"> <tr> <td></td> <td></td> <td> GYM. NULL Stand: 23.06.2020 08:55 </td> </tr></table><div class=\"mon_title\">24.6.2020 Mittwoch</div><table class=\"mon_list\" ><tr></tr></table>Untis Stundenplan Software',
};

final List<DsbPlan> dsbTest2Expct = [
  DsbPlan(
    TTDay.Tuesday,
    [],
    '23.6.2020 Dienstag',
  ),
  DsbPlan(
    TTDay.Wednesday,
    [],
    '24.6.2020 Mittwoch',
  ),
];

void assertDsbPlanListsEqual(List<DsbPlan> l1, List<DsbPlan> l2) {
  expect(l1.length, l2.length);
  for (var i = 0; i < l1.length; i++) {
    expect(l1[i].date, l2[i].date);
    expect(l1[i].day, l2[i].day);
    expect(l1[i].subs.length, l2[i].subs.length);
    for (var j = 0; j < l1[i].subs.length; j++) {
      expect(l1[i].subs[j].affectedClass, l2[i].subs[j].affectedClass);
      expect(l1[i].subs[j].hours.length, l2[i].subs[j].hours.length);
      for (var k = 0; k < l1[i].subs[j].hours.length; k++)
        expect(l1[i].subs[j].hours[k], l2[i].subs[j].hours[k]);
      expect(l1[i].subs[j].isFree, l2[i].subs[j].isFree);
      expect(l1[i].subs[j].notes, l2[i].subs[j].notes);
      expect(l1[i].subs[j].subject, l2[i].subs[j].subject);
      expect(l1[i].subs[j].teacher, l2[i].subs[j].teacher);
    }
  }
}

class DsbTestCase extends TestCase {
  String username;
  String password;
  Map<String, String> htmlCache;
  List<DsbPlan> expectedPlans;
  String stage;
  String char;
  Future<List<DsbPlan>> Function(
      String, String, Function, Function, String, String) tfunc;

  DsbTestCase(this.username, this.password, this.htmlCache, this.expectedPlans,
      this.stage, this.char,
      {this.tfunc});

  @override
  Future<Null> run() async {
    tfunc ??= (username, password, httpGet, httpPost, stage, char) async {
      return dsbSortAllByHour(dsbSearchClass(
          await dsbGetAllSubs(username, password,
              lang: Language.all.first,
              httpGet: httpGet,
              httpPost: httpPost,
              dsbLanguage: 'de',
              cacheGetRequests: false,
              cachePostRequests: false),
          stage,
          char));
    };
    var plans = await tfunc(
        username,
        password,
        (url, {getCache, setCache}) => _getFromCache(url.toString()),
        (url, _, __, ___, {getCache, setCache}) =>
            _getFromCache(url.toString()),
        stage,
        char);
    assertDsbPlanListsEqual(plans, expectedPlans);
  }

  Future<String> _getFromCache(String url) async {
    for (var key in htmlCache.keys)
      if (key.toLowerCase().contains(url.toLowerCase()) ||
          url.toLowerCase().contains(key.toLowerCase())) return htmlCache[key];
    return null;
  }
}

List<DsbTestCase> dsbTestCases = [
  DsbTestCase(null, null, dsbTest1Cache, dsbTest1Expct, '11', 'q'),
  DsbTestCase(null, null, dsbTest1Cache, dsbTest1Expct, '11', null),
  DsbTestCase(null, null, dsbTest2Cache, dsbTest2Expct, null, 'q'),
  DsbTestCase('invalid', 'none', dsbTest2Cache, dsbTest2Expct, null, null),
];

class JsonTestCase extends TestCase {
  List<DsbPlan> plans;

  JsonTestCase(this.plans);

  @override
  Future<Null> run() async {
    assertDsbPlanListsEqual(plansFromJson(plansToJson(plans)), plans);
  }
}

List<JsonTestCase> jsonTestCases = [
  JsonTestCase(dsbTest1Expct),
  JsonTestCase(dsbTest2Expct),
];

void main() {
  runTests(dsbTestCases, 'dsbapi dsb');
  runTests(jsonTestCases, 'dsbapi json');
}
