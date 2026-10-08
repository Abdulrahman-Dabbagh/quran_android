# Quran Android — technical implementation plan

Prepared 8 October 2026 for Abdulrahman Dabbagh.

## Decisions and working defaults
Android first; free distribution; start with the reference app's code and experience; iOS later. Development defaults: no ads, no purchases, no new account requirement, no Firebase telemetry, Madani pages first. Free does not by itself establish all content reuse rights. Public distribution of a derivative must satisfy GPLv3 source obligations and applicable content licenses. Final branding, production package name and content delivery permissions remain release decisions.

## Architecture decision
Create a derivative of https://github.com/quran/quran_android rather than recreate Quran rendering and playback. Baseline commit: 188355356fce2ca731919611d677c6736ccee24d (main checkout, not a verified released tag). Preserve upstream attribution and LICENSE. Keep source namespaces unchanged; change the installable application ID separately. Maintain an upstream remote and a patch branch; review upstream changes before merging. A successful clean baseline build is the first milestone. If main's dependencies cannot resolve on a fully networked runner, compare a released tag and select a reproducible baseline; do not blindly downgrade dependencies.

Observed source toolchain: Gradle wrapper 9.8.0, Android Gradle Plugin 9.4.1, Kotlin 2.4.20, compile SDK 37, target SDK 36, min SDK 24. Upstream CI specifies JDK 27; source compilation compatibility is Java 17. These versions are source declarations, not confirmed available downloads in this environment. Preserve them initially and validate compatibility on the build runner.

Native Android Kotlin/Java with existing Compose and XML screens. Preserve upstream dependency injection, network, local storage, SQLDelight migrations, download and media services. Avoid a Flutter/React Native rewrite for the Android baseline. iOS will require a separate implementation or deliberate shared-domain extraction; Android UI code is not automatically reusable there.

## Baseline scope and acceptance
| Area | Implementation | Acceptance |
|---|---|---|
| Reading | Existing Madani page and ayah mapping modules | Page navigation, surah/juz lookup and selected ayah highlighting match verified source content |
| Offline | Existing page/database downloads | Downloaded pages reopen after process restart in airplane mode; interrupted downloads recover |
| Audio | Existing reciter catalogue, player and download modules | Play, pause, seek, repeat range and highlighting; background playback, lock-screen controls and audio focus work |
| Translation/tafsir | Existing translation storage and selection | Correct surah/ayah alignment and offline access after download |
| Search | Existing Arabic and translation search | Arabic diacritics/normalization, no-result and result-navigation behavior verified |
| Bookmarks/tags | Existing bookmark data and UI | Add/edit/remove survive restart; jump to correct ayah |
| Appearance | Existing themes, settings and localization | Night mode, Arabic RTL, English UI, font scaling and rotation checked |
| Sync | Audit inherited feature before release | No reliance on upstream OAuth credentials; unauthenticated core works; hide/disable unavailable account flows |

Do not generate Quran text with AI. Preserve trusted assets byte-for-byte. Maintain provenance, checksums, license and attribution for each page set, text database, translation, tafsir and reciter recording. Human Quran-content review remains necessary for release; UI tests alone cannot certify religious correctness.

## Phases and deliverables
### 0 — Source intake and reproducibility (started)
Acquire source and pin provenance; inventory modules and build prerequisites. Give derivative a provisional unique application ID and independent version sequence. Disable Firebase through upstream's supported no-op path. Add a repeatable verification script. Deliver source snapshot, plan and truthful build status.
Exit: clean debug APK and baseline test results on an SDK-equipped runner. Current status: source acquired and configuration changed; build blocked before configuration by Gradle download network access. Android SDK absent; only JDK 17 available locally.

### 1 — Independently installable baseline
Build unchanged upstream first, then derivative, to distinguish existing failures from introduced regressions. Install alongside the reference app. Inventory all manifest components, provider authorities, OAuth redirects, deep links, app labels, shortcuts, notifications, Auto integration and version metadata. Replace name/icons/store-facing identity without implying official affiliation. Audit inherited update links, support links, analytics, sync and external endpoints. Keep debug signing for local previews only.
Exit: working baseline APK, comparison matrix and no reliance on upstream private credentials.

### 2 — Content and network independence
Create asset registry with owner/source/license/version/checksum/size/locale/reciter/permission evidence. Do not assume a public URL permits production reuse or bandwidth consumption. Determine which assets can be mirrored and host permitted files on object storage/CDN under your account, or obtain explicit upstream hosting permission. Preserve downloaded databases and mappings; use HTTPS, versioned manifests, checksum verification, bounded retries and recoverable downloads. Test storage limits, deletion and interrupted downloads.
Exit: documented permitted assets, working downloads and offline reading/audio. No backend is needed for core reading/bookmarks. Storage/CDN account and cost approval may be needed; audit DNS/network behavior too.

