# DESIGN-SPEC.md — Bugigangas Go UI/UX Specification

> **Date:** 2026-06-09
> **Author:** ui-ux-architect
> **Status:** Final — Ready for implementation by flutter-especialist

---

## 1. Color Palette (Updated from APP-DESIGN.md)

| Token | Hex | Usage |
|-------|-----|-------|
| `primary` | `#009696` | Buttons, active tabs, central bottom nav icon, CTAs |
| `primaryLight` | `#0B9B9B` | Hover states, subtle accents |
| `primaryDark` | `#007A7A` | Pressed states, status bar |
| `onPrimary` | `#FFFFFF` | Text on primary backgrounds |
| `primaryContainer` | `#B2F0F0` | Light background containers, decorative areas |
| `background` | `#F5F7F9` | Scaffold background (light cool gray) |
| `surface` | `#FFFFFF` | Cards, sheets, dialogs |
| `textPrimary` | `#1A1A1A` | Headings, body text, tracking codes |
| `textSecondary` | `#757575` | Subtitles, descriptions, hints |
| `textHint` | `#9CA3AF` | Placeholders, disabled text |
| `badgeProcessingBg` | `#FFF3E0` | Background for "Processing" badge |
| `badgeProcessingFg` | `#E65100` | Text/icon for "Processing" badge |
| `badgeOnDeliveryBg` | `#E8F5E9` | Background for "On Delivery" badge |
| `badgeOnDeliveryFg` | `#1B5E20` | Text/icon for "On Delivery" badge |
| `badgeOnProcessBg` | `#FFF8E1` | Background for "On Process" badge |
| `badgeOnProcessFg` | `#F59E0B` | Text/icon for "On Process" badge |

**Status Color Pairs (for tracking badges):**

| Status | Background | Foreground |
|--------|-----------|------------|
| Processing / Posted | `#FFF3E0` (light orange) | `#E65100` (dark orange) |
| In Transit | `#E3F2FD` (light blue) | `#0D47A1` (dark blue) |
| Out for Delivery | `#F3E5F5` (light purple) | `#4A148C` (dark purple) |
| Delivered | `#E8F5E9` (light green) | `#1B5E20` (dark green) |
| Exception / Error | `#FFEBEE` (light red) | `#B71C1C` (dark red) |

**Package Card Circle Colors (for differentiation):**

| Package Index | Circle Color | Icon |
|--------------|-------------|------|
| 0 (PostNord default) | `#FF8A65` (Orange) | `Icons.inventory_2` |
| 1 | `#42A5F5` (Blue) | `Icons.inventory_2` |
| 2 | `#AB47BC` (Purple) | `Icons.inventory_2` |
| 3+ | Cycles back to Orange | `Icons.inventory_2` |

---

## 2. Typography

### Font Stack (Priority Order)
1. **Poppins** (recommended — modern, geometric, excellent legibility on mobile)
2. Inter (fallback)
3. Roboto (system fallback)

### How to add
Add `google_fonts: ^6.1` to `pubspec.yaml` dependencies, then use:
```dart
GoogleFonts.poppinsTextTheme(Theme.of(context).textTheme)
```

### Type Scale

| Style | Size | Weight | Letter-spacing | Color |
|-------|------|--------|---------------|-------|
| `displayLarge` | 36 | Bold (700) | -0.5 | textPrimary |
| `displayMedium` | 28 | Bold (700) | -0.5 | textPrimary |
| `headlineLarge` | 28 | SemiBold (600) | -0.25 | textPrimary |
| `headlineMedium` | 24 | SemiBold (600) | 0 | textPrimary |
| `headlineSmall` | 20 | SemiBold (600) | 0 | textPrimary |
| `titleLarge` | 18 | SemiBold (600) | 0 | textPrimary |
| `titleMedium` | 16 | SemiBold (600) | 0.15 | textPrimary |
| `titleSmall` | 14 | SemiBold (600) | 0.1 | textPrimary |
| `bodyLarge` | 16 | Regular (400) | 0 | textPrimary |
| `bodyMedium` | 14 | Regular (400) | 0 | textSecondary |
| `bodySmall` | 12 | Regular (400) | 0 | textHint |
| `labelLarge` | 14 | SemiBold (600) | 0.5 | textSecondary |
| `labelSmall` | 11 | SemiBold (600) | 0.5 | textHint |

