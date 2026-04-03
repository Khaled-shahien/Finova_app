# Design System Specification: The Financial Atelier

## 1. Overview & Creative North Star
**Creative North Star: "The Editorial Ledger"**

To move beyond the generic "SaaS dashboard" aesthetic, this design system treats personal finance as a high-end editorial experience. We reject the cluttered, boxy layouts of traditional banking. Instead, we embrace **Soft Minimalism**—a philosophy where data is given room to breathe, and hierarchy is communicated through tonal depth rather than structural rigidity.

The system breaks the "template" look by using intentional white space, dramatic typographic scales (Manrope for displays), and a layered surface architecture. It feels like a premium physical planner translated into a fluid digital medium—authoritative yet approachable.

---

## 2. Color & Surface Architecture
We move away from flat hex codes toward a functional "Tonal Palette."

### The "No-Line" Rule
**Explicit Instruction:** Designers are prohibited from using 1px solid borders for sectioning. Boundaries must be defined solely through:
1.  **Background Shifts:** e.g., a `surface-container-low` card sitting on a `surface` background.
2.  **Tonal Transitions:** Using subtle variations in surface tiers to imply edges.

### Surface Hierarchy & Nesting
Treat the UI as a series of physical layers—like stacked sheets of fine paper.
-   **Base Layer:** `surface` (#f8f9fa) for the overall application background.
-   **Section Layer:** `surface-container-low` (#f3f4f5) for large grouping areas.
-   **Content Layer:** `surface-container-lowest` (#ffffff) for individual interactive cards.
-   **Active/Elevated Layer:** `surface-container-high` (#e7e8e9) for elements requiring immediate focus.

### The "Glass & Gradient" Rule
To inject "soul" into the interface:
-   **Glassmorphism:** For floating action buttons or modal overlays, use `surface` colors at 80% opacity with a `20px` backdrop-blur.
-   **Signature Gradients:** Main CTAs or Hero Cards should utilize a subtle linear gradient: `primary` (#24389c) to `primary_container` (#3f51b5) at a 135° angle. This adds a "lithographic" quality that flat fills lack.

---

## 3. Typography
We utilize a dual-font strategy to balance character with legibility.

| Level | Font | Token Reference | Usage |
| :--- | :--- | :--- | :--- |
| **Display** | Manrope | `display-lg` (3.5rem) | Hero balances and monthly summaries. |
| **Headline** | Manrope | `headline-md` (1.75rem) | Page titles and major section headers. |
| **Title** | Inter | `title-lg` (1.375rem) | Card titles and modal headers. |
| **Body** | Inter | `body-md` (0.875rem) | Transaction descriptions and general text. |
| **Label** | Inter | `label-sm` (0.6875rem) | Overline text, timestamps, and metadata. |

**The Hierarchy Logic:** Manrope provides a modern, geometric "editorial" feel for high-level data, while Inter ensures maximum readability for dense financial logs.

---

## 4. Elevation & Depth
Depth is achieved through **Tonal Layering** rather than traditional structural lines.

### The Layering Principle
Instead of shadows, stack surface tiers. 
*   *Example:* Place a `surface-container-lowest` card on top of a `surface-container-low` background. The slight shift in brightness provides a "natural" lift.

### Ambient Shadows
When a "floating" effect is required (e.g., a bottom navigation bar or a FAB):
-   **Blur:** `24px` to `32px` (extra-diffused).
-   **Opacity:** `4%` to `8%`.
-   **Color:** Use a tinted version of `on-surface` (#191c1d) to mimic natural light, never pure black.

### The "Ghost Border" Fallback
If accessibility requires a border (e.g., in high-contrast modes), use the **Ghost Border**:
-   **Token:** `outline-variant` (#c5c5d4).
-   **Opacity:** Reduced to `15%`.
-   **Weight:** `1px`.

---

## 5. Components

### Cards & Lists (The FinTech Core)
-   **Rule:** Forbid divider lines. Use vertical spacing (Token `4` or `1rem`) or subtle background shifts.
-   **Transaction Item:** Use a `surface-container-lowest` card with an `xl` (1.5rem) corner radius. The icon for the category should use a soft background (e.g., `primary_fixed` for indigo icons).

### Buttons
-   **Primary:** Gradient fill (`primary` to `primary_container`), `full` (pill) rounding, `on_primary` text.
-   **Secondary:** `surface-container-high` fill, no border, `primary` text.
-   **Tertiary:** Ghost style, no background, `primary` text.

### Inputs
-   **Styling:** Use `surface-container-low` for the input field background.
-   **Active State:** Transitions to `surface-container-lowest` with a `2px` `primary` "Ghost Border" at 40% opacity.
-   **Error:** Background shifts to `error_container`, text becomes `on_error_container`.

### Finance-Specific Components
-   **The Delta Indicator:** For income/expense shifts, use `secondary` (Teal) for "Up" and `tertiary` (Red/Orange) for "Down." Use `label-md` for the percentage text, paired with a subtle upward/downward arrow icon.
-   **Progress Rings:** Use `outline-variant` for the track and `primary` or `secondary` for the progress fill. Stroke ends must be rounded.

---

## 6. Do’s and Don'ts

### Do
-   **Do** use asymmetrical spacing for hero sections (e.g., more padding on the top-left than the bottom-right) to create an editorial feel.
-   **Do** use `display-lg` for large currency amounts, but reduce the letter-spacing by `-0.02em` for a tighter, premium look.
-   **Do** utilize the `8pt` grid religiously for layout, but feel free to "break" it for decorative background elements.

### Don’t
-   **Don't** use 100% black text. Always use `on-surface` (#191c1d) to maintain the soft minimalist aesthetic.
-   **Don't** use standard Material Design drop shadows. They feel "engineered" rather than "designed."
-   **Don't** use cards inside cards (nesting cards) unless the background colors shift tiers (e.g., Lowest on Low).
-   **Don't** use high-saturation reds for expenses. Use the `tertiary` (#802000) or `on_tertiary_fixed_variant` for a sophisticated "Brick Red" that feels premium, not alarming.

---

## 7. Implementation Notes (Flutter/Clean Architecture)
-   **ThemeData:** Map these tokens directly to `ColorScheme` in Flutter.
-   **Corner Radius:** Map the `xl` (1.5rem) to `BorderRadius.circular(24)`.
-   **Spacing:** Use a `Spacing` helper class to reference the scale (e.g., `AppSpacing.s4` for 16px).
-   **Architecture:** UI components should be pure/stateless, receiving data through ViewModels to ensure the visual system remains decoupled from business logic.