// CurrenSee — Icons (line, 1.6 stroke, 22px box)

const I = ({ children, size = 22, color = 'currentColor', stroke = 1.6 }) => (
  <svg width={size} height={size} viewBox="0 0 24 24" fill="none"
    stroke={color} strokeWidth={stroke} strokeLinecap="round" strokeLinejoin="round"
    style={{ display: 'block', flexShrink: 0 }}>
    {children}
  </svg>
);

const Ico = {
  swap: (p) => <I {...p}><path d="M7 4v16"/><path d="M3 8l4-4 4 4"/><path d="M17 20V4"/><path d="M13 16l4 4 4-4"/></I>,
  search: (p) => <I {...p}><circle cx="11" cy="11" r="7"/><path d="M21 21l-4.3-4.3"/></I>,
  close: (p) => <I {...p}><path d="M6 6l12 12M18 6L6 18"/></I>,
  back: (p) => <I {...p}><path d="M15 18l-6-6 6-6"/></I>,
  forward: (p) => <I {...p}><path d="M9 6l6 6-6 6"/></I>,
  check: (p) => <I {...p}><path d="M5 12l5 5L20 7"/></I>,
  star: (p) => <I {...p}><path d="M12 3l2.7 5.5 6.1.9-4.4 4.3 1 6.1L12 17l-5.5 2.8 1-6.1L3 9.4l6.1-.9z"/></I>,
  bell: (p) => <I {...p}><path d="M6 8a6 6 0 0112 0c0 7 3 9 3 9H3s3-2 3-9"/><path d="M10 21a2 2 0 004 0"/></I>,
  plus: (p) => <I {...p}><path d="M12 5v14M5 12h14"/></I>,
  trash: (p) => <I {...p}><path d="M3 6h18M8 6V4a2 2 0 012-2h4a2 2 0 012 2v2M6 6l1 14a2 2 0 002 2h6a2 2 0 002-2l1-14"/></I>,
  history: (p) => <I {...p}><path d="M3 12a9 9 0 109-9 9 9 0 00-7.7 4.3"/><path d="M3 4v4h4"/><path d="M12 7v5l3 2"/></I>,
  home: (p) => <I {...p}><path d="M3 11l9-8 9 8"/><path d="M5 10v10h14V10"/></I>,
  settings: (p) => <I {...p}><circle cx="12" cy="12" r="3"/><path d="M19.4 15a1.6 1.6 0 00.3 1.8l.1.1a2 2 0 11-2.8 2.8l-.1-.1a1.6 1.6 0 00-1.8-.3 1.6 1.6 0 00-1 1.5V21a2 2 0 01-4 0v-.1a1.6 1.6 0 00-1-1.5 1.6 1.6 0 00-1.8.3l-.1.1a2 2 0 11-2.8-2.8l.1-.1a1.6 1.6 0 00.3-1.8 1.6 1.6 0 00-1.5-1H3a2 2 0 010-4h.1a1.6 1.6 0 001.5-1 1.6 1.6 0 00-.3-1.8l-.1-.1a2 2 0 112.8-2.8l.1.1a1.6 1.6 0 001.8.3h.1a1.6 1.6 0 001-1.5V3a2 2 0 014 0v.1a1.6 1.6 0 001 1.5 1.6 1.6 0 001.8-.3l.1-.1a2 2 0 112.8 2.8l-.1.1a1.6 1.6 0 00-.3 1.8v.1a1.6 1.6 0 001.5 1H21a2 2 0 010 4h-.1a1.6 1.6 0 00-1.5 1z"/></I>,
  user: (p) => <I {...p}><circle cx="12" cy="8" r="4"/><path d="M4 21a8 8 0 0116 0"/></I>,
  mail: (p) => <I {...p}><rect x="3" y="5" width="18" height="14" rx="2"/><path d="M3 7l9 6 9-6"/></I>,
  lock: (p) => <I {...p}><rect x="4" y="11" width="16" height="10" rx="2"/><path d="M8 11V8a4 4 0 018 0v3"/></I>,
  eye: (p) => <I {...p}><path d="M2 12s4-7 10-7 10 7 10 7-4 7-10 7S2 12 2 12z"/><circle cx="12" cy="12" r="3"/></I>,
  help: (p) => <I {...p}><circle cx="12" cy="12" r="9"/><path d="M9.5 9a2.5 2.5 0 015 0c0 2-2.5 2-2.5 4"/><path d="M12 17.5h.01"/></I>,
  send: (p) => <I {...p}><path d="M22 2L11 13"/><path d="M22 2l-7 20-4-9-9-4z"/></I>,
  chevronDown: (p) => <I {...p}><path d="M6 9l6 6 6-6"/></I>,
  chevronRight: (p) => <I {...p}><path d="M9 6l6 6-6 6"/></I>,
  arrowUp: (p) => <I {...p}><path d="M12 19V5M5 12l7-7 7 7"/></I>,
  arrowDown: (p) => <I {...p}><path d="M12 5v14M5 12l7 7 7-7"/></I>,
  trend: (p) => <I {...p}><path d="M3 17l6-6 4 4 8-8"/><path d="M14 7h7v7"/></I>,
  globe: (p) => <I {...p}><circle cx="12" cy="12" r="9"/><path d="M3 12h18M12 3a14 14 0 010 18M12 3a14 14 0 000 18"/></I>,
  zap: (p) => <I {...p}><path d="M13 2L4 14h7l-1 8 9-12h-7z"/></I>,
  shield: (p) => <I {...p}><path d="M12 2l8 4v6c0 5-4 9-8 10-4-1-8-5-8-10V6z"/></I>,
  refresh: (p) => <I {...p}><path d="M3 12a9 9 0 0115-6.7L21 8"/><path d="M21 3v5h-5"/><path d="M21 12a9 9 0 01-15 6.7L3 16"/><path d="M3 21v-5h5"/></I>,
  dot: (p) => <I {...p}><circle cx="12" cy="12" r="3" fill={p.color || 'currentColor'}/></I>,
  more: (p) => <I {...p}><circle cx="5" cy="12" r="1.5" fill={p.color || 'currentColor'}/><circle cx="12" cy="12" r="1.5" fill={p.color || 'currentColor'}/><circle cx="19" cy="12" r="1.5" fill={p.color || 'currentColor'}/></I>,
  filter: (p) => <I {...p}><path d="M4 6h16M7 12h10M10 18h4"/></I>,
};

