// CurrenSee — Prototype app (state-driven navigation)

const { useState: usePState, useEffect: usePEffect } = React;

const TWEAK_DEFAULTS = /*EDITMODE-BEGIN*/{
  "theme": "dark",
  "density": "comfy",
  "accent": "#C9A961",
  "palette": ["#07091A", "#11162C", "#C9A961"],
  "converterVariant": "A"
}/*EDITMODE-END*/;

const ACCENT_CHOICES = [
  '#C9A961', // signature gold
  '#5EBA86', // emerald
  '#7FB3D5', // cool steel-blue
  '#D38B5E', // amber-copper
];

const PALETTE_CHOICES = [
  ['#07091A', '#11162C', '#C9A961'],   // Midnight Gold (default)
  ['#0A1612', '#13211C', '#5EBA86'],   // Deep Forest
  ['#0E0A1A', '#1A1530', '#B89AE0'],   // Plum Lilac
  ['#F4F1E8', '#FFFFFF', '#8E7438'],   // Cream Gold (light)
];

function applyPalette(palette) {
  const [bg, surface, gold] = palette;
  const root = document.documentElement;
  root.style.setProperty('--bg', bg);
  // derive nearby tones
  const mix = (a, b, t) => {
    const ah = a.replace('#', '');
    const bh = b.replace('#', '');
    const ar = parseInt(ah.slice(0,2),16), ag = parseInt(ah.slice(2,4),16), ab = parseInt(ah.slice(4,6),16);
    const br = parseInt(bh.slice(0,2),16), bg2 = parseInt(bh.slice(2,4),16), bb = parseInt(bh.slice(4,6),16);
    const r = Math.round(ar + (br-ar)*t), g = Math.round(ag + (bg2-ag)*t), b2 = Math.round(ab + (bb-ab)*t);
    return '#' + [r,g,b2].map(n => n.toString(16).padStart(2,'0')).join('');
  };
  root.style.setProperty('--bg-2', mix(bg, surface, 0.5));
  root.style.setProperty('--surface', surface);
  root.style.setProperty('--surface-2', mix(surface, '#FFFFFF', 0.06));
  root.style.setProperty('--surface-3', mix(surface, '#FFFFFF', 0.12));
  root.style.setProperty('--gold', gold);
  root.style.setProperty('--gold-soft', mix(gold, '#FFFFFF', 0.25));
  root.style.setProperty('--gold-deep', mix(gold, '#000000', 0.35));
  const gr = parseInt(gold.slice(1,3),16), gg = parseInt(gold.slice(3,5),16), gb = parseInt(gold.slice(5,7),16);
  root.style.setProperty('--gold-glow', `rgba(${gr},${gg},${gb},0.18)`);
}

