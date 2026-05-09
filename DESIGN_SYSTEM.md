# UI/UX Design System - Focus HSC AI

## Overview

Focus HSC AI uses a premium Material Design 3 aesthetic with custom branding, glassmorphism effects, and smooth animations optimized for studying.

## Color Palette

### Primary Colors
- **Primary**: #4F46E5 (Deep Indigo)
- **Primary Dark**: #312E81 (Dark Indigo)
- **Primary Light**: #6366F1 (Light Indigo)

### Semantic Colors
- **Success**: #10B981 (Green) - Correct answers
- **Error**: #F87171 (Red) - Wrong answers
- **Warning**: #FBBF24 (Yellow) - Warnings/caution
- **Info**: #3B82F6 (Blue) - Information

### Surface Colors
- **Light Surface**: #F9FAFB (Off-white)
- **Dark Surface**: #121212 (Dark background)
- **Light Card**: #FFFFFF (White)
- **Dark Card**: #1E1E2E (Dark card)

### Text Colors
- **Light Primary Text**: #111827 (Dark gray)
- **Light Secondary Text**: #6B7280 (Medium gray)
- **Dark Primary Text**: #F3F4F6 (Light gray)
- **Dark Secondary Text**: #D1D5DB (Medium light gray)

## Typography

### Font Families
- **Poppins**: Headlines, titles, and emphasis
- **Inter**: Body text and descriptions

### Typography Scale

| Level | Font | Size | Weight | Usage |
|-------|------|------|--------|-------|
| Display Large | Poppins | 32px | Bold | Major headings |
| Display Medium | Poppins | 28px | Bold | Section headers |
| Heading 1 | Poppins | 20px | 700 | Screen titles |
| Heading 2 | Poppins | 18px | 600 | Card titles |
| Body Large | Inter | 16px | 500 | Main content |
| Body Medium | Inter | 14px | 400 | Regular text |
| Body Small | Inter | 12px | 400 | Secondary text |
| Caption | Inter | 11px | 400 | Captions |

## Component Styles

### Cards
- Border Radius: 16dp
- Padding: 16-20dp
- Shadow: Soft elevation (2-8dp)
- Hover: Slight scale (1.02x)

### Buttons
- Primary Button:
  - Gradient: Primary (indigo to deeper indigo)
  - Padding: 16x52px
  - Border Radius: 12dp
  - Shadow: 4dp
  - Press: Scale to 0.95x

- Secondary Button:
  - Border: 2px primary color
  - Transparent background
  - Same dimensions as primary

### Input Fields
- Border: Rounded (12dp)
- Border Width: 1-2px
- Focus Color: Primary
- Error Color: Red
- Background: Surface+10% opacity

### Icons
- Size Hierarchy:
  - Small: 16-20px
  - Medium: 24-32px
  - Large: 40-48px
  - Extra Large: 60-80px

## Animations

### Duration Standards
- Short: 300ms (micro-interactions)
- Medium: 500ms (screen transitions)
- Long: 800ms (complex animations)

### Animation Timing
- Easing: EaseInOut (standard curves)
- Bounce: for celebrations
- Linear: for progress indicators

### Specific Animations
- **Page Transitions**: Slide + Fade (500ms)
- **Button Press**: Scale (300ms)
- **Card Entry**: FadeIn + SlideY (500ms)
- **Loading**: Shimmer loop (continuous)
- **Results**: Scale bounce (800ms)
- **MCQ Options**: Color transition (300ms)

## Spacing System

Base unit: 8px

| Token | Size | Usage |
|-------|------|-------|
| xs | 4px | Icon spacing |
| sm | 8px | Small gaps |
| md | 16px | Default padding |
| lg | 24px | Large sections |
| xl | 32px | Page margins |
| 2xl | 48px | Screen height gaps |

## Elevation & Shadows

```dart
// Soft shadow (default cards)
BoxShadow(
  color: Color(0x1A000000),
  blurRadius: 8,
  offset: Offset(0, 2),
)

// Elevated shadow (hover states)
BoxShadow(
  color: Color(0x1A000000),
  blurRadius: 16,
  offset: Offset(0, 8),
)
```

## Dark Mode Implementation

- All text automatically inverts
- Cards use darker background (#1E1E2E)
- Shadows become lighter/more visible
- Gradients maintain visual hierarchy
- No hard white/black contrast

## States

### Button States
- Default: Full opacity, normal scale
- Hover: Scale 1.05, shadow increase
- Pressed: Scale 0.95, shadow decrease
- Disabled: 50% opacity, no interaction

### Input States
- Empty: Hint text visible
- Focused: Border color = primary
- Filled: Border color = divider
- Error: Border color = error red

### Card States
- Normal: Base shadow
- Hover: Elevated shadow, slight scale
- Selected: Border highlight + opacity

## Responsive Design

### Breakpoints
- Mobile: < 600dp
- Tablet: 600dp - 1200dp
- Desktop: > 1200dp

### Padding Adjustments
- Mobile: 16dp
- Tablet: 24dp
- Desktop: 32dp

## Accessibility

- Minimum touch target: 48x48dp
- Color contrast ratio: 4.5:1 for text
- Icon labels for icon-only buttons
- Focus indicators visible
- Support for screen readers

## Glassmorphism

Subtle glass effects used for:
- Overlay backgrounds
- Translucent cards (production ready)
- Frosted glass on backgrounds

Implementation:
```dart
Container(
  color: Colors.white.withOpacity(0.1),
  backdrop: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
)
```

## Component Library

### Available Widgets
- `PremiumCard`: Base card component
- `GradientButton`: Primary action button
- `ProgressIndicatorCard`: Circular progress display
- `QuickActionButton`: 2x2 grid buttons
- `CountdownTimer`: Exam countdown display
- `LoadingShimmer`: Skeleton loading state
- `EmptyStateWidget`: Empty state display
- `ChatBubble`: Chat message display
- `MCQOptionButton`: MCQ option selector
- `RoutineTaskTile`: Task list item
- `WeakTopicCard`: Weak topic display

## Usage Examples

### Creating a Premium Card
```dart
PremiumCard(
  padding: EdgeInsets.all(16),
  child: Text('Content'),
  onTap: () => action(),
)
```

### Creating a Gradient Button
```dart
GradientButton(
  label: 'Submit',
  onPressed: () => action(),
  gradient: AppColors.primaryGradient,
)
```

### Applying Theme
```dart
Theme.of(context).textTheme.titleLarge
Theme.of(context).colorScheme.primary
```

---

**Design System Version**: 1.0
**Last Updated**: May 8, 2026
