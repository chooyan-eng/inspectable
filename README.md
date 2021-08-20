# Inspectable

Inspectable is a widget which inspect entire descendant widgets.

## Features

- Inspect widgets belonging to its subtree.
- Colorize widgets you want to check.

## Goal

The goal of Inspectable is to clarify the exact widgets which consturuct current displaying UI for Flutter app developers without IDE.

"Without IDE" may be useful if you want to inspect widget tree built with "release" mode or without connecting real devices with PC.

## Usage

1. place `Inspectable` below `MaterialApp`.

```dart
class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: Inspectable(
        child: MyHomePage(),
        colors: <Type, Color> {
          Text: Colors.blue,
          Material: Colors.red,
          GestureDetector: Colors.teal,
        }
      ),
    );
  }
}
```

Optionally, you can colorize and emphasize the name of widgets with `colors` property.

2. call `Inspectable.of(context).inspect()` to display Widget tree.

```dart
TextButton(
  onPressed: () {
    Inspectable.of(context).inspect();
  },
  child: Text(
    'INSPECT',
  ),
)
```

3. If you want to inspect only below the specific widget, you can just place another Inspectable there.

```dart
Inspectable(
  child: AnyWidgetForInspect();
)
```

note that in this case, you must use `context` below `AnyWidgetForInspect` as context would look up closest ancestor `Inspectable` of it.


# Contact

If you have anything you want to inform me ([@chooyan-eng](https://github.com/chooyan-eng)), such as suggestions to enhance this package or functionalities you want etc, feel free to make [issues on GitHub](https://github.com/chooyan-eng/inspectable/issues) or send messages on Twitter en: [@tsuyoshi_chujo](https://twitter.com/tsuyoshi_chujo) ja: [@chooyan_i18n](https://twitter.com/chooyan_i18n).