// Currency icon — circular disc with country tone gradient + symbol
function CurrencyIcon({ code, size = 40 }) {
  const c = window.CURRENCY_BY_CODE[code] || { tone: '#555', symbol: '?', code: code };
  // dim/brighten tone for a subtle gradient
  const id = `cg-${code}-${size}`;
  return (
    <div style={{
      width: size, height: size, borderRadius: '50%',
      position: 'relative', flexShrink: 0,
      background: `radial-gradient(120% 100% at 30% 25%, ${c.tone}f0 0%, ${c.tone}80 60%, ${c.tone}40 100%)`,
      boxShadow:
        'inset 0 1px 0 rgba(255,255,255,0.18), inset 0 -1px 0 rgba(0,0,0,0.25), 0 1px 2px rgba(0,0,0,0.3)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      color: '#fff',
      fontFamily: 'var(--f-mono)',
      fontWeight: 600,
      fontSize: size * 0.32,
      letterSpacing: '0.02em',
      overflow: 'hidden',
    }}>
      {/* subtle gold inner ring */}
      <div style={{
        position: 'absolute', inset: 2, borderRadius: '50%',
        border: '0.5px solid rgba(201,169,97,0.35)',
        pointerEvents: 'none',
      }}/>
      <span style={{ textShadow: '0 1px 2px rgba(0,0,0,0.5)' }}>{c.code}</span>
    </div>
  );
}

Object.assign(window, { Ico, CurrencyIcon });