---

## 3. Border Radius Mapping

| Component | Radius | Shape |
|-----------|--------|-------|
| Main cards (Home package cards, Buy Postage cards) | `BorderRadius.circular(24)` | Soft, floating |
| Search bar | `BorderRadius.circular(28)` | Pill shape |
| Status badges | `BorderRadius.circular(20)` | Pill shape |
| Bottom Navigation bar | `BorderRadius.only(topLeft: 24, topRight: 24)` | Floating top corners |
| Quick filter buttons | `BorderRadius.circular(24)` | Oval/pill |
| AppBar gradient container (Home) | `BorderRadius.only(bottomLeft: 32, bottomRight: 32)` | Curved bottom |
| CTA buttons | `BorderRadius.circular(16)` | Rounded |
| Tab pill container (Support screen) | `BorderRadius.circular(32)` | Pill shaped |
| Profile avatar | `CircleBorder()` | Circular |
| Central search icon in bottom nav | `CircleBorder()` | Circular highlight |
| Shipping option cards (Buy Postage) | `BorderRadius.circular(24)` | Match main cards |
| Dialog | `BorderRadius.circular(20)` | Soft modal |

---

## 4. Icon Inventory (Material Design Icons)

### Bottom Navigation Bar (5 items)

| Position | Label | Icon (Material) | Notes |
|----------|-------|----------------|-------|
| 1 | Home | `Icons.home_rounded` | Default |
| 2 | Market / Carrinho | `Icons.shopping_cart_rounded` | — |
| 3 | Search | `Icons.search_rounded` | Central, teal circle background |
| 4 | Chat | `Icons.chat_bubble_rounded` | — |
| 5 | Profile | `Icons.person_rounded` | — |

### Home Screen (Tela 1)

| Component | Icon | Notes |
|-----------|------|-------|
| Notification bell | `Icons.notifications_rounded` | With badge |
| Search magnifier | `Icons.search_rounded` | Inside SearchBar |
| Package card leading (per package) | `Icons.inventory_2` | Inside colored circle |
| Tracking code copy | `Icons.copy_rounded` | Optional — on tap copy |
| Arrow forward (see all) | `Icons.arrow_forward_ios_rounded` | Small, hint color |

### Buy Postage Screen (Tela 2)

| Component | Icon | Notes |
|-----------|------|-------|
| Back button | `Icons.arrow_back_rounded` | AppBar leading |
| Menu / hamburger | `Icons.menu_rounded` | AppBar trailing |
| Country dropdown arrow | `Icons.keyboard_arrow_down_rounded` | Right side of destination card |
| Letter illustration | Use asset `letter_illustration.svg` | Right side of Letter card |
| Parcel illustration | Use asset `parcel_illustration.svg` | Right side of Parcel card |
| Postcard illustration | Use asset `postcard_illustration.svg` | Right side of Postcards card |
| Denmark flag | Use asset `flag_denmark.png` | Left side of destination card |

### Support Screen (Tela 3)

| Component | Icon | Notes |
|-----------|------|-------|
| Back button | `Icons.arrow_back_rounded` | AppBar leading |
| Chat (inactive tab) | `Icons.chat_bubble_outline_rounded` | Alongside text |
| FAQ (inactive tab) | `Icons.help_outline_rounded` | Alongside text |
| Chat (active tab) | `Icons.chat_bubble_rounded` | White icon on teal |
| Smartphone illustration | Use asset `support_chat_illustration.svg` | Central area |

