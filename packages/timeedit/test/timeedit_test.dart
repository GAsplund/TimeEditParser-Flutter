import 'package:flutter_test/flutter_test.dart';
import 'package:timeedit/objects/page_entry.dart';
import 'package:timeedit/src/timeedit_web.dart';

import 'package:timeedit/timeedit.dart';

void main() {
  group("Navigate to schedule", () {
    test("Fetch orgs", () async => {expect(await TimeEditWeb.searchOrgs("ch"), isNotEmpty)});

    test("Fetch entries", () async => {expect(await TimeEditWeb.getEntries("chalmers"), isNotEmpty)});

    test("Fetch page IDs", () async => {expect(await TimeEditWeb.getPageIds("chalmers", "public"), isNotEmpty)});
  });

  group("Get schedule info", () {
    test(
        "Fetch schedule categories",
        () async => {
              expect(await TimeEditWeb.getCategories("chalmers", "public", 3), isNotEmpty),
            });
    test(
        "Fetch schedule objects",
        () async => {
              expect(await TimeEditWeb.getObjects("chalmers", "public", 3, [182], []), isNotEmpty)
            });
  });
}
