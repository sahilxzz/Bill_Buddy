require('dotenv').config();

const mongoose = require('mongoose');

const connectDatabase = require('../config/database');
const Biller = require('../model/biller');

const billers = [
  {
    name: 'BESCOM',
    category: 'electricity',
    fields: [
      {
        key: 'consumerNumber',
        label: 'Consumer Number',
        type: 'number',
        required: true,
        minLength: 10,
        maxLength: 10,
      },
    ],
  },
  {
    name: 'Adani Electricity',
    category: 'electricity',
    fields: [
      {
        key: 'consumerNumber',
        label: 'Consumer Number',
        type: 'number',
        required: true,
        minLength: 9,
        maxLength: 9,
      },
    ],
  },
  {
    name: 'Airtel',
    category: 'mobile',
    fields: [
      {
        key: 'mobileNumber',
        label: 'Mobile Number',
        type: 'number',
        required: true,
        minLength: 10,
        maxLength: 10,
      },
    ],
  },
  {
    name: 'Jio',
    category: 'mobile',
    fields: [
      {
        key: 'mobileNumber',
        label: 'Mobile Number',
        type: 'number',
        required: true,
        minLength: 10,
        maxLength: 10,
      },
    ],
  },
  {
    name: 'Tata Play',
    category: 'dth',
    fields: [
      {
        key: 'subscriberId',
        label: 'Subscriber ID',
        type: 'number',
        required: true,
        minLength: 10,
        maxLength: 10,
      },
    ],
  },
  {
    name: 'ACT Fibernet',
    category: 'broadband',
    fields: [
      {
        key: 'accountNumber',
        label: 'Account Number',
        type: 'number',
        required: true,
        minLength: 8,
        maxLength: 12,
      },
    ],
  },
];

const seedBillers = async () => {
  try {
    await connectDatabase();

    await Biller.deleteMany({});

    await Biller.insertMany(billers);

    console.log(`${billers.length} billers inserted successfully`);

    await mongoose.connection.close();

    process.exit(0);
  } catch (error) {
    console.error('Biller seed failed:', error.message);

    await mongoose.connection.close();

    process.exit(1);
  }
};

seedBillers();