---

## 5. BottomNavigationBar Specification (Floating Custom)

### Layout
- Bar is **not** a standard `BottomNavigationBar` — use a custom `Container` with:
  - `width: double.infinity` (with horizontal margin of 16)
  - `height: 72` (64 content + 8 bottom safe area)
  - `decoration: BoxDecoration(borderRadius: BorderRadius.only(topLeft: 24, topRight: 24), boxShadow: ...)`
  - `color: Colors.white`
  - Positioned at the bottom using `Stack` or `bottomNavigationBar` property of Scaffold

### Item Specification

| # | Icon | Label | Active Color | Inactive Color |
|---|------|-------|-------------|----------------|
| 0 | `Icons.home_rounded` | Home | `#009696` | `#9CA3AF` |
| 1 | `Icons.shopping_cart_rounded` | Market | `#009696` | `#9CA3AF` |
| 2 | `Icons.search_rounded` | (none) | `#FFFFFF` | `#FFFFFF` |
| 3 | `Icons.chat_bubble_rounded` | Chat | `#009696` | `#9CA3AF` |
| 4 | `Icons.person_rounded` | Profile | `#009696` | `#9CA3AF` |

### Central Item (Search) — Special Treatment
- Item index 2 is wrapped in a teal circle (`Container` with `CircleBorder()`, size 56x56)
- Background: `#009696`
- Elevation: 4 (shadow)
- Offset upward by 12px relative to other items (using `EdgeInsets.only(bottom: 12)` or transform)
- Icon: `Icons.search_rounded`, color: white

### Code Structure Suggestion
```dart
// Use a custom widget: FloatingBottomNav
// Parameters: currentIndex, onTap callback
// Build method should render 5 items in a Row with equal Expanded flex
// Center item gets the circular teal treatment
```

---

## 6. Home Screen Header Specification

### Container
- A `Container` with gradient background using:
  ```dart
  LinearGradient(
    begin: Alignment.topLeft,
    end: Alignment.bottomRight,
    colors: [Color(0xFF0B9B9B), Color(0xFF009696)],
  )
  ```
- `BorderRadius.only(bottomLeft: 32, bottomRight: 32)`
- Bottom padding to accommodate the search bar overflow

### Layout (top to bottom)

```
┌─────────────────────────────────────┐
│ [Avatar] Welcome back, Andrew [Bell]│ ← Row 1 (profile + notification)
│                                       │
│  Track your Package                  │ ← Title
│  Subtitle text here                  │ ← Subtitle
│                                       │
│ ┌─────────────────────────────────┐  │ ← Search Bar (overflows bottom)
│ │ 🔍 Tracking by parcel          │  │
│ └─────────────────────────────────┘  │
└─────────────────────────────────────┘
```

### Proportions
- **Avatar size:** 40x40 (CircleAvatar)
- **Bell icon size:** 24x24 Icon, wrapped in 40x40 Ink/Container for tap area
- **Search bar:** Height 48, horizontal margin 16, white background, borderRadius 28
- **Title:** `headlineMedium` weight 700, color white
- **Subtitle:** `bodyMedium` weight 400, color white with 85% opacity
- **Left padding:** 24 (title/subtitle)
- **Total header height:** ~220px (including search bar overflow of ~24px)

### Notification Badge
- Small red dot (8x8) positioned at top-right of bell icon
- Use `Stack` or `Badge` widget with `smallSize: 8`

### Profile Image
- Use asset `profile_avatar.png` (placeholder) inside `CircleAvatar`
- If no real photo available, use `CircleAvatar(child: Icon(Icons.person))`

---

## 7. Quick Filters Specification (Home Screen)

### Container
- Horizontal `ListView.builder` with `scrollDirection: Axis.horizontal`
- Padding: symmetric horizontal 16
- Item spacing: 8

### Filter Items

