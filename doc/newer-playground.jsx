import { useState, useRef, useCallback, useEffect } from "react";

function lerp(a, b, t) {
  return a + (b - a) * t;
}

/* Soft ease-out curve for smoother decay */
function easeOut(t) {
  return 1 - Math.pow(1 - t, 3);
}

function useHoverTracker(ref) {
  const [ratio, setRatio] = useState(0.5);
  const [hovering, setHovering] = useState(false);

  /* All animated values live in refs, driven by a single rAF loop */
  const animR = useRef(0.5);
  const animP = useRef(0);
  const animLeft = useRef(0);
  const animRight = useRef(0);
  const [, tick] = useState(0);

  const onMove = useCallback((e) => {
    if (!ref.current) return;
    const rect = ref.current.getBoundingClientRect();
    setRatio(Math.max(0, Math.min(1, (e.clientX - rect.left) / rect.width)));
  }, [ref]);

  useEffect(() => {
    let id;
    const loop = () => {
      const tR = hovering ? ratio : 0.5;
      const tP = hovering ? 1 : 0;

      /* Slower lerp factors for buttery smooth motion */
      animR.current = lerp(animR.current, tR, 0.055);
      animP.current = lerp(animP.current, tP, 0.045);

      /* Compute target strengths from smoothed ratio */
      const dir = dirFromRatio(animR.current);
      const targetLeft = Math.max(0, Math.min(1, (0.5 - dir) * 2.5)) * animP.current;
      const targetRight = Math.max(0, Math.min(1, (dir - 0.5) * 2.5)) * animP.current;

      /* Extra-smooth lerp on the strength values themselves */
      animLeft.current = lerp(animLeft.current, targetLeft, 0.06);
      animRight.current = lerp(animRight.current, targetRight, 0.06);

      tick((v) => v + 1);
      id = requestAnimationFrame(loop);
    };
    id = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(id);
  }, [ratio, hovering]);

  return {
    ratio: animR.current,
    presence: animP.current,
    leftStrength: animLeft.current,
    rightStrength: animRight.current,
    hovering,
    onMove,
    onEnter: () => setHovering(true),
    onLeave: () => setHovering(false),
  };
}

function dirFromRatio(r) {
  if (r < 0.35) return 0;
  if (r > 0.65) return 1;
  return (r - 0.35) / 0.3;
}

/* Left-pointing arrow SVG with soft growth */
function LeftArrow({ progress, color = "#6366f1", size = 20 }) {
  const r = size / 2;
  const p = easeOut(Math.max(0, Math.min(1, progress)));
  return (
    <svg width={size} height={size} viewBox={`${-r} ${-r} ${size} ${size}`} style={{ display: "block" }}>
      <line x1={lerp(0, r * 0.8, p)} y1="0" x2={lerp(0, -r * 0.8, p)} y2="0" stroke={color} strokeWidth="2" strokeLinecap="round" />
      <line x1={lerp(0, -r * 0.45, p)} y1={lerp(0, -r * 0.4, p)} x2={lerp(0, -r * 0.8, p)} y2="0" stroke={color} strokeWidth="2" strokeLinecap="round" />
      <line x1={lerp(0, -r * 0.45, p)} y1={lerp(0, r * 0.4, p)} x2={lerp(0, -r * 0.8, p)} y2="0" stroke={color} strokeWidth="2" strokeLinecap="round" />
    </svg>
  );
}

