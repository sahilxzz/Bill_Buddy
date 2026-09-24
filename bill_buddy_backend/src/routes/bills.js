const express = require('express');

const Bill = require('../model/bill');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

router.get('/', authMiddleware, async (req, res) => {
  try {
    const bills = await Bill.find({
      userId: req.user.userId,
    }).sort({
      dueDate: 1,
    });

    return res.json({
      bills,
    });
  } catch (error) {
    console.error('Get bills error:', error);

    return res.status(500).json({
      message: 'Something went wrong',
    });
  }
});

module.exports = router;