### 3 — Your additional features
After baseline validation, turn requested features into short specifications and implement one at a time in existing feature/common modules. Store local reading-related data with stable surah/ayah keys. For possible reading goals or revision schedules, create separate user-data tables with migrations, leaving Quran data intact. Those examples are not approved scope yet. Add tests for calculations, migrations and boundary behavior; add focused UI checks only for affected paths. Avoid unnecessary account/AI/cloud services.
Exit per feature: implemented behavior, tests, screenshots or device demonstration and regression check.

### 4 — Release qualification
Run debug build, lint, upstream unit tests and SQLDelight migration checks. Test release shrinking separately. Device matrix: minimum supported Android API 24, target/API 36, current supported SDK device, low-memory phone and tablet; Arabic/English, large font, rotation, accessibility, airplane mode, slow/interrupted network and limited storage. Audio cases include calls, Bluetooth disconnect, headphone removal, service restart and permission handling. Compare downloaded content against trusted checksums and manually inspect representative page/ayah boundaries. Inspect actual release network traffic before writing privacy/Data Safety claims. Firebase disabled does not mean the app has zero external network traffic.
Exit: signed AAB, verified install/update, regression report, content review and no critical known defects.

### 5 — Google Play distribution
Prepare original icon/screenshots, English/Arabic listing, credits, source-code link, privacy-policy page and support contact. Review current target API and policy requirements at submission time. Provide corresponding source and license information for distributed derivative builds. Review repetitive-content/impersonation policies before submitting a near-identical fork; meaningful added value is preferable and acceptance is not guaranteed. Keep signing keys and passwords outside source and distribute ownership to your secured account. Use Play App Signing with protected upload key. Upload to internal testing, complete required closed testing if applicable, then production submission after release approval.
For personal developer accounts created after 13 November 2023, Google's current documentation requires at least 12 testers continuously opted in for 14 days before applying for production access. Real testers and Google approval cannot be automated away.
Exit: approved store release, verified public listing and maintenance handover.

### 6 — iOS later
Reassess Swift/SwiftUI versus shared business logic after additional features stabilize. Reuse only content whose rights permit iOS use; design independent playback/download/bookmark implementations. Apple account, signing, macOS/Xcode or a supported cloud build service, device testing and App Store review are separate prerequisites.

## Tools and ownership
| Tool/service | Purpose | Who handles it |
|---|---|---|
| Git + hosted source repository | Versioning, upstream updates, GPL source availability | I prepare source/commits; you supply or authorize repository access |
| Android SDK + matching JDK + Gradle wrapper | APK/AAB builds and tests | I configure/run where network and tooling allow; Android Studio is optional for you |
| Networked build runner / CI | Repeatable builds and downloadable artifacts | I prepare pipeline; you authorize external account access/cost if required |
| Emulator + real Android device | Functional/audio/download validation | I run available emulators; real-device acceptance requires a person/device |
| Object storage/CDN | Permitted page/audio/translation delivery | I configure with access; you approve account charges and hosting/rights decisions |
| Google Play Console | Listing, testing and release | I prepare assets and supported submissions; you handle identity, fees, account agreements and final release approval |
| Secret storage and signing key backup | Secure reproducible release signing | I configure; you retain ownership and secure recovery |

## What I can complete vs your involvement
I can handle code changes, build configuration, test execution where supported, bug fixes, source packaging, release drafts, asset registries, CI setup and deployment/submission where authenticated tools support it. No current Play Console or hosted project access has been established. I cannot promise an APK without a functioning build environment, real tester participation, legal permissions from content owners, or store approval.
You do not need to write code or install Android Studio. Later you must own/verify developer accounts, authorize costs, confirm final branding/package ID, approve privacy/content declarations and final public release, and arrange necessary human content/device review/testers. Development setup and reversible implementation already fall within your authorization; no extra approval is requested now.

## Release decision log
- Provisional application ID: com.abdulrahman.quran (debug adds .debug). Confirm before first store upload; application ID becomes the persistent store identity.
- Provisional debug label: Quran Personal Madani; final public name/icon unchanged pending branding work.
- Version: 0.1.0, versionCode 1.
- No ads/purchases/Firebase default. This is a development assumption, not proof of every third-party data behavior.
- Preserve GPL and credits; publish corresponding source with distributed releases.
- No automatic public publication or account creation this turn.

## Status and next executable step
Source was cloned successfully. Application ID/version changed and Firebase disabled through project properties. git diff --check passed. ./gradlew :app:assembleMadaniDebug failed before project compilation with Network is unreachable while fetching services.gradle.org. No APK produced, no app launched, no unit tests or lint executed. Source declares a newer toolchain than the available local JDK and no Android SDK is present.
Next: execute scripts/verify-baseline.sh on a networked runner with the pinned toolchain and SDK. Resolve baseline issues before branding or new features. Do not request credentials in chat or commit secrets.

## Primary references
- Reference listing: https://play.google.com/store/apps/details?id=com.quran.labs.androidquran
- Source, README reuse notes and LICENSE: https://github.com/quran/quran_android
- Toolchain, build variants and module definitions: pinned source included with this plan.
- Play testing: https://support.google.com/googleplay/android-developer/answer/14151465
