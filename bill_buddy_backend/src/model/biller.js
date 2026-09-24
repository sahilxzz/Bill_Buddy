const mongoose = require('mongoose');

const billerFieldSchema = new mongoose.Schema(
  {
    key: {
      type: String,
      required: true,
    },

    label: {
      type: String,
      required: true,
    },

    type: {
      type: String,
      enum: ['text', 'number'],
      default: 'text',
    },

    required: {
      type: Boolean,
      default: true,
    },

    minLength: {
      type: Number,
    },

    maxLength: {
      type: Number,
    },
  },
  { _id: false },
);

const billerSchema = new mongoose.Schema(
  {
    name: {
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

    fields: {
      type: [billerFieldSchema],
      required: true,
    },
  },
  {
    timestamps: true,
  },
);

module.exports = mongoose.model('Biller', billerSchema, 'billers');