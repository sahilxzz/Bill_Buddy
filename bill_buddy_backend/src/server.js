const express = require('express');
const cors = require('cors');

const authRoutes = require('./routes/auth');

const app = express();

const PORT = 3000;

app.use(cors());
app.use(express.json());

app.get('/api/health', (req, res) => {
  res.json({
    status: 'ok',
    message: 'BillBuddy backend is running',
  });
});

app.use('/api/auth', authRoutes);

app.listen(PORT, () => {
  console.log(`BillBuddy backend running on port ${PORT}`);
});