function App() {
  const [t, setTweak] = useTweaks(TWEAK_DEFAULTS);

  usePEffect(() => { applyPalette(t.palette); }, [t.palette]);

  const [screen, setScreen] = usePState('splash');
  const [onbStep, setOnbStep] = usePState(0);
  const [pickerKind, setPickerKind] = usePState('from');
  const [returnScreen, setReturnScreen] = usePState('converter');
  const [conv, setConv] = usePState({ from: 'USD', to: 'EUR', amount: 1000 });

  // Auto-advance splash → onboarding
  usePEffect(() => {
    if (screen === 'splash') {
      const id = setTimeout(() => setScreen('onboarding'), 2200);
      return () => clearTimeout(id);
    }
  }, [screen]);

  const goTab = (id) => {
    if (id === 'converter') setScreen('converter');
    else if (id === 'history') setScreen('history');
    else if (id === 'alerts') setScreen('alerts');
    else if (id === 'settings') setScreen('settings');
  };

  const openPicker = (kind) => {
    setPickerKind(kind);
    setReturnScreen('converter');
    setScreen('picker');
  };
  const handlePick = (code) => {
    setConv({ ...conv, [pickerKind]: code });
    setScreen(returnScreen);
  };

  const Converter = t.converterVariant === 'B' ? ScrConverterB : ScrConverterA;

  let body;
  switch (screen) {
    case 'splash':
      body = <ScrSplash onContinue={() => setScreen('onboarding')} />;
      break;
    case 'onboarding':
      body = <ScrOnboarding
        step={onbStep}
        onSkip={() => setScreen('login')}
        onNext={() => {
          if (onbStep < 2) setOnbStep(onbStep + 1);
          else setScreen('login');
        }}
      />;
      break;
    case 'login':
      body = <ScrLogin onLogin={() => setScreen('converter')} onRegister={() => setScreen('register')} />;
      break;
    case 'register':
      body = <ScrRegister onRegister={() => setScreen('converter')} onLogin={() => setScreen('login')} />;
      break;
    case 'converter':
      body = <Converter
        state={conv}
        setState={setConv}
        onPickCurrency={openPicker}
        onConvert={() => setScreen('success')}
        onTabChange={goTab}
      />;
      break;
    case 'picker':
      body = <ScrPicker
        pickerKind={pickerKind}
        selectedFrom={conv.from}
        selectedTo={conv.to}
        onSelect={handlePick}
        onClose={() => setScreen(returnScreen)}
      />;
      break;
    case 'success':
      body = <ScrSuccess state={conv} onDone={() => setScreen('converter')} />;
      break;
    case 'history':
      body = <ScrHistory onTabChange={goTab} onOpenItem={(h) => { setConv({ from: h.from, to: h.to, amount: h.amount }); setScreen('rateDetail'); }}/>;
      break;
    case 'alerts':
      body = <ScrAlerts onTabChange={goTab} onNew={() => setScreen('newAlert')} />;
      break;
    case 'newAlert':
      body = <ScrNewAlert onBack={() => setScreen('alerts')} onSave={() => setScreen('alerts')} />;
      break;
    case 'rateDetail':
      body = <ScrRateDetail from={conv.from} to={conv.to} onBack={() => setScreen('history')} />;
      break;
    case 'settings':
      body = <ScrSettings onTabChange={goTab} onNav={(s) => setScreen(s)} />;
      break;
    case 'help':
      body = <ScrHelp onBack={() => setScreen('settings')} />;
      break;
    case 'feedback':
      body = <ScrFeedback onBack={() => setScreen('settings')} onSend={() => setScreen('settings')} />;
      break;
    default:
      body = <ScrSplash />;
  }

  return (
    <div style={{
      minHeight: '100vh', width: '100%',
      background: 'radial-gradient(120% 80% at 50% -10%, #1A1F35 0%, #07091A 60%)',
      display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center',
      padding: '24px 16px', boxSizing: 'border-box',
      color: '#ECE6D6', fontFamily: 'Geist, system-ui, sans-serif',
    }}>
      {/* Background grid */}
      <div style={{
        position: 'fixed', inset: 0, pointerEvents: 'none', opacity: 0.5,
        backgroundImage: 'linear-gradient(rgba(201,169,97,0.04) 1px, transparent 1px), linear-gradient(90deg, rgba(201,169,97,0.04) 1px, transparent 1px)',
        backgroundSize: '60px 60px',
      }}/>

      <CSPhone theme={t.theme} density={t.density}>
        {body}
      </CSPhone>

      {/* Floating screen jumper (always visible) */}
      <div style={{
        marginTop: 18, display: 'flex', flexWrap: 'wrap', gap: 6, justifyContent: 'center',
        maxWidth: 480, position: 'relative', zIndex: 1,
      }}>
        {[
          ['splash', 'Splash'],
          ['onboarding', 'Onboarding'],
          ['login', 'Login'],
          ['register', 'Register'],
          ['converter', 'Converter'],
          ['picker', 'Picker'],
          ['success', 'Success'],
          ['history', 'History'],
          ['alerts', 'Alerts'],
          ['newAlert', 'New alert'],
          ['rateDetail', 'Rate detail'],
          ['settings', 'Settings'],
          ['help', 'Help'],
          ['feedback', 'Feedback'],
        ].map(([id, label]) => {
          const on = screen === id;
          return (
            <button key={id} onClick={() => setScreen(id)} style={{
              padding: '6px 10px', borderRadius: 100,
              background: on ? '#C9A961' : 'rgba(255,255,255,0.04)',
              color: on ? '#07091A' : 'rgba(236,230,214,0.7)',
              border: on ? '0' : '1px solid rgba(255,255,255,0.08)',
              fontFamily: 'JetBrains Mono, monospace', fontSize: 10, letterSpacing: '0.06em',
              cursor: 'pointer',
            }}>{label}</button>
          );
        })}
      </div>

      <TweaksPanel title="Tweaks">
        <TweakSection label="Theme" />
        <TweakColor
          label="Palette"
          value={t.palette}
          options={PALETTE_CHOICES}
          onChange={(v) => {
            setTweak({ palette: v, theme: v[0].startsWith('#F') ? 'light' : 'dark' });
          }}
        />
        <TweakColor
          label="Accent"
          value={t.accent}
          options={ACCENT_CHOICES}
          onChange={(v) => {
            // also push into palette[2]
            const pal = [...t.palette];
            pal[2] = v;
            setTweak({ accent: v, palette: pal });
          }}
        />
        <TweakRadio
          label="Mode"
          value={t.theme}
          options={['dark', 'light']}
          onChange={(v) => setTweak('theme', v)}
        />
        <TweakSection label="Layout" />
        <TweakRadio
          label="Converter"
          value={t.converterVariant}
          options={['A', 'B']}
          onChange={(v) => setTweak('converterVariant', v)}
        />
        <TweakRadio
          label="Density"
          value={t.density}
          options={['comfy', 'compact']}
          onChange={(v) => setTweak('density', v)}
        />
      </TweaksPanel>
    </div>
  );
}

ReactDOM.createRoot(document.getElementById('root')).render(<App />);