| Filter | Label | Behavior |
|--------|-------|----------|
| 0 | Pick Up | Initially selected (teal bg) |
| 1 | Package Claim | Initially unselected (gray bg) |
| 2 | All Packages | Initially unselected (gray bg) |
| 3 | International | Initially unselected (gray bg) |

### Style
- **Selected state:** `backgroundColor: #009696`, `foregroundColor: #FFFFFF`, elevation 0
- **Unselected state:** `backgroundColor: #F0F2F5` (light gray), `foregroundColor: #1A1A1A`, border: none
- **Shape:** `StadiumBorder()` or `RoundedRectangleBorder(borderRadius: 24)`
- **Padding:** horizontal 20, vertical 10
- **Text style:** `titleSmall` (14px, semi-bold)

### Code Suggestion
```dart
class QuickFilterChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  // Render with AnimatedContainer for smooth transition
  // Use ValueNotifier or state management for selection
}
```

---

## 8. Package List Cards Specification (Home Screen)

### Card Structure
```
┌────────────────────────────────────────┐
│  🟠[Circle]  CRG211000581  [Processing]│ ← Row
│              150 kg - 1200x800x100     │
└────────────────────────────────────────┘
```

### Specs
- **Card:** `Container` with `BoxShadow`: `color: Color(0x1A000000)`, `blurRadius: 12`, `offset: (0, 4)`
- **Border radius:** 24
- **Margin:** vertical 6, horizontal 16
- **Padding:** 16 all sides
- **Leading circle:** 48x48, colored circle (Orange/Blue/Purple), icon `Icons.inventory_2` (22px, white)
- **Title:** tracking code (`codeStyle`: 14px, monospace, weight 500, letterSpacing 1.0)
- **Subtitle:** description + dimensions (bodySmall, textSecondary)
- **Trailing badge:** Use existing `StatusBadge` widget (compact: true)
- **Gap between cards:** 12

---

## 9. Buy Postage Screen Specification (Tela 2)

### AppBar
- leading: `Icons.arrow_back_rounded`
- title: "Buy postage" (text centered)
- actions: `Icons.menu_rounded`

### Destination Section
- Title "Destination" in `textSecondary`, 12px
- Card with:
  - Leading: flag image (`flag_denmark.png`, 24x24)
  - Title: "Denmark" (bold, 16px)
  - Trailing: `Icons.keyboard_arrow_down_rounded`

### Shipping Options Section
- Title "Shipping options" in bold, 18px
- 3 cards in vertical list:

| Card | Background Color | Icon Position | Content |
|------|-----------------|---------------|---------|
| **Letter** | `#E3F2FD` (pastel blue 10% opacity) | Right | Name, description "From 29 DKK" |
| **Parcel** | `#FFF8E1` (pastel yellow 10% opacity) | Right | Name, description "From 49 DKK" |
| **Postcards** | `#E8F5E9` (pastel green 10% opacity) | Right | Name, description "From 19 DKK" |

### Card Layout (per card)
```
┌──────────────────────────────────┐
│  Letter           [illustration] │
│  description text                │
│  From 29 DKK                     │
└──────────────────────────────────┘
```

- **Border radius:** 24
- **Padding:** 20
- **Min height:** 140
- **Left side:** Column (name bold, description bodyMedium, price headlineSmall)
- **Right side:** SizedBox(width: 80) containing the illustration asset

---

## 10. Support Screen Specification (Tela 3)

### AppBar
- leading: `Icons.arrow_back_rounded`
- title: "Support"

### Tab Switcher (Custom Segmented Control)
- Container: cinza claro `#F0F2F5`, `BorderRadius.circular(32)`, padding 4
- Two segments: "Chat" and "FAQ"
- Selected segment: background `#009696`, text white, `BorderRadius.circular(32)`
- Unselected segment: text `#757575`, no background color

### Central Illustration Area
- Asset: `support_chat_illustration.svg`
- Size: ~200x200 (maintained aspect ratio)
- Centered in the middle of the screen (above the text)

