import 'dart:ui';

class AppColors {
  /// #F1AB65 ![](https://dummyimage.com/24/F1AB65.png&text=+)
  static const primary = Color.fromRGBO(241, 171, 101, 1);

  /// #021032 ![](https://dummyimage.com/24/021032.png&text=+)
  static const secondary = Color.fromRGBO(2, 16, 50, 1);

  /// #2E8B57 ![](https://dummyimage.com/24/2E8B57.png&text=+)
  static const background = Color.fromRGBO(253, 242, 220, 1);
}

enum TypographyVariant {
  /// font-size: 28
  h1,

  /// font-size: 24
  h2,

  /// font-size: 18
  h3,

  /// font-size: 16
  h4,

  /// font-size: 14
  h5,

  /// font-size: 12
  h6,

  /// font-size: 10
  h7,
}
