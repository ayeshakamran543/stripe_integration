# Ikay Books – Flutter + Stripe Integration

A bookstore app built with Flutter that lets users browse books, add them to a cart and pay with the **Stripe Payment Sheet**. Payments are created securely on the backend by a **Firebase Cloud Function**, so the Stripe secret key never lives in the app.

## Demo

https://github.com/<your-username>/<your-repo>/assets/<video-id>/demo.mp4

> Placeholder: drag-and-drop `docs/video/demo.mp4` into a GitHub issue/README edit to get the hosted URL, or link a YouTube/Drive video here.

## Screenshots

| Store | Cart | Stripe Payment Sheet | Library |
|:---:|:---:|:---:|:---:|
| <img src="docs/screenshots/store.png" width="200" /> | <img src="docs/screenshots/cart.png" width="200" /> | <img src="docs/screenshots/payment-sheet.png" width="200" /> | <img src="docs/screenshots/library.png" width="200" /> |
| Search, categories and featured books | Cart with total and secure checkout | Stripe Payment Sheet (test mode) | Purchased books appear here |

## Download

Android APK (release build, about 61 MB): **[Download ikay-books.apk](apk/ikay-books.apk?raw=true)**

You may need to allow "Install unknown apps" on your phone. The app runs in Stripe test mode, so no real money is charged.

Use Stripe test cards to pay, for example `4242 4242 4242 4242`, any future expiry date, any CVC.

## Features

- Browse a catalog of books with covers (loaded from Open Library), author, category, pages and description
- Book detail page with add-to-cart and buy-now
- Cart with live badge count on the navigation bar and running total
- Stripe Payment Sheet checkout (cards and other automatic payment methods)
- Library tab showing purchased books
- Prices are validated server-side so the client cannot change what is charged

## Tech stack

| Layer | Technology |
|---|---|
| App | Flutter (Material 3), `flutter_stripe`, `cached_network_image`, `phosphor_flutter` |
| Backend | Firebase Cloud Functions (Node 22), `stripe` SDK |
| Payments | Stripe PaymentIntents (test mode) |

## How it works

1. The app sends the selected book IDs to the `createPaymentIntent` callable function.
2. The function looks up prices in its own `CATALOG`, totals the amount and creates a Stripe PaymentIntent.
3. The function returns the PaymentIntent `clientSecret`.
4. The app initialises and presents the Stripe Payment Sheet with that secret.
5. On success the books are moved from the cart to the Library.

Purchases are kept in memory only, so they reset when the app restarts.

## Project structure

```
lib/
  main.dart                  App entry, theme, bottom navigation
  models/book.dart           Book model and catalog
  screens/                   Store, book detail, cart, library pages
  services/store_controller.dart   Cart, owned books and checkout logic
  widgets/                   Book cover, empty state, checkout runner
functions/index.js           Firebase function that creates PaymentIntents
server/server.js             Optional local Express server (alternative backend)
```

## Getting started

### Prerequisites

- Flutter SDK (Dart `^3.10.1`)
- A [Stripe](https://dashboard.stripe.com/test/apikeys) account (test keys)
- A Firebase project with the Blaze plan (required for Cloud Functions) and the Firebase CLI

### 1. Clone and install

```bash
git clone https://github.com/<your-username>/<your-repo>.git
cd stripe_integration
flutter pub get
```

### 2. Configure Firebase

```bash
dart pub global activate flutterfire_cli
flutterfire configure
```

### 3. Add your Stripe keys

- Set your **publishable** key (`pk_test_...`) in `lib/main.dart` (`Stripe.publishableKey`).
- Store your **secret** key (`sk_test_...`) as a Firebase secret, never in the app:

```bash
firebase functions:secrets:set STRIPE_SECRET_KEY
```

### 4. Deploy the function

```bash
cd functions
npm install
cd ..
firebase deploy --only functions
```

### 5. Run the app

```bash
flutter run
```

Build an APK:

```bash
flutter build apk --release
```

### Optional: local server

`server/` contains a small Express server with a `/create-payment-intent` endpoint.

```bash
cd server
npm install
echo "STRIPE_SECRET_KEY=sk_test_..." > .env
npm start
```

## Security notes

- Only test-mode keys should be used with this project.
- Never commit or bundle secret keys. Anything listed under Flutter `assets` ships inside the APK, so keep secrets in Firebase secrets or server environment variables only.

## License

This project is for learning and demonstration purposes.
