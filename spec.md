\# CurrenSee App Specification



\## 1. Project Overview



CurrenSee is a simple mobile-first currency conversion app built with Flutter and Firebase. The app allows users to create accounts, convert currencies using live exchange rates, view past conversions, save preferences, and optionally set rate alerts.



The project should prioritize simplicity, clean UI, and fast execution. This is not a complex fintech app. It is a student-level practical project that demonstrates authentication, API consumption, cloud database usage, and mobile UI development.



\---



\## 2. North Star



Build a fast, simple app that lets users know what their money is worth instantly.



\### Core User Flow



User signs up → selects currencies → enters amount → gets converted result → conversion is saved to history.



\---



\## 3. Tech Stack



\### Frontend



\* Flutter

\* Dart



\### Backend-as-a-Service



\* Firebase



\### Firebase Services



\* Firebase Authentication

\* Cloud Firestore

\* Firebase Cloud Messaging (optional for rate alerts)



\### External API



Use one exchange-rate provider:



\* ExchangeRate-API

\* Fixer

\* CurrencyLayer

\* exchangerate.host



Prefer a free/simple API for MVP.



\### Flutter Packages



Use:



\* firebase\_core

\* firebase\_auth

\* cloud\_firestore

\* http or dio

\* provider, riverpod, or bloc

\* intl

\* fl\_chart (optional for charts)



Recommended state management: Riverpod or Provider.



\---



\## 4. MVP Features



\### 4.1 Authentication



Users should be able to:



\* Register with email and password

\* Login with email and password

\* Logout

\* Stay logged in after reopening the app



\### 4.2 Currency Converter



Users should be able to:



\* Select base currency

\* Select target currency

\* Enter amount

\* Fetch live exchange rate

\* View converted amount

\* Swap base and target currencies

\* Save successful conversion to Firestore



\### 4.3 Currency List



Users should be able to:



\* View supported currencies

\* Search currencies

\* See currency code, name, and symbol where available



\### 4.4 Conversion History



Users should be able to:



\* View previous conversions

\* See amount, base currency, target currency, rate, converted amount, and date

\* Clear history (optional)



\### 4.5 User Preferences



Users should be able to:



\* Set default base currency

\* Save last-used base and target currency

\* Load these preferences when app opens



\### 4.6 Feedback



Users should be able to:



\* Submit feedback or report an issue



\### 4.7 Help Center



Include a simple static FAQ/help screen.



\---



\## 5. Optional V2 Features



Do not build these first unless MVP is complete:



\* Historical exchange rate charts

\* Rate alerts

\* Push notifications

\* Currency market news

\* User profile editing

\* Dark mode



\---



\## 6. App Screens



\### Auth Screens



\* Splash screen

\* Login screen

\* Register screen

\* Forgot password screen (optional)



\### Main Screens



\* Home / Converter screen

\* Currency picker screen

\* Conversion history screen

\* Settings/preferences screen

\* Help/FAQ screen

\* Feedback screen



Use bottom navigation for:



\* Converter

\* History

\* Settings



\---



\## 7. Firestore Structure



```txt

users/{userId}

&#x20; fullName: string

&#x20; email: string

&#x20; defaultBaseCurrency: string

&#x20; lastBaseCurrency: string

&#x20; lastTargetCurrency: string

&#x20; createdAt: timestamp

&#x20; updatedAt: timestamp



users/{userId}/conversion\_history/{historyId}

&#x20; baseCurrency: string

&#x20; targetCurrency: string

&#x20; amount: number

&#x20; rate: number

&#x20; convertedAmount: number

&#x20; createdAt: timestamp



users/{userId}/rate\_alerts/{alertId}

&#x20; baseCurrency: string

&#x20; targetCurrency: string

&#x20; targetRate: number

&#x20; condition: string // "above" or "below"

&#x20; isActive: boolean

&#x20; createdAt: timestamp



feedback/{feedbackId}

&#x20; userId: string

&#x20; email: string

&#x20; message: string

&#x20; createdAt: timestamp

```



\---



\## 8. Suggested Folder Structure



```txt

lib/

&#x20; main.dart

&#x20; app.dart



&#x20; core/

&#x20;   constants/

&#x20;     app\_colors.dart

&#x20;     app\_strings.dart

&#x20;   config/

&#x20;     firebase\_options.dart

&#x20;   utils/

&#x20;     currency\_formatter.dart

&#x20;     validators.dart

&#x20;   services/

&#x20;     exchange\_rate\_service.dart

&#x20;     auth\_service.dart

&#x20;     firestore\_service.dart



&#x20; features/

&#x20;   auth/

&#x20;     screens/

&#x20;     widgets/

&#x20;     providers/

&#x20;   converter/

&#x20;     screens/

&#x20;     widgets/

&#x20;     providers/

&#x20;     models/

&#x20;   history/

&#x20;     screens/

&#x20;     widgets/

&#x20;     providers/

&#x20;   settings/

&#x20;     screens/

&#x20;     widgets/

&#x20;     providers/

&#x20;   feedback/

&#x20;     screens/

&#x20;     providers/

&#x20;   help/

&#x20;     screens/



&#x20; shared/

&#x20;   widgets/

&#x20;     app\_button.dart

&#x20;     app\_text\_field.dart

&#x20;     loading\_view.dart

&#x20;     error\_view.dart

```



\---



\## 9. UI Direction



\### Design Style



\* Clean

\* Modern

\* Mobile-first

\* Financial but friendly

\* Simple cards

\* Clear typography

\* Large conversion result

\* Minimal clutter



\### Suggested Colors



\* Primary: deep blue or green

\* Accent: light green or gold

\* Background: off-white

\* Text: near-black



\---



\## 10. Business Logic



\### Conversion Formula



```txt

convertedAmount = amount \* exchangeRate

```



\### Example Flow



1\. User enters 100

2\. Base currency: USD

3\. Target currency: NGN

4\. App fetches USD to NGN rate

5\. App displays converted amount

6\. App saves the conversion to Firestore



\---



\## 11. Error Handling



Handle:



\* No internet connection

\* Invalid amount

\* API failure

\* Unsupported currency

\* Firebase auth error

\* Empty history

\* Firestore write failure



Show friendly messages, not raw error dumps.



\---



\## 12. Security Rules



Firestore should only allow authenticated users to access their own user document and history.



\### Basic Rule Idea



```js

users/{userId} can only be read/written by request.auth.uid == userId

users/{userId}/conversion\_history/{historyId} can only be read/written by request.auth.uid == userId

feedback can be created by authenticated users

```



\---



\## 13. Development Phases



\### Phase 1: Setup



\* Create Flutter project

\* Connect Firebase

\* Set up packages

\* Create folder structure



\### Phase 2: Auth



\* Register

\* Login

\* Logout

\* Auth state listener



\### Phase 3: Converter



\* Currency dropdown/picker

\* Amount input

\* API request

\* Display result

\* Swap currencies



\### Phase 4: Firestore



\* Save user profile

\* Save conversion history

\* Fetch conversion history

\* Save preferences



\### Phase 5: Polish



\* Loading states

\* Validation

\* Error handling

\* Empty states

\* UI cleanup



\### Phase 6: Extras



\* Feedback form

\* Help screen

\* Rate alerts if time permits



\---



\## 14. Final Deliverables



The finished project should include:



\* Working Flutter app

\* Firebase Auth integration

\* Firestore integration

\* Live currency conversion

\* Conversion history

\* User preferences

\* Help/FAQ screen

\* Feedback screen

\* README documentation

\* Short demo video showing the app working



