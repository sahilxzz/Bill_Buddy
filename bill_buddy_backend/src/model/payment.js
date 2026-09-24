const mongoose = require('mongoose');

const paymentSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },

    billId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Bill',
      required: true,
    },

    amount: {
      type: Number,
      required: true,
      min: 0,
    },

    status: {
      type: String,
      enum: ['success', 'pending', 'failed'],
      default: 'success',
    },

    transactionId: {
      type: String,
      required: true,
      unique: true,
    },

    idempotencyKey: {
      type: String,
      required: true,
      unique: true,
    },

    paidAt: {
      type: Date,
      default: Date.now,
    },
  },
  {
    timestamps: true,
  },
);

module.exports = mongoose.model(
  'Payment',
  paymentSchema,
  'payments',
);