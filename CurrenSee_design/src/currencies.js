// CurrenSee — currency data + mock rates
// Rates anchored to USD = 1.000 (mid-market mock, May 2026)

window.CURRENCIES = [
  { code: 'USD', name: 'US Dollar',        symbol: '$',   flag: '🇺🇸', country: 'United States', tone: '#3C5A7E', rate: 1.0000 },
  { code: 'EUR', name: 'Euro',             symbol: '€',   flag: '🇪🇺', country: 'European Union', tone: '#1B3A8A', rate: 0.9214 },
  { code: 'GBP', name: 'British Pound',    symbol: '£',   flag: '🇬🇧', country: 'United Kingdom', tone: '#9B2D2D', rate: 0.7821 },
  { code: 'JPY', name: 'Japanese Yen',     symbol: '¥',   flag: '🇯🇵', country: 'Japan',          tone: '#C03A3A', rate: 156.42 },
  { code: 'CHF', name: 'Swiss Franc',      symbol: 'Fr',  flag: '🇨🇭', country: 'Switzerland',    tone: '#9B1B1B', rate: 0.8930 },
  { code: 'CAD', name: 'Canadian Dollar',  symbol: 'C$',  flag: '🇨🇦', country: 'Canada',         tone: '#B83A3A', rate: 1.3654 },
  { code: 'AUD', name: 'Australian Dollar',symbol: 'A$',  flag: '🇦🇺', country: 'Australia',      tone: '#1B3A6E', rate: 1.5210 },
  { code: 'NZD', name: 'New Zealand Dollar',symbol:'NZ$', flag: '🇳🇿', country: 'New Zealand',    tone: '#1B2E5C', rate: 1.6402 },
  { code: 'CNY', name: 'Chinese Yuan',     symbol: '¥',   flag: '🇨🇳', country: 'China',          tone: '#B82828', rate: 7.2410 },
  { code: 'HKD', name: 'Hong Kong Dollar', symbol: 'HK$', flag: '🇭🇰', country: 'Hong Kong',      tone: '#C0342B', rate: 7.8104 },
  { code: 'SGD', name: 'Singapore Dollar', symbol: 'S$',  flag: '🇸🇬', country: 'Singapore',      tone: '#C0342B', rate: 1.3492 },
  { code: 'INR', name: 'Indian Rupee',     symbol: '₹',   flag: '🇮🇳', country: 'India',          tone: '#D17A1F', rate: 83.47 },
  { code: 'KRW', name: 'South Korean Won', symbol: '₩',   flag: '🇰🇷', country: 'South Korea',    tone: '#1F3F8A', rate: 1372.5 },
  { code: 'MXN', name: 'Mexican Peso',     symbol: 'Mex$',flag: '🇲🇽', country: 'Mexico',         tone: '#1F7A3A', rate: 17.82 },
  { code: 'BRL', name: 'Brazilian Real',   symbol: 'R$',  flag: '🇧🇷', country: 'Brazil',         tone: '#1F7A4A', rate: 5.1140 },
  { code: 'ZAR', name: 'South African Rand',symbol:'R',   flag: '🇿🇦', country: 'South Africa',   tone: '#1F6E3A', rate: 18.45 },
  { code: 'AED', name: 'UAE Dirham',       symbol: 'د.إ', flag: '🇦🇪', country: 'United Arab Emirates', tone: '#1F5C3F', rate: 3.6730 },
  { code: 'SAR', name: 'Saudi Riyal',      symbol: '﷼',   flag: '🇸🇦', country: 'Saudi Arabia',   tone: '#1B5532', rate: 3.7510 },
  { code: 'TRY', name: 'Turkish Lira',     symbol: '₺',   flag: '🇹🇷', country: 'Turkey',         tone: '#A6232E', rate: 32.18 },
  { code: 'SEK', name: 'Swedish Krona',    symbol: 'kr',  flag: '🇸🇪', country: 'Sweden',         tone: '#1F4A8A', rate: 10.62 },
  { code: 'NOK', name: 'Norwegian Krone',  symbol: 'kr',  flag: '🇳🇴', country: 'Norway',         tone: '#1B3F7E', rate: 10.85 },
  { code: 'DKK', name: 'Danish Krone',     symbol: 'kr',  flag: '🇩🇰', country: 'Denmark',        tone: '#9B1B1B', rate: 6.8740 },
];

