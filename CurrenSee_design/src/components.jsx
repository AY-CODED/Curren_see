// CurrenSee — Reusable components

const { useState, useEffect, useRef, useMemo, useCallback } = React;

/* ── Custom dark phone shell ────────────────────────────────
   Wraps content in an Android device with our dark surface.
   We use AndroidDevice (dark) but supply our own header inside content. */

function CSPhone({ children, width = 380, height = 760, theme = 'dark', density = 'comfy' }) {
  return (
    <div data-theme={theme} data-density={density} style={{
      width, height,
      borderRadius: 38,
      overflow: 'hidden',
      background: '#000',
      border: '8px solid #1a1818',
      boxShadow:
        '0 0 0 1px rgba(255,255,255,0.04), 0 30px 80px rgba(0,0,0,0.5), 0 8px 30px rgba(0,0,0,0.3)',
      position: 'relative',
      display: 'flex', flexDirection: 'column',
      boxSizing: 'border-box',
    }}>
      <CSStatusBar theme={theme} />
      <div className="cs-app" style={{ flex: 1, overflow: 'auto' }}>
        {children}
      </div>
      <CSGestureBar theme={theme} />
    </div>
  );
}

function CSStatusBar({ theme = 'dark' }) {
  const c = theme === 'dark' ? 'rgba(236,230,214,0.9)' : 'rgba(26,27,46,0.9)';
  const bg = theme === 'dark' ? '#07091A' : '#F4F1E8';
  return (
    <div style={{
      height: 36, padding: '0 22px',
      display: 'flex', alignItems: 'center', justifyContent: 'space-between',
      background: bg,
      fontFamily: 'var(--f-mono)',
      fontSize: 13, color: c, fontWeight: 500,
      position: 'relative', flexShrink: 0,
    }}>
      <span style={{ letterSpacing: 0.5 }}>9:41</span>
      {/* camera punch */}
      <div style={{
        position: 'absolute', left: '50%', top: 8,
        transform: 'translateX(-50%)',
        width: 18, height: 18, borderRadius: '50%',
        background: '#000',
        boxShadow: 'inset 0 0 0 1px rgba(255,255,255,0.05)',
      }}/>
      <div style={{ display: 'flex', gap: 5, alignItems: 'center' }}>
        {/* signal */}
        <svg width="14" height="10" viewBox="0 0 14 10"><g fill={c}><rect x="0" y="7" width="2" height="3" rx=".5"/><rect x="3" y="5" width="2" height="5" rx=".5"/><rect x="6" y="3" width="2" height="7" rx=".5"/><rect x="9" y="0" width="2" height="10" rx=".5"/></g></svg>
        {/* wifi */}
        <svg width="14" height="10" viewBox="0 0 14 10" fill="none" stroke={c} strokeWidth="1.2"><path d="M1 4a9 9 0 0112 0"/><path d="M3 6a6 6 0 018 0"/><circle cx="7" cy="9" r="1" fill={c}/></svg>
        {/* battery */}
        <svg width="22" height="10" viewBox="0 0 22 10"><rect x="0.5" y="0.5" width="18" height="9" rx="2" fill="none" stroke={c}/><rect x="2" y="2" width="14" height="6" rx="1" fill={c}/><rect x="19.5" y="3" width="1.5" height="4" rx=".5" fill={c}/></svg>
      </div>
    </div>
  );
}

function CSGestureBar({ theme }) {
  const bg = theme === 'dark' ? '#07091A' : '#F4F1E8';
  const c = theme === 'dark' ? 'rgba(236,230,214,0.5)' : 'rgba(26,27,46,0.4)';
  return (
    <div style={{
      height: 24, background: bg,
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      flexShrink: 0,
    }}>
      <div style={{ width: 110, height: 4, borderRadius: 2, background: c }} />
    </div>
  );
}

