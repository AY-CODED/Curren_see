// CurrenSee — Screens part 2
// Picker, History (filled+empty), Settings, Help, Feedback, Alerts, Rate Detail, Error

/* ═══════════════════════════════════════════════════════════════
   8. CURRENCY PICKER
   ═══════════════════════════════════════════════════════════════ */
function ScrPicker({ pickerKind = 'from', selectedFrom, selectedTo, onSelect, onClose }) {
  const [q, setQ] = React.useState('');
  const selected = pickerKind === 'from' ? selectedFrom : selectedTo;
  const recents = ['USD', 'EUR', 'GBP', 'JPY'];
  const all = window.CURRENCIES;
  const filtered = all.filter(c =>
    c.code.toLowerCase().includes(q.toLowerCase()) ||
    c.name.toLowerCase().includes(q.toLowerCase()) ||
    c.country.toLowerCase().includes(q.toLowerCase())
  );
  // group by first letter
  const groups = filtered.reduce((acc, c) => {
    const k = c.code[0];
    (acc[k] = acc[k] || []).push(c);
    return acc;
  }, {});

  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSHeader
        title={pickerKind === 'from' ? 'Send from' : 'Receive in'}
        eyebrow="Choose a currency"
        left={
          <button onClick={onClose} style={{ background: 'transparent', border: 0, color: 'var(--ink-2)', cursor: 'pointer', padding: 0 }}>
            <Ico.close size={22}/>
          </button>
        }
      />
      {/* Search */}
      <div style={{ padding: '4px 22px 12px', position: 'relative' }}>
        <Ico.search size={18} color="var(--ink-3)" />
        <input
          autoFocus
          value={q}
          onChange={e => setQ(e.target.value)}
          placeholder="Search currency, country, or code"
          className="cs-input"
          style={{ paddingLeft: 46 }}
        />
        <div style={{ position: 'absolute', left: 38, top: '50%', transform: 'translateY(-50%)', color: 'var(--ink-3)' }}>
          <Ico.search size={18}/>
        </div>
      </div>

      {/* Recents */}
      {q === '' && (
        <div style={{ padding: '4px 22px 14px' }}>
          <div className="cs-eyebrow" style={{ marginBottom: 10, fontSize: 10 }}>Recent</div>
          <div style={{ display: 'flex', gap: 8, overflowX: 'auto' }}>
            {recents.map(code => {
              const isSel = code === selected;
              return (
                <button key={code} onClick={() => onSelect(code)} style={{
                  display: 'flex', alignItems: 'center', gap: 8,
                  padding: '8px 12px 8px 8px', borderRadius: 100,
                  background: isSel ? 'var(--gold-glow)' : 'var(--surface)',
                  border: `1px solid ${isSel ? 'var(--gold)' : 'var(--hairline)'}`,
                  color: isSel ? 'var(--gold)' : 'var(--ink)',
                  fontFamily: 'var(--f-mono)', fontSize: 12, letterSpacing: '0.04em',
                  cursor: 'pointer', flexShrink: 0,
                }}>
                  <CurrencyIcon code={code} size={22} />
                  {code}
                </button>
              );
            })}
          </div>
        </div>
      )}

      <div style={{ flex: 1, overflowY: 'auto', overflowX: 'hidden' }}>
        {Object.keys(groups).sort().map(letter => (
          <div key={letter}>
            <div className="cs-eyebrow" style={{
              padding: '14px 22px 6px', fontSize: 10,
              background: 'var(--bg)', position: 'sticky', top: 0, zIndex: 1,
            }}>{letter}</div>
            {groups[letter].map(c => (
              <CurrencyRow
                key={c.code}
                code={c.code}
                selected={c.code === selected}
                onClick={() => onSelect(c.code)}
                right={<span className="cs-mono" style={{ color: 'var(--ink-3)', fontSize: 11 }}>
                  {c.country}
                </span>}
              />
            ))}
          </div>
        ))}
        {filtered.length === 0 && (
          <div style={{ padding: '40px 22px', textAlign: 'center', color: 'var(--ink-3)' }}>
            <div className="cs-eyebrow" style={{ fontSize: 11 }}>No matches</div>
            <p style={{ marginTop: 8 }}>Try a country, code, or name.</p>
          </div>
        )}
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   9. HISTORY
   ═══════════════════════════════════════════════════════════════ */
function ScrHistory({ empty = false, onTabChange, onOpenItem }) {
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSHeader
        title="History"
        eyebrow={empty ? 'Nothing yet' : `${window.MOCK_HISTORY.length} conversions`}
        large
        left={<CSMark size={26}/>}
        right={<>
          <IconButton><Ico.filter size={18}/></IconButton>
          <IconButton><Ico.search size={18}/></IconButton>
        </>}
      />
      {empty ? (
        <HistoryEmpty />
      ) : (
        <div style={{ flex: 1, overflowY: 'auto' }}>
          {/* Summary card */}
          <div style={{ padding: '8px 22px 14px' }}>
            <div style={{
              padding: '16px 18px', borderRadius: 14,
              background: 'linear-gradient(135deg, var(--surface) 0%, var(--surface-2) 100%)',
              border: '1px solid var(--hairline-2)',
              display: 'flex', gap: 18, alignItems: 'center',
            }}>
              <div style={{ flex: 1 }}>
                <div className="cs-eyebrow" style={{ fontSize: 9, marginBottom: 6 }}>This month</div>
                <div style={{ display: 'flex', alignItems: 'baseline', gap: 6 }}>
                  <span style={{
                    fontFamily: 'var(--f-display)', fontSize: 30, color: 'var(--ink)',
                    letterSpacing: '-0.02em', lineHeight: 1,
                  }}>$14,820</span>
                  <span className="cs-mono" style={{ fontSize: 11, color: 'var(--ink-3)' }}>USD</span>
                </div>
                <div style={{ marginTop: 6, display: 'flex', gap: 12 }}>
                  <span className="cs-chip cs-chip-pos">+18.2%</span>
                  <span style={{ color: 'var(--ink-3)', fontSize: 11, alignSelf: 'center', fontFamily: 'var(--f-mono)' }}>vs Apr</span>
                </div>
              </div>
              <CSSparkline data={[80, 85, 78, 92, 96, 88, 102, 110, 118, 122, 138, 148]} width={88} height={48} color="var(--gold)" fillColor="var(--gold)" />
            </div>
          </div>

          {/* Filter chips */}
          <div style={{ padding: '0 22px 10px', display: 'flex', gap: 8, overflowX: 'auto' }}>
            {[
              { label: 'All', on: true },
              { label: 'This week' },
              { label: 'USD →' },
              { label: '→ EUR' },
              { label: 'Above $1k' },
            ].map((f, i) => (
              <div key={i} className={`cs-chip ${f.on ? 'cs-chip-gold' : ''}`} style={{ flexShrink: 0, cursor: 'pointer' }}>
                {f.label}
              </div>
            ))}
          </div>

          {/* Grouped list */}
          <HistoryGroup title="Today">
            {window.MOCK_HISTORY.slice(0, 2).map(h => <HistoryRow key={h.id} h={h} onClick={() => onOpenItem && onOpenItem(h)} />)}
          </HistoryGroup>
          <HistoryGroup title="Yesterday">
            {window.MOCK_HISTORY.slice(2, 4).map(h => <HistoryRow key={h.id} h={h} onClick={() => onOpenItem && onOpenItem(h)} />)}
          </HistoryGroup>
          <HistoryGroup title="Earlier in May">
            {window.MOCK_HISTORY.slice(4).map(h => <HistoryRow key={h.id} h={h} onClick={() => onOpenItem && onOpenItem(h)} />)}
          </HistoryGroup>
          <div style={{ height: 24 }}/>
        </div>
      )}
      <BottomNav active="history" onChange={onTabChange}/>
    </div>
  );
}
function HistoryGroup({ title, children }) {
  return (
    <div>
      <div className="cs-eyebrow" style={{ padding: '14px 22px 4px', fontSize: 10 }}>{title}</div>
      <div>{children}</div>
    </div>
  );
}
function HistoryRow({ h, onClick }) {
  return (
    <div onClick={onClick} style={{
      display: 'flex', alignItems: 'center', gap: 12,
      padding: '14px 22px',
      borderBottom: '1px solid var(--hairline)',
      cursor: 'pointer',
    }}>
      <div style={{ display: 'flex', position: 'relative', width: 50, flexShrink: 0 }}>
        <CurrencyIcon code={h.from} size={32}/>
        <div style={{ marginLeft: -10, zIndex: 1, border: '2px solid var(--bg)', borderRadius: '50%' }}>
          <CurrencyIcon code={h.to} size={32}/>
        </div>
      </div>
      <div style={{ flex: 1, minWidth: 0 }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 6 }}>
          <span className="cs-mono" style={{ color: 'var(--ink)', fontSize: 13, fontWeight: 500 }}>
            {h.from} → {h.to}
          </span>
          <span className="cs-mono" style={{ color: 'var(--ink-3)', fontSize: 10 }}>@ {window.fmtRate(h.rate)}</span>
        </div>
        <div style={{ marginTop: 4, color: 'var(--ink-3)', fontSize: 11, fontFamily: 'var(--f-mono)' }}>{h.ts}</div>
      </div>
      <div style={{ textAlign: 'right' }}>
        <div style={{ fontFamily: 'var(--f-display)', fontSize: 18, color: 'var(--ink)', lineHeight: 1, letterSpacing: '-0.01em' }}>
          {window.fmtAmount(h.converted, h.to)}
        </div>
        <div style={{ marginTop: 4, color: 'var(--ink-3)', fontSize: 11, fontFamily: 'var(--f-mono)' }}>
          from {window.fmtAmount(h.amount, h.from)} {h.from}
        </div>
      </div>
    </div>
  );
}
function HistoryEmpty() {
  return (
    <div style={{
      flex: 1, display: 'flex', flexDirection: 'column',
      alignItems: 'center', justifyContent: 'center', padding: '40px 32px', textAlign: 'center',
    }}>
      <div style={{
        width: 76, height: 76, borderRadius: '50%',
        background: 'var(--surface)',
        border: '1px dashed var(--hairline-2)',
        display: 'flex', alignItems: 'center', justifyContent: 'center',
        marginBottom: 22, color: 'var(--ink-3)',
      }}>
        <Ico.history size={32} stroke={1.4}/>
      </div>
      <div className="cs-label" style={{ marginBottom: 10 }}>No history</div>
      <div style={{ fontFamily: 'var(--f-display)', fontSize: 26, color: 'var(--ink)', letterSpacing: '-0.02em', lineHeight: 1.1 }}>
        Make your first <em style={{ color: 'var(--gold)' }}>conversion.</em>
      </div>
      <p style={{ marginTop: 12, color: 'var(--ink-2)', fontSize: 14, maxWidth: 280 }}>
        Saved conversions live here — every amount, rate, and date, kept private to your account.
      </p>
      <button className="cs-btn cs-btn-primary" style={{ marginTop: 26 }}>
        <Ico.plus size={16} stroke={2}/> Convert now
      </button>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   10. SETTINGS
   ═══════════════════════════════════════════════════════════════ */
function ScrSettings({ onTabChange, onNav }) {
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSHeader title="Settings" eyebrow="Account · preferences" large left={<CSMark size={26}/>} />
      <div style={{ flex: 1, overflowY: 'auto' }}>
        {/* Profile card */}
        <div style={{ padding: '8px 22px 14px' }}>
          <div style={{
            padding: '16px 18px', borderRadius: 14,
            background: 'var(--surface)', border: '1px solid var(--hairline)',
            display: 'flex', gap: 14, alignItems: 'center',
          }}>
            <div style={{
              width: 48, height: 48, borderRadius: '50%',
              background: 'linear-gradient(135deg, var(--gold), var(--gold-deep))',
              color: '#0A0E1A',
              display: 'flex', alignItems: 'center', justifyContent: 'center',
              fontFamily: 'var(--f-display)', fontSize: 20, fontStyle: 'italic',
              boxShadow: '0 4px 16px var(--gold-glow)',
            }}>A</div>
            <div style={{ flex: 1, minWidth: 0 }}>
              <div style={{ color: 'var(--ink)', fontSize: 15, fontWeight: 500 }}>Alex Morgan</div>
              <div style={{ color: 'var(--ink-3)', fontSize: 12, fontFamily: 'var(--f-mono)' }}>alex@currensee.app</div>
            </div>
            <Ico.chevronRight size={18} color="var(--ink-3)"/>
          </div>
        </div>

        <SettingsSection title="Preferences">
          <SettingsRow icon={<Ico.globe size={18}/>} label="Default base currency" value="USD" />
          <SettingsRow icon={<Ico.refresh size={18}/>} label="Auto-refresh rates" rightToggle defaultOn />
          <SettingsRow icon={<Ico.zap size={18}/>} label="Decimal precision" value="Auto" />
          <SettingsRow icon={<Ico.settings size={18}/>} label="Appearance" value="Dark" />
        </SettingsSection>

        <SettingsSection title="Notifications">
          <SettingsRow icon={<Ico.bell size={18}/>} label="Rate alerts" rightToggle defaultOn />
          <SettingsRow icon={<Ico.trend size={18}/>} label="Weekly market digest" rightToggle />
          <SettingsRow icon={<Ico.mail size={18}/>} label="Email confirmations" rightToggle defaultOn />
        </SettingsSection>

        <SettingsSection title="Support">
          <SettingsRow icon={<Ico.help size={18}/>} label="Help center" hasArrow onClick={() => onNav && onNav('help')} />
          <SettingsRow icon={<Ico.send size={18}/>} label="Send feedback" hasArrow onClick={() => onNav && onNav('feedback')} />
          <SettingsRow icon={<Ico.shield size={18}/>} label="Privacy & security" hasArrow />
        </SettingsSection>

        <div style={{ padding: '20px 22px 24px' }}>
          <button className="cs-btn cs-btn-ghost" style={{ width: '100%' }}>
            <Ico.close size={16} stroke={1.8}/> Sign out
          </button>
          <div style={{ marginTop: 16, textAlign: 'center', color: 'var(--ink-3)', fontSize: 11, fontFamily: 'var(--f-mono)', letterSpacing: '0.08em' }}>
            v 1.0.0 · build 2026.05
          </div>
        </div>
      </div>
      <BottomNav active="settings" onChange={onTabChange}/>
    </div>
  );
}
function SettingsSection({ title, children }) {
  return (
    <div style={{ padding: '6px 22px 18px' }}>
      <div className="cs-eyebrow" style={{ fontSize: 10, marginBottom: 10 }}>{title}</div>
      <div style={{
        background: 'var(--surface)', border: '1px solid var(--hairline)',
        borderRadius: 14, overflow: 'hidden',
      }}>
        {children}
      </div>
    </div>
  );
}
function SettingsRow({ icon, label, value, hasArrow, rightToggle, defaultOn, onClick }) {
  const [on, setOn] = React.useState(!!defaultOn);
  return (
    <div onClick={onClick} style={{
      display: 'flex', alignItems: 'center', gap: 14,
      padding: '14px 16px',
      borderBottom: '1px solid var(--hairline)',
      cursor: onClick ? 'pointer' : 'default',
    }}>
      <div style={{
        width: 32, height: 32, borderRadius: 8,
        background: 'var(--surface-2)', color: 'var(--gold)',
        display: 'flex', alignItems: 'center', justifyContent: 'center', flexShrink: 0,
      }}>{icon}</div>
      <div style={{ flex: 1, color: 'var(--ink)', fontSize: 14 }}>{label}</div>
      {value && <div style={{ color: 'var(--ink-2)', fontSize: 13, fontFamily: 'var(--f-mono)' }}>{value}</div>}
      {hasArrow && <Ico.chevronRight size={16} color="var(--ink-3)"/>}
      {rightToggle && (
        <div onClick={(e) => { e.stopPropagation(); setOn(!on); }} style={{
          width: 36, height: 22, borderRadius: 100,
          background: on ? 'var(--gold)' : 'var(--hairline-2)',
          position: 'relative', transition: 'background .2s',
          cursor: 'pointer', flexShrink: 0,
        }}>
          <div style={{
            position: 'absolute', top: 2, left: on ? 16 : 2,
            width: 18, height: 18, borderRadius: '50%',
            background: on ? '#0A0E1A' : 'var(--ink-3)',
            transition: 'left .2s',
          }}/>
        </div>
      )}
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   11. HELP / FAQ
   ═══════════════════════════════════════════════════════════════ */
function ScrHelp({ onBack }) {
  const [open, setOpen] = React.useState(0);
  const items = [
    { q: 'Where do exchange rates come from?', a: 'Rates are pulled from exchangerate.host every 60 seconds. They reflect mid-market reference values — the rate banks use among themselves, before any spread.' },
    { q: 'Are conversions actually transferred?', a: 'No. CurrenSee is a viewer — it tells you what your money is worth. To actually move money, use your bank or a transfer service.' },
    { q: 'How do rate alerts work?', a: 'Pick a currency pair and a target. We check the market in the background and send you a notification the moment your condition is met. Up to 10 active alerts.' },
    { q: 'Is my data private?', a: 'Yes. Conversion history and alerts are stored under your account only. We don\'t share or sell anything — see our Privacy policy.' },
    { q: 'Can I use it offline?', a: 'You can browse cached rates and your history. New conversions and alerts need a connection.' },
    { q: 'Why does the converted amount blink?', a: 'It\'s a fresh calculation — rates change constantly. The blink confirms you\'re seeing the most current value.' },
  ];
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSHeader
        title="Help"
        eyebrow="Frequently asked"
        large
        left={
          <button onClick={onBack} style={{ background: 'transparent', border: 0, color: 'var(--ink-2)', cursor: 'pointer', padding: 0 }}>
            <Ico.back size={22}/>
          </button>
        }
      />
      {/* Quick links */}
      <div style={{ padding: '8px 22px 16px', display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 10 }}>
        {[
          { Icon: Ico.mail, label: 'Email us' },
          { Icon: Ico.send, label: 'Feedback' },
          { Icon: Ico.shield, label: 'Privacy' },
          { Icon: Ico.globe, label: 'Status' },
        ].map((q, i) => (
          <div key={i} style={{
            padding: '14px', borderRadius: 12,
            background: 'var(--surface)', border: '1px solid var(--hairline)',
            display: 'flex', alignItems: 'center', gap: 10,
            cursor: 'pointer',
          }}>
            <div style={{ color: 'var(--gold)' }}><q.Icon size={18}/></div>
            <div style={{ color: 'var(--ink)', fontSize: 13, fontWeight: 500 }}>{q.label}</div>
          </div>
        ))}
      </div>
      <div style={{ padding: '4px 22px 0' }}>
        <div className="cs-eyebrow" style={{ fontSize: 10, marginBottom: 8 }}>Top questions</div>
      </div>
      <div style={{ flex: 1, overflowY: 'auto', padding: '0 22px 24px' }}>
        {items.map((it, i) => {
          const isOpen = open === i;
          return (
            <div key={i} style={{
              borderBottom: '1px solid var(--hairline)',
              padding: '14px 0',
            }}>
              <div onClick={() => setOpen(isOpen ? -1 : i)} style={{
                display: 'flex', alignItems: 'center', gap: 12, cursor: 'pointer',
              }}>
                <div style={{ flex: 1, color: 'var(--ink)', fontSize: 14, fontWeight: 500 }}>{it.q}</div>
                <div style={{
                  width: 24, height: 24, borderRadius: '50%',
                  display: 'flex', alignItems: 'center', justifyContent: 'center',
                  background: isOpen ? 'var(--gold)' : 'transparent',
                  color: isOpen ? '#0A0E1A' : 'var(--ink-3)',
                  border: isOpen ? '0' : '1px solid var(--hairline-2)',
                  transition: 'transform .2s',
                  transform: isOpen ? 'rotate(180deg)' : 'rotate(0)',
                }}>
                  <Ico.chevronDown size={14} stroke={2}/>
                </div>
              </div>
              {isOpen && (
                <p className="cs-enter" style={{ marginTop: 10, color: 'var(--ink-2)', fontSize: 13, lineHeight: 1.6, marginBottom: 0 }}>
                  {it.a}
                </p>
              )}
            </div>
          );
        })}
        <div style={{
          marginTop: 22, padding: '18px',
          borderRadius: 14,
          background: 'linear-gradient(135deg, var(--gold-glow), transparent)',
          border: '1px solid rgba(201,169,97,0.25)',
        }}>
          <div className="cs-label" style={{ marginBottom: 6 }}>Still stuck?</div>
          <div style={{ fontFamily: 'var(--f-display)', fontSize: 22, color: 'var(--ink)', letterSpacing: '-0.02em' }}>
            We reply within <em style={{ color: 'var(--gold)' }}>4 hours.</em>
          </div>
          <button className="cs-btn cs-btn-primary" style={{ marginTop: 14, width: '100%' }}>
            Contact support
            <Ico.send size={14} stroke={2}/>
          </button>
        </div>
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   12. FEEDBACK
   ═══════════════════════════════════════════════════════════════ */
function ScrFeedback({ onBack, onSend }) {
  const [type, setType] = React.useState(0);
  const types = [
    { label: 'Idea', Icon: Ico.zap },
    { label: 'Issue', Icon: Ico.shield },
    { label: 'Praise', Icon: Ico.star },
  ];
  const [val, setVal] = React.useState('');
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSHeader
        title="Feedback"
        eyebrow="We read everything"
        large
        left={
          <button onClick={onBack} style={{ background: 'transparent', border: 0, color: 'var(--ink-2)', cursor: 'pointer', padding: 0 }}>
            <Ico.back size={22}/>
          </button>
        }
      />
      <div style={{ flex: 1, padding: '8px 22px 0', display: 'flex', flexDirection: 'column' }}>
        <div className="cs-eyebrow" style={{ fontSize: 10, marginBottom: 10 }}>What's on your mind?</div>
        <div style={{ display: 'flex', gap: 10, marginBottom: 18 }}>
          {types.map((t, i) => {
            const on = type === i;
            return (
              <button key={i} onClick={() => setType(i)} style={{
                flex: 1, padding: '14px 8px', borderRadius: 12,
                background: on ? 'var(--gold-glow)' : 'var(--surface)',
                border: `1px solid ${on ? 'var(--gold)' : 'var(--hairline)'}`,
                color: on ? 'var(--gold)' : 'var(--ink-2)',
                display: 'flex', flexDirection: 'column', alignItems: 'center', gap: 8,
                cursor: 'pointer',
                fontFamily: 'var(--f-mono)', fontSize: 11, letterSpacing: '0.08em', textTransform: 'uppercase',
              }}>
                <t.Icon size={20} stroke={1.6}/>
                {t.label}
              </button>
            );
          })}
        </div>

        <div className="cs-eyebrow" style={{ fontSize: 10, marginBottom: 8 }}>Tell us more</div>
        <textarea
          value={val}
          onChange={e => setVal(e.target.value)}
          placeholder={
            type === 0 ? 'A feature you wish existed…' :
            type === 1 ? 'Where did it break, and what were you trying to do?' :
            'What did you love? We\'ll pass it along to the team.'
          }
          className="cs-input"
          style={{ minHeight: 140, resize: 'none', fontFamily: 'var(--f-sans)', lineHeight: 1.5 }}
        />
        <div style={{ marginTop: 6, color: 'var(--ink-3)', fontSize: 11, textAlign: 'right', fontFamily: 'var(--f-mono)' }}>
          {val.length} / 600
        </div>

        <div style={{ marginTop: 20, padding: 14, borderRadius: 12, background: 'var(--surface)', border: '1px solid var(--hairline)', display: 'flex', gap: 12 }}>
          <div style={{ color: 'var(--gold)' }}><Ico.mail size={18}/></div>
          <div style={{ flex: 1, color: 'var(--ink-2)', fontSize: 12, lineHeight: 1.5 }}>
            We'll reply to <span style={{ color: 'var(--ink)' }}>alex@currensee.app</span>. Include screenshots in your email reply if helpful.
          </div>
        </div>

        <div style={{ marginTop: 'auto', padding: '20px 0 8px' }}>
          <button onClick={onSend} className="cs-btn cs-btn-primary" style={{ width: '100%', padding: '18px' }}>
            Send feedback
            <Ico.send size={14} stroke={2}/>
          </button>
        </div>
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   13. ALERTS
   ═══════════════════════════════════════════════════════════════ */
function ScrAlerts({ onTabChange, onNew }) {
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSHeader
        title="Alerts"
        eyebrow={`${window.MOCK_ALERTS.filter(a => a.active).length} active · ${window.MOCK_ALERTS.length} total`}
        large
        left={<CSMark size={26}/>}
        right={<IconButton onClick={onNew}><Ico.plus size={18}/></IconButton>}
      />

      <div style={{ flex: 1, overflowY: 'auto', padding: '8px 22px 0' }}>
        {window.MOCK_ALERTS.map(a => <AlertCard key={a.id} a={a} />)}

        <div style={{
          marginTop: 12, padding: 18, borderRadius: 14,
          border: '1px dashed var(--hairline-2)',
          background: 'rgba(255,255,255,0.02)',
          display: 'flex', alignItems: 'center', gap: 14,
          cursor: 'pointer',
        }} onClick={onNew}>
          <div style={{
            width: 40, height: 40, borderRadius: '50%',
            background: 'var(--gold-glow)', color: 'var(--gold)',
            display: 'flex', alignItems: 'center', justifyContent: 'center',
            border: '1px solid var(--gold)',
          }}>
            <Ico.plus size={20} stroke={2}/>
          </div>
          <div>
            <div style={{ color: 'var(--ink)', fontSize: 14, fontWeight: 500 }}>New alert</div>
            <div style={{ color: 'var(--ink-3)', fontSize: 12 }}>Watch a pair, get notified</div>
          </div>
        </div>
      </div>
      <BottomNav active="alerts" onChange={onTabChange}/>
    </div>
  );
}
function AlertCard({ a }) {
  const current = window.csRate(a.from, a.to);
  const distance = ((a.target - current) / current * 100);
  const triggered = a.condition === 'above' ? current >= a.target : current <= a.target;
  return (
    <div style={{
      padding: '16px 18px',
      marginBottom: 10,
      borderRadius: 14,
      background: 'var(--surface)', border: '1px solid var(--hairline)',
      opacity: a.active ? 1 : 0.5,
    }}>
      <div style={{ display: 'flex', alignItems: 'center', gap: 12, marginBottom: 12 }}>
        <div style={{ display: 'flex', position: 'relative' }}>
          <CurrencyIcon code={a.from} size={28}/>
          <div style={{ marginLeft: -8, border: '2px solid var(--surface)', borderRadius: '50%' }}>
            <CurrencyIcon code={a.to} size={28}/>
          </div>
        </div>
        <div style={{ flex: 1 }}>
          <div className="cs-mono" style={{ color: 'var(--ink)', fontSize: 13, letterSpacing: '0.04em' }}>
            {a.from} → {a.to}
          </div>
          <div style={{ marginTop: 2, color: 'var(--ink-3)', fontSize: 11, fontFamily: 'var(--f-mono)' }}>
            When rate goes {a.condition} <span style={{ color: 'var(--gold)' }}>{a.target.toFixed(4)}</span>
          </div>
        </div>
        <div className={`cs-chip ${a.active ? 'cs-chip-gold' : ''}`}>
          {a.active ? 'Watching' : 'Paused'}
        </div>
      </div>
      <div style={{
        position: 'relative', height: 38,
        padding: '4px 0',
      }}>
        <div style={{
          position: 'absolute', top: 18, left: 0, right: 0, height: 1,
          background: 'var(--hairline)',
        }}/>
        {/* current marker */}
        <div style={{
          position: 'absolute', top: 14, left: '38%',
          width: 8, height: 8, borderRadius: '50%',
          background: 'var(--ink-2)',
        }}/>
        <div style={{
          position: 'absolute', top: 24, left: '38%', transform: 'translateX(-50%)',
          fontFamily: 'var(--f-mono)', fontSize: 9, color: 'var(--ink-3)',
        }}>now {window.fmtRate(current)}</div>
        {/* target marker */}
        <div style={{
          position: 'absolute', top: 12, left: '72%',
          width: 12, height: 12, borderRadius: '50%',
          background: triggered ? 'var(--positive)' : 'var(--gold)',
          boxShadow: triggered ? '0 0 0 4px var(--positive-soft)' : '0 0 0 4px var(--gold-glow)',
        }}/>
        <div style={{
          position: 'absolute', top: 26, left: '72%', transform: 'translateX(-50%)',
          fontFamily: 'var(--f-mono)', fontSize: 9, color: 'var(--gold)',
        }}>target</div>
      </div>
      <div style={{ marginTop: 8, color: 'var(--ink-3)', fontSize: 11, fontFamily: 'var(--f-mono)', display: 'flex', justifyContent: 'space-between' }}>
        <span>{distance >= 0 ? '+' : ''}{distance.toFixed(2)}% away</span>
        <span>Created May 12</span>
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   14. RATE DETAIL — chart
   ═══════════════════════════════════════════════════════════════ */
function ScrRateDetail({ from = 'GBP', to = 'USD', onBack }) {
  const [range, setRange] = React.useState('1M');
  const days = { '1D': 24, '1W': 24, '1M': 30, '3M': 90, '1Y': 90, 'All': 90 }[range];
  const seed = { '1D': 3, '1W': 7, '1M': 11, '3M': 17, '1Y': 23, 'All': 31 }[range];
  const series = useMemo(() => window.csSeries(from, to, days, seed), [from, to, days, seed]);
  const min = Math.min(...series);
  const max = Math.max(...series);
  const current = series[series.length - 1];
  const open = series[0];
  const change = current - open;
  const changePct = (change / open) * 100;
  const positive = change >= 0;

  // Build SVG path
  const W = 336;
  const H = 200;
  const pad = 2;
  const points = series.map((v, i) => {
    const x = (i / (series.length - 1)) * (W - pad * 2) + pad;
    const y = H - pad - ((v - min) / (max - min || 1)) * (H - pad * 2);
    return [x, y];
  });
  const path = points.map((p, i) => (i === 0 ? `M${p[0]},${p[1]}` : `L${p[0]},${p[1]}`)).join(' ');
  const area = path + ` L${W - pad},${H} L${pad},${H} Z`;

  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSHeader
        title={`${from}/${to}`}
        eyebrow="Rate detail"
        left={
          <button onClick={onBack} style={{ background: 'transparent', border: 0, color: 'var(--ink-2)', cursor: 'pointer', padding: 0 }}>
            <Ico.back size={22}/>
          </button>
        }
        right={<>
          <IconButton><Ico.bell size={18}/></IconButton>
          <IconButton><Ico.star size={18}/></IconButton>
        </>}
      />
      {/* Hero number */}
      <div style={{ padding: '8px 22px 0' }}>
        <div style={{ display: 'flex', alignItems: 'baseline', gap: 10 }}>
          <span style={{
            fontFamily: 'var(--f-display)', fontSize: 56, lineHeight: 1,
            color: 'var(--ink)', letterSpacing: '-0.03em',
          }}>{window.fmtRate(current)}</span>
          <span className="cs-mono" style={{ fontSize: 13, color: 'var(--ink-3)' }}>{to}</span>
        </div>
        <div style={{ marginTop: 10, display: 'flex', alignItems: 'center', gap: 10 }}>
          <span className={`cs-chip ${positive ? 'cs-chip-pos' : 'cs-chip-neg'}`}>
            {positive ? '▲' : '▼'} {Math.abs(change).toFixed(4)}
          </span>
          <span style={{ color: positive ? 'var(--positive)' : 'var(--negative)', fontFamily: 'var(--f-mono)', fontSize: 13 }}>
            {positive ? '+' : ''}{changePct.toFixed(2)}%
          </span>
          <span style={{ color: 'var(--ink-3)', fontSize: 12, fontFamily: 'var(--f-mono)' }}>· {range}</span>
        </div>
      </div>

      {/* Chart */}
      <div style={{ padding: '20px 22px 0' }}>
        <svg width="100%" viewBox={`0 0 ${W} ${H}`} preserveAspectRatio="none" style={{ display: 'block' }}>
          <defs>
            <linearGradient id="rdfill" x1="0" x2="0" y1="0" y2="1">
              <stop offset="0%" stopColor="var(--gold)" stopOpacity="0.35"/>
              <stop offset="100%" stopColor="var(--gold)" stopOpacity="0"/>
            </linearGradient>
          </defs>
          {/* horizontal grid */}
          {[0.2, 0.4, 0.6, 0.8].map((r, i) => (
            <line key={i} x1="0" x2={W} y1={H * r} y2={H * r} stroke="var(--hairline)" strokeDasharray="3 4" />
          ))}
          <path d={area} fill="url(#rdfill)" />
          <path d={path} stroke="var(--gold)" strokeWidth="1.8" fill="none" strokeLinecap="round" />
          {/* last marker */}
          <circle cx={points[points.length-1][0]} cy={points[points.length-1][1]} r="4" fill="var(--gold)" />
          <circle cx={points[points.length-1][0]} cy={points[points.length-1][1]} r="9" fill="var(--gold)" opacity="0.2" />
        </svg>
      </div>

      {/* Range tabs */}
      <div style={{
        margin: '14px 22px 8px',
        padding: 4,
        borderRadius: 100,
        background: 'var(--surface)',
        border: '1px solid var(--hairline)',
        display: 'flex',
      }}>
        {['1D', '1W', '1M', '3M', '1Y', 'All'].map(r => {
          const on = range === r;
          return (
            <button key={r} onClick={() => setRange(r)} style={{
              flex: 1, padding: '8px 0', borderRadius: 100,
              background: on ? 'var(--gold)' : 'transparent',
              color: on ? '#0A0E1A' : 'var(--ink-2)',
              border: 0, cursor: 'pointer',
              fontFamily: 'var(--f-mono)', fontSize: 11, fontWeight: 600,
              letterSpacing: '0.08em',
            }}>{r}</button>
          );
        })}
      </div>

      {/* Stats grid */}
      <div style={{ padding: '14px 22px', display: 'grid', gridTemplateColumns: 'repeat(2, 1fr)', gap: 10 }}>
        {[
          { label: 'Open', val: window.fmtRate(open) },
          { label: 'High', val: window.fmtRate(max) },
          { label: 'Low',  val: window.fmtRate(min) },
          { label: 'Avg',  val: window.fmtRate(series.reduce((a,b)=>a+b,0)/series.length) },
        ].map((s, i) => (
          <div key={i} style={{
            padding: '12px 14px', borderRadius: 12,
            background: 'var(--surface)', border: '1px solid var(--hairline)',
            display: 'flex', justifyContent: 'space-between', alignItems: 'center',
          }}>
            <div className="cs-eyebrow" style={{ fontSize: 9 }}>{s.label}</div>
            <div className="cs-mono" style={{ fontSize: 14, color: 'var(--ink)' }}>{s.val}</div>
          </div>
        ))}
      </div>

      {/* CTA */}
      <div style={{ padding: '6px 22px 22px', display: 'flex', gap: 10 }}>
        <button className="cs-btn cs-btn-ghost" style={{ flex: 1 }}>
          <Ico.bell size={14}/> Set alert
        </button>
        <button className="cs-btn cs-btn-primary" style={{ flex: 1 }}>
          <Ico.refresh size={14}/> Convert
        </button>
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   15. NEW ALERT MODAL (used over Alerts screen)
   ═══════════════════════════════════════════════════════════════ */
function ScrNewAlert({ onBack, onSave }) {
  const [from, setFrom] = React.useState('USD');
  const [to, setTo] = React.useState('EUR');
  const [target, setTarget] = React.useState(0.95);
  const [cond, setCond] = React.useState('above');
  const current = window.csRate(from, to);
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSHeader
        title="New alert"
        eyebrow="We'll watch for you"
        left={
          <button onClick={onBack} style={{ background: 'transparent', border: 0, color: 'var(--ink-2)', cursor: 'pointer', padding: 0 }}>
            <Ico.close size={22}/>
          </button>
        }
      />
      <div style={{ flex: 1, padding: '8px 22px 0' }}>
        <div className="cs-eyebrow" style={{ fontSize: 10, marginBottom: 10 }}>Currency pair</div>
        <div style={{
          padding: '14px 16px', borderRadius: 14,
          background: 'var(--surface)', border: '1px solid var(--hairline)',
          display: 'flex', alignItems: 'center', gap: 14,
        }}>
          <button style={{ background: 'transparent', border: 0, padding: 0, color: 'inherit', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 8 }}>
            <CurrencyIcon code={from} size={28}/>
            <span className="cs-mono" style={{ fontSize: 14, color: 'var(--ink)' }}>{from}</span>
          </button>
          <Ico.forward size={14} color="var(--ink-3)"/>
          <button style={{ background: 'transparent', border: 0, padding: 0, color: 'inherit', cursor: 'pointer', display: 'flex', alignItems: 'center', gap: 8 }}>
            <CurrencyIcon code={to} size={28}/>
            <span className="cs-mono" style={{ fontSize: 14, color: 'var(--ink)' }}>{to}</span>
          </button>
          <div style={{ marginLeft: 'auto' }} className="cs-chip">{window.fmtRate(current)}</div>
        </div>

        <div className="cs-eyebrow" style={{ fontSize: 10, margin: '20px 0 10px' }}>Notify me when rate goes</div>
        <div style={{ display: 'flex', gap: 10 }}>
          {['above', 'below'].map(c => {
            const on = cond === c;
            return (
              <button key={c} onClick={() => setCond(c)} style={{
                flex: 1, padding: '14px', borderRadius: 12,
                background: on ? 'var(--gold-glow)' : 'var(--surface)',
                border: `1px solid ${on ? 'var(--gold)' : 'var(--hairline)'}`,
                color: on ? 'var(--gold)' : 'var(--ink-2)',
                fontFamily: 'var(--f-mono)', fontSize: 13, letterSpacing: '0.04em', textTransform: 'capitalize',
                cursor: 'pointer',
                display: 'flex', alignItems: 'center', justifyContent: 'center', gap: 8,
              }}>
                {c === 'above' ? <Ico.arrowUp size={16}/> : <Ico.arrowDown size={16}/>}
                {c}
              </button>
            );
          })}
        </div>

        <div className="cs-eyebrow" style={{ fontSize: 10, margin: '20px 0 10px' }}>Target rate</div>
        <div style={{
          padding: '18px 18px', borderRadius: 14,
          background: 'var(--surface)', border: '1px solid var(--hairline)',
          display: 'flex', alignItems: 'baseline', gap: 10,
        }}>
          <input
            type="number" step="0.0001" value={target}
            onChange={e => setTarget(parseFloat(e.target.value) || 0)}
            style={{
              flex: 1, background: 'transparent', border: 0, outline: 'none',
              fontFamily: 'var(--f-display)', fontSize: 36, color: 'var(--ink)',
              letterSpacing: '-0.025em', padding: 0,
            }}
          />
          <span className="cs-mono" style={{ color: 'var(--ink-3)', fontSize: 13 }}>{to}</span>
        </div>
        <div style={{ marginTop: 8, color: 'var(--ink-3)', fontSize: 12, fontFamily: 'var(--f-mono)' }}>
          Current is <span style={{ color: 'var(--gold)' }}>{window.fmtRate(current)}</span> · target is {((target - current)/current*100).toFixed(2)}% {target > current ? 'higher' : 'lower'}
        </div>
      </div>
      <div style={{ padding: '16px 22px 16px' }}>
        <button onClick={onSave} className="cs-btn cs-btn-primary" style={{ width: '100%', padding: '18px' }}>
          Create alert
          <Ico.bell size={14} stroke={2}/>
        </button>
      </div>
    </div>
  );
}

/* ═══════════════════════════════════════════════════════════════
   16. ERROR STATE — offline / API failure
   ═══════════════════════════════════════════════════════════════ */
function ScrError() {
  return (
    <div className="cs-app" style={{ height: '100%', display: 'flex', flexDirection: 'column' }}>
      <CSHeader title="Converter" eyebrow="Offline" left={<CSMark size={26}/>} />
      <div style={{ flex: 1, padding: '20px 28px 0', display: 'flex', flexDirection: 'column', alignItems: 'center', justifyContent: 'center', textAlign: 'center' }}>
        <div style={{
          width: 76, height: 76, borderRadius: '50%',
          background: 'var(--negative-soft)', border: '1px solid rgba(216,108,92,0.3)',
          display: 'flex', alignItems: 'center', justifyContent: 'center',
          marginBottom: 22, color: 'var(--negative)',
        }}>
          <Ico.globe size={32} stroke={1.4}/>
        </div>
        <div className="cs-label" style={{ marginBottom: 10, color: 'var(--negative)' }}>Can't reach the market</div>
        <div style={{ fontFamily: 'var(--f-display)', fontSize: 28, color: 'var(--ink)', letterSpacing: '-0.02em', lineHeight: 1.1 }}>
          Rates haven't updated <em style={{ color: 'var(--gold)' }}>since 9:12.</em>
        </div>
        <p style={{ marginTop: 14, color: 'var(--ink-2)', fontSize: 14, maxWidth: 280 }}>
          You're seeing cached rates from earlier today. Conversions made now will sync when you're back online.
        </p>
        <div style={{
          marginTop: 22, padding: '14px 18px', borderRadius: 12,
          background: 'var(--surface)', border: '1px solid var(--hairline)',
          display: 'flex', alignItems: 'center', gap: 10,
        }}>
          <span style={{ width: 8, height: 8, borderRadius: '50%', background: 'var(--negative)', animation: 'cs-pulse 1.5s ease-in-out infinite' }}/>
          <style>{`@keyframes cs-pulse{0%,100%{opacity:1}50%{opacity:.3}}`}</style>
          <span style={{ fontFamily: 'var(--f-mono)', fontSize: 11, color: 'var(--ink-2)', letterSpacing: '0.04em' }}>
            Retrying every 10 seconds
          </span>
        </div>
        <button className="cs-btn cs-btn-primary" style={{ marginTop: 18 }}>
          <Ico.refresh size={14} stroke={2}/> Try now
        </button>
      </div>
      <BottomNav active="converter"/>
    </div>
  );
}

Object.assign(window, {
  ScrPicker, ScrHistory, ScrSettings, ScrHelp, ScrFeedback,
  ScrAlerts, ScrRateDetail, ScrNewAlert, ScrError,
  HistoryRow, AlertCard, SettingsRow, SettingsSection, HistoryEmpty,
});
