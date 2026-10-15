# Flutter Course: Demos and Projects

Code for the Flutter course, Sessions 3 to 7. Every session has small **demos**
(one concept each) and one **project** that puts the concepts together.

## Setup

1. Install Flutter (stable channel) and run `flutter doctor`.
2. Clone this repository and open the folder in VS Code.
3. Get the packages:

   ```bash
   flutter pub get
   ```

## Running an app

Every demo and project is its own small app with its own `main()`.

**In VS Code (recommended):** open **Run and Debug** (`Cmd+Shift+D` / `Ctrl+Shift+D`),
pick an app from the dropdown (grouped by session), and press **F5**.
It runs in debug mode, so the Widget Inspector and breakpoints work.

**From the terminal:** pass the file with `-t`:

```bash
flutter run -t lib/day5_demos/demo1_setstate_problem.dart
```

Plain `flutter run` starts the Restaurant Menu App (`lib/main.dart`).

## What's inside

| Session | Topic | Demos | Project |
|---|---|---|---|
| 3 | Layouts & Styling | `lib/day3_demos/` | Restaurant Menu App: `lib/main.dart`, `lib/restaurant/` |
| 4 | Navigation & Forms | `lib/day4_demos/` | Contact Book App: `lib/contact_book/` |
| 5 | State Management with Riverpod | `lib/day5_demos/` | Pizza Order App: `lib/pizza_order/` |
| 6 | Working with APIs | `lib/day6_demos/` | Joke App: `lib/joke_app/` |
| 7 | Local Storage | `lib/day7_demos/` | Quotes App: `lib/quotes_app/` |

Each demo file starts with a comment explaining what it shows and how to run it.

## Student guides

The guide for each session is in `docs/`:

- `docs/student_pdfs/`: PDFs, which open directly on GitHub
- `docs/student_pages/`: the same guides as web pages. Download one and open it in a browser.

## Tests

```bash
flutter test
```

The project tests use a fake server and fake storage, so they don't need the internet.

## Good to know

- **Sessions 6 and 7 need the internet.** The APIs used are free and need no key:
  JSONPlaceholder, the Official Joke API and DummyJSON.
- **Session 7 in Chrome:** saved data belongs to one web address. Run on a fixed port, or a new run
  starts with empty storage: `flutter run -d chrome --web-port 5050 -t lib/day7_demos/demo1_prefs_basics.dart`.
  The Session 7 entries in VS Code already do this.
- **Riverpod 3:** `StateProvider` is imported from `package:flutter_riverpod/legacy.dart`.

## Credits

- Font: [Poppins](https://fonts.google.com/specimen/Poppins), SIL Open Font License, see `assets/fonts/OFL.txt`.
- Dish photos in `assets/images/` are placeholder photos from [Lorem Picsum](https://picsum.photos), which serves free-to-use Unsplash photos.
