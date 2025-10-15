
# PokeDex App

A basic Pokédex built with Flutter. Kids (and grown-ups) can:

-   roll a **random Pokémon** card,

-   **explore** a library of Pokémon with simple **filters**,

-   **search** with typo-tolerance,

-   open a rich **details page** with image, flavor text, **stats**, and a full **evolution tree**,

-   and **favorite** the ones they want to come back to.


No account, no API key requried - powered by [PokéAPI](https://pokeapi.co/).

----------

## Features

### Random Pokémon

-   Big card with official artwork, name, and Pokédex number.

-   Buttons: **Learn more** → Details page, **Another!** → reroll.


### Explore (Library)

-   **Simple filters** (no heavy enrichment on device):

    -   **Generation**: fetches `/generation/{name|id}` and lists that gen’s species.

    -   **Type**: fetches `/type/{name}` and lists all Pokémon of that type.

-   **Bottom-sheet filter panel** with ChoiceChips (Gen _or_ Type at a time).

-   **Search bar** above the grid with **fuzzy** search (using `fuzzy_bolt` package) scoped to the current list.


### Details Page

-   Collapsing **SliverAppBar** with large artwork.

-   Tabs:

    -   **About**: genus, flavor text, height/weight, growth rate, egg groups, hatch steps, capture rate, color, generation, abilities (hidden marked).

    -   **Stats**: base stats with bars + total.

    -   **Evolution**: full tree from `evolution-chain`, with simple requirement text (“Lv. 16”, “Use Thunder Stone”, “While raining”, etc.).

-   “Favorite” button in the AppBar (local store).

##  How the app is used

1.  **Home**: switch tabs in the bottom bar:

    -   **Random**: roll a Pokémon; tap **Learn more** to see the details page.

    -   **Explore**: tap the **Filter** icon → choose **Generation** _or_ **Type** (mutually exclusive).  
        The grid updates to that scope. Use the search bar to quickly find a name within the list.

    -   **Favorites**: see your saved Pokémon.

2.  **Details**: swipe between **About**, **Stats**, and **Evolution**.

    
----------

## Architecture

**State management**

-   Lightweight **ViewModels** (registered via `get_it`) + `ValueNotifier` for UI updates.

-   Screens use `ValueListenableBuilder` to react to loading/loaded/error states.


**Networking**

-   `Dio`-based `NetworkClient` with base URL, timeouts, and logging.


**Search**

-   Local fuzzy search via `fuzzy_bolt` over the **current** scoped list (gen **or** type).

-   Ultra-short queries (1 char) fall back to simple prefix/contains for better feel.


----------

## Tech stack

-   **Flutter** (flutter 3.35.6 and dart 3.9.2)

-   **dio** (networking)

-   **get_it** (DI/locator)

-   **cached_network_image** (image caching)

-   **fuzzy_bolt** (typo-tolerant search)

-   **shared_preferences** (local storage for favorites)

----------

## Images

Official artwork (PNG) from:

```
https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/other/official-artwork/{id}.png

```

----------

## Getting started

### Prereqs

-   Flutter SDK (stable channel)

-   Dart >= 3.9.0

-   iOS/Android tooling set up


### Install

```bash
flutter pub get

```

### Run

```bash
flutter run

```

No environment variables or API keys needed.

----------

##  Project layout (high-level)

```
lib/
  common/
    model/            # shared models like PokemonListItem
    view/             # shared widgets (images, error cards, etc.)
  poke_library/
    view/             # PokeLibraryScreen + filter bottom sheet
    model/            # grid state
    viewmodel/        # ViewModel and data source
  random_pokemon/
    view/             # RandomPokemonScreen
    model/            # state
    viewmodel/        # ViewModel and data source
  pokemon_details/
    view/             # Details page + tabs (About/Stats/Evolution)
    model/            # bundle & state
    viewmodel/        # ViewModel and data source
  favorites/
    view/             # FavoritesScreen & FavoriteButton
    viewmodel/        # ViewModel and data source
  network/
    network_client.dart
```

----------


##  Credits & license

-   Data & sprites by **PokéAPI** — see their terms: [https://pokeapi.co/](https://pokeapi.co/)

-   Artwork hosted on GitHub (official artwork sprites).

---

##  Thoughts on Further Work

### Error handling

* **Centralized interceptors** for Dio (map status codes → friendly messages).
* **Repository** between Remote Source ↔ ViewModel to classify:

    * network vs. parsing vs. empty results vs. rate limiting, better error handling for VM

### Styling & theming

* **Color palette** for the whole app.
* **Text styles**
* **Design tokens** for consistent paddings / borders etc.
* **Dark mode**
* **i18n** (arb files)

### Networking

* Improve on the Dio client, add interceptors

### Logging & diagnostics

* **Logger service** (debug/info/warn/error) with tags & throttling.

### UI/UX 

* **Richer details**
* **Animations**
* **Recent searches / suggestions**
* **Accessibility**

### QA & testing

* More extensive tests (widget/integration)

### CI/CD

* **Static analysis** (`flutter analyze`, `dart lint`, format).
* **CI pipeline** (GitHub Actions / CodeMagic): test → build → artifacts.
* **Release tracks**:

    * iOS: App Store Connect page, **TestFlight**, device testing.
    * Android: Play Console internal testing.

### Search & filters (BFF option)

* **Backend-for-Frontend** to overcome PokéAPI’s lack of server search:

    * Endpoint for **full-text/typo-tolerant search** (prefix+fuzzy).
    * Server caching, rate limiting,
    * More specified DTOs for App scope
* This reduces on-device requests and enables **multi-filter** combos.

### Code quality

* * **analysis_options.yaml** with strict lints.


---

