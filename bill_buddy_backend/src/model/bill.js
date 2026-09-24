const mongoose = require('mongoose');

const billSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },

    userBillerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'UserBiller',
      required: true,
    },

    billerName: {
      type: String,
      required: true,
      trim: true,
    },

    nickname: {
      type: String,
      required: true,
      trim: true,
    },

    category: {
      type: String,
      required: true,
    },

    accountDetails: {
      type: Map,
      of: String,
      required: true,
    },

    amount: {
      type: Number,
      required: true,
      min: 0,
    },

    dueDate: {
      type: Date,
      required: true,
    },

    billingPeriod: {
      type: String,
      required: true,
    },

    status: {
      type: String,
      enum: [
        'upcoming',
        'due_soon',
        'overdue',
        'paid',
      ],
      default: 'upcoming',
    },
  },
  {
    timestamps: true,
  },
);

module.exports = mongoose.model(
  'Bill',
  billSchema,
  'bills',
);