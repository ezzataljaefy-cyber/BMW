import express, { Request, Response } from 'express';

const app = express();
const port = process.env.PORT || 3000;

app.use(express.json());

app.get('/', (req: Request, res: Response) => {
  res.send('Mobile Troubleshooter Backend is running!');
});

// Placeholder for future API endpoints
const apiRouter = express.Router();

// Middleware for simple keyword-based moderation
const moderateRequest = (req: Request, res: Response, next: Function) => {
  const { message } = req.body;
  const blockedKeywords = ['badword1', 'prohibited_topic']; // Example keywords
  if (message && blockedKeywords.some(keyword => message.includes(keyword))) {
    return res.status(400).json({ error: 'Your message contains prohibited content.' });
  }
  next();
};

// Middleware for basic rate-limiting (very simplistic example)
const rateLimiter = (req: Request, res: Response, next: Function) => {
  // In a real app, you'd use a library like 'express-rate-limit'
  // and track IPs in a store like Redis.
  console.log(`Request from IP: ${req.ip}`);
  next();
};

// Milestone 2: AI Chat Endpoint
apiRouter.post('/ai/chat', moderateRequest, rateLimiter, (req: Request, res: Response) => {
  const { message, includeDeviceInfo, includeArticleContext } = req.body;

  // In a real implementation, you would use the AI_API_KEY to authenticate
  // with your AI provider (e.g., OpenAI, Gemini).
  // const aiApiKey = process.env.AI_API_KEY;

  console.log('Received chat request:', { message, includeDeviceInfo, includeArticleContext });

  // Set headers for Server-Sent Events (SSE)
  res.setHeader('Content-Type', 'text/event-stream');
  res.setHeader('Cache-Control', 'no-cache');
  res.setHeader('Connection', 'keep-alive');
  res.flushHeaders();

  const mockResponse = "This is a streamed response from the mock AI. ";
  const tokens = mockResponse.split('');
  let i = 0;

  const intervalId = setInterval(() => {
    if (i < tokens.length) {
      // Send each token as a separate event
      res.write(`data: ${JSON.stringify({ token: tokens[i] })}\n\n`);
      i++;
    } else {
      // Send a done event and close the connection
      res.write('data: {"event": "done"}\n\n');
      clearInterval(intervalId);
      res.end();
    }
  }, 100); // Stream a token every 100ms

  // Clean up if the client closes the connection
  res.on('close', () => {
    clearInterval(intervalId);
    res.end();
    console.log('Client closed connection');
  });
});

// In-memory store for mock subscription data
const userSubscriptions: { [userId: string]: { expiryDate: Date, platform: string } } = {};

// Milestone 3: IAP Validation Endpoint
apiRouter.post('/iap/validate', (req: Request, res: Response) => {
  const { receiptData, platform, userId } = req.body;

  if (!receiptData || !platform || !userId) {
    return res.status(400).json({ error: 'Missing required fields: receiptData, platform, userId' });
  }

  // In a real app, you would use a library like 'google-auth-library' for Google
  // or 'node-apple-receipt-verify' for Apple to validate the receipt.
  // This is a mock validation.
  console.log(`Validating receipt for ${platform} for user ${userId}`);

  const isValid = receiptData.includes('mock_receipt_token');

  if (isValid) {
    const expiryDate = new Date();
    expiryDate.setMonth(expiryDate.getMonth() + 1); // Mock a 1-month subscription

    userSubscriptions[userId] = { expiryDate, platform };

    console.log(`Subscription for user ${userId} is valid until ${expiryDate.toISOString()}`);

    return res.status(200).json({
      success: true,
      subscriptionActive: true,
      expiryDate: expiryDate.toISOString(),
    });
  } else {
    return res.status(400).json({
      success: false,
      subscriptionActive: false,
      error: 'Invalid receipt',
    });
  }
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