### Text Section
- "Log in with MitID for chat." → `bodyMedium`, textSecondary, centered
- "Access chat and features log in with MitID." → `headlineSmall`, textPrimary, bold, centered, max 2 lines
- Gap between texts: 8px

### CTA Button
- `ElevatedButton` with `width: double.infinity`
- Margin: horizontal 24, vertical 16
- Height: 52
- `BorderRadius.circular(16)`
- Background: `#009696`
- Text: "Started new chat", white, bold, 16px
- onPressed: Navigate to chat (or show coming soon dialog)

---

## 11. Assets Inventory

### Assets to Download (Free, No Copyright)

| Asset Name | Source | URL / How to Get | Used In |
|-----------|--------|------------------|---------|
| `support_chat_illustration.svg` | unDraw.co | Search "Mobile messaging" or "Chat" at undraw.co, set teal color, download SVG | Support screen central area |
| `delivery_address_illustration.svg` | unDraw.co | Search "Delivery address" at undraw.co, download SVG | Home screen empty state / generic |
| `profile_avatar.png` | Pixabay / UI Avatars | Use `https://ui-avatars.com/api/?name=Andrew+Hawkins&background=009696&color=fff&size=256` or download a generic avatar from Pixabay | Home header CircleAvatar |
| `flag_denmark.png` | Flagpedia / iconpacks | Download 24x24 PNG of Denmark flag from a free flag source | Buy Postage destination card |
| `letter_illustration.svg` | unDraw.co or Freepik | Search "Envelope" or "Email" at undraw.co, download SVG | Buy Postage — Letter card |
| `parcel_illustration.svg` | unDraw.co or Freepik | Search "Package" or "Parcel" at undraw.co, download SVG | Buy Postage — Parcel card |
| `postcard_illustration.svg` | unDraw.co | Search "Postcard" or "Letter" at undraw.co, download SVG | Buy Postage — Postcards card |
| `empty_state_parcel.svg` | unDraw.co | Search "Empty", "Package", "No data" at undraw.co, download SVG | Tracking screen empty state |

### Alternative Approach (if downloads fail)
Use **Lottie animations** or **Flutter-built placeholder widgets** instead of SVG assets:
- For illustrations: Use `FlutterLogo` or custom `CustomPainter` shapes as fallback
- For flags: Use `Text("🇩🇰")` emoji as placeholder
- For profile: Use `CircleAvatar(child: Icon(Icons.person))`

### Folder Structure for Assets
```
assets/
  imgs/
    model.png                      (existing)
    profile_avatar.png             (new — profile photo)
    flag_denmark.png               (new — flag icon)
    support_chat_illustration.svg  (new — support screen)
    delivery_address_illustration.svg (new — home empty state)
    letter_illustration.svg        (new — buy postage)
    parcel_illustration.svg        (new — buy postage)
    postcard_illustration.svg      (new — buy postage)
    empty_state_parcel.svg         (new — tracking empty state)
```

---

## 12. Detailed Steps for flutter-especialist

### Phase 1 — Theme & Foundation (Day 1)
1. Update `app_colors.dart`:
   - Change `primary` from `0xFF00A59B` to `0xFF009696`
   - Change `textPrimary` from `0xFF1A1A2E` to `0xFF1A1A1A`
   - Change `textSecondary` from `0xFF6B7280` to `0xFF757575`
   - Update status badge colors to match APP-DESIGN.md pastel pairs
   - Keep existing `StatusColorPair` structure, update hex values
2. Update `app_theme.dart`:
   - Change card border radius from 16 to 24
   - Change elevated button border radius from 12 to 16
   - Update search bar border radius to 28
   - Update input decoration border radius to 16
   - Update chip border radius to 24
3. Add `google_fonts` dependency to `pubspec.yaml`
4. Update `app_typography.dart` to use Poppins or Inter
5. Add new assets to `pubspec.yaml`

