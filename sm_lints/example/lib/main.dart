// Copyright 2013 The Flutter Authors. All rights reserved.
// Use of this source code is governed by a BSD-style license that can be
// found in the LICENSE file.

// The code in this file (and all other dart files in the package) is
// analyzed using the rules activated in `analysis_options.yaml`.

// The following syntax deactivates a lint for the entire file:
// ignore_for_file: avoid_renaming_method_parameters

void main() {
  // ignore: omit_local_variable_types, omit_obvious_local_variable_types
  const String partOne = 'Hello';
  // ignore: omit_local_variable_types, omit_obvious_local_variable_types
  const String partTwo = 'World';

  // The following syntax deactivates a lint on a per-line bases:
  print('$partOne $partTwo'); // ignore: avoid_print
}

// ignore: unreachable_from_main, public_member_api_docs
abstract class Base {
  // ignore: unreachable_from_main, public_member_api_docs
  int methodA(int foo);
  // ignore: unreachable_from_main, public_member_api_docs
  String methodB(String foo);
}

// Normally, the parameter renaming from `foo` to `bar` in this class would
// trigger the `avoid_renaming_method_parameters` lint, but it has been
// deactivated for the file with the `ignore_for_file` comment above.
// ignore: unreachable_from_main, public_member_api_docs
class Sub extends Base {
  @override
  int methodA(int bar) => bar;

  @override
  String methodB(String bar) => bar;
}