window.CURRENCY_BY_CODE = Object.fromEntries(window.CURRENCIES.map(c => [c.code, c]));

// Convert helper: amount of FROM in TO
window.csConvert = function(amount, fromCode, toCode) {
  const f = window.CURRENCY_BY_CODE[fromCode];
  const t = window.CURRENCY_BY_CODE[toCode];
  if (!f || !t) return 0;
  // Convert amount in FROM to USD, then USD to TO
  const usd = amount / f.rate;
  return usd * t.rate;
};

window.csRate = function(fromCode, toCode) {
  return window.csConvert(1, fromCode, toCode);
};

// Mock 30-day price series for sparklines / charts
window.csSeries = function(fromCode, toCode, days = 30, seed = 1) {
  const base = window.csRate(fromCode, toCode);
  const arr = [];
  let s = seed;
  const rand = () => {
    s = (s * 9301 + 49297) % 233280;
    return s / 233280;
  };
  let v = base * (0.96 + rand() * 0.08);
  for (let i = 0; i < days; i++) {
    const drift = (rand() - 0.48) * 0.012;
    v = v * (1 + drift);
    arr.push(v);
  }
  // Anchor last value to current rate
  arr[arr.length - 1] = base;
  return arr;
};

// Mock conversion history rows
window.MOCK_HISTORY = [
  { id: 'h1', from: 'USD', to: 'EUR', amount: 2400, rate: 0.9214, converted: 2211.36, ts: 'Today · 14:32' },
  { id: 'h2', from: 'EUR', to: 'JPY', amount: 800,  rate: 169.78, converted: 135824.00, ts: 'Today · 09:11' },
  { id: 'h3', from: 'GBP', to: 'USD', amount: 1500, rate: 1.2786, converted: 1917.90, ts: 'Yesterday' },
  { id: 'h4', from: 'USD', to: 'CHF', amount: 5000, rate: 0.8930, converted: 4465.00, ts: 'Yesterday' },
  { id: 'h5', from: 'CAD', to: 'USD', amount: 3200, rate: 0.7325, converted: 2344.00, ts: 'May 22' },
  { id: 'h6', from: 'USD', to: 'MXN', amount: 250,  rate: 17.82,  converted: 4455.00, ts: 'May 21' },
  { id: 'h7', from: 'EUR', to: 'GBP', amount: 1200, rate: 0.8488, converted: 1018.56, ts: 'May 19' },
  { id: 'h8', from: 'AUD', to: 'NZD', amount: 600,  rate: 1.0784, converted: 647.04,  ts: 'May 17' },
];

// Mock active alerts
window.MOCK_ALERTS = [
  { id: 'a1', from: 'USD', to: 'EUR', target: 0.95, condition: 'above', active: true },
  { id: 'a2', from: 'GBP', to: 'USD', target: 1.30, condition: 'above', active: true },
  { id: 'a3', from: 'USD', to: 'JPY', target: 150,  condition: 'below', active: false },
];

// Format helpers
window.fmtAmount = function(n, code) {
  const c = window.CURRENCY_BY_CODE[code];
  const decimals = (code === 'JPY' || code === 'KRW') ? 0 : 2;
  const opts = { minimumFractionDigits: decimals, maximumFractionDigits: decimals };
  return new Intl.NumberFormat('en-US', opts).format(n);
};
window.fmtRate = function(n) {
  if (n >= 100) return n.toFixed(2);
  if (n >= 10)  return n.toFixed(3);
  return n.toFixed(4);
};
