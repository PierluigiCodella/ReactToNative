# ReactToNative

Un progetto che dimostra come **embeddare componenti React Native all'interno di un'app nativa iOS**, invertendo la logica comune di React Native dove l'app è prevalentemente React con alcuni bridge nativi.

## 📋 Indice

- [Architettura](#architettura)
- [Vantaggi e Svantaggi](#vantaggi-e-svantaggi)
- [Confronto: React Bridge vs KMP SDK](#confronto-react-bridge-vs-kmp-sdk)
- [Struttura del Progetto](#struttura-del-progetto)
- [Comunicazione Nativo ↔️ React](#comunicazione-nativo--react)
- [Setup e Installazione](#setup-e-installazione)

## 🏗️ Architettura

Questo progetto implementa un approccio **Native-First** con componenti React Native embedded:

```
┌─────────────────────────────────────────┐
│         Native iOS App (Swift)          │
│  ┌───────────────────────────────────┐  │
│  │    LoginViewController            │  │
│  │  ┌─────────────────────────────┐  │  │
│  │  │  React Native Component     │  │  │
│  │  │  (Login UI in TypeScript)   │  │  │
│  │  └─────────────────────────────┘  │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │   FavouritesViewController        │  │
│  │   (Native UITableView)            │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │   Native Bridge Module            │  │
│  │   LoginViewEventManager           │  │
│  └───────────────────────────────────┘  │
│                                         │
│  ┌───────────────────────────────────┐  │
│  │   Shared State                    │  │
│  │   UserManager (Combine)           │  │
│  └───────────────────────────────────┘  │
└─────────────────────────────────────────┘
```

### Flusso di Comunicazione

1. **Native → React**: Il codice nativo (Swift) istanzia i componenti React e può iniettare props
2. **React → Native**: Il layer TypeScript invoca callback nativi o emette eventi intercettati dal codice nativo
3. **Gestione Stato**: Il `UserManager` (Combine) mantiene lo stato condiviso tra le view native e React

## 🎯 Embedding React Native Components in Native Apps

### Vantaggi

✅ **Logica condivisa cross-platform**
- Business logic e UI logic condivisi tra iOS e Android (futuro)
- Single source of truth per la logica di business

✅ **Sviluppo veloce con Fast Refresh**
- Hot reload in tempo reale
- Iterazione rapida sulle UI
- Feedback immediato durante lo sviluppo

✅ **Flessibilità**
- Possibilità di usare React Native solo dove serve
- Mantenimento di performance native per le parti critiche

### Svantaggi

❌ **Non adatto per soluzioni complesse**
- Gaming
- Augmented Reality (AR)
- IoT con requisiti real-time critici

❌ **Overhead del bridge**
- Comunicazione asincrona tra native e JavaScript
- Potenziali bottleneck nelle performance per operazioni intensive

❌ **Dimensione del bundle**
- React Native aggiunge peso all'app
- Considerazioni sul tempo di caricamento

## 🔄 Confronto: React Bridge vs KMP SDK

### React Native Components

| Caratteristica | Dettaglio |
|----------------|-----------|
| **Codice condiviso** | ✅ Business logic e UI logic |
| **Linguaggio** | TypeScript + Native code (Swift/Kotlin) |
| **Sviluppo** | 🚀 Veloce con Fast Refresh (hot reload) |
| **Output** | JavaScript bundle interpretato a runtime |
| **Casi d'uso** | UI dinamiche, form, liste, dashboard |
| **Non adatto per** | ❌ Gaming, AR, IoT complesso |

### KMP (Kotlin Multiplatform) Library

| Caratteristica | Dettaglio |
|----------------|-----------|
| **Codice condiviso** | ✅ Business logic e UI logic |
| **Linguaggio** | 100% codice nativo generato |
| **Sviluppo** | 🐌 Lento, nessun fast refresh |
| **Output** | `.xcframework` (iOS) / `.aar` (Android) |
| **Performance** | ⚡ Native, nessun overhead di bridge |
| **Non adatto per** | ❌ Gaming, AR, IoT complesso |

### Quando usare cosa?

**React Native Bridge** → Quando serve:
- Sviluppo rapido e iterativo
- UI che cambiano frequentemente

**KMP SDK** → Quando serve:
- Performance massime
- Librerie distribuite come package

## 📁 Struttura del Progetto

```
ReactToNative/
├── App.tsx                          # Componente React Native (Login UI)
├── index.js                         # Entry point React Native
├── package.json                     # Dipendenze npm
│
└── ios/
    ├── Podfile                      # Dipendenze iOS
    ├── ReactToNative/
    │   ├── AppDelegate.swift        # Entry point app iOS
    │   ├── SceneDelegate.swift      # Scene lifecycle
    │   │
    │   ├── LoginViewController.swift     # ViewController che embedded React
    │   ├── FavouritesViewController.swift # ViewController nativo
    │   │
    │   └── LoginViewManager/
    │       ├── LoginViewEventManager.swift  # Bridge Swift
    │       ├── LoginViewEventManager.m      # Bridge Objective-C
    │       └── UserManager.swift            # Stato condiviso (Combine)
    │
    └── ReactToNative.xcworkspace/    # Workspace Xcode
```

## 🔗 Comunicazione Nativo ↔️ React

### Native → React (Props Injection)

```swift
// LoginViewController.swift
let view = RCTRootView(
    bundleURL: url,
    moduleName: "Login",
    initialProperties: nil  // Props iniettate nel componente React
)
```

### React → Native (Event Callbacks)

```typescript
// App.tsx
const onLoginPressed = () => {
    setIsLoggedIn(true);
    NativeModules.LoginViewEventManager.onLoginSuccess({token: "abc"});
}
```

```swift
// LoginViewEventManager.swift
@objc(onLoginSuccess:)
func onLoginSuccess(event: NSDictionary) {
    UserManager.shared.isLoggedIn = true
}
```

### Gestione Stato Condiviso

```swift
// UserManager.swift (Singleton con Combine)
public class UserManager: ObservableObject {
    static let shared = UserManager()
    @Published var isLoggedIn = false
}

// FavouritesViewController.swift
UserManager.shared.$isLoggedIn
    .receive(on: DispatchQueue.main)
    .sink { isLoggedIn in
        self.setTableViewVisibility(isLoggedIn: isLoggedIn)
    }
```

## 🚀 Setup e Installazione

### Prerequisiti

- Xcode 14+
- Node.js 16+
- CocoaPods
- React Native CLI

### Installazione

```bash
# 1. Installa le dipendenze npm
npm install

# 2. Installa i Pods iOS
cd ios
pod install

# 3. Torna alla root
cd ..
```

### Esecuzione

```bash
# Terminal 1: Avvia il Metro Bundler
npm start

# Terminal 2 (o Xcode): Esegui l'app iOS
# Apri ios/ReactToNative.xcworkspace in Xcode e premi Run
```

## 🔮 Roadmap

- [ ] Aggiunta supporto Android
- [ ] Implementazione di più componenti React embedded
- [ ] Esempio di navigazione ibrida (native + React Navigation)
- [ ] Ottimizzazione bundle size

## 📝 Note

- Questo progetto usa React Native **0.71.13**
- Il bridge è implementato usando `RCTBridgeModule` (approccio Objective-C)
- Lo stato condiviso usa **Combine** (Publisher/Subscriber pattern)
- In modalità DEBUG, il bundle viene caricato dal Metro Bundler
- In modalità RELEASE, il bundle viene incluso come `main.jsbundle`

---

**Autore**: Pierluigi Codella  
**Data Creazione**: 16/12/24
