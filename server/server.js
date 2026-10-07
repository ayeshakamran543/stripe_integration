const express = require("express");
const cors = require("cors");
const Stripe = require("stripe");

const stripe = new Stripe(process.env.STRIPE_SECRET_KEY);
const app = express();
app.use(cors(), express.json());

app.post("/create-payment-intent", async (req, res) => {
  try {
    // App sends a decimal string like "29.99"; Stripe wants cents.
    const amount = Math.round(parseFloat(req.body.amount) * 100);
    if (!Number.isInteger(amount) || amount < 50) {
      return res.status(400).json({ error: "Invalid amount" });
    }
    const pi = await stripe.paymentIntents.create({
      amount,
      currency: req.body.currency || "usd",
      automatic_payment_methods: { enabled: true },
    });
    res.json({ clientSecret: pi.client_secret });
  } catch (e) {
    res.status(400).json({ error: e.message });
  }
});

app.listen(3000, () => console.log("Listening on :3000"));
