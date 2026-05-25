// CurrenSee — Screens part 1
// Splash, Onboarding, Login, Register, Converter (2 variations), Success

const { useState: useState1, useEffect: useEffect1 } = React;

/* ═══════════════════════════════════════════════════════════════
   1. SPLASH
   ═══════════════════════════════════════════════════════════════ */
function ScrSplash({ onContinue }) {
  return (
    <div className="cs-app" style={{
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      height: '100%', padding: '40px 32px', position: 'relative',
    }}>
      {/* Concentric gold rings */}
      <div style={{
        position: 'absolute', top: '50%', left: '50%',
        transform: 'translate(-50%, -55%)',
        width: 380, height: 380, pointerEvents: 'none',
      }}>
        {[0, 1, 2, 3].map(i => (
          <div key={i} style={{
            position: 'absolute', inset: i * 30,
            borderRadius: '50%',
            border: '1px solid rgba(201,169,97,0.08)',
          }}/>
        ))}
      </div>
      <div className="cs-enter" style={{ marginBottom: 28, position: 'relative' }}>
        <CSMark size={72} color="var(--gold)" />
      </div>
      <div className="cs-enter" style={{ animationDelay: '.1s', textAlign: 'center' }}>
        <CSWordmark size={42} color="var(--ink)" goldColor="var(--gold)" />
      </div>
      <div className="cs-enter" style={{
        animationDelay: '.2s',
        marginTop: 16, color: 'var(--ink-3)', textAlign: 'center',
        fontFamily: 'var(--f-mono)', fontSize: 11, letterSpacing: '0.22em', textTransform: 'uppercase',
      }}>
        Money · at a glance
      </div>
      <div style={{ position: 'absolute', bottom: 36, left: 0, right: 0, display: 'flex', justifyContent: 'center' }}>
        <div className="cs-enter" style={{ animationDelay: '.4s', display: 'flex', alignItems: 'center', gap: 10, color: 'var(--ink-3)' }}>
          <div style={{
            width: 24, height: 24, borderRadius: '50%',
            border: '1.5px solid var(--gold)', borderTopColor: 'transparent',
            animation: 'spin 1.2s linear infinite',
          }}/>
          <style>{`@keyframes spin{to{transform:rotate(360deg)}}`}</style>
          <span style={{ fontFamily: 'var(--f-mono)', fontSize: 11, letterSpacing: '0.18em', textTransform: 'uppercase' }}>
            Fetching rates
          </span>
        </div>
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   2. ONBOARDING (3 cards)
   ═══════════════════════════════════════════════════════════════ */
function ScrOnboarding({ step = 0, onNext, onSkip }) {
  const slides = [
    {
      label: 'Convert',
      title: <>Know what your<br/>money is <em style={{ color: 'var(--gold)', fontStyle: 'italic' }}>worth.</em></>,
      body: 'Instant, mid-market rates from twenty-two currencies. No spreads. No surprises.',
      art: <ArtConvert />,
    },
    {
      label: 'Track',
      title: <>Every conversion,<br/><em style={{ color: 'var(--gold)', fontStyle: 'italic' }}>remembered.</em></>,
      body: 'Your history is private, searchable, and ready when you need to find that one number.',
      art: <ArtTrack />,
    },
    {
      label: 'Watch',
      title: <>Get told when a rate<br/><em style={{ color: 'var(--gold)', fontStyle: 'italic' }}>moves your way.</em></>,
      body: 'Set a target. We\'ll quietly watch the market and ping you the moment it hits.',
      art: <ArtWatch />,
    },
  ];
  const s = slides[step];
  const last = step === slides.length - 1;
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <div style={{ display: 'flex', justifyContent: 'space-between', alignItems: 'center', padding: '14px 22px' }}>
        <CSLogo size={18} />
        <button onClick={onSkip} className="cs-btn cs-btn-text">Skip</button>
      </div>
      <div style={{ flex: 1, padding: '8px 28px 0', display: 'flex', flexDirection: 'column' }}>
        <div style={{
          flex: 1, marginTop: 8,
          background: 'var(--surface)',
          border: '1px solid var(--hairline)',
          borderRadius: 24,
          position: 'relative', overflow: 'hidden',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          minHeight: 240,
        }}>
          {s.art}
        </div>
        <div style={{ paddingTop: 28 }}>
          <div className="cs-label" style={{ marginBottom: 12 }}>{`0${step+1} / 03 · ${s.label}`}</div>
          <div style={{
            fontFamily: 'var(--f-display)', fontSize: 34, lineHeight: 1.05,
            letterSpacing: '-0.02em', color: 'var(--ink)',
          }}>{s.title}</div>
          <p style={{
            marginTop: 14, marginBottom: 0,
            color: 'var(--ink-2)', fontSize: 14, lineHeight: 1.55, maxWidth: 320,
          }}>{s.body}</p>
        </div>
      </div>
      <div style={{ padding: '24px 28px 24px', display: 'flex', alignItems: 'center', gap: 16 }}>
        <div style={{ display: 'flex', gap: 6 }}>
          {slides.map((_, i) => (
            <div key={i} style={{
              width: i === step ? 22 : 6, height: 6, borderRadius: 3,
              background: i === step ? 'var(--gold)' : 'var(--hairline-2)',
              transition: 'width .3s',
            }}/>
          ))}
        </div>
        <button onClick={onNext} className="cs-btn cs-btn-primary" style={{ marginLeft: 'auto', padding: '14px 20px' }}>
          {last ? 'Get started' : 'Next'}
          <Ico.forward size={16} stroke={2} />
        </button>
      </div>
    </div>
  );
}

function ArtConvert() {
  return (
    <div style={{ position: 'relative', width: 220, height: 200 }}>
      <div style={{ position: 'absolute', left: 0, top: 18, transform: 'rotate(-6deg)' }}>
        <CurrencyDisc code="USD" size={86} />
      </div>
      <div style={{ position: 'absolute', right: 0, bottom: 18, transform: 'rotate(8deg)' }}>
        <CurrencyDisc code="EUR" size={86} />
      </div>
      <div style={{
        position: 'absolute', left: '50%', top: '50%',
        transform: 'translate(-50%, -50%)',
        width: 60, height: 60, borderRadius: '50%',
        background: 'var(--gold-glow)',
        border: '1px solid rgba(201,169,97,0.4)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        color: 'var(--gold)',
      }}>
        <Ico.swap size={26} stroke={1.8} />
      </div>
    </div>
  );
}
function ArtTrack() {
  return (
    <div style={{ width: 240, height: 200, padding: '20px 0', display: 'flex', flexDirection: 'column', gap: 10 }}>
      {[0, 1, 2].map(i => (
        <div key={i} style={{
          display: 'flex', alignItems: 'center', gap: 12,
          padding: '10px 14px', borderRadius: 12,
          background: 'var(--surface-2)',
          border: '1px solid var(--hairline)',
          opacity: 1 - i * 0.22,
          transform: `translateX(${i * 10}px)`,
        }}>
          <CurrencyDisc code={['USD', 'GBP', 'JPY'][i]} size={28} />
          <div style={{ flex: 1, fontFamily: 'var(--f-mono)', fontSize: 12, color: 'var(--ink-2)' }}>
            {['$2,400', '£1,500', '¥800'][i]} → {['€2,211', '$1,917', '€7.50'][i]}
          </div>
          <div style={{ width: 36, height: 16 }}>
            <CSSparkline data={window.csSeries('USD', 'EUR', 12, 5 + i)} width={36} height={16} color="var(--gold)" />
          </div>
        </div>
      ))}
    </div>
  );
}
function ArtWatch() {
  const data = window.csSeries('GBP', 'USD', 30, 7);
  return (
    <div style={{ width: 240, height: 200, position: 'relative', padding: '20px 12px' }}>
      <svg width="216" height="140" style={{ overflow: 'visible' }}>
        <line x1="0" y1="58" x2="216" y2="58" stroke="var(--gold)" strokeDasharray="3 3" strokeWidth="1" opacity="0.5" />
        <text x="216" y="54" textAnchor="end" fill="var(--gold)" style={{ fontFamily: 'var(--f-mono)', fontSize: 10 }}>1.30</text>
        <g transform="translate(0, 20)">
          <CSSparkline data={data} width={216} height={100} color="var(--gold)" fillColor="var(--gold)" />
        </g>
      </svg>
      <div style={{
        position: 'absolute', right: 16, top: 30,
        padding: '6px 10px', borderRadius: 100,
        background: 'var(--gold)', color: '#0A0E1A',
        fontFamily: 'var(--f-mono)', fontSize: 10, fontWeight: 600,
        letterSpacing: '0.08em', textTransform: 'uppercase',
        boxShadow: '0 4px 16px var(--gold-glow)',
      }}>Alert</div>
    </div>
  );
}

// Bigger currency disc for hero art
function CurrencyDisc({ code, size = 70 }) {
  const c = window.CURRENCY_BY_CODE[code] || { tone: '#555' };
  return (
    <div style={{
      width: size, height: size, borderRadius: '50%',
      background: `radial-gradient(120% 100% at 30% 25%, ${c.tone}f0 0%, ${c.tone}80 60%, ${c.tone}30 100%)`,
      boxShadow: 'inset 0 1px 0 rgba(255,255,255,0.18), 0 12px 30px rgba(0,0,0,0.4)',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      color: '#fff', fontFamily: 'var(--f-display)', fontStyle: 'italic',
      fontSize: size * 0.5, letterSpacing: '-0.02em',
      position: 'relative',
    }}>
      <div style={{
        position: 'absolute', inset: 4, borderRadius: '50%',
        border: '0.5px solid rgba(201,169,97,0.4)',
      }}/>
      {c.symbol}
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   3. LOGIN
   ═══════════════════════════════════════════════════════════════ */
function ScrLogin({ onLogin, onRegister }) {
  const [email, setEmail] = useState1('alex@currensee.app');
  const [pwd, setPwd] = useState1('••••••••••');
  const [showPwd, setShowPwd] = useState1(false);
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column', padding: '20px 28px 24px' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
        <CSLogo size={20} />
      </div>
      <div style={{ marginTop: 50 }}>
        <div className="cs-label" style={{ marginBottom: 12 }}>Welcome back</div>
        <div style={{
          fontFamily: 'var(--f-display)', fontSize: 40, lineHeight: 1, letterSpacing: '-0.025em',
          color: 'var(--ink)',
        }}>
          Sign <em style={{ fontStyle: 'italic', color: 'var(--gold)' }}>in.</em>
        </div>
        <p style={{ marginTop: 14, color: 'var(--ink-2)', fontSize: 14 }}>
          Pick up where you left off — your rates and history are waiting.
        </p>
      </div>
      <div style={{ marginTop: 32, display: 'flex', flexDirection: 'column', gap: 14 }}>
        <FormField label="Email" icon={<Ico.mail size={18} />}>
          <input className="cs-input" type="email" value={email} onChange={e => setEmail(e.target.value)} style={{ paddingLeft: 46 }} />
        </FormField>
        <FormField label="Password" icon={<Ico.lock size={18} />}
          right={
            <button onClick={() => setShowPwd(!showPwd)} style={{
              background: 'transparent', border: 0, cursor: 'pointer', color: 'var(--ink-3)',
              padding: 0, position: 'absolute', right: 16, top: '50%', transform: 'translateY(-50%)',
            }}>
              <Ico.eye size={18} />
            </button>
          }
        >
          <input className="cs-input" type={showPwd ? 'text' : 'password'} value={pwd} onChange={e => setPwd(e.target.value)} style={{ paddingLeft: 46, paddingRight: 44 }} />
        </FormField>
        <div style={{ textAlign: 'right', marginTop: -4 }}>
          <button className="cs-btn cs-btn-text" style={{ fontSize: 13 }}>Forgot password?</button>
        </div>
      </div>
      <div style={{ marginTop: 24 }}>
        <button onClick={onLogin} className="cs-btn cs-btn-primary" style={{ width: '100%', padding: '18px' }}>
          Sign in
          <Ico.forward size={16} stroke={2}/>
        </button>
      </div>
      <div style={{ marginTop: 20, display: 'flex', alignItems: 'center', gap: 12 }}>
        <div style={{ flex: 1, height: 1, background: 'var(--hairline)' }}/>
        <span className="cs-eyebrow" style={{ fontSize: 10 }}>or</span>
        <div style={{ flex: 1, height: 1, background: 'var(--hairline)' }}/>
      </div>
      <div style={{ marginTop: 16, display: 'flex', gap: 10 }}>
        <button className="cs-btn cs-btn-ghost" style={{ flex: 1 }}>
          <svg width="16" height="16" viewBox="0 0 16 16"><path fill="currentColor" d="M15 8.16c0-.5-.04-.99-.13-1.46H8v2.77h3.93a3.36 3.36 0 01-1.46 2.2v1.83h2.36C14.21 12.14 15 10.32 15 8.16z"/><path fill="currentColor" d="M8 15c1.97 0 3.62-.65 4.83-1.77l-2.36-1.83c-.65.44-1.49.7-2.47.7-1.9 0-3.5-1.28-4.08-3H1.49v1.88A7 7 0 008 15z"/></svg>
          Google
        </button>
        <button className="cs-btn cs-btn-ghost" style={{ flex: 1 }}>
          <svg width="16" height="16" viewBox="0 0 16 16"><path fill="currentColor" d="M11.18 8.42c0-1.92 1.57-2.84 1.64-2.88-.9-1.31-2.29-1.49-2.79-1.51-1.19-.12-2.32.7-2.93.7-.6 0-1.54-.69-2.53-.67-1.3.02-2.5.76-3.17 1.92C-.1 8.34.91 11.95 2.22 13.93c.65.97 1.42 2.06 2.42 2.02.97-.04 1.34-.63 2.52-.63s1.51.63 2.54.61c1.05-.02 1.71-.99 2.35-1.96.74-1.13 1.05-2.23 1.06-2.28-.02-.01-2.04-.78-2.06-3.1z"/></svg>
          Apple
        </button>
      </div>
      <div style={{ flex: 1 }}/>
      <div style={{ textAlign: 'center', color: 'var(--ink-2)', fontSize: 14 }}>
        New here? <button onClick={onRegister} className="cs-btn cs-btn-text" style={{ display: 'inline-flex', padding: 0, fontSize: 14 }}>Create an account</button>
      </div>
    </div>
  );
}

function FormField({ label, icon, children, right, error }) {
  return (
    <div>
      {label && <div className="cs-eyebrow" style={{ marginBottom: 8, fontSize: 10 }}>{label}</div>}
      <div style={{ position: 'relative' }}>
        {icon && (
          <div style={{
            position: 'absolute', left: 16, top: '50%', transform: 'translateY(-50%)',
            color: 'var(--ink-3)', pointerEvents: 'none',
          }}>{icon}</div>
        )}
        {children}
        {right}
      </div>
      {error && <div style={{ marginTop: 6, color: 'var(--negative)', fontSize: 12 }}>{error}</div>}
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   4. REGISTER
   ═══════════════════════════════════════════════════════════════ */
function ScrRegister({ onRegister, onLogin }) {
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column', padding: '20px 28px 24px' }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 10 }}>
        <button onClick={onLogin} style={{ background: 'transparent', border: 0, color: 'var(--ink-2)', cursor: 'pointer', padding: 0 }}>
          <Ico.back size={22}/>
        </button>
        <CSLogo size={18} />
      </div>
      <div style={{ marginTop: 36 }}>
        <div className="cs-label" style={{ marginBottom: 12 }}>Get started</div>
        <div style={{
          fontFamily: 'var(--f-display)', fontSize: 36, lineHeight: 1, letterSpacing: '-0.025em', color: 'var(--ink)',
        }}>
          Open an <em style={{ fontStyle: 'italic', color: 'var(--gold)' }}>account.</em>
        </div>
        <p style={{ marginTop: 12, color: 'var(--ink-2)', fontSize: 13 }}>
          Free, forever. Used by 84,000+ travelers, traders, and freelancers worldwide.
        </p>
      </div>
      <div style={{ marginTop: 26, display: 'flex', flexDirection: 'column', gap: 12 }}>
        <FormField label="Full name" icon={<Ico.user size={18}/>}>
          <input className="cs-input" placeholder="Alex Morgan" style={{ paddingLeft: 46 }} />
        </FormField>
        <FormField label="Email" icon={<Ico.mail size={18}/>}>
          <input className="cs-input" placeholder="you@email.com" style={{ paddingLeft: 46 }} />
        </FormField>
        <FormField label="Password" icon={<Ico.lock size={18}/>}>
          <input className="cs-input" type="password" placeholder="At least 8 characters" style={{ paddingLeft: 46 }} />
        </FormField>
        <FormField label="Default base currency">
          <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap' }}>
            {['USD', 'EUR', 'GBP', 'JPY'].map((code, i) => (
              <button key={code} style={{
                display: 'flex', alignItems: 'center', gap: 8,
                padding: '10px 14px', borderRadius: 100,
                background: i === 0 ? 'var(--gold-glow)' : 'var(--surface)',
                border: i === 0 ? '1px solid var(--gold)' : '1px solid var(--hairline)',
                color: i === 0 ? 'var(--gold)' : 'var(--ink)',
                fontFamily: 'var(--f-mono)', fontSize: 12, letterSpacing: '0.04em',
                cursor: 'pointer',
              }}>
                <CurrencyIcon code={code} size={22} />
                {code}
              </button>
            ))}
          </div>
        </FormField>
      </div>
      <div style={{ marginTop: 'auto', paddingTop: 24 }}>
        <button onClick={onRegister} className="cs-btn cs-btn-primary" style={{ width: '100%', padding: '18px' }}>
          Create account
          <Ico.forward size={16} stroke={2}/>
        </button>
        <p style={{ marginTop: 14, textAlign: 'center', color: 'var(--ink-3)', fontSize: 11, lineHeight: 1.5 }}>
          By continuing you agree to our <span style={{ color: 'var(--ink-2)', borderBottom: '1px solid var(--hairline-2)' }}>Terms</span> &nbsp;·&nbsp; <span style={{ color: 'var(--ink-2)', borderBottom: '1px solid var(--hairline-2)' }}>Privacy</span>
        </p>
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   5. CONVERTER — Variation A (Editorial / Spacious)
   The hero. Big serif number, fine gold accents, ticker on top.
   ═══════════════════════════════════════════════════════════════ */
function ScrConverterA({ state, setState, onPickCurrency, onConvert, onTabChange }) {
  const { from, to, amount } = state;
  const fromCur = window.CURRENCY_BY_CODE[from];
  const toCur = window.CURRENCY_BY_CODE[to];
  const rate = window.csRate(from, to);
  const converted = window.csConvert(amount, from, to);
  const series = useMemo(() => window.csSeries(from, to, 24, 11), [from, to]);
  const delta = ((series[series.length-1] / series[0]) - 1) * 100;

  const tickerItems = [
    { pair: 'EUR/USD', rate: '1.0853', delta: 0.24 },
    { pair: 'GBP/USD', rate: '1.2786', delta: -0.11 },
    { pair: 'USD/JPY', rate: '156.42', delta: 0.42 },
    { pair: 'USD/CHF', rate: '0.8930', delta: -0.08 },
    { pair: 'AUD/USD', rate: '0.6574', delta: 0.31 },
    { pair: 'USD/CAD', rate: '1.3654', delta: 0.07 },
  ];

  const swap = () => setState({ ...state, from: to, to: from });
  const setAmount = (v) => setState({ ...state, amount: v });

  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSTicker items={tickerItems} />
      <CSHeader
        eyebrow="Converter"
        title="Today's rate"
        left={<CSMark size={26} />}
        right={<>
          <IconButton badge><Ico.bell size={18}/></IconButton>
          <IconButton><Ico.user size={18}/></IconButton>
        </>}
      />

      {/* Amount input — base */}
      <div style={{ padding: '4px 22px 0' }}>
        <CSAmountField
          label="You send"
          code={from}
          amount={amount}
          editable
          onAmount={setAmount}
          onPickCurrency={() => onPickCurrency('from')}
        />
      </div>

      {/* Swap divider */}
      <div style={{ position: 'relative', height: 28, margin: '4px 22px' }}>
        <div style={{ position: 'absolute', top: '50%', left: 0, right: 0, height: 1, background: 'var(--hairline)' }}/>
        <div style={{
          position: 'absolute', top: '50%', left: '50%',
          transform: 'translate(-50%, -50%)',
        }}>
          <button onClick={swap} style={{
            width: 44, height: 44, borderRadius: '50%',
            background: 'var(--surface-2)', color: 'var(--gold)',
            border: '1px solid var(--gold)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            cursor: 'pointer',
            boxShadow: '0 0 0 4px var(--bg), 0 6px 20px var(--gold-glow)',
          }}>
            <Ico.swap size={18} stroke={2}/>
          </button>
        </div>
      </div>

      {/* Result — target */}
      <div style={{ padding: '0 22px 18px' }}>
        <CSAmountField
          label="You receive"
          code={to}
          amount={converted}
          isResult
          onPickCurrency={() => onPickCurrency('to')}
        />
      </div>

      {/* Rate strip */}
      <div style={{
        margin: '0 22px',
        padding: '14px 18px',
        borderRadius: 14,
        background: 'var(--surface)',
        border: '1px solid var(--hairline)',
        display: 'flex', alignItems: 'center', gap: 14,
      }}>
        <div style={{ flex: 1, minWidth: 0 }}>
          <div className="cs-eyebrow" style={{ fontSize: 9, marginBottom: 4 }}>Mid-market · live</div>
          <div className="cs-mono" style={{ color: 'var(--ink)', fontSize: 14 }}>
            1 {from} = <span style={{ color: 'var(--gold)' }}>{window.fmtRate(rate)}</span> {to}
          </div>
        </div>
        <div style={{ width: 58, height: 26 }}>
          <CSSparkline data={series} width={58} height={26} color={delta >= 0 ? 'var(--positive)' : 'var(--negative)'} />
        </div>
        <div className={`cs-chip ${delta >= 0 ? 'cs-chip-pos' : 'cs-chip-neg'}`}>
          {delta >= 0 ? '▲' : '▼'} {Math.abs(delta).toFixed(2)}%
        </div>
      </div>

      <div style={{ padding: '18px 22px 12px' }}>
        <button onClick={onConvert} className="cs-btn cs-btn-primary" style={{ width: '100%', padding: '18px' }}>
          Save conversion
          <Ico.check size={16} stroke={2}/>
        </button>
      </div>

      <div style={{ flex: 1 }}/>
      <BottomNav active="converter" onChange={onTabChange} />
    </div>
  );
}

/* Amount field used in Converter A — display-style big number */
function CSAmountField({ label, code, amount, editable, isResult, onAmount, onPickCurrency }) {
  const fmt = window.fmtAmount(amount || 0, code);
  return (
    <div style={{ display: 'flex', alignItems: 'center', gap: 12 }}>
      <button onClick={onPickCurrency} style={{
        display: 'flex', alignItems: 'center', gap: 10,
        padding: '8px 12px 8px 8px',
        background: 'var(--surface)',
        border: '1px solid var(--hairline)',
        borderRadius: 100,
        cursor: 'pointer', color: 'var(--ink)',
      }}>
        <CurrencyIcon code={code} size={32} />
        <span style={{ fontFamily: 'var(--f-mono)', fontSize: 13, fontWeight: 600, letterSpacing: '0.04em' }}>{code}</span>
        <Ico.chevronDown size={14} color="var(--ink-3)" />
      </button>
      <div style={{ flex: 1, minWidth: 0, textAlign: 'right' }}>
        <div className="cs-eyebrow" style={{ fontSize: 9, marginBottom: 2 }}>{label}</div>
        {editable ? (
          <input
            value={fmt}
            onChange={e => {
              const raw = e.target.value.replace(/[^0-9.]/g, '');
              const n = parseFloat(raw) || 0;
              onAmount(n);
            }}
            style={{
              width: '100%', textAlign: 'right',
              border: 0, background: 'transparent', outline: 'none',
              fontFamily: 'var(--f-display)', fontSize: 38, lineHeight: 1.1,
              color: 'var(--ink)', letterSpacing: '-0.025em',
              padding: 0,
            }}
          />
        ) : (
          <div style={{
            fontFamily: 'var(--f-display)', fontSize: 38, lineHeight: 1.1, letterSpacing: '-0.025em',
            color: isResult ? 'var(--gold)' : 'var(--ink)',
            textAlign: 'right',
          }} className={isResult ? 'cs-flip' : ''} key={amount}>
            {fmt}
          </div>
        )}
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   6. CONVERTER — Variation B (Compact "Trading desk" card)
   Stacked card with both currencies, big number on top, calculator below
   ═══════════════════════════════════════════════════════════════ */
function ScrConverterB({ state, setState, onPickCurrency, onConvert, onTabChange }) {
  const { from, to, amount } = state;
  const rate = window.csRate(from, to);
  const converted = window.csConvert(amount, from, to);
  const series = useMemo(() => window.csSeries(from, to, 24, 11), [from, to]);
  const delta = ((series[series.length-1] / series[0]) - 1) * 100;
  const swap = () => setState({ ...state, from: to, to: from });
  const press = (k) => {
    const s = String(amount);
    if (k === '⌫') {
      const next = s.length <= 1 ? 0 : parseFloat(s.slice(0, -1)) || 0;
      setState({ ...state, amount: next });
    } else if (k === '.') {
      if (!s.includes('.')) setState({ ...state, amount: parseFloat(s + '.') || amount });
    } else {
      setState({ ...state, amount: parseFloat(s === '0' ? k : s + k) });
    }
  };
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSHeader
        title="Converter"
        eyebrow={`Live · ${new Date().toLocaleTimeString('en', { hour: '2-digit', minute: '2-digit' })}`}
        left={<CSMark size={26} />}
        right={<>
          <IconButton><Ico.refresh size={18}/></IconButton>
          <IconButton><Ico.user size={18}/></IconButton>
        </>}
      />
      {/* The trading card */}
      <div style={{
        margin: '4px 22px 16px',
        background: 'linear-gradient(180deg, var(--surface) 0%, var(--surface-2) 100%)',
        border: '1px solid var(--hairline-2)',
        borderRadius: 22, padding: '20px 20px 18px',
        position: 'relative', overflow: 'hidden',
      }}>
        {/* corner mark */}
        <div style={{ position: 'absolute', top: 14, right: 18 }}>
          <CSMark size={20} color="var(--gold)" />
        </div>
        {/* Pair display */}
        <div style={{ display: 'flex', alignItems: 'center', gap: 8 }}>
          <button onClick={() => onPickCurrency('from')} style={{
            background: 'transparent', border: 0, padding: 0, color: 'inherit', cursor: 'pointer',
            display: 'flex', alignItems: 'center', gap: 6,
          }}>
            <CurrencyIcon code={from} size={22} />
            <span className="cs-mono" style={{ fontSize: 12, color: 'var(--ink)' }}>{from}</span>
          </button>
          <Ico.forward size={12} color="var(--ink-3)" />
          <button onClick={() => onPickCurrency('to')} style={{
            background: 'transparent', border: 0, padding: 0, color: 'inherit', cursor: 'pointer',
            display: 'flex', alignItems: 'center', gap: 6,
          }}>
            <CurrencyIcon code={to} size={22} />
            <span className="cs-mono" style={{ fontSize: 12, color: 'var(--ink)' }}>{to}</span>
          </button>
        </div>

        {/* Amount + result */}
        <div style={{ marginTop: 16 }}>
          <div className="cs-eyebrow" style={{ fontSize: 9 }}>{from} · You send</div>
          <div style={{
            fontFamily: 'var(--f-display)', fontSize: 32, color: 'var(--ink-2)',
            letterSpacing: '-0.02em', lineHeight: 1.1,
          }}>
            {window.fmtAmount(amount, from)}
          </div>
        </div>
        <div style={{ height: 1, background: 'var(--hairline)', margin: '14px 0' }}/>
        <div>
          <div className="cs-eyebrow" style={{ fontSize: 9, color: 'var(--gold)' }}>{to} · You receive</div>
          <div className="cs-flip" key={`${from}${to}${amount}`} style={{
            fontFamily: 'var(--f-display)', fontSize: 52, color: 'var(--gold)',
            letterSpacing: '-0.03em', lineHeight: 1, marginTop: 4,
          }}>
            {window.fmtAmount(converted, to)}
          </div>
        </div>

        {/* Mini stats row */}
        <div style={{ display: 'flex', gap: 10, marginTop: 18 }}>
          <Stat label="Rate" value={window.fmtRate(rate)} />
          <Stat label="24h" value={`${delta >= 0 ? '+' : ''}${delta.toFixed(2)}%`} valueColor={delta >= 0 ? 'var(--positive)' : 'var(--negative)'} />
          <div style={{ flex: 1, display: 'flex', alignItems: 'flex-end' }}>
            <CSSparkline data={series} width={86} height={34} color={delta >= 0 ? 'var(--positive)' : 'var(--negative)'} fillColor={delta >= 0 ? 'var(--positive)' : 'var(--negative)'} />
          </div>
        </div>
      </div>

      {/* Calculator pad */}
      <div style={{ flex: 1, padding: '0 18px 8px', display: 'flex', flexDirection: 'column' }}>
        <div style={{
          display: 'grid', gridTemplateColumns: 'repeat(4, 1fr)', gap: 8, flex: 1,
        }}>
          {['7','8','9','⌫','4','5','6','.','1','2','3','0','⇅','C','%','='].map((k, i) => {
            const isAction = ['⌫', '.', '⇅', 'C', '%', '='].includes(k);
            const isPrimary = k === '=';
            const onClick = () => {
              if (k === 'C') setState({ ...state, amount: 0 });
              else if (k === '⇅') swap();
              else if (k === '=') onConvert();
              else if (k === '%') {}
              else press(k);
            };
            return (
              <button key={i} onClick={onClick} style={{
                aspectRatio: '1.2 / 1',
                background: isPrimary ? 'var(--gold)' : (isAction ? 'var(--surface-2)' : 'var(--surface)'),
                border: isAction ? 0 : '1px solid var(--hairline)',
                color: isPrimary ? '#0A0E1A' : (isAction ? 'var(--gold)' : 'var(--ink)'),
                borderRadius: 14, cursor: 'pointer',
                fontFamily: isPrimary || /[0-9.]/.test(k) ? 'var(--f-display)' : 'var(--f-mono)',
                fontSize: isPrimary ? 22 : 20,
                display: 'flex', alignItems: 'center', justifyContent: 'center',
              }}>
                {k}
              </button>
            );
          })}
        </div>
      </div>
      <BottomNav active="converter" onChange={onTabChange}/>
    </div>
  );
}

function Stat({ label, value, valueColor }) {
  return (
    <div style={{
      padding: '8px 10px', borderRadius: 10,
      background: 'rgba(255,255,255,0.03)',
      border: '1px solid var(--hairline)',
      minWidth: 64,
    }}>
      <div className="cs-eyebrow" style={{ fontSize: 8.5, marginBottom: 2 }}>{label}</div>
      <div className="cs-mono" style={{ fontSize: 13, color: valueColor || 'var(--ink)' }}>{value}</div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   7. SUCCESS — celebration after save
   ═══════════════════════════════════════════════════════════════ */
function ScrSuccess({ state, onDone }) {
  const { from, to, amount } = state;
  const converted = window.csConvert(amount, from, to);
  return (
    <div className="cs-app" style={{
      height: '100%', display: 'flex', flexDirection: 'column',
      alignItems: 'center', justifyContent: 'center', padding: 32, position: 'relative',
    }}>
      <div style={{ position: 'absolute', top: 16, right: 16 }}>
        <IconButton onClick={onDone}><Ico.close size={18}/></IconButton>
      </div>
      {/* Gold halo */}
      <div style={{
        width: 120, height: 120, borderRadius: '50%',
        background: 'radial-gradient(circle, var(--gold-glow), transparent 70%)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        marginBottom: 28, position: 'relative',
      }}>
        <div style={{
          width: 80, height: 80, borderRadius: '50%',
          background: 'linear-gradient(180deg, var(--gold-soft), var(--gold))',
          color: '#0A0E1A',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          boxShadow: '0 12px 40px var(--gold-glow)',
        }} className="cs-enter">
          <Ico.check size={36} stroke={2.2}/>
        </div>
      </div>
      <div className="cs-enter" style={{ animationDelay: '.1s', textAlign: 'center' }}>
        <div className="cs-label" style={{ marginBottom: 10 }}>Conversion saved</div>
        <div style={{
          fontFamily: 'var(--f-display)', fontSize: 30, color: 'var(--ink)', letterSpacing: '-0.02em',
          lineHeight: 1.1,
        }}>
          <span className="cs-mono" style={{ fontSize: 20, color: 'var(--ink-2)' }}>
            {window.CURRENCY_BY_CODE[from].symbol}{window.fmtAmount(amount, from)}
          </span>
          <span style={{ margin: '0 10px', color: 'var(--gold)' }}>→</span>
          <span>{window.CURRENCY_BY_CODE[to].symbol}{window.fmtAmount(converted, to)}</span>
        </div>
        <p style={{ marginTop: 14, color: 'var(--ink-2)', fontSize: 14, maxWidth: 280 }}>
          Filed in your history. Tap again any time — your last pair is remembered.
        </p>
      </div>
      <div className="cs-enter" style={{ animationDelay: '.2s', marginTop: 28, display: 'flex', gap: 10, width: '100%', maxWidth: 320 }}>
        <button className="cs-btn cs-btn-ghost" style={{ flex: 1 }} onClick={onDone}>New conversion</button>
        <button className="cs-btn cs-btn-primary" style={{ flex: 1 }}>View history</button>
      </div>
    </div>
  );
}

Object.assign(window, {
  ScrSplash, ScrOnboarding, ScrLogin, ScrRegister,
  ScrConverterA, ScrConverterB, ScrSuccess,
  CSAmountField, Stat, FormField, CurrencyDisc,
});
