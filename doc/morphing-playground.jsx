import { useState, useRef, useCallback, useEffect } from "react";

function lerp(a, b, t) {
  return a + (b - a) * t;
}

function useHoverTracker(ref) {
  const [ratio, setRatio] = useState(0.5);
  const [hovering, setHovering] = useState(false);
  const animR = useRef(0.5);
  const animP = useRef(0);
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
      animR.current = lerp(animR.current, tR, 0.11);
      animP.current = lerp(animP.current, tP, 0.09);
      tick((v) => v + 1);
      id = requestAnimationFrame(loop);
    };
    id = requestAnimationFrame(loop);
    return () => cancelAnimationFrame(id);
  }, [ratio, hovering]);

  return {
    ratio: animR.current,
    presence: animP.current,
    rawRatio: ratio,
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

/* ============================================================
   VARIANT 1: Glassmorphism Pill
   ============================================================ */
function GlassPill({ label = "EXPLORE" }) {
  const ref = useRef(null);
  const h = useHoverTracker(ref);
  const dir = dirFromRatio(h.ratio);
  const arrowX = lerp(-40, 40, h.ratio) * h.presence;
  const textX = lerp(10, -10, h.ratio) * h.presence;
  const arrowOpacity = h.presence * (dir < 0.25 || dir > 0.75 ? 1 : 0.15);

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
        padding: "16px 52px",
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
        transform: `scaleX(${1 + 0.025 * h.presence})`,
        boxShadow: h.hovering
          ? "0 8px 32px rgba(0,0,0,0.08), inset 0 1px 0 rgba(255,255,255,0.8)"
          : "0 2px 12px rgba(0,0,0,0.04), inset 0 1px 0 rgba(255,255,255,0.6)",
        minWidth: "220px",
        outline: "none",
        transition: "box-shadow 0.3s",
      }}
    >
      <div style={{
        position: "absolute",
        top: "50%", left: `${h.ratio * 100}%`,
        width: "100px", height: "100px", borderRadius: "50%",
        background: "radial-gradient(circle, rgba(99,102,241,0.1), transparent 70%)",
        transform: "translate(-50%,-50%)", opacity: h.presence, pointerEvents: "none",
      }} />
      <svg width="28" height="28" viewBox="-14 -14 28 28" style={{
        position: "absolute",
        left: `calc(50% + ${arrowX}px)`, top: "50%",
        transform: "translate(-50%,-50%)",
        opacity: arrowOpacity, pointerEvents: "none",
      }}>
        {dir <= 0.5 ? (
          <>
            <line x1={lerp(10, 0, dir * 2)} y1="0" x2={lerp(-10, 0, dir * 2)} y2="0" stroke="#6366f1" strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(-6, 0, dir * 2)} y1="-5" x2={lerp(-10, 0, dir * 2)} y2="0" stroke="#6366f1" strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(-6, 0, dir * 2)} y1="5" x2={lerp(-10, 0, dir * 2)} y2="0" stroke="#6366f1" strokeWidth="2" strokeLinecap="round" />
          </>
        ) : (
          <>
            <line x1={lerp(0, -10, (dir - 0.5) * 2)} y1="0" x2={lerp(0, 10, (dir - 0.5) * 2)} y2="0" stroke="#6366f1" strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(0, 6, (dir - 0.5) * 2)} y1="-5" x2={lerp(0, 10, (dir - 0.5) * 2)} y2="0" stroke="#6366f1" strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(0, 6, (dir - 0.5) * 2)} y1="5" x2={lerp(0, 10, (dir - 0.5) * 2)} y2="0" stroke="#6366f1" strokeWidth="2" strokeLinecap="round" />
          </>
        )}
      </svg>
      <span style={{ position: "relative", zIndex: 1, transform: `translateX(${textX}px)` }}>{label}</span>
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
  const fillPct = h.hovering ? (dir < 0.3 ? h.ratio * 100 : dir > 0.7 ? h.ratio * 100 : 50) : 50;
  const arrowX = lerp(-36, 36, h.ratio) * h.presence;
  const textX = lerp(8, -8, h.ratio) * h.presence;
  const arrowVis = h.presence * (dir < 0.25 || dir > 0.75 ? 1 : 0.1);
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
        padding: "16px 48px",
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
        transition: "color 0.3s",
      }}
    >
      <div style={{
        position: "absolute", inset: 0,
        background: accent,
        transformOrigin: fillFrom === "left" ? "left center" : "right center",
        transform: `scaleX(${h.presence * 1})`,
        opacity: h.presence * 0.92,
        transition: "transform-origin 0.3s",
      }} />
      <svg width="24" height="24" viewBox="-12 -12 24 24" style={{
        position: "absolute",
        left: `calc(50% + ${arrowX}px)`, top: "50%",
        transform: "translate(-50%,-50%)",
        opacity: arrowVis, pointerEvents: "none",
      }}>
        {dir <= 0.5 ? (
          <>
            <line x1={lerp(8, 0, dir * 2)} y1="0" x2={lerp(-8, 0, dir * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
            <line x1={lerp(-5, 0, dir * 2)} y1="-4" x2={lerp(-8, 0, dir * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
            <line x1={lerp(-5, 0, dir * 2)} y1="4" x2={lerp(-8, 0, dir * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
          </>
        ) : (
          <>
            <line x1={lerp(0, -8, (dir - 0.5) * 2)} y1="0" x2={lerp(0, 8, (dir - 0.5) * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
            <line x1={lerp(0, 5, (dir - 0.5) * 2)} y1="-4" x2={lerp(0, 8, (dir - 0.5) * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
            <line x1={lerp(0, 5, (dir - 0.5) * 2)} y1="4" x2={lerp(0, 8, (dir - 0.5) * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
          </>
        )}
      </svg>
      <span style={{ position: "relative", zIndex: 1, transform: `translateX(${textX}px)` }}>{label}</span>
    </button>
  );
}

/* ============================================================
   VARIANT 3: Soft Shadow Rounded
   ============================================================ */
function SoftShadow({ label = "DISCOVER" }) {
  const ref = useRef(null);
  const h = useHoverTracker(ref);
  const dir = dirFromRatio(h.ratio);
  const arrowX = lerp(-44, 44, h.ratio) * h.presence;
  const textX = lerp(12, -12, h.ratio) * h.presence;
  const arrowVis = h.presence * (dir < 0.25 || dir > 0.75 ? 1 : 0.1);
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
        padding: "18px 52px",
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
        transition: "transform 0.3s, box-shadow 0.3s",
      }}
    >
      <div style={{
        position: "absolute",
        bottom: 0, left: 0, right: 0, height: "3px",
        background: `linear-gradient(90deg, hsl(${hue},70%,65%), hsl(${hue + 40},70%,65%))`,
        opacity: h.presence, transform: `scaleX(${0.3 + h.presence * 0.7})`,
        borderRadius: "0 0 16px 16px",
      }} />
      <svg width="26" height="26" viewBox="-13 -13 26 26" style={{
        position: "absolute",
        left: `calc(50% + ${arrowX}px)`, top: "50%",
        transform: "translate(-50%,-50%)",
        opacity: arrowVis, pointerEvents: "none",
      }}>
        {dir <= 0.5 ? (
          <>
            <line x1={lerp(9, 0, dir * 2)} y1="0" x2={lerp(-9, 0, dir * 2)} y2="0" stroke={`hsl(${hue},55%,50%)`} strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(-5, 0, dir * 2)} y1="-5" x2={lerp(-9, 0, dir * 2)} y2="0" stroke={`hsl(${hue},55%,50%)`} strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(-5, 0, dir * 2)} y1="5" x2={lerp(-9, 0, dir * 2)} y2="0" stroke={`hsl(${hue},55%,50%)`} strokeWidth="2" strokeLinecap="round" />
          </>
        ) : (
          <>
            <line x1={lerp(0, -9, (dir - 0.5) * 2)} y1="0" x2={lerp(0, 9, (dir - 0.5) * 2)} y2="0" stroke={`hsl(${hue},55%,50%)`} strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(0, 5, (dir - 0.5) * 2)} y1="-5" x2={lerp(0, 9, (dir - 0.5) * 2)} y2="0" stroke={`hsl(${hue},55%,50%)`} strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(0, 5, (dir - 0.5) * 2)} y1="5" x2={lerp(0, 9, (dir - 0.5) * 2)} y2="0" stroke={`hsl(${hue},55%,50%)`} strokeWidth="2" strokeLinecap="round" />
          </>
        )}
      </svg>
      <span style={{ position: "relative", zIndex: 1, transform: `translateX(${textX}px)` }}>{label}</span>
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
  const arrowX = lerp(-32, 32, h.ratio) * h.presence;
  const textX = lerp(8, -8, h.ratio) * h.presence;
  const arrowVis = h.presence * (dir < 0.25 || dir > 0.75 ? 1 : 0.08);
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
        padding: "14px 40px",
        fontSize: "13px",
        fontFamily: "'Crimson Pro', Georgia, serif",
        fontWeight: 600,
        letterSpacing: "3px",
        textTransform: "uppercase",
        color: "#1a1a1a",
        background: "transparent",
        border: "none",
        borderRadius: "0",
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
        transition: "transform-origin 0.2s",
      }} />
      <svg width="22" height="22" viewBox="-11 -11 22 22" style={{
        position: "absolute",
        left: `calc(50% + ${arrowX}px)`, top: "48%",
        transform: "translate(-50%,-50%)",
        opacity: arrowVis, pointerEvents: "none",
      }}>
        {dir <= 0.5 ? (
          <>
            <line x1={lerp(7, 0, dir * 2)} y1="0" x2={lerp(-7, 0, dir * 2)} y2="0" stroke="#1a1a1a" strokeWidth="1.5" strokeLinecap="round" />
            <line x1={lerp(-4, 0, dir * 2)} y1="-4" x2={lerp(-7, 0, dir * 2)} y2="0" stroke="#1a1a1a" strokeWidth="1.5" strokeLinecap="round" />
            <line x1={lerp(-4, 0, dir * 2)} y1="4" x2={lerp(-7, 0, dir * 2)} y2="0" stroke="#1a1a1a" strokeWidth="1.5" strokeLinecap="round" />
          </>
        ) : (
          <>
            <line x1={lerp(0, -7, (dir - 0.5) * 2)} y1="0" x2={lerp(0, 7, (dir - 0.5) * 2)} y2="0" stroke="#1a1a1a" strokeWidth="1.5" strokeLinecap="round" />
            <line x1={lerp(0, 4, (dir - 0.5) * 2)} y1="-4" x2={lerp(0, 7, (dir - 0.5) * 2)} y2="0" stroke="#1a1a1a" strokeWidth="1.5" strokeLinecap="round" />
            <line x1={lerp(0, 4, (dir - 0.5) * 2)} y1="4" x2={lerp(0, 7, (dir - 0.5) * 2)} y2="0" stroke="#1a1a1a" strokeWidth="1.5" strokeLinecap="round" />
          </>
        )}
      </svg>
      <span style={{ position: "relative", zIndex: 1, transform: `translateX(${textX}px)` }}>{label}</span>
    </button>
  );
}

/* ============================================================
   VARIANT 5: Chunky 3D Press
   ============================================================ */
function Chunky3D({ label = "GO NEXT" }) {
  const ref = useRef(null);
  const h = useHoverTracker(ref);
  const dir = dirFromRatio(h.ratio);
  const arrowX = lerp(-38, 38, h.ratio) * h.presence;
  const textX = lerp(10, -10, h.ratio) * h.presence;
  const arrowVis = h.presence * (dir < 0.25 || dir > 0.75 ? 1 : 0.1);
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
        padding: "16px 48px",
        fontSize: "14px",
        fontFamily: "'DM Sans', sans-serif",
        fontWeight: 800,
        letterSpacing: "1.5px",
        textTransform: "uppercase",
        color: "#fff",
        background: `linear-gradient(180deg, #4f46e5, #3730a3)`,
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
        transition: "transform 0.15s, box-shadow 0.15s",
      }}
    >
      <svg width="26" height="26" viewBox="-13 -13 26 26" style={{
        position: "absolute",
        left: `calc(50% + ${arrowX}px)`, top: "50%",
        transform: "translate(-50%,-50%)",
        opacity: arrowVis, pointerEvents: "none",
        filter: "drop-shadow(0 1px 2px rgba(0,0,0,0.3))",
      }}>
        {dir <= 0.5 ? (
          <>
            <line x1={lerp(9, 0, dir * 2)} y1="0" x2={lerp(-9, 0, dir * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
            <line x1={lerp(-5, 0, dir * 2)} y1="-5" x2={lerp(-9, 0, dir * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
            <line x1={lerp(-5, 0, dir * 2)} y1="5" x2={lerp(-9, 0, dir * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
          </>
        ) : (
          <>
            <line x1={lerp(0, -9, (dir - 0.5) * 2)} y1="0" x2={lerp(0, 9, (dir - 0.5) * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
            <line x1={lerp(0, 5, (dir - 0.5) * 2)} y1="-5" x2={lerp(0, 9, (dir - 0.5) * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
            <line x1={lerp(0, 5, (dir - 0.5) * 2)} y1="5" x2={lerp(0, 9, (dir - 0.5) * 2)} y2="0" stroke="#fff" strokeWidth="2.5" strokeLinecap="round" />
          </>
        )}
      </svg>
      <span style={{ position: "relative", zIndex: 1, transform: `translateX(${textX}px)` }}>{label}</span>
    </button>
  );
}

/* ============================================================
   VARIANT 6: Gradient Blob
   ============================================================ */
function GradientBlob({ label = "SWIPE" }) {
  const ref = useRef(null);
  const h = useHoverTracker(ref);
  const dir = dirFromRatio(h.ratio);
  const arrowX = lerp(-40, 40, h.ratio) * h.presence;
  const textX = lerp(10, -10, h.ratio) * h.presence;
  const arrowVis = h.presence * (dir < 0.25 || dir > 0.75 ? 1 : 0.1);
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
        padding: "18px 52px",
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
        transition: "color 0.3s",
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
        transition: "width 0.4s, height 0.4s",
      }} />
      <svg width="26" height="26" viewBox="-13 -13 26 26" style={{
        position: "absolute",
        left: `calc(50% + ${arrowX}px)`, top: "50%",
        transform: "translate(-50%,-50%)",
        opacity: arrowVis, pointerEvents: "none",
      }}>
        {dir <= 0.5 ? (
          <>
            <line x1={lerp(9, 0, dir * 2)} y1="0" x2={lerp(-9, 0, dir * 2)} y2="0" stroke="#fff" strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(-5, 0, dir * 2)} y1="-5" x2={lerp(-9, 0, dir * 2)} y2="0" stroke="#fff" strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(-5, 0, dir * 2)} y1="5" x2={lerp(-9, 0, dir * 2)} y2="0" stroke="#fff" strokeWidth="2" strokeLinecap="round" />
          </>
        ) : (
          <>
            <line x1={lerp(0, -9, (dir - 0.5) * 2)} y1="0" x2={lerp(0, 9, (dir - 0.5) * 2)} y2="0" stroke="#fff" strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(0, 5, (dir - 0.5) * 2)} y1="-5" x2={lerp(0, 9, (dir - 0.5) * 2)} y2="0" stroke="#fff" strokeWidth="2" strokeLinecap="round" />
            <line x1={lerp(0, 5, (dir - 0.5) * 2)} y1="5" x2={lerp(0, 9, (dir - 0.5) * 2)} y2="0" stroke="#fff" strokeWidth="2" strokeLinecap="round" />
          </>
        )}
      </svg>
      <span style={{ position: "relative", zIndex: 1, transform: `translateX(${textX}px)` }}>{label}</span>
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

      {/* Header */}
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
          Hover across each button. The arrow morphs based on cursor position — left side shows ←, right side shows →, with smooth interpolation between states.
        </p>

        {/* Zone legend */}
        <div style={{
          display: "flex",
          justifyContent: "center",
          gap: "0",
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

      {/* Button Variants */}
      <Section index={0} title="Glassmorphism Pill" description="Frosted glass with indigo glow tracking — the classic modern look with depth.">
        <GlassPill label="EXPLORE" />
      </Section>

      <Section index={1} title="Outline Fill Wipe" description="Border-only at rest. On hover, color floods in from the arrow's direction with a full wipe.">
        <OutlineFill label="NAVIGATE" />
      </Section>

      <Section index={2} title="Soft Shadow Float" description="Clean white card that lifts on hover. A colored shadow shifts direction and hue with the cursor.">
        <SoftShadow label="DISCOVER" />
      </Section>

      <Section index={3} title="Underline Editorial" description="Typography-first, no-frills. A thin underline sweeps in from the arrow's direction. Minimal and elegant.">
        <UnderlineMinimal label="CONTINUE" />
      </Section>

      <Section index={4} title="Chunky 3D Press" description="Retro game-style with a thick bottom shadow. Presses down on hover for tactile feedback.">
        <Chunky3D label="GO NEXT" />
      </Section>

      <Section index={5} title="Gradient Blob" description="A colorful blob follows the cursor across the button surface, shifting hue as it travels.">
        <GradientBlob label="SWIPE" />
      </Section>

      {/* Footer */}
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
