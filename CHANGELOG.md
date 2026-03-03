## 0.1.2

- Add `showModeIcon` parameter to ModeToggleButton (default `true`)
- Set `showModeIcon: false` to hide the hamburger/morph icon when branding is sufficient
- Add "Show Mode Icon" toggle to playground example

## 0.1.1

- Add `Widget? icon` parameter to ModeToggleButton for custom branding
- Branding layout: icon + label on the left, hamburger on the right
- CollapsedLeft shows centered icon or circled monogram fallback
- Smooth cross-fade between expanded content and collapsed branding
- Add ModeToggleButton section to README
- Add interactive icon picker to playground example

## 0.1.0

- Initial release
- 4 button variants: GlassPillButton, OutlineFillButton, SoftShadowButton, UnderlineMinimalButton
- Cursor-aware arrow morphing with smooth animation
- Touch/drag support for mobile
- Configurable parameters: fontSize, letterSpacing, padding, arrowSize, arrowStrokeWidth
- Variant-specific parameters: borderRadius, borderWidth, fillOpacity, shadowBlur, elevation, underlineHeight
- Interactive playground example app with live controls