/* ── App header (in-page) ──────────────────────────────── */
function CSHeader({ title, eyebrow, left, right, large = false }) {
  return (
    <div style={{ padding: large ? '14px 22px 4px' : '14px 22px 12px' }}>
      <div style={{ display: 'flex', alignItems: 'center', justifyContent: 'space-between', minHeight: 36 }}>
        <div style={{ display: 'flex', alignItems: 'center', gap: 12, flex: 1, minWidth: 0 }}>
          {left}
          {!large && (
            <div style={{ minWidth: 0 }}>
              {eyebrow && <div className="cs-label" style={{ marginBottom: 2 }}>{eyebrow}</div>}
              <div style={{
                fontFamily: 'var(--f-display)',
                fontSize: 22, lineHeight: 1, letterSpacing: '-0.02em',
                color: 'var(--ink)',
                whiteSpace: 'nowrap', overflow: 'hidden', textOverflow: 'ellipsis',
              }}>{title}</div>
            </div>
          )}
        </div>
        <div style={{ display: 'flex', gap: 6, alignItems: 'center' }}>{right}</div>
      </div>
      {large && (
        <div style={{ paddingTop: 18, paddingBottom: 6 }}>
          {eyebrow && <div className="cs-label" style={{ marginBottom: 8 }}>{eyebrow}</div>}
          <div style={{
            fontFamily: 'var(--f-display)', fontSize: 38, lineHeight: 1,
            letterSpacing: '-0.025em', color: 'var(--ink)',
          }}>{title}</div>
        </div>
      )}
    </div>
  );
}

/* ── Icon button ──────────────────────────────── */
function IconButton({ children, onClick, badge }) {
  return (
    <button onClick={onClick} style={{
      width: 38, height: 38, borderRadius: '50%',
      background: 'var(--surface)', border: '1px solid var(--hairline)',
      color: 'var(--ink-2)', cursor: 'pointer',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      position: 'relative',
    }}>
      {children}
      {badge && (
        <span style={{
          position: 'absolute', top: 6, right: 6,
          width: 8, height: 8, borderRadius: '50%',
          background: 'var(--gold)',
          boxShadow: '0 0 0 2px var(--bg)',
        }}/>
      )}
    </button>
  );
}

/* ── Ticker bar (live rates strip) ──────────────────────── */
function CSTicker({ items }) {
  const row = (
    <div className="cs-ticker-track">
      {items.map((it, i) => (
        <span key={i}>
          {it.pair}{' '}
          <span style={{ color: 'var(--ink)' }}>{it.rate}</span>{' '}
          <span className={it.delta >= 0 ? 'pos' : 'neg'}>
            {it.delta >= 0 ? '▲' : '▼'} {Math.abs(it.delta).toFixed(2)}%
          </span>
        </span>
      ))}
    </div>
  );
  return (
    <div className="cs-ticker">
      {row}{row}
    </div>
  );
}

/* ── Sparkline ──────────────────────────────── */
function CSSparkline({ data, width = 80, height = 28, color = 'var(--gold)', fillColor }) {
  const { path, area, last } = useMemo(() => {
    if (!data || data.length === 0) return { path: '', area: '', last: 0 };
    const min = Math.min(...data);
    const max = Math.max(...data);
    const range = max - min || 1;
    const pad = 2;
    const points = data.map((v, i) => {
      const x = (i / (data.length - 1)) * (width - pad * 2) + pad;
      const y = height - pad - ((v - min) / range) * (height - pad * 2);
      return [x, y];
    });
    const path = points.map((p, i) => (i === 0 ? `M${p[0]},${p[1]}` : `L${p[0]},${p[1]}`)).join(' ');
    const area = path + ` L${points[points.length-1][0]},${height} L${points[0][0]},${height} Z`;
    return { path, area, last: points[points.length-1] };
  }, [data, width, height]);

  return (
    <svg width={width} height={height} style={{ display: 'block', overflow: 'visible' }}>
      {fillColor && <path d={area} fill={fillColor} opacity={0.18} />}
      <path d={path} stroke={color} strokeWidth="1.4" fill="none" strokeLinecap="round" strokeLinejoin="round" />
      {last && (
        <circle cx={last[0]} cy={last[1]} r="2" fill={color} />
      )}
    </svg>
  );
}

/* ── Currency row ──────────────────────────────── */
function CurrencyRow({ code, right, onClick, selected, size = 40 }) {
  const c = window.CURRENCY_BY_CODE[code];
  if (!c) return null;
  return (
    <div onClick={onClick} style={{
      display: 'flex', alignItems: 'center', gap: 14,
      padding: '12px 22px',
      cursor: onClick ? 'pointer' : 'default',
      background: selected ? 'var(--surface-2)' : 'transparent',
      borderBottom: '1px solid var(--hairline)',
    }}>
      <CurrencyIcon code={code} size={size} />
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{
          display: 'flex', alignItems: 'baseline', gap: 8,
          color: 'var(--ink)', fontSize: 15, fontWeight: 500,
        }}>
          <span className="cs-mono" style={{ letterSpacing: '0.04em' }}>{c.code}</span>
          <span style={{ color: 'var(--ink-3)', fontSize: 12 }}>{c.symbol}</span>
        </div>
        <div style={{ color: 'var(--ink-2)', fontSize: 13, marginTop: 2 }}>{c.name}</div>
      </div>
      {right}
      {selected && (
        <div style={{ color: 'var(--gold)' }}>
          <Ico.check size={18}/>
        </div>
      )}
    </div>
  );
}

/* ── Bottom nav ──────────────────────────────── */
function BottomNav({ active, onChange }) {
  const tabs = [
    { id: 'converter', label: 'Convert', Icon: Ico.refresh },
    { id: 'history',   label: 'History', Icon: Ico.history },
    { id: 'alerts',    label: 'Alerts',  Icon: Ico.bell },
    { id: 'settings',  label: 'Settings',Icon: Ico.settings },
  ];
  return (
    <div className="cs-tabbar">
      {tabs.map(t => {
        const on = active === t.id;
        return (
          <button key={t.id} onClick={() => onChange && onChange(t.id)} style={{
            flex: 1, background: 'transparent', border: 0, cursor: 'pointer',
            padding: '8px 4px', color: on ? 'var(--gold)' : 'var(--ink-3)',
            display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 4,
            fontFamily: 'var(--f-mono)', fontSize: 9, letterSpacing: '0.12em', textTransform: 'uppercase',
          }}>
            <t.Icon size={20} stroke={on ? 1.8 : 1.4} />
            <span>{t.label}</span>
          </button>
        );
      })}
    </div>
  );
}

/* ── Animated count-up number (used on convert) ── */
function CountUp({ value, decimals = 2, duration = 600, style }) {
  const [n, setN] = useState(value);
  const startRef = useRef({ from: value, to: value, t0: 0 });
  useEffect(() => {
    startRef.current = { from: n, to: value, t0: performance.now() };
    let raf;
    const tick = (t) => {
      const { from, to, t0 } = startRef.current;
      const p = Math.min(1, (t - t0) / duration);
      const eased = 1 - Math.pow(1 - p, 3);
      setN(from + (to - from) * eased);
      if (p < 1) raf = requestAnimationFrame(tick);
    };
    raf = requestAnimationFrame(tick);
    return () => cancelAnimationFrame(raf);
    // eslint-disable-next-line
  }, [value]);
  const formatted = new Intl.NumberFormat('en-US', {
    minimumFractionDigits: decimals, maximumFractionDigits: decimals
  }).format(n);
  return <span style={style}>{formatted}</span>;
}

Object.assign(window, {
  CSPhone, CSStatusBar, CSGestureBar, CSHeader, IconButton,
  CSTicker, CSSparkline, CurrencyRow, BottomNav, CountUp,
});
