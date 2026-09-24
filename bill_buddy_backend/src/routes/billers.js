const express = require('express');

const Biller = require('../model/biller');

const router = express.Router();

router.get('/', async (req, res) => {
  try {
    const { category } = req.query;

    const filter = {};

    if (category) {
      filter.category = category;
    }

    const billers = await Biller.find(filter).sort({
      name: 1,
    });

    return res.json({
      billers,
    });
  } catch (error) {
    console.error('Get billers error:', error);

    return res.status(500).json({
      message: 'Something went wrong',
    });
  }
});

module.exports = router;