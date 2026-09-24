const mongoose = require('mongoose');

const userBillerSchema = new mongoose.Schema(
  {
    userId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'User',
      required: true,
    },

    billerId: {
      type: mongoose.Schema.Types.ObjectId,
      ref: 'Biller',
      required: true,
    },

    billerName: {
      type: String,
      required: true,
      trim: true,
    },

    category: {
      type: String,
      required: true,
      enum: [
        'electricity',
        'water',
        'gas',
        'broadband',
        'mobile',
        'dth',
        'credit_card',
      ],
    },

    nickname: {
      type: String,
      required: true,
      trim: true,
    },

    accountDetails: {
      type: Map,
      of: String,
      required: true,
    },
  },
  {
    timestamps: true,
  },
);

module.exports = mongoose.model(
  'UserBiller',
  userBillerSchema,
  'userBillers',
);