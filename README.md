# MiniKYCSDK

A lightweight iOS SDK for **ID verification** and **on-device face-liveness verification**, designed for Egyptian eKYC flows.

Distributed as a pre-built **`.xcframework`** binary. Source is closed.

## Requirements

| | |
|---|---|
| iOS | 16.0+ |
| Devices | iPhone with TrueDepth front camera (for liveness). Document capture works on any iPhone with a rear camera. |
| Xcode | 15+ |

## Installation

### Swift Package Manager (recommended)

In Xcode: **File → Add Package Dependencies…** and enter:

```
https://github.com/hesham92/MiniKYCSDK.git
```

Or in `Package.swift`:

```swift
dependencies: [
    .package(url: "https://github.com/hesham92/MiniKYCSDK.git", from: "0.2.0"),
],
targets: [
    .target(name: "YourApp", dependencies: [
        .product(name: "MiniKYCSDK", package: "MiniKYCSDK"),
    ]),
]
```

SPM downloads the pre-built `.xcframework`, verifies its SHA256 checksum, and links it into your app. No source code is fetched.

### Drag-and-drop xcframework

Download `MiniKYCSDK.xcframework.zip` from the [Releases page](https://github.com/hesham92/MiniKYCSDK/releases), unzip, and drag the `.xcframework` into your Xcode project's *Frameworks, Libraries, and Embedded Content* section.

### Info.plist permissions

Your host app needs:

```xml
<key>NSCameraUsageDescription</key>
<string>Used to scan your ID and capture a selfie for identity verification.</string>
```

## What it does

| Step | API | Notes |
|---|---|---|
| 1. Initialize | `MiniKYC.initialize(baseURL:apiKey:...)` | Returns a session token. |
| 2. Capture ID front | `MiniKYC.capture(captureType: .frontId, ...)` | Returns a `UIViewController` you present. |
| 3. Extract document | `MiniKYC.send(.frontId, document: ...)` | On-device OCR via Vision. |
| 4. Capture ID back | `MiniKYC.capture(captureType: .backId, ...)` | |
| 5. Liveness selfie | `MiniKYC.capture(captureType: .selfie, ...)` | ARKit 4-direction head-pose challenge with Arabic voice prompts. |
| 6. Read status | `MiniKYC.getFinalStatus()` | `.verified` on success. |

## Liveness flow

ARKit `ARFaceTrackingConfiguration` (not regular AVFoundation) for spoof resistance:

1. Detect the user's face.
2. Issue 4 head-direction challenges in sequence: **look right → look left → look up → look down**.
3. Each challenge is spoken in Arabic ("انظر إلى اليمين", etc.) via `AVSpeechSynthesizer`.
4. A 1.5s **refractory window** after each match prevents accidental satisfaction of the next challenge during head-recovery motion.
5. On completion, the SDK captures the current `ARFrame` as the verified selfie.

Held-up photos and paused videos fail this flow because they can't execute a 4-step head motion sequence on demand.

## Public API surface

```swift
public enum MiniKYC {
    static func initialize(baseURL:apiKey:warningAction:userName:phone:email:headers:completion:)
    static func capture(captureType:config:completion:) -> UIViewController?
    static func send(_ captureType:headers:document:)
    static func nextAction() -> Action
    static func getFinalStatus() -> FinalStatus
    static func resetSequence()
    static func setLoggingEnabled(_:)
    static func setTheme(_:)
    static func setLocale(_:)
    static func setCaptureTimeout(_:)
    static func setRequestHeaders(_:)
}

public enum CaptureType {
    case frontId, backId, selfie, vehicleLicenseFront, vehicleLicenseBack
}
```

Full public API surface is exposed via the `.swiftinterface` files inside the xcframework — visible to Xcode's autocomplete and `Cmd+Click → Jump to Definition`.

## License

[MIT](LICENSE) © 2026 Hesham Elsherif
