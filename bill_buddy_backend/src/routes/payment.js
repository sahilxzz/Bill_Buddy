const express = require('express');
const crypto = require('crypto');

const Payment = require('../model/payment');
const Bill = require('../model/bill');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

router.post('/', authMiddleware, async (req, res) => {
  try {
    const {
      billId,
      amount,
      idempotencyKey,
    } = req.body;

    if (!billId || amount == null || !idempotencyKey) {
      return res.status(400).json({
        message:
          'Bill ID, amount and idempotency key are required',
      });
    }

    if (typeof amount !== 'number' || amount <= 0) {
      return res.status(400).json({
        message: 'Invalid payment amount',
      });
    }

    /*
     * If the same request is sent again,
     * return the existing payment instead of
     * creating another transaction.
     */
    const existingPayment = await Payment.findOne({
      idempotencyKey,
      userId: req.user.userId,
    });

    if (existingPayment) {
      return res.json({
        message: 'Payment already processed',
        payment: existingPayment,
      });
    }

    const bill = await Bill.findOne({
      _id: billId,
      userId: req.user.userId,
    });

    if (!bill) {
      return res.status(404).json({
        message: 'Bill not found',
      });
    }

    if (bill.status === 'paid') {
      return res.status(409).json({
        message: 'This bill has already been paid',
      });
    }

    /*
     * For the MVP we only allow the exact bill amount.
     * Partial payments can be added later if required.
     */
    if (amount !== bill.amount) {
      return res.status(400).json({
        message:
          `Payment amount must be ₹${bill.amount.toFixed(2)}`,
      });
    }

    const transactionId =
      `BB${Date.now()}${crypto.randomBytes(3).toString('hex').toUpperCase()}`;

    const payment = await Payment.create({
      userId: req.user.userId,
      billId: bill._id,
      amount: bill.amount,
      status: 'success',
      transactionId,
      idempotencyKey,
      paidAt: new Date(),
    });

    bill.status = 'paid';
    await bill.save();

    return res.status(201).json({
      message: 'Payment successful',
      payment,
    });
  } catch (error) {
    console.error('Payment error:', error);

    /*
     * Handles a race condition where the same idempotency
     * key reaches the database twice.
     */
    if (error.code === 11000) {
      const existingPayment = await Payment.findOne({
        idempotencyKey: req.body.idempotencyKey,
        userId: req.user.userId,
      });

      if (existingPayment) {
        return res.json({
          message: 'Payment already processed',
          payment: existingPayment,
        });
      }
    }

    return res.status(500).json({
      message: 'Payment failed',
    });
  }
});

module.exports = router;