### Phase 2 — Navigation Shell (Day 1-2)
1. Create `lib/shared/widgets/floating_bottom_nav.dart`:
   - Custom widget with 5 items
   - Central search button with teal circle
   - Floating design with top rounded corners
   - Animate selection with scale/color transitions
2. Create a **ShellScreen** or **AppShell** that wraps the bottom nav around all screens
   - Update `router.dart` to use a `ShellRoute`
   - Home, Buy Postage, Search (placeholder), Chat (placeholder), Profile (placeholder)

### Phase 3 — Home Screen Overhaul (Day 2-3)
1. Rewrite `home_screen.dart`:
   - **Header:** Gradient container with curved bottom, profile avatar, welcome text, notification bell with badge
   - **Title:** "Track your Package" + subtitle
   - **Search bar:** Overlapping white TextField with rounded corners
   - **Quick filters:** Horizontal listView of oval buttons (Pick Up, Package Claim, etc.)
   - **Package list:** "PostNord parcel" section title + vertical ListView.builder
     - Each card: colored circle leading (Orange/Blue/Purple), code, details, status badge trailing
     - `BoxShadow` with blur 12, offset 0,4
     - BorderRadius 24
   - Remove old stats cards (em trânsito, entregues, total)
   - Remove old action cards
   - Keep existing providers (`packageListProvider`, `searchQueryProvider`, etc.)

### Phase 4 — Buy Postage Screen (Day 3)
1. Create `lib/features/postage/presentation/buy_postage_screen.dart`
2. Create `lib/features/postage/presentation/` folder structure
3. Create route `/buy-postage` in router
4. Build screen:
   - AppBar with back + title "Buy postage" + menu icon
   - "Destination" section with flag card (Denmark + dropdown arrow)
   - "Shipping options" section with 3 cards (Letter, Parcel, Postcards)
     - Pastel backgrounds, left text + right illustration

### Phase 5 — Support Screen (Day 3-4)
1. Create `lib/features/support/presentation/support_screen.dart`
2. Create route `/support` in router
3. Build screen:
   - AppBar with back + title "Support"
   - Custom tab pill (Chat / FAQ) with teal active state
   - Chat content: illustration + "Log in with MitID" text + CTA button
   - FAQ tab: placeholder with list of common questions (or coming soon)

### Phase 6 — Polish (Day 4)
1. Add page transitions (slide animations)
2. Add shimmer loading states for package list
3. Add empty states with illustrations for tracking screen
4. Add haptic feedback on CTA buttons
5. Test all screen flows

---

## 13. Gap Analysis: Current → Desired

| Aspect | Current State | Desired State (APP-DESIGN.md) | Action Needed |
|--------|--------------|-------------------------------|---------------|
| Primary color | `#00A59B` | `#009696` / `#0B9B9B` | Update hex |
| Card border radius | 16 | 24-32 | Update theme |
| Bottom nav | Standard M3 `NavigationBar` | Custom floating with 5 items + central circle | New widget |
| Home header | SliverAppBar with gradient + title | Custom header with avatar, welcome, bell, title, search bar | Full rewrite |
| Quick filters | Not present | Horizontal oval buttons (Pick Up, Package Claim) | New component |
| Package cards | Stats cards + action cards + recent tiles | Leading colored circle + code + details + status badge | Redesign list |
| Search | Separate TextField in TrackingScreen | Overlaid on Home header, placeholder "Tracking by parcel" | Integrate into Home |
| Buy Postage screen | Not present | Full screen with destination + 3 shipping option cards | New feature |
| Support screen | Not present | Tab pill (Chat/FAQ) + illustration + CTA | New feature |
| Notifications | Not present | Bell icon with badge in Home header | New component |
| Typography | System default | Poppins/Inter via Google Fonts | Add dependency |
| Assets | Only `model.png` | 7+ new illustrations and icons | Download assets |

---

