// CurrenSee — Design Canvas (all screens + design system)

function CanvasApp() {
  // Each screen owns its own local state for picker/converter mock-ups
  const [convA, setConvA] = React.useState({ from: 'USD', to: 'EUR', amount: 1000 });
  const [convB, setConvB] = React.useState({ from: 'GBP', to: 'JPY', amount: 250 });

  // Phone artboard dimensions (slightly smaller than prototype to fit grid)
  const PW = 360, PH = 720;

  return (
    <div data-theme="dark">
      <DesignCanvas>

        {/* ─────────────────────────────────────────────────────── BRAND */}
        <DCSection id="brand" title="Brand" subtitle="Wordmark · mark · monogram">
          <DCArtboard id="brand-logo" label="Logo lockup · dark" width={520} height={300}>
            <BrandPanel dark>
              <CSLogo size={42} />
              <div style={brandLabel}>PRIMARY LOCKUP · DARK</div>
            </BrandPanel>
          </DCArtboard>
          <DCArtboard id="brand-logo-light" label="Logo lockup · light" width={520} height={300}>
            <BrandPanel>
              <CSLogo size={42} color="#1A1B2E" goldColor="#8E7438" />
              <div style={{...brandLabel, color: '#8A8676'}}>PRIMARY LOCKUP · LIGHT</div>
            </BrandPanel>
          </DCArtboard>
          <DCArtboard id="brand-mark" label="Mark only" width={300} height={300}>
            <BrandPanel dark>
              <CSMark size={120} />
              <div style={brandLabel}>MARK</div>
            </BrandPanel>
          </DCArtboard>
          <DCArtboard id="brand-mono" label="Monogram tile" width={300} height={300}>
            <div style={{
              width: '100%', height: '100%',
              background: 'linear-gradient(135deg, #C9A961 0%, #8E7438 100%)',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              position: 'relative',
            }}>
              <CSMark size={140} color="#07091A" />
              <div style={{
                position: 'absolute', bottom: 16, left: 16,
                fontFamily: 'JetBrains Mono', fontSize: 10, letterSpacing: '0.18em',
                color: '#07091A', textTransform: 'uppercase', opacity: .7,
              }}>APP ICON · 1024</div>
            </div>
          </DCArtboard>
        </DCSection>

        {/* ─────────────────────────────────────────────────────── TYPE */}
        <DCSection id="type" title="Type" subtitle="Instrument Serif · Geist · JetBrains Mono">
          <DCArtboard id="type-scale" label="Type scale" width={680} height={520}>
            <TypeScale />
          </DCArtboard>
          <DCArtboard id="type-pairing" label="Pairing in use" width={340} height={520}>
            <TypePairing />
          </DCArtboard>
        </DCSection>

        {/* ─────────────────────────────────────────────────────── COLOR */}
        <DCSection id="color" title="Color" subtitle="Deep navy stack + signature gold">
          <DCArtboard id="color-surfaces" label="Surface scale" width={500} height={360}>
            <Swatches kind="surface" />
          </DCArtboard>
          <DCArtboard id="color-ink" label="Ink + gold" width={500} height={360}>
            <Swatches kind="ink" />
          </DCArtboard>
          <DCArtboard id="color-semantic" label="Semantic" width={340} height={360}>
            <Swatches kind="semantic" />
          </DCArtboard>
        </DCSection>

        {/* ─────────────────────────────────────────────────────── COMPONENTS */}
        <DCSection id="components" title="Components" subtitle="Buttons · inputs · chips · rows">
          <DCArtboard id="comp-buttons" label="Buttons" width={420} height={300}>
            <CompPanel>
              <Row label="PRIMARY"><button className="cs-btn cs-btn-primary">Save conversion <Ico.check size={14} stroke={2}/></button></Row>
              <Row label="GHOST"><button className="cs-btn cs-btn-ghost">Cancel</button></Row>
              <Row label="TEXT"><button className="cs-btn cs-btn-text">Forgot password?</button></Row>
              <Row label="ICON"><IconButton><Ico.bell size={18}/></IconButton><IconButton badge><Ico.user size={18}/></IconButton></Row>
            </CompPanel>
          </DCArtboard>
          <DCArtboard id="comp-inputs" label="Inputs" width={420} height={300}>
            <CompPanel>
              <Row label="DEFAULT"><input className="cs-input" placeholder="alex@email.com" defaultValue="alex@currensee.app"/></Row>
              <Row label="WITH ICON">
                <div style={{ width: '100%', position: 'relative' }}>
                  <div style={{ position: 'absolute', left: 16, top: '50%', transform: 'translateY(-50%)', color: 'var(--ink-3)' }}><Ico.search size={18}/></div>
                  <input className="cs-input" placeholder="Search currency" style={{ paddingLeft: 46 }}/>
                </div>
              </Row>
            </CompPanel>
          </DCArtboard>
          <DCArtboard id="comp-chips" label="Chips & badges" width={420} height={260}>
            <CompPanel>
              <Row label="NEUTRAL"><span className="cs-chip">All</span><span className="cs-chip">USD →</span><span className="cs-chip">This week</span></Row>
              <Row label="GOLD"><span className="cs-chip cs-chip-gold">Watching</span><span className="cs-chip cs-chip-gold">Live</span></Row>
              <Row label="STATUS"><span className="cs-chip cs-chip-pos">▲ +0.42%</span><span className="cs-chip cs-chip-neg">▼ -0.11%</span></Row>
            </CompPanel>
          </DCArtboard>
          <DCArtboard id="comp-currency" label="Currency icons" width={420} height={260}>
            <CompPanel>
              <div style={{ display: 'flex', gap: 12, alignItems: 'center', flexWrap: 'wrap', padding: 12 }}>
                {['USD','EUR','GBP','JPY','CHF','CAD','AUD','CNY','INR','BRL','MXN','TRY'].map(c => (
                  <CurrencyIcon key={c} code={c} size={40} />
                ))}
              </div>
            </CompPanel>
          </DCArtboard>
          <DCArtboard id="comp-row" label="List row" width={420} height={200}>
            <div style={{ height: '100%', overflow: 'hidden', background: 'var(--bg)', borderRadius: 14 }} className="cs-app">
              <CurrencyRow code="USD" right={<span className="cs-mono" style={{ color: 'var(--ink-3)', fontSize: 11 }}>United States</span>} />
              <CurrencyRow code="EUR" selected right={<span className="cs-mono" style={{ color: 'var(--ink-3)', fontSize: 11 }}>European Union</span>} />
            </div>
          </DCArtboard>
        </DCSection>

        {/* ─────────────────────────────────────────────────────── AUTH */}
        <DCSection id="auth" title="Auth" subtitle="Splash · onboarding · login · register">
          <DCArtboard id="scr-splash" label="01 · Splash" width={PW} height={PH}>
            <PhoneFrame><ScrSplash /></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-onb-1" label="02 · Onboarding · 1/3" width={PW} height={PH}>
            <PhoneFrame><ScrOnboarding step={0} onNext={()=>{}} onSkip={()=>{}}/></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-onb-2" label="03 · Onboarding · 2/3" width={PW} height={PH}>
            <PhoneFrame><ScrOnboarding step={1} onNext={()=>{}} onSkip={()=>{}}/></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-onb-3" label="04 · Onboarding · 3/3" width={PW} height={PH}>
            <PhoneFrame><ScrOnboarding step={2} onNext={()=>{}} onSkip={()=>{}}/></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-login" label="05 · Login" width={PW} height={PH}>
            <PhoneFrame><ScrLogin /></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-register" label="06 · Register" width={PW} height={PH}>
            <PhoneFrame><ScrRegister /></PhoneFrame>
          </DCArtboard>
        </DCSection>

        {/* ─────────────────────────────────────────────────────── CONVERTER (HERO) */}
        <DCSection id="converter" title="Converter · the hero" subtitle="Two directions for the centerpiece screen">
          <DCArtboard id="scr-conv-a" label="A · Editorial / Spacious" width={PW} height={PH}>
            <PhoneFrame>
              <ScrConverterA state={convA} setState={setConvA} onPickCurrency={()=>{}} onConvert={()=>{}} onTabChange={()=>{}} />
            </PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-conv-b" label="B · Trading desk + pad" width={PW} height={PH}>
            <PhoneFrame>
              <ScrConverterB state={convB} setState={setConvB} onPickCurrency={()=>{}} onConvert={()=>{}} onTabChange={()=>{}} />
            </PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-success" label="07 · Success" width={PW} height={PH}>
            <PhoneFrame>
              <ScrSuccess state={{ from: 'USD', to: 'EUR', amount: 1000 }} onDone={()=>{}} />
            </PhoneFrame>
          </DCArtboard>
        </DCSection>

        {/* ─────────────────────────────────────────────────────── LIST + DETAIL */}
        <DCSection id="lists" title="Lists & detail" subtitle="Picker · history · rate detail">
          <DCArtboard id="scr-picker" label="08 · Currency picker" width={PW} height={PH}>
            <PhoneFrame><ScrPicker pickerKind="from" selectedFrom="USD" onSelect={()=>{}} onClose={()=>{}}/></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-history" label="09 · History · filled" width={PW} height={PH}>
            <PhoneFrame><ScrHistory onTabChange={()=>{}}/></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-history-empty" label="10 · History · empty" width={PW} height={PH}>
            <PhoneFrame><ScrHistory empty onTabChange={()=>{}}/></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-rate" label="11 · Rate detail · chart" width={PW} height={PH}>
            <PhoneFrame><ScrRateDetail from="GBP" to="USD" onBack={()=>{}}/></PhoneFrame>
          </DCArtboard>
        </DCSection>

        {/* ─────────────────────────────────────────────────────── ALERTS */}
        <DCSection id="alerts" title="Alerts" subtitle="Watch a pair · get notified">
          <DCArtboard id="scr-alerts" label="12 · Alerts list" width={PW} height={PH}>
            <PhoneFrame><ScrAlerts onTabChange={()=>{}} onNew={()=>{}}/></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-new-alert" label="13 · New alert" width={PW} height={PH}>
            <PhoneFrame><ScrNewAlert onBack={()=>{}} onSave={()=>{}}/></PhoneFrame>
          </DCArtboard>
        </DCSection>

        {/* ─────────────────────────────────────────────────────── SUPPORT */}
        <DCSection id="support" title="Settings & support" subtitle="Settings · help · feedback">
          <DCArtboard id="scr-settings" label="14 · Settings" width={PW} height={PH}>
            <PhoneFrame><ScrSettings onTabChange={()=>{}} onNav={()=>{}}/></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-help" label="15 · Help / FAQ" width={PW} height={PH}>
            <PhoneFrame><ScrHelp onBack={()=>{}}/></PhoneFrame>
          </DCArtboard>
          <DCArtboard id="scr-feedback" label="16 · Feedback" width={PW} height={PH}>
            <PhoneFrame><ScrFeedback onBack={()=>{}} onSend={()=>{}}/></PhoneFrame>
          </DCArtboard>
        </DCSection>

        {/* ─────────────────────────────────────────────────────── STATES */}
        <DCSection id="states" title="States" subtitle="Empty, error, loading">
          <DCArtboard id="scr-error" label="17 · Offline / error" width={PW} height={PH}>
            <PhoneFrame><ScrError /></PhoneFrame>
          </DCArtboard>
        </DCSection>

      </DesignCanvas>
    </div>
  );
}

