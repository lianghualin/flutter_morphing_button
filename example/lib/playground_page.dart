import 'package:flutter/material.dart';
import 'package:morphing_button/morphing_button.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  // -- Tap feedback --
  String _lastTap = '';

  // -- Global controls --
  double _arrowSize = 8;
  double _arrowStroke = 2.5;
  bool _enabled = true;
  double _splitRatio = 0.5;

  // -- NavToggle --
  NavToggleMode _navMode = NavToggleMode.sidebar;
  double _navWidth = 220;
  int _navSelectedIndex = 0;

  // -- V1: Glass Pill --
  String _v1Label = 'EXPLORE';
  double _v1FontSize = 13;
  double _v1LetterSpacing = 2.5;
  double _v1HPad = 52;
  double _v1VPad = 16;
  double _v1Hue = 239; // indigo (0xFF6366F1)
  double _v1TextLightness = 0.14;

  // -- V2: Outline Fill --
  String _v2Label = 'NAVIGATE';
  double _v2FontSize = 13;
  double _v2LetterSpacing = 2;
  double _v2HPad = 48;
  double _v2VPad = 16;
  double _v2BorderRadius = 0;
  double _v2BorderWidth = 2;
  double _v2FillOpacity = 0.92;
  double _v2Hue = 250; // purple base
  double _v2TextLightness = 0.14;

  // -- V3: Soft Shadow --
  String _v3Label = 'DISCOVER';
  double _v3FontSize = 14;
  double _v3LetterSpacing = 1.5;
  double _v3HPad = 52;
  double _v3VPad = 18;
  double _v3ShadowBlur = 28;
  double _v3Elevation = 2;
  double _v3Hue = 185; // mid-spectrum
  double _v3TextLightness = 0.2;

  // -- V4: Underline --
  String _v4Label = 'CONTINUE';
  double _v4FontSize = 13;
  double _v4LetterSpacing = 3;
  double _v4HPad = 40;
  double _v4VPad = 14;
  double _v4UnderlineHeight = 1.5;
  double _v4Hue = 0; // dark (achromatic)
  double _v4TextLightness = 0.1;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [Color(0xFFFAFAFE), Color(0xFFF2F2F8)],
          ),
        ),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _buildHeader(),

              // Tap feedback
              _TapFeedback(message: _lastTap),

              // V1: Glass Pill
              _VariantSection(
                index: 0,
                title: 'Glassmorphism Pill',
                description:
                    'Frosted glass with indigo glow tracking \u2014 the classic modern look with depth.',
                button: GlassPillButton(
                  label: _v1Label,
                  fontSize: _v1FontSize,
                  letterSpacing: _v1LetterSpacing,
                  horizontalPadding: _v1HPad,
                  verticalPadding: _v1VPad,
                  arrowSize: _arrowSize + 2,
                  arrowStrokeWidth: _arrowStroke,
                  enabled: _enabled,
                  splitRatio: _splitRatio,
                  accentColor: HSLColor.fromAHSL(1, _v1Hue, 0.7, 0.55).toColor(),
                  textColor: HSLColor.fromAHSL(1, _v1Hue, 0.3, _v1TextLightness).toColor(),
                  onLeftTap: () => setState(() => _lastTap = '\u2190 Glass Pill: LEFT tapped'),
                  onRightTap: () => setState(() => _lastTap = 'Glass Pill: RIGHT tapped \u2192'),
                ),
                controls: [
                  _LabelControl(
                    value: _v1Label,
                    onChanged: (v) => setState(() => _v1Label = v),
                  ),
                  _HueSliderControl(
                    label: 'Accent Hue',
                    value: _v1Hue,
                    onChanged: (v) => setState(() => _v1Hue = v),
                  ),
                  _SliderControl(
                    label: 'Text Lightness',
                    value: _v1TextLightness,
                    min: 0,
                    max: 0.8,
                    decimals: 2,
                    onChanged: (v) => setState(() => _v1TextLightness = v),
                  ),
                  _SliderControl(
                    label: 'Font Size',
                    value: _v1FontSize,
                    min: 8,
                    max: 24,
                    onChanged: (v) => setState(() => _v1FontSize = v),
                  ),
                  _SliderControl(
                    label: 'Letter Spacing',
                    value: _v1LetterSpacing,
                    min: 0,
                    max: 6,
                    decimals: 1,
                    onChanged: (v) => setState(() => _v1LetterSpacing = v),
                  ),
                  _SliderControl(
                    label: 'Padding H',
                    value: _v1HPad,
                    min: 16,
                    max: 80,
                    onChanged: (v) => setState(() => _v1HPad = v),
                  ),
                  _SliderControl(
                    label: 'Padding V',
                    value: _v1VPad,
                    min: 4,
                    max: 32,
                    onChanged: (v) => setState(() => _v1VPad = v),
                  ),
                ],
              ),

              // V2: Outline Fill
              _VariantSection(
                index: 1,
                title: 'Outline Fill Wipe',
                description:
                    'Border-only at rest. On hover, color floods in from the arrow\'s direction with a full wipe.',
                button: OutlineFillButton(
                  label: _v2Label,
                  fontSize: _v2FontSize,
                  letterSpacing: _v2LetterSpacing,
                  horizontalPadding: _v2HPad,
                  verticalPadding: _v2VPad,
                  arrowSize: _arrowSize,
                  arrowStrokeWidth: _arrowStroke,
                  enabled: _enabled,
                  splitRatio: _splitRatio,
                  borderRadius: _v2BorderRadius,
                  borderWidth: _v2BorderWidth,
                  fillOpacity: _v2FillOpacity,
                  accentColor: HSLColor.fromAHSL(1, _v2Hue, 0.65, 0.5).toColor(),
                  textColor: HSLColor.fromAHSL(1, _v2Hue, 0.1, _v2TextLightness).toColor(),
                  onLeftTap: () => setState(() => _lastTap = '\u2190 Outline Fill: LEFT tapped'),
                  onRightTap: () => setState(() => _lastTap = 'Outline Fill: RIGHT tapped \u2192'),
                ),
                controls: [
                  _LabelControl(
                    value: _v2Label,
                    onChanged: (v) => setState(() => _v2Label = v),
                  ),
                  _HueSliderControl(
                    label: 'Accent Hue',
                    value: _v2Hue,
                    onChanged: (v) => setState(() => _v2Hue = v),
                  ),
                  _SliderControl(
                    label: 'Text Lightness',
                    value: _v2TextLightness,
                    min: 0,
                    max: 0.8,
                    decimals: 2,
                    onChanged: (v) => setState(() => _v2TextLightness = v),
                  ),
                  _SliderControl(
                    label: 'Border Radius',
                    value: _v2BorderRadius,
                    min: 0,
                    max: 30,
                    onChanged: (v) => setState(() => _v2BorderRadius = v),
                  ),
                  _SliderControl(
                    label: 'Border Width',
                    value: _v2BorderWidth,
                    min: 0.5,
                    max: 6,
                    decimals: 1,
                    onChanged: (v) => setState(() => _v2BorderWidth = v),
                  ),
                  _SliderControl(
                    label: 'Fill Opacity',
                    value: _v2FillOpacity,
                    min: 0,
                    max: 1,
                    decimals: 2,
                    onChanged: (v) => setState(() => _v2FillOpacity = v),
                  ),
                  _SliderControl(
                    label: 'Font Size',
                    value: _v2FontSize,
                    min: 8,
                    max: 24,
                    onChanged: (v) => setState(() => _v2FontSize = v),
                  ),
                  _SliderControl(
                    label: 'Letter Spacing',
                    value: _v2LetterSpacing,
                    min: 0,
                    max: 6,
                    decimals: 1,
                    onChanged: (v) => setState(() => _v2LetterSpacing = v),
                  ),
                  _SliderControl(
                    label: 'Padding H',
                    value: _v2HPad,
                    min: 16,
                    max: 80,
                    onChanged: (v) => setState(() => _v2HPad = v),
                  ),
                  _SliderControl(
                    label: 'Padding V',
                    value: _v2VPad,
                    min: 4,
                    max: 32,
                    onChanged: (v) => setState(() => _v2VPad = v),
                  ),
                ],
              ),

              // V3: Soft Shadow
              _VariantSection(
                index: 2,
                title: 'Soft Shadow Float',
                description:
                    'Clean white card that lifts on hover. A colored shadow shifts direction and hue with the cursor.',
                button: SoftShadowButton(
                  label: _v3Label,
                  fontSize: _v3FontSize,
                  letterSpacing: _v3LetterSpacing,
                  horizontalPadding: _v3HPad,
                  verticalPadding: _v3VPad,
                  arrowSize: _arrowSize + 1,
                  arrowStrokeWidth: _arrowStroke,
                  enabled: _enabled,
                  splitRatio: _splitRatio,
                  shadowBlur: _v3ShadowBlur,
                  elevation: _v3Elevation,
                  accentColor: HSLColor.fromAHSL(1, _v3Hue, 0.65, 0.55).toColor(),
                  textColor: HSLColor.fromAHSL(1, _v3Hue, 0.1, _v3TextLightness).toColor(),
                  onLeftTap: () => setState(() => _lastTap = '\u2190 Soft Shadow: LEFT tapped'),
                  onRightTap: () => setState(() => _lastTap = 'Soft Shadow: RIGHT tapped \u2192'),
                ),
                controls: [
                  _LabelControl(
                    value: _v3Label,
                    onChanged: (v) => setState(() => _v3Label = v),
                  ),
                  _HueSliderControl(
                    label: 'Accent Hue',
                    value: _v3Hue,
                    onChanged: (v) => setState(() => _v3Hue = v),
                  ),
                  _SliderControl(
                    label: 'Text Lightness',
                    value: _v3TextLightness,
                    min: 0,
                    max: 0.8,
                    decimals: 2,
                    onChanged: (v) => setState(() => _v3TextLightness = v),
                  ),
                  _SliderControl(
                    label: 'Shadow Blur',
                    value: _v3ShadowBlur,
                    min: 0,
                    max: 60,
                    onChanged: (v) => setState(() => _v3ShadowBlur = v),
                  ),
                  _SliderControl(
                    label: 'Elevation',
                    value: _v3Elevation,
                    min: 0,
                    max: 12,
                    decimals: 1,
                    onChanged: (v) => setState(() => _v3Elevation = v),
                  ),
                  _SliderControl(
                    label: 'Font Size',
                    value: _v3FontSize,
                    min: 8,
                    max: 24,
                    onChanged: (v) => setState(() => _v3FontSize = v),
                  ),
                  _SliderControl(
                    label: 'Letter Spacing',
                    value: _v3LetterSpacing,
                    min: 0,
                    max: 6,
                    decimals: 1,
                    onChanged: (v) => setState(() => _v3LetterSpacing = v),
                  ),
                  _SliderControl(
                    label: 'Padding H',
                    value: _v3HPad,
                    min: 16,
                    max: 80,
                    onChanged: (v) => setState(() => _v3HPad = v),
                  ),
                  _SliderControl(
                    label: 'Padding V',
                    value: _v3VPad,
                    min: 4,
                    max: 32,
                    onChanged: (v) => setState(() => _v3VPad = v),
                  ),
                ],
              ),

              // V4: Underline
              _VariantSection(
                index: 3,
                title: 'Underline Editorial',
                description:
                    'Typography-first, no-frills. A thin underline sweeps in from the arrow\'s direction.',
                button: UnderlineMinimalButton(
                  label: _v4Label,
                  fontSize: _v4FontSize,
                  letterSpacing: _v4LetterSpacing,
                  horizontalPadding: _v4HPad,
                  verticalPadding: _v4VPad,
                  arrowSize: _arrowSize - 1,
                  arrowStrokeWidth: _arrowStroke - 1,
                  enabled: _enabled,
                  splitRatio: _splitRatio,
                  underlineHeight: _v4UnderlineHeight,
                  accentColor: HSLColor.fromAHSL(1, _v4Hue, 0.7, 0.35).toColor(),
                  textColor: HSLColor.fromAHSL(1, _v4Hue, 0.2, _v4TextLightness).toColor(),
                  onLeftTap: () => setState(() => _lastTap = '\u2190 Underline: LEFT tapped'),
                  onRightTap: () => setState(() => _lastTap = 'Underline: RIGHT tapped \u2192'),
                ),
                controls: [
                  _LabelControl(
                    value: _v4Label,
                    onChanged: (v) => setState(() => _v4Label = v),
                  ),
                  _HueSliderControl(
                    label: 'Accent Hue',
                    value: _v4Hue,
                    onChanged: (v) => setState(() => _v4Hue = v),
                  ),
                  _SliderControl(
                    label: 'Text Lightness',
                    value: _v4TextLightness,
                    min: 0,
                    max: 0.8,
                    decimals: 2,
                    onChanged: (v) => setState(() => _v4TextLightness = v),
                  ),
                  _SliderControl(
                    label: 'Underline Height',
                    value: _v4UnderlineHeight,
                    min: 0.5,
                    max: 5,
                    decimals: 1,
                    onChanged: (v) => setState(() => _v4UnderlineHeight = v),
                  ),
                  _SliderControl(
                    label: 'Font Size',
                    value: _v4FontSize,
                    min: 8,
                    max: 24,
                    onChanged: (v) => setState(() => _v4FontSize = v),
                  ),
                  _SliderControl(
                    label: 'Letter Spacing',
                    value: _v4LetterSpacing,
                    min: 0,
                    max: 6,
                    decimals: 1,
                    onChanged: (v) => setState(() => _v4LetterSpacing = v),
                  ),
                  _SliderControl(
                    label: 'Padding H',
                    value: _v4HPad,
                    min: 16,
                    max: 80,
                    onChanged: (v) => setState(() => _v4HPad = v),
                  ),
                  _SliderControl(
                    label: 'Padding V',
                    value: _v4VPad,
                    min: 4,
                    max: 32,
                    onChanged: (v) => setState(() => _v4VPad = v),
                  ),
                ],
              ),

              // NavToggle Demo
              _buildNavToggleSection(),

              // Theme Demo
              _buildThemeSection(),

              // Global Controls
              _buildGlobalControls(),

              // Footer
              Padding(
                padding: const EdgeInsets.all(40),
                child: Text(
                  'HOVER ACROSS EACH BUTTON TO SEE THE MORPHING EFFECT',
                  style: TextStyle(
                    fontSize: 11,
                    color: Colors.grey.shade400,
                    letterSpacing: 1.5,
                    fontFamily: 'monospace',
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildNavToggleSection() {
    final items = [
      (Icons.home_outlined, 'Home'),
      (Icons.search, 'Search'),
      (Icons.favorite_outline, 'Favorites'),
      (Icons.settings_outlined, 'Settings'),
    ];

    // Derive morph progress from width (maps 56-280 → 0.0-1.0)
    final morphProgress = ((_navWidth - 56) / (280 - 56)).clamp(0.0, 1.0);

    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEF2))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        children: [
          const Text(
            'NAV TOGGLE',
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              letterSpacing: 3,
              color: Color(0xFFAAAAAA),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Navigation Toggle Button',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 400,
            child: Text(
              'A hover-aware navigation item with 3 rendering modes. '
              'First item uses iconMorphProgress tied to width slider.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          // Mode selector
          SegmentedButton<NavToggleMode>(
            segments: const [
              ButtonSegment(
                value: NavToggleMode.sidebar,
                label: Text('Sidebar'),
                icon: Icon(Icons.view_sidebar_outlined, size: 16),
              ),
              ButtonSegment(
                value: NavToggleMode.iconRail,
                label: Text('Icon Rail'),
                icon: Icon(Icons.view_week_outlined, size: 16),
              ),
              ButtonSegment(
                value: NavToggleMode.tabBar,
                label: Text('Tab Bar'),
                icon: Icon(Icons.tab_outlined, size: 16),
              ),
            ],
            selected: {_navMode},
            onSelectionChanged: (v) => setState(() => _navMode = v.first),
          ),
          const SizedBox(height: 20),
          // Nav items
          Container(
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(12),
              border: Border.all(color: const Color(0xFFE8E8F0)),
            ),
            clipBehavior: Clip.antiAlias,
            child: _navMode == NavToggleMode.tabBar
                ? Row(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      for (var i = 0; i < items.length; i++)
                        NavToggleButton(
                          currentWidth: 120,
                          mode: _navMode,
                          icon: items[i].$1,
                          label: items[i].$2,
                          isSelected: _navSelectedIndex == i,
                          iconMorphProgress: i == 0 ? morphProgress : null,
                          accentColor: const Color(0xFF6366F1),
                          enabled: _enabled,
                          onTap: () => setState(() {
                            _navSelectedIndex = i;
                            _lastTap = 'Nav: ${items[i].$2} tapped';
                          }),
                        ),
                    ],
                  )
                : SizedBox(
                    width: _navWidth,
                    child: Column(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        for (var i = 0; i < items.length; i++)
                          NavToggleButton(
                            currentWidth: _navWidth,
                            mode: _navMode,
                            icon: items[i].$1,
                            label: items[i].$2,
                            isSelected: _navSelectedIndex == i,
                            iconMorphProgress: i == 0 ? morphProgress : null,
                            accentColor: const Color(0xFF6366F1),
                            enabled: _enabled,
                            onTap: () => setState(() {
                              _navSelectedIndex = i;
                              _lastTap = 'Nav: ${items[i].$2} tapped';
                            }),
                          ),
                      ],
                    ),
                  ),
          ),
          if (_navMode != NavToggleMode.tabBar) ...[
            const SizedBox(height: 16),
            SizedBox(
              width: 360,
              child: _SliderControl(
                label: 'Nav Width',
                value: _navWidth,
                min: 56,
                max: 280,
                onChanged: (v) => setState(() => _navWidth = v),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _buildThemeSection() {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEF2))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        children: [
          const Text(
            'THEME',
            style: TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              letterSpacing: 3,
              color: Color(0xFFAAAAAA),
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'MorphingButtonTheme',
            style: TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 400,
            child: Text(
              'Wrap buttons in a MorphingButtonTheme to set defaults. '
              'These two buttons inherit fontSize and arrowSize from the theme.',
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          MorphingButtonTheme(
            data: const MorphingButtonThemeData(
              fontSize: 16,
              arrowSize: 12,
              letterSpacing: 3,
              accentColor: Color(0xFF10B981),
            ),
            child: Column(
              children: [
                GlassPillButton(
                  label: 'THEMED',
                  onTap: () =>
                      setState(() => _lastTap = 'Themed Glass Pill tapped'),
                ),
                const SizedBox(height: 16),
                OutlineFillButton(
                  label: 'THEMED',
                  onTap: () =>
                      setState(() => _lastTap = 'Themed Outline Fill tapped'),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildGlobalControls() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 24),
      child: _ControlPanel(
        title: 'Global Controls',
        children: [
          _SliderControl(
            label: 'Arrow Size',
            value: _arrowSize,
            min: 4,
            max: 16,
            onChanged: (v) => setState(() => _arrowSize = v),
          ),
          _SliderControl(
            label: 'Arrow Stroke',
            value: _arrowStroke,
            min: 1,
            max: 5,
            decimals: 1,
            onChanged: (v) => setState(() => _arrowStroke = v),
          ),
          _SliderControl(
            label: 'Split Ratio',
            value: _splitRatio,
            min: 0.1,
            max: 0.9,
            decimals: 2,
            onChanged: (v) => setState(() => _splitRatio = v),
          ),
          _ToggleControl(
            label: 'Enabled',
            value: _enabled,
            onChanged: (v) => setState(() => _enabled = v),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    return Padding(
      padding: const EdgeInsets.fromLTRB(24, 64, 24, 48),
      child: Column(
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 4),
            decoration: BoxDecoration(
              color: const Color(0xFFEEEEFF),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              'INTERACTIVE PLAYGROUND',
              style: TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                letterSpacing: 2,
                color: Color(0xFF6366F1),
              ),
            ),
          ),
          const SizedBox(height: 20),
          const Text(
            'Morphing Buttons',
            style: TextStyle(
              fontSize: 42,
              fontWeight: FontWeight.w300,
              color: Color(0xFF111111),
              letterSpacing: -1,
              height: 1.15,
            ),
          ),
          const SizedBox(height: 14),
          Text(
            'Hover across each button. The arrow morphs based on cursor '
            'position \u2014 left side shows \u2190, right side shows \u2192, '
            'with smooth interpolation between states.\n'
            'Adjust the controls below each button to customize the look.',
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 15,
              color: Colors.grey.shade500,
              height: 1.6,
            ),
          ),
          const SizedBox(height: 28),
          _buildZoneLegend(),
        ],
      ),
    );
  }

  Widget _buildZoneLegend() {
    return Container(
      width: 320,
      height: 32,
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(16),
        border: Border.all(color: const Color(0xFFDDDDDD)),
      ),
      child: ClipRRect(
        borderRadius: BorderRadius.circular(16),
        child: Row(
          children: [
            _zoneLabel('\u2190 LEFT', const Color(0xFFEEF0FF), true),
            _zoneLabel('CENTER', const Color(0xFFF5F5F8), true),
            _zoneLabel('RIGHT \u2192', const Color(0xFFFFF0F5), false),
          ],
        ),
      ),
    );
  }

  Widget _zoneLabel(String label, Color bg, bool showBorder) {
    return Expanded(
      child: Container(
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: bg,
          border: showBorder
              ? const Border(
                  right: BorderSide(color: Color(0xFFE0E0E8)),
                )
              : null,
        ),
        child: Text(
          label,
          style: const TextStyle(
            fontSize: 9,
            letterSpacing: 1.5,
            color: Color(0xFF999999),
            fontFamily: 'monospace',
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Variant section with collapsible controls
// ---------------------------------------------------------------------------

class _VariantSection extends StatefulWidget {
  final int index;
  final String title;
  final String description;
  final Widget button;
  final List<Widget> controls;

  const _VariantSection({
    required this.index,
    required this.title,
    required this.description,
    required this.button,
    required this.controls,
  });

  @override
  State<_VariantSection> createState() => _VariantSectionState();
}

class _VariantSectionState extends State<_VariantSection> {
  bool _expanded = false;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      decoration: const BoxDecoration(
        border: Border(bottom: BorderSide(color: Color(0xFFEEEEF2))),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 32, vertical: 48),
      child: Column(
        children: [
          Text(
            'Variant ${widget.index + 1}',
            style: const TextStyle(
              fontSize: 10,
              fontFamily: 'monospace',
              letterSpacing: 3,
              color: Color(0xFFAAAAAA),
            ),
          ),
          const SizedBox(height: 6),
          Text(
            widget.title,
            style: const TextStyle(
              fontSize: 20,
              fontWeight: FontWeight.w500,
              color: Color(0xFF1A1A2E),
              letterSpacing: -0.3,
            ),
          ),
          const SizedBox(height: 6),
          SizedBox(
            width: 400,
            child: Text(
              widget.description,
              textAlign: TextAlign.center,
              style: TextStyle(
                fontSize: 13,
                color: Colors.grey.shade500,
                height: 1.5,
              ),
            ),
          ),
          const SizedBox(height: 24),
          widget.button,
          const SizedBox(height: 20),
          // Toggle controls
          GestureDetector(
            onTap: () => setState(() => _expanded = !_expanded),
            child: Container(
              padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
              decoration: BoxDecoration(
                color: _expanded
                    ? const Color(0xFFEEEEFF)
                    : const Color(0xFFF5F5F8),
                borderRadius: BorderRadius.circular(14),
                border: Border.all(
                  color: _expanded
                      ? const Color(0xFFCCCCEE)
                      : const Color(0xFFE0E0E8),
                ),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Icon(
                    _expanded
                        ? Icons.tune
                        : Icons.tune_outlined,
                    size: 14,
                    color: _expanded
                        ? const Color(0xFF6366F1)
                        : const Color(0xFF999999),
                  ),
                  const SizedBox(width: 6),
                  Text(
                    _expanded ? 'HIDE CONTROLS' : 'CONTROLS',
                    style: TextStyle(
                      fontSize: 10,
                      fontFamily: 'monospace',
                      letterSpacing: 1.5,
                      color: _expanded
                          ? const Color(0xFF6366F1)
                          : const Color(0xFF999999),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Controls panel
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 200),
            crossFadeState: _expanded
                ? CrossFadeState.showSecond
                : CrossFadeState.showFirst,
            firstChild: const SizedBox.shrink(),
            secondChild: Padding(
              padding: const EdgeInsets.only(top: 16),
              child: _ControlPanel(
                children: widget.controls,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Control panel container
// ---------------------------------------------------------------------------

class _ControlPanel extends StatelessWidget {
  final String? title;
  final List<Widget> children;

  const _ControlPanel({this.title, required this.children});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 420,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: const Color(0xFFE8E8F0)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(alpha: 0.03),
            blurRadius: 8,
            offset: const Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          if (title != null) ...[
            Text(
              title!,
              style: const TextStyle(
                fontSize: 11,
                fontFamily: 'monospace',
                letterSpacing: 2,
                fontWeight: FontWeight.w600,
                color: Color(0xFF6366F1),
              ),
            ),
            const SizedBox(height: 12),
          ],
          ...children,
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Slider control
// ---------------------------------------------------------------------------

class _SliderControl extends StatelessWidget {
  final String label;
  final double value;
  final double min;
  final double max;
  final int decimals;
  final ValueChanged<double> onChanged;

  const _SliderControl({
    required this.label,
    required this.value,
    required this.min,
    required this.max,
    this.decimals = 0,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 2,
                thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 6),
                overlayShape: const RoundSliderOverlayShape(overlayRadius: 12),
                activeTrackColor: const Color(0xFF6366F1),
                inactiveTrackColor: const Color(0xFFE0E0E8),
                thumbColor: const Color(0xFF6366F1),
                overlayColor: const Color(0x206366F1),
              ),
              child: Slider(
                value: value.clamp(min, max),
                min: min,
                max: max,
                onChanged: onChanged,
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: Text(
              decimals == 0
                  ? '${value.round()}'
                  : value.toStringAsFixed(decimals),
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Color(0xFF444444),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Hue slider control with rainbow track
// ---------------------------------------------------------------------------

class _HueSliderControl extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _HueSliderControl({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final previewColor = HSLColor.fromAHSL(1, value, 0.7, 0.5).toColor();
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Row(
              children: [
                Container(
                  width: 14,
                  height: 14,
                  decoration: BoxDecoration(
                    color: previewColor,
                    shape: BoxShape.circle,
                    border: Border.all(
                      color: Colors.black.withValues(alpha: 0.1),
                    ),
                  ),
                ),
                const SizedBox(width: 6),
                Text(
                  label,
                  style: const TextStyle(
                    fontSize: 12,
                    color: Color(0xFF666666),
                  ),
                ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              height: 24,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(12),
                gradient: LinearGradient(
                  colors: List.generate(
                    7,
                    (i) => HSLColor.fromAHSL(1, i * 60.0, 0.7, 0.5).toColor(),
                  ),
                ),
              ),
              child: SliderTheme(
                data: SliderTheme.of(context).copyWith(
                  trackHeight: 0,
                  activeTrackColor: Colors.transparent,
                  inactiveTrackColor: Colors.transparent,
                  thumbShape: const RoundSliderThumbShape(enabledThumbRadius: 8),
                  overlayShape: const RoundSliderOverlayShape(overlayRadius: 14),
                  thumbColor: Colors.white,
                  overlayColor: Colors.white24,
                ),
                child: Slider(
                  value: value.clamp(0, 360),
                  min: 0,
                  max: 360,
                  onChanged: onChanged,
                ),
              ),
            ),
          ),
          SizedBox(
            width: 48,
            child: Text(
              '${value.round()}\u00B0',
              textAlign: TextAlign.right,
              style: const TextStyle(
                fontSize: 12,
                fontFamily: 'monospace',
                color: Color(0xFF444444),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Tap feedback indicator
// ---------------------------------------------------------------------------

class _TapFeedback extends StatelessWidget {
  final String message;

  const _TapFeedback({required this.message});

  @override
  Widget build(BuildContext context) {
    if (message.isEmpty) return const SizedBox.shrink();
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: AnimatedSwitcher(
        duration: const Duration(milliseconds: 200),
        child: Container(
          key: ValueKey(message),
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 8),
          decoration: BoxDecoration(
            color: message.contains('LEFT')
                ? const Color(0xFFEEF0FF)
                : const Color(0xFFFFF0F5),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(
              color: message.contains('LEFT')
                  ? const Color(0xFFCCCCEE)
                  : const Color(0xFFEECCDD),
            ),
          ),
          child: Text(
            message,
            style: const TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              letterSpacing: 1,
              color: Color(0xFF444444),
            ),
          ),
        ),
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Label text control
// ---------------------------------------------------------------------------

class _ToggleControl extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;

  const _ToggleControl({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          SizedBox(
            width: 110,
            child: Text(
              label,
              style: const TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Switch(
            value: value,
            onChanged: onChanged,
            activeThumbColor: const Color(0xFF6366F1),
          ),
          Text(
            value ? 'ON' : 'OFF',
            style: TextStyle(
              fontSize: 12,
              fontFamily: 'monospace',
              color: value ? const Color(0xFF6366F1) : const Color(0xFF999999),
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------------------------------
// Label text control
// ---------------------------------------------------------------------------

class _LabelControl extends StatelessWidget {
  final String value;
  final ValueChanged<String> onChanged;

  const _LabelControl({
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 8),
      child: Row(
        children: [
          const SizedBox(
            width: 110,
            child: Text(
              'Label Text',
              style: TextStyle(
                fontSize: 12,
                color: Color(0xFF666666),
              ),
            ),
          ),
          Expanded(
            child: SizedBox(
              height: 32,
              child: TextField(
                controller: TextEditingController(text: value),
                onChanged: onChanged,
                style: const TextStyle(
                  fontSize: 12,
                  fontFamily: 'monospace',
                ),
                decoration: InputDecoration(
                  contentPadding:
                      const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                  isDense: true,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E8)),
                  ),
                  enabledBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFFE0E0E8)),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6),
                    borderSide: const BorderSide(color: Color(0xFF6366F1)),
                  ),
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
