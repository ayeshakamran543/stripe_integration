const { onCall, HttpsError } = require("firebase-functions/v2/https");
const { defineSecret } = require("firebase-functions/params");
const Stripe = require("stripe");

const stripeSecret = defineSecret("STRIPE_SECRET_KEY");

// Source of truth for prices (in cents). Keep ids in sync with lib/models/book.dart.
const CATALOG = {
  "atomic-habits": { title: "Atomic Habits", cents: 1299 },
  "deep-work": { title: "Deep Work", cents: 1199 },
  "the-alchemist": { title: "The Alchemist", cents: 899 },
  "clean-code": { title: "Clean Code", cents: 2499 },
  "psychology-of-money": { title: "The Psychology of Money", cents: 1399 },
  "flutter-in-action": { title: "Flutter in Action", cents: 1999 },
};

exports.createPaymentIntent = onCall(
  { secrets: [stripeSecret], maxInstances: 10 },
  async (request) => {
    const bookIds = request.data.bookIds;
    if (!Array.isArray(bookIds) || bookIds.length === 0) {
      throw new HttpsError("invalid-argument", "No books selected");
    }

    const unique = [...new Set(bookIds)];
    if (unique.some((id) => !CATALOG[id])) {
      throw new HttpsError("invalid-argument", "Unknown book in order");
    }

    const amount = unique.reduce((sum, id) => sum + CATALOG[id].cents, 0);

    const stripe = new Stripe(stripeSecret.value());
    try {
      const pi = await stripe.paymentIntents.create({
        amount,
        currency: "usd",
        automatic_payment_methods: { enabled: true },
        description: unique.map((id) => CATALOG[id].title).join(", "),
        metadata: { bookIds: unique.join(",") },
      });
      return { clientSecret: pi.client_secret, amount };
    } catch (e) {
      throw new HttpsError("internal", e.message);
    }
  }
);
