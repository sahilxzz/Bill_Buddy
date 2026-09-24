const express = require('express');

const UserBiller = require('../model/userBiller');
const Biller = require('../model/biller');
const authMiddleware = require('../middleware/auth');

const router = express.Router();

router.post('/', authMiddleware, async (req, res) => {
  try {
    const {
      billerId,
      nickname,
      accountDetails,
    } = req.body;

    if (!billerId || !nickname || !accountDetails) {
      return res.status(400).json({
        message: 'Biller, nickname and account details are required',
      });
    }

    const biller = await Biller.findById(billerId);

    if (!biller) {
      return res.status(404).json({
        message: 'Biller not found',
      });
    }

    for (const field of biller.fields) {
      const value = accountDetails[field.key];

      if (field.required && (!value || value.toString().trim() === '')) {
        return res.status(400).json({
          message: `${field.label} is required`,
        });
      }

      if (value) {
        const stringValue = value.toString().trim();

        if (
          field.type === 'number' &&
          !/^\d+$/.test(stringValue)
        ) {
          return res.status(400).json({
            message: `${field.label} must contain only numbers`,
          });
        }

        if (
          field.minLength &&
          stringValue.length < field.minLength
        ) {
          return res.status(400).json({
            message: `${field.label} is too short`,
          });
        }

        if (
          field.maxLength &&
          stringValue.length > field.maxLength
        ) {
          return res.status(400).json({
            message: `${field.label} is too long`,
          });
        }
      }
    }

    const userBiller = await UserBiller.create({
      userId: req.user.userId,
      billerId: biller._id,
      billerName: biller.name,
      category: biller.category,
      nickname: nickname.trim(),
      accountDetails,
    });

    return res.status(201).json({
      message: 'Biller saved successfully',
      biller: userBiller,
    });
  } catch (error) {
    console.error('Save user biller error:', error);

    return res.status(500).json({
      message: 'Something went wrong',
    });
  }
});

router.get('/', authMiddleware, async (req, res) => {
  try {
    const userBillers = await UserBiller.find({
      userId: req.user.userId,
    }).sort({
      createdAt: -1,
    });

    return res.json({
      billers: userBillers,
    });
  } catch (error) {
    console.error('Get user billers error:', error);

    return res.status(500).json({
      message: 'Something went wrong',
    });
  }
});

module.exports = router;