/* Right-pointing arrow SVG with soft growth */
function RightArrow({ progress, color = "#6366f1", size = 20 }) {
  const r = size / 2;
  const p = easeOut(Math.max(0, Math.min(1, progress)));
  return (
    <svg width={size} height={size} viewBox={`${-r} ${-r} ${size} ${size}`} style={{ display: "block" }}>
      <line x1={lerp(0, -r * 0.8, p)} y1="0" x2={lerp(0, r * 0.8, p)} y2="0" stroke={color} strokeWidth="2" strokeLinecap="round" />
      <line x1={lerp(0, r * 0.45, p)} y1={lerp(0, -r * 0.4, p)} x2={lerp(0, r * 0.8, p)} y2="0" stroke={color} strokeWidth="2" strokeLinecap="round" />
      <line x1={lerp(0, r * 0.45, p)} y1={lerp(0, r * 0.4, p)} x2={lerp(0, r * 0.8, p)} y2="0" stroke={color} strokeWidth="2" strokeLinecap="round" />
    </svg>
  );
}

const MAX_ARROW_W = 28;
const ARROW_SIZE = 20;
const GAP = 8;
const SLOT_MAX = MAX_ARROW_W + GAP;

/* ============================================================
   VARIANT 1: Glassmorphism Pill
   ============================================================ */
function GlassPill({ label = "EXPLORE" }) {
  const ref = useRef(null);
  const h = useHoverTracker(ref);

  return (
    <button
      ref={ref}
      onMouseMove={h.onMove}
      onMouseEnter={h.onEnter}
      onMouseLeave={h.onLeave}
      style={{
        position: "relative",
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "16px 48px",
        fontSize: "13px",
        fontFamily: "'DM Sans', sans-serif",
        fontWeight: 600,
        letterSpacing: "2.5px",
        textTransform: "uppercase",
        color: "#1a1a2e",
        background: "rgba(255,255,255,0.55)",
        backdropFilter: "blur(16px)",
        WebkitBackdropFilter: "blur(16px)",
        border: "1px solid rgba(0,0,0,0.08)",
        borderRadius: "60px",
        cursor: "pointer",
        overflow: "hidden",
        boxShadow: h.hovering
          ? "0 8px 32px rgba(0,0,0,0.08), inset 0 1px 0 rgba(255,255,255,0.8)"
          : "0 2px 12px rgba(0,0,0,0.04), inset 0 1px 0 rgba(255,255,255,0.6)",
        minWidth: "220px",
        outline: "none",
        transition: "box-shadow 0.5s ease",
      }}
    >
      <div style={{
        position: "absolute",
        top: "50%", left: `${h.ratio * 100}%`,
        width: "140px", height: "140px", borderRadius: "50%",
        background: "radial-gradient(circle, rgba(99,102,241,0.1), transparent 70%)",
        transform: "translate(-50%,-50%)", opacity: h.presence, pointerEvents: "none",
      }} />
      <div style={{ width: `${easeOut(h.leftStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-start", opacity: easeOut(h.leftStrength) }}>
        <LeftArrow progress={h.leftStrength} color="#6366f1" size={ARROW_SIZE} />
      </div>
      <span style={{ position: "relative", zIndex: 1, flexShrink: 0 }}>{label}</span>
      <div style={{ width: `${easeOut(h.rightStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-end", opacity: easeOut(h.rightStrength) }}>
        <RightArrow progress={h.rightStrength} color="#6366f1" size={ARROW_SIZE} />
      </div>
    </button>
  );
}

/* ============================================================
   VARIANT 2: Bordered Outline with Color Fill
   ============================================================ */
function OutlineFill({ label = "NAVIGATE" }) {
  const ref = useRef(null);
  const h = useHoverTracker(ref);
  const dir = dirFromRatio(h.ratio);
  const accent = dir > 0.5 ? `hsl(${lerp(160, 170, dir)}, 70%, 40%)` : `hsl(${lerp(250, 260, dir)}, 60%, 55%)`;
  const fillFrom = dir <= 0.5 ? "left" : "right";

  return (
    <button
      ref={ref}
      onMouseMove={h.onMove}
      onMouseEnter={h.onEnter}
      onMouseLeave={h.onLeave}
      style={{
        position: "relative",
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "16px 44px",
        fontSize: "13px",
        fontFamily: "'Space Mono', monospace",
        fontWeight: 700,
        letterSpacing: "2px",
        textTransform: "uppercase",
        color: h.presence > 0.5 ? "#fff" : "#222",
        background: "transparent",
        border: `2px solid ${accent}`,
        borderRadius: "4px",
        cursor: "pointer",
        overflow: "hidden",
        minWidth: "220px",
        outline: "none",
        transition: "color 0.5s ease",
      }}
    >
      <div style={{
        position: "absolute", inset: 0,
        background: accent,
        transformOrigin: fillFrom === "left" ? "left center" : "right center",
        transform: `scaleX(${h.presence})`,
        opacity: h.presence * 0.92,
        transition: "transform-origin 0.6s ease",
      }} />
      <div style={{ width: `${easeOut(h.leftStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-start", opacity: easeOut(h.leftStrength), position: "relative", zIndex: 1 }}>
        <LeftArrow progress={h.leftStrength} color="#fff" size={ARROW_SIZE} />
      </div>
      <span style={{ position: "relative", zIndex: 1, flexShrink: 0 }}>{label}</span>
      <div style={{ width: `${easeOut(h.rightStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-end", opacity: easeOut(h.rightStrength), position: "relative", zIndex: 1 }}>
        <RightArrow progress={h.rightStrength} color="#fff" size={ARROW_SIZE} />
      </div>
    </button>
  );
}

/* ============================================================
   VARIANT 3: Soft Shadow Rounded
   ============================================================ */
function SoftShadow({ label = "DISCOVER" }) {
  const ref = useRef(null);
  const h = useHoverTracker(ref);
  const shadowX = lerp(-8, 8, h.ratio) * h.presence;
  const hue = lerp(20, 350, h.ratio);

  return (
    <button
      ref={ref}
      onMouseMove={h.onMove}
      onMouseEnter={h.onEnter}
      onMouseLeave={h.onLeave}
      style={{
        position: "relative",
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "18px 48px",
        fontSize: "14px",
        fontFamily: "'DM Sans', sans-serif",
        fontWeight: 500,
        letterSpacing: "1.5px",
        color: "#333",
        background: "#fff",
        border: "none",
        borderRadius: "16px",
        cursor: "pointer",
        overflow: "hidden",
        minWidth: "220px",
        outline: "none",
        boxShadow: h.hovering
          ? `${shadowX}px 6px 28px hsla(${hue},60%,60%,0.25), 0 1px 4px rgba(0,0,0,0.06)`
          : "0 2px 12px rgba(0,0,0,0.06), 0 1px 3px rgba(0,0,0,0.04)",
        transform: `translateY(${h.hovering ? -2 : 0}px)`,
        transition: "transform 0.5s ease, box-shadow 0.5s ease",
      }}
    >
      <div style={{
        position: "absolute",
        bottom: 0, left: 0, right: 0, height: "3px",
        background: `linear-gradient(90deg, hsl(${hue},70%,65%), hsl(${hue + 40},70%,65%))`,
        opacity: h.presence, transform: `scaleX(${0.3 + h.presence * 0.7})`,
        borderRadius: "0 0 16px 16px",
      }} />
      <div style={{ width: `${easeOut(h.leftStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-start", opacity: easeOut(h.leftStrength) }}>
        <LeftArrow progress={h.leftStrength} color={`hsl(${hue},55%,50%)`} size={ARROW_SIZE} />
      </div>
      <span style={{ position: "relative", zIndex: 1, flexShrink: 0 }}>{label}</span>
      <div style={{ width: `${easeOut(h.rightStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-end", opacity: easeOut(h.rightStrength) }}>
        <RightArrow progress={h.rightStrength} color={`hsl(${hue},55%,50%)`} size={ARROW_SIZE} />
      </div>
    </button>
  );
}

/* ============================================================
   VARIANT 4: Underline Minimal
   ============================================================ */
function UnderlineMinimal({ label = "CONTINUE" }) {
  const ref = useRef(null);
  const h = useHoverTracker(ref);
  const dir = dirFromRatio(h.ratio);
  const lineOrigin = dir <= 0.5 ? "right" : "left";

  return (
    <button
      ref={ref}
      onMouseMove={h.onMove}
      onMouseEnter={h.onEnter}
      onMouseLeave={h.onLeave}
      style={{
        position: "relative",
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "14px 36px",
        fontSize: "13px",
        fontFamily: "'Crimson Pro', Georgia, serif",
        fontWeight: 600,
        letterSpacing: "3px",
        textTransform: "uppercase",
        color: "#1a1a1a",
        background: "transparent",
        border: "none",
        cursor: "pointer",
        overflow: "hidden",
        minWidth: "200px",
        outline: "none",
      }}
    >
      <div style={{
        position: "absolute",
        bottom: "4px", left: "12px", right: "12px", height: "1.5px",
        background: "#1a1a1a",
        transformOrigin: `${lineOrigin} center`,
        transform: `scaleX(${h.presence})`,
        transition: "transform-origin 0.4s ease",
      }} />
      <div style={{ width: `${easeOut(h.leftStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-start", opacity: easeOut(h.leftStrength) }}>
        <LeftArrow progress={h.leftStrength} color="#1a1a1a" size={18} />
      </div>
      <span style={{ position: "relative", zIndex: 1, flexShrink: 0 }}>{label}</span>
      <div style={{ width: `${easeOut(h.rightStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-end", opacity: easeOut(h.rightStrength) }}>
        <RightArrow progress={h.rightStrength} color="#1a1a1a" size={18} />
      </div>
    </button>
  );
}

/* ============================================================
   VARIANT 5: Chunky 3D Press
   ============================================================ */
function Chunky3D({ label = "GO NEXT" }) {
  const ref = useRef(null);
  const h = useHoverTracker(ref);
  const offsetY = h.hovering ? 2 : 0;

  return (
    <button
      ref={ref}
      onMouseMove={h.onMove}
      onMouseEnter={h.onEnter}
      onMouseLeave={h.onLeave}
      style={{
        position: "relative",
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "16px 44px",
        fontSize: "14px",
        fontFamily: "'DM Sans', sans-serif",
        fontWeight: 800,
        letterSpacing: "1.5px",
        textTransform: "uppercase",
        color: "#fff",
        background: "linear-gradient(180deg, #4f46e5, #3730a3)",
        border: "none",
        borderRadius: "12px",
        cursor: "pointer",
        overflow: "hidden",
        minWidth: "220px",
        outline: "none",
        boxShadow: h.hovering
          ? "0 2px 0 #1e1b4b, 0 4px 12px rgba(79,70,229,0.3)"
          : "0 4px 0 #1e1b4b, 0 6px 16px rgba(79,70,229,0.2)",
        transform: `translateY(${offsetY}px)`,
        transition: "transform 0.25s ease, box-shadow 0.25s ease",
      }}
    >
      <div style={{ width: `${easeOut(h.leftStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-start", opacity: easeOut(h.leftStrength), position: "relative", zIndex: 1 }}>
        <LeftArrow progress={h.leftStrength} color="#fff" size={ARROW_SIZE} />
      </div>
      <span style={{ position: "relative", zIndex: 1, flexShrink: 0 }}>{label}</span>
      <div style={{ width: `${easeOut(h.rightStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-end", opacity: easeOut(h.rightStrength), position: "relative", zIndex: 1 }}>
        <RightArrow progress={h.rightStrength} color="#fff" size={ARROW_SIZE} />
      </div>
    </button>
  );
}

/* ============================================================
   VARIANT 6: Gradient Blob
   ============================================================ */
function GradientBlob({ label = "SWIPE" }) {
  const ref = useRef(null);
  const h = useHoverTracker(ref);
  const blobX = h.ratio * 100;
  const hue1 = lerp(280, 340, h.ratio);
  const hue2 = lerp(200, 260, h.ratio);

  return (
    <button
      ref={ref}
      onMouseMove={h.onMove}
      onMouseEnter={h.onEnter}
      onMouseLeave={h.onLeave}
      style={{
        position: "relative",
        display: "inline-flex",
        alignItems: "center",
        justifyContent: "center",
        padding: "18px 48px",
        fontSize: "13px",
        fontFamily: "'DM Sans', sans-serif",
        fontWeight: 600,
        letterSpacing: "2.5px",
        textTransform: "uppercase",
        color: h.presence > 0.4 ? "#fff" : "#444",
        background: "#f8f8fa",
        border: "1px solid #e8e8ee",
        borderRadius: "50px",
        cursor: "pointer",
        overflow: "hidden",
        minWidth: "220px",
        outline: "none",
        transition: "color 0.5s ease",
      }}
    >
      <div style={{
        position: "absolute",
        top: "50%", left: `${blobX}%`,
        width: `${140 + h.presence * 160}px`,
        height: `${140 + h.presence * 60}px`,
        borderRadius: "50%",
        background: `linear-gradient(135deg, hsl(${hue1},70%,60%), hsl(${hue2},70%,55%))`,
        transform: "translate(-50%,-50%)",
        opacity: h.presence * 0.9,
        filter: "blur(2px)",
        pointerEvents: "none",
      }} />
      <div style={{ width: `${easeOut(h.leftStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-start", opacity: easeOut(h.leftStrength), position: "relative", zIndex: 1 }}>
        <LeftArrow progress={h.leftStrength} color="#fff" size={ARROW_SIZE} />
      </div>
      <span style={{ position: "relative", zIndex: 1, flexShrink: 0 }}>{label}</span>
      <div style={{ width: `${easeOut(h.rightStrength) * SLOT_MAX}px`, overflow: "hidden", flexShrink: 0, display: "flex", alignItems: "center", justifyContent: "flex-end", opacity: easeOut(h.rightStrength), position: "relative", zIndex: 1 }}>
        <RightArrow progress={h.rightStrength} color="#fff" size={ARROW_SIZE} />
      </div>
    </button>
  );
}

/* ============================================================
   SECTION WRAPPER
   ============================================================ */
function Section({ title, description, children, index }) {
  return (
    <div style={{
      display: "flex",
      flexDirection: "column",
      alignItems: "center",
      gap: "24px",
      padding: "48px 32px",
      borderBottom: "1px solid #eeeef2",
      animation: `fadeUp 0.6s ${index * 0.08}s both`,
    }}>
      <div style={{ textAlign: "center" }}>
        <span style={{
          fontSize: "10px",
          fontFamily: "'Space Mono', monospace",
          letterSpacing: "3px",
          color: "#aaa",
          textTransform: "uppercase",
        }}>
          Variant {index + 1}
        </span>
        <h3 style={{
          fontSize: "20px",
          fontWeight: 500,
          color: "#1a1a2e",
          margin: "6px 0 0",
          fontFamily: "'DM Sans', sans-serif",
          letterSpacing: "-0.3px",
        }}>
          {title}
        </h3>
        <p style={{
          fontSize: "13px",
          color: "#888",
          margin: "6px 0 0",
          maxWidth: "400px",
          lineHeight: 1.5,
        }}>
          {description}
        </p>
      </div>
      {children}
    </div>
  );
}

/* ============================================================
   MAIN PLAYGROUND
   ============================================================ */
export default function Playground() {
  return (
    <div style={{
      minHeight: "100vh",
      background: "linear-gradient(180deg, #fafafe 0%, #f2f2f8 100%)",
      fontFamily: "'DM Sans', sans-serif",
    }}>
      <style>{`
        @import url('https://fonts.googleapis.com/css2?family=DM+Sans:wght@300;400;500;600;700;800&family=Space+Mono:wght@400;700&family=Crimson+Pro:wght@400;500;600;700&display=swap');
        @keyframes fadeUp {
          from { opacity: 0; transform: translateY(20px); }
          to { opacity: 1; transform: translateY(0); }
        }
        * { box-sizing: border-box; margin: 0; }
      `}</style>

      <header style={{
        textAlign: "center",
        padding: "64px 24px 48px",
        borderBottom: "1px solid #eeeef2",
      }}>
        <div style={{
          display: "inline-block",
          padding: "4px 14px",
          background: "#eef",
          borderRadius: "20px",
          fontSize: "11px",
          fontFamily: "'Space Mono', monospace",
          letterSpacing: "2px",
          color: "#6366f1",
          textTransform: "uppercase",
          marginBottom: "20px",
        }}>
          Interactive Playground
        </div>
        <h1 style={{
          fontSize: "clamp(32px, 5vw, 52px)",
          fontWeight: 300,
          color: "#111",
          letterSpacing: "-1px",
          lineHeight: 1.15,
        }}>
          Morphing Buttons
        </h1>
        <p style={{
          fontSize: "15px",
          color: "#888",
          marginTop: "14px",
          maxWidth: "480px",
          marginInline: "auto",
          lineHeight: 1.6,
        }}>
          Hover slowly across each button. Arrows glide in with soft, spring-like easing — no harsh snaps.
        </p>

        <div style={{
          display: "flex",
          justifyContent: "center",
          marginTop: "28px",
          width: "min(320px, 80vw)",
          marginInline: "auto",
          height: "32px",
          borderRadius: "16px",
          overflow: "hidden",
          border: "1px solid #ddd",
        }}>
          {[
            { label: "← LEFT", bg: "#eef0ff", w: "35%" },
            { label: "CENTER", bg: "#f5f5f8", w: "30%" },
            { label: "RIGHT →", bg: "#fff0f5", w: "35%" },
          ].map((z, i) => (
            <div key={i} style={{
              flex: `0 0 ${z.w}`, background: z.bg,
              display: "flex", alignItems: "center", justifyContent: "center",
              fontSize: "9px", letterSpacing: "1.5px", color: "#999",
              fontFamily: "'Space Mono', monospace",
              borderRight: i < 2 ? "1px solid #e0e0e8" : "none",
            }}>{z.label}</div>
          ))}
        </div>
      </header>

      <Section index={0} title="Glassmorphism Pill" description="Frosted glass with indigo glow tracking. Arrow glides beside the label.">
        <GlassPill label="EXPLORE" />
      </Section>

      <Section index={1} title="Outline Fill Wipe" description="Border-only at rest. Color floods in softly from the arrow's direction.">
        <OutlineFill label="NAVIGATE" />
      </Section>

      <Section index={2} title="Soft Shadow Float" description="White card that lifts on hover. Colored shadow drifts with the cursor.">
        <SoftShadow label="DISCOVER" />
      </Section>

      <Section index={3} title="Underline Editorial" description="Typography-first with a sweeping underline. Minimal and elegant.">
        <UnderlineMinimal label="CONTINUE" />
      </Section>

      <Section index={4} title="Chunky 3D Press" description="Retro game-style with a thick bottom shadow. Presses down on hover.">
        <Chunky3D label="GO NEXT" />
      </Section>

      <Section index={5} title="Gradient Blob" description="A colorful blob follows the cursor, shifting hue as it travels.">
        <GradientBlob label="SWIPE" />
      </Section>

      <footer style={{
        textAlign: "center",
        padding: "40px 24px",
        fontSize: "11px",
        color: "#bbb",
        letterSpacing: "1.5px",
        fontFamily: "'Space Mono', monospace",
      }}>
        HOVER ACROSS EACH BUTTON TO SEE THE MORPHING EFFECT
      </footer>
    </div>
  );
}
