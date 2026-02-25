import 'package:flutter/material.dart';
import 'package:morphing_button/morphing_button.dart';

class PlaygroundPage extends StatefulWidget {
  const PlaygroundPage({super.key});

  @override
  State<PlaygroundPage> createState() => _PlaygroundPageState();
}

class _PlaygroundPageState extends State<PlaygroundPage> {
  // -- Global controls --
  double _arrowSize = 8;
  double _arrowStroke = 2.5;

  // -- V1: Glass Pill --
  String _v1Label = 'EXPLORE';
  double _v1FontSize = 13;
  double _v1LetterSpacing = 2.5;
  double _v1HPad = 52;
  double _v1VPad = 16;

  // -- V2: Outline Fill --
  String _v2Label = 'NAVIGATE';
  double _v2FontSize = 13;
  double _v2LetterSpacing = 2;
  double _v2HPad = 48;
  double _v2VPad = 16;
  double _v2BorderRadius = 0;
  double _v2BorderWidth = 2;
  double _v2FillOpacity = 0.92;

  // -- V3: Soft Shadow --
  String _v3Label = 'DISCOVER';
  double _v3FontSize = 14;
  double _v3LetterSpacing = 1.5;
  double _v3HPad = 52;
  double _v3VPad = 18;
  double _v3ShadowBlur = 28;
  double _v3Elevation = 2;

  // -- V4: Underline --
  String _v4Label = 'CONTINUE';
  double _v4FontSize = 13;
  double _v4LetterSpacing = 3;
  double _v4HPad = 40;
  double _v4VPad = 14;
  double _v4UnderlineHeight = 1.5;

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
                  arrowSize: _arrowSize + 2, // glass uses slightly larger
                  arrowStrokeWidth: _arrowStroke,
                ),
                controls: [
                  _LabelControl(
                    value: _v1Label,
                    onChanged: (v) => setState(() => _v1Label = v),
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
                  borderRadius: _v2BorderRadius,
                  borderWidth: _v2BorderWidth,
                  fillOpacity: _v2FillOpacity,
                ),
                controls: [
                  _LabelControl(
                    value: _v2Label,
                    onChanged: (v) => setState(() => _v2Label = v),
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
                  shadowBlur: _v3ShadowBlur,
                  elevation: _v3Elevation,
                ),
                controls: [
                  _LabelControl(
                    value: _v3Label,
                    onChanged: (v) => setState(() => _v3Label = v),
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
                  underlineHeight: _v4UnderlineHeight,
                ),
                controls: [
                  _LabelControl(
                    value: _v4Label,
                    onChanged: (v) => setState(() => _v4Label = v),
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
