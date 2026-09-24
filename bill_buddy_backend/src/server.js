require('dotenv').config();

const express = require('express');
const cors = require('cors');

const connectDatabase = require('./config/database');
const authRoutes = require('./routes/auth');
const billerRoutes = require('./routes/billers');
const userBillerRoutes = require('./routes/userBillers');
const billRoutes = require('./routes/bills');
const paymentRoutes = require('./routes/payment');

const app = express();

const PORT = process.env.PORT || 3000;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'BillBuddy backend is running',
  });
});

app.use('/api/auth', authRoutes);
app.use('/api/billers', billerRoutes);
app.use('/api/user-billers', userBillerRoutes);
app.use('/api/bills', billRoutes);
app.use('/api/payments', paymentRoutes);

const startServer = async () => {
  await connectDatabase();

  app.listen(PORT, () => {
    console.log(`BillBuddy backend running on port ${PORT}`);
  });
};

startServer();