/* ── Helpers ──────────────────────────────────────────── */
const brandLabel = {
  position: 'absolute', bottom: 16, left: 16,
  fontFamily: 'JetBrains Mono', fontSize: 10, letterSpacing: '0.18em',
  color: 'rgba(236,230,214,0.45)', textTransform: 'uppercase',
};
function BrandPanel({ children, dark }) {
  return (
    <div style={{
      width: '100%', height: '100%',
      background: dark ? 'radial-gradient(120% 80% at 50% 30%, #11162C 0%, #07091A 100%)' : '#F4F1E8',
      display: 'flex', alignItems: 'center', justifyContent: 'center',
      position: 'relative',
    }}>
      {children}
    </div>
  );
}

function PhoneFrame({ children }) {
  return (
    <div className="cs-app" style={{
      width: '100%', height: '100%',
      background: 'var(--bg)',
      overflow: 'hidden',
      borderRadius: 8,
      display: 'flex', flexDirection: 'column',
    }}>
      <CSStatusBar />
      <div style={{ flex: 1, overflow: 'auto' }}>
        {children}
      </div>
      <CSGestureBar />
    </div>
  );
}

function CompPanel({ children }) {
  return (
    <div style={{
      width: '100%', height: '100%',
      background: 'var(--bg)',
      padding: 16, overflow: 'auto',
      display: 'flex', flexDirection: 'column', gap: 14,
      borderRadius: 8,
    }} className="cs-app">
      {children}
    </div>
  );
}
function Row({ label, children }) {
  return (
    <div>
      <div className="cs-eyebrow" style={{ fontSize: 9, marginBottom: 8 }}>{label}</div>
      <div style={{ display: 'flex', gap: 8, flexWrap: 'wrap', alignItems: 'center' }}>{children}</div>
    </div>
  );
}

function TypeScale() {
  return (
    <div className="cs-app" style={{ width: '100%', height: '100%', padding: 28, overflow: 'auto', background: 'var(--bg)', borderRadius: 8 }}>
      <div className="cs-eyebrow" style={{ marginBottom: 12 }}>Display · Instrument Serif</div>
      <div style={{ fontFamily: 'var(--f-display)', fontSize: 56, color: 'var(--ink)', letterSpacing: '-0.025em', lineHeight: 1 }}>
        $1,234.56
      </div>
      <div style={{ fontFamily: 'var(--f-display)', fontSize: 36, marginTop: 14, color: 'var(--ink)', letterSpacing: '-0.02em', lineHeight: 1 }}>
        Sign <em style={{ color: 'var(--gold)', fontStyle: 'italic' }}>in.</em>
      </div>
      <div style={{ fontFamily: 'var(--f-display)', fontSize: 22, marginTop: 12, color: 'var(--ink)' }}>
        Today's rate
      </div>

      <div className="cs-eyebrow" style={{ marginTop: 22, marginBottom: 12 }}>Body · Geist</div>
      <div style={{ fontSize: 16, color: 'var(--ink)' }}>Pick up where you left off.</div>
      <div style={{ fontSize: 14, color: 'var(--ink-2)', marginTop: 6 }}>Your rates and history are waiting.</div>
      <div style={{ fontSize: 12, color: 'var(--ink-3)', marginTop: 6 }}>By continuing you agree to our Terms.</div>

      <div className="cs-eyebrow" style={{ marginTop: 22, marginBottom: 12 }}>Mono · JetBrains Mono</div>
      <div className="cs-mono" style={{ fontSize: 14, color: 'var(--ink)' }}>1 USD = 0.9214 EUR</div>
      <div className="cs-label" style={{ marginTop: 8 }}>EYEBROW / TICKER</div>
    </div>
  );
}
function TypePairing() {
  return (
    <div className="cs-app" style={{ width: '100%', height: '100%', padding: 22, overflow: 'auto', background: 'var(--bg)', borderRadius: 8 }}>
      <div className="cs-label" style={{ marginBottom: 12 }}>HERO PAIRING</div>
      <div style={{ fontFamily: 'var(--f-display)', fontSize: 32, color: 'var(--ink)', letterSpacing: '-0.02em', lineHeight: 1.05 }}>
        Know what your<br/>money is <em style={{ color: 'var(--gold)' }}>worth.</em>
      </div>
      <p style={{ marginTop: 12, color: 'var(--ink-2)', fontSize: 13, lineHeight: 1.55 }}>
        Instant, mid-market rates from twenty-two currencies.
      </p>
      <div className="cs-mono" style={{ marginTop: 22, fontSize: 11, color: 'var(--gold)', letterSpacing: '0.14em', textTransform: 'uppercase' }}>
        1 USD = 0.9214 EUR
      </div>
      <div style={{
        marginTop: 22, padding: '14px 16px',
        background: 'var(--surface)', border: '1px solid var(--hairline)', borderRadius: 12,
      }}>
        <div className="cs-eyebrow" style={{ fontSize: 9 }}>You receive</div>
        <div style={{ fontFamily: 'var(--f-display)', fontSize: 38, color: 'var(--gold)', letterSpacing: '-0.025em', lineHeight: 1, marginTop: 4 }}>
          €921.40
        </div>
      </div>
    </div>
  );
}
function Swatches({ kind }) {
  const groups = {
    surface: [
      { name: '--bg',        hex: '#07091A' },
      { name: '--bg-2',      hex: '#0B0F22' },
      { name: '--surface',   hex: '#11162C' },
      { name: '--surface-2', hex: '#171D38' },
      { name: '--surface-3', hex: '#1E2643' },
      { name: '--hairline',  hex: 'rgba(255,255,255,0.06)' },
    ],
    ink: [
      { name: '--ink',       hex: '#ECE6D6' },
      { name: '--ink-2',     hex: '#B6B0A0' },
      { name: '--ink-3',     hex: '#7A7668' },
      { name: '--gold',      hex: '#C9A961', accent: true },
      { name: '--gold-soft', hex: '#E8C97A', accent: true },
      { name: '--gold-deep', hex: '#8E7438', accent: true },
    ],
    semantic: [
      { name: '--positive',  hex: '#5EBA86' },
      { name: '--negative',  hex: '#D86C5C' },
    ],
  };
  return (
    <div className="cs-app" style={{ width: '100%', height: '100%', padding: 18, background: 'var(--bg)', borderRadius: 8, overflow: 'auto' }}>
      <div className="cs-eyebrow" style={{ marginBottom: 12 }}>
        {kind === 'surface' ? 'Surface' : kind === 'ink' ? 'Ink + signature' : 'Semantic'}
      </div>
      <div style={{ display: 'flex', flexDirection: 'column', gap: 8 }}>
        {groups[kind].map((s, i) => (
          <div key={i} style={{
            display: 'flex', alignItems: 'center', gap: 12,
            padding: '10px 12px', borderRadius: 10,
            background: 'rgba(255,255,255,0.02)', border: '1px solid var(--hairline)',
          }}>
            <div style={{
              width: 38, height: 38, borderRadius: 8,
              background: s.hex,
              border: '1px solid rgba(255,255,255,0.05)',
              boxShadow: s.accent ? `0 4px 18px ${s.hex}40` : 'none',
            }}/>
            <div style={{ flex: 1 }}>
              <div className="cs-mono" style={{ fontSize: 12, color: 'var(--ink)' }}>{s.name}</div>
              <div className="cs-mono" style={{ fontSize: 10, color: 'var(--ink-3)', marginTop: 2 }}>{s.hex}</div>
            </div>
          </div>
        ))}
      </div>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<CanvasApp />);