## 14. Recommendations (Beyond Original Design)

1. **Search Functionality:**
   - Home search bar should filter the package list in real-time (use existing `searchQueryProvider`)
   - Consider adding a "recent searches" section below the search bar

2. **Accessibility:**
   - All status badges include icons alongside color (already implemented in `StatusBadge` — keep this)
   - Minimum contrast ratio 4.5:1 for all text
   - Semantic labels on all IconButtons
   - Use `Semantics` widget for the bottom nav central button

3. **Micro-interactions:**
   - Quick filter buttons: use `AnimatedContainer` for smooth color transition (200ms)
   - Bottom nav items: scale animation on tap (1.0 → 1.1 → 1.0)
   - Package cards: subtle `InkWell` ripple effect
   - Pull-to-refresh on package list

4. **Empty States:**
   - Home: "No packages yet — start tracking!" with illustration
   - Tracking: "No results found" with search illustration
   - Support Chat: Illustration as already designed
   - Buy Postage: Default to Denmark as pre-selected

5. **Loading States:**
   - Use `Shimmer` effect for package card skeletons while loading
   - Use `CircularProgressIndicator` in teal color for page transitions

6. **Error Handling:**
   - Show `SnackBar` with error message if tracking code lookup fails
   - "Try again" button on network errors

7. **Performance:**
   - Use `const` constructors everywhere possible
   - Use `ListView.builder` (not `ListView`) for package lists
   - Use `Image.asset` with `fit: BoxFit.contain` for SVG illustrations
   - Consider `flutter_svg` package for SVG rendering (add to pubspec)

8. **Dark Mode:**
   - Consider adding a dark theme variant in a future iteration
   - Store theme preference in SharedPreferences

---

## 15. Widget Tree Overview

```
MaterialApp.router
  └── GoRouter
       ├── ShellRoute (with FloatingBottomNav)
       │    ├── HomeScreen
       │    │    ├── GradientHeader (avatar + welcome + bell + title + search)
       │    │    ├── QuickFilters (horizontal scroll)
       │    │    └── PackageListView
       │    │         └── PackageCard (circle + code + status badge)
       │    ├── BuyPostageScreen (NEW)
       │    │    ├── DestinationCard (flag + name + dropdown)
       │    │    └── ShippingOptionsList
       │    │         ├── LetterCard (pastel blue + illustration)
       │    │         ├── ParcelCard (pastel yellow + illustration)
       │    │         └── PostcardCard (pastel green + illustration)
       │    ├── SearchScreen (placeholder)
       │    ├── SupportScreen (NEW)
       │    │    ├── TabPill (Chat | FAQ)
       │    │    ├── ChatContent (illustration + text + CTA)
       │    │    └── FAQContent (placeholder)
       │    └── ProfileScreen (placeholder)
       ├── /tracking → TrackingScreen (existing, can be kept or integrated)
       └── /tracking/:code → PackageDetailScreen (existing, keep as-is)
```

---

## 16. pubspec.yaml Changes Required

```yaml
dependencies:
  # ... existing ...
  google_fonts: ^6.1.0         # NEW — for Poppins/Inter
  flutter_svg: ^2.0.10+1       # NEW — for SVG illustration rendering
  shimmer: ^3.0.0              # NEW — for loading skeletons (optional)

# Assets section must be updated to:
flutter:
  uses-material-design: true
  assets:
    - assets/imgs/
    # Individual declarations (more explicit):
    - assets/imgs/model.png
    - assets/imgs/profile_avatar.png
    - assets/imgs/flag_denmark.png
    - assets/imgs/support_chat_illustration.svg
    - assets/imgs/delivery_address_illustration.svg
    - assets/imgs/letter_illustration.svg
    - assets/imgs/parcel_illustration.svg
    - assets/imgs/postcard_illustration.svg
    - assets/imgs/empty_state_parcel.svg
```

---

*End of DESIGN-SPEC.md*
