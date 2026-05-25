// CurrenSee — Logo (wordmark + mark)
// Mark concept: stacked C's forming an eye/lens with a horizontal bar
// (the "see" + currency reference). Gold on dark.

function CSMark({ size = 32, color = 'var(--gold)', bg = 'transparent' }) {
  return (
    <svg width={size} height={size} viewBox="0 0 40 40" fill="none" xmlns="http://www.w3.org/2000/svg" style={{ display: 'block' }}>
      {bg !== 'transparent' && <circle cx="20" cy="20" r="20" fill={bg} />}
      {/* Outer arc — left-opening C */}
      <path d="M30 11.5C27.5 8.5 24 7 20 7C12.8 7 7 12.8 7 20C7 27.2 12.8 33 20 33C24 33 27.5 31.5 30 28.5"
        stroke={color} strokeWidth="2.2" strokeLinecap="round" fill="none" />
      {/* Inner shorter arc — the "see" pupil/lens hint */}
      <path d="M26 16C24.8 14.7 22.5 14 20.5 14C17 14 14 16.7 14 20C14 23.3 17 26 20.5 26C22.5 26 24.8 25.3 26 24"
        stroke={color} strokeWidth="1.6" strokeLinecap="round" fill="none" opacity="0.55" />
      {/* Center horizontal — currency line / horizon */}
      <line x1="22" y1="20" x2="34" y2="20" stroke={color} strokeWidth="2.2" strokeLinecap="round" />
      {/* Dot terminator — gold bead */}
      <circle cx="34" cy="20" r="1.6" fill={color} />
    </svg>
  );
}

function CSWordmark({ size = 24, color = 'var(--ink)', goldColor = 'var(--gold)' }) {
  // "Curren" + italic "See" + dot
  return (
    <div style={{
      display: 'inline-flex',
      alignItems: 'baseline',
      fontFamily: 'var(--f-display)',
      fontSize: size,
      lineHeight: 1,
      letterSpacing: '-0.04em',
      color,
      fontWeight: 900,
    }}>
      <span>Curren</span>
      <span style={{ fontStyle: 'italic', color: goldColor, fontWeight: 900 }}>See</span>
      <span style={{ color: goldColor, marginLeft: 1 }}>.</span>
    </div>
  );
}

function CSLogo({ size = 28, gap = 10, color = 'var(--ink)', goldColor = 'var(--gold)' }) {
  return (
    <div style={{ display: 'inline-flex', alignItems: 'center', gap }}>
      <CSMark size={size * 1.2} color={goldColor} />
      <CSWordmark size={size} color={color} goldColor={goldColor} />
    </div>
  );
}

Object.assign(window, { CSMark, CSWordmark, CSLogo });
