require('dotenv').config();

const express = require('express');
const cors = require('cors');

const connectDatabase = require('./config/database');
const authRoutes = require('./routes/auth');

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

const startServer = async () => {
  await connectDatabase();

  app.listen(PORT, () => {
    console.log(`BillBuddy backend running on port ${PORT}`);
  });
};

startServer();