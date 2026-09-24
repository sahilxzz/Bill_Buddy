require('dotenv').config();

const mongoose = require('mongoose');

const connectDatabase = require('../config/database');
const User = require('../model/user');
const UserBiller = require('../model/userBiller');
const Bill = require('../model/bill');

const seedBills = async () => {
  try {
    await connectDatabase();

    // Find the first registered user.
    const user = await User.findOne();

    if (!user) {
      throw new Error(
        'No user found. Please create an account first.',
      );
    }

    // Get billers saved by this user.
    const userBillers = await UserBiller.find({
      userId: user._id,
    });

    if (userBillers.length === 0) {
      throw new Error(
        'No saved billers found. Please add a biller first.',
      );
    }

    // Remove previously seeded bills for this user.
    await Bill.deleteMany({
      userId: user._id,
    });

    const today = new Date();

    const bills = userBillers.map((userBiller, index) => {
      const dueDate = new Date(today);

      // Create different due dates:
      // First bill  -> tomorrow
      // Second bill -> +5 days
      // Third bill  -> -2 days (overdue)
      // Remaining   -> +10 days
      if (index === 0) {
        dueDate.setDate(today.getDate() + 1);
      } else if (index === 1) {
        dueDate.setDate(today.getDate() + 5);
      } else if (index === 2) {
        dueDate.setDate(today.getDate() - 2);
      } else {
        dueDate.setDate(today.getDate() + 10);
      }

      let status = 'upcoming';

      if (dueDate < today) {
        status = 'overdue';
      } else {
        const difference =
          dueDate.getTime() - today.getTime();

        const daysUntilDue =
          difference / (1000 * 60 * 60 * 24);

        if (daysUntilDue <= 3) {
          status = 'due_soon';
        }
      }

      // Generate different amounts.
      const amounts = [
        1240,
        599,
        999,
        750,
        1499,
      ];

      return {
        userId: user._id,
        userBillerId: userBiller._id,

        billerName: userBiller.billerName,
        nickname: userBiller.nickname,
        category: userBiller.category,

        accountDetails:
          userBiller.accountDetails,

        amount:
          amounts[index % amounts.length],

        dueDate,

        billingPeriod: 'September 2026',

        status,
      };
    });

    await Bill.insertMany(bills);

    console.log(
      `${bills.length} bills inserted successfully`,
    );

    bills.forEach((bill) => {
      console.log(
        `${bill.nickname} - ₹${bill.amount} - ${bill.status}`,
      );
    });

    await mongoose.connection.close();

    process.exit(0);
  } catch (error) {
    console.error(
      'Bill seed failed:',
      error.message,
    );

    await mongoose.connection.close();

    process.exit(1);
  }
};

seedBills();