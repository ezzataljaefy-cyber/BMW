import express, { Request, Response } from 'express';

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req: Request, res: Response) => {
  res.send('Mobile Troubleshooter Backend is running!');
});

// Placeholder for future API endpoints
const apiRouter = express.Router();

// Milestone 2: AI Chat Endpoint
apiRouter.post('/ai/chat', (req: Request, res: Response) => {
  // To be implemented in Milestone 2
  res.status(501).json({ message: 'Not Implemented' });
});

// Milestone 3: IAP Validation Endpoint
apiRouter.post('/iap/validate', (req: Request, res: Response) => {
  // To be implemented in Milestone 3
  res.status(501).json({ message: 'Not Implemented' });
});

// Milestone 3: WooCommerce Sync Endpoint
apiRouter.post('/sync/wp', (req: Request, res: Response) => {
    // To be implemented in Milestone 3
    res.status(501).json({ message: 'Not Implemented' });
});


app.use('/api', apiRouter);

app.listen(port, () => {
  console.log(`Server is running on http://localhost:${port}`);
});
