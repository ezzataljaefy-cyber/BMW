# Mobile Troubleshooter Backend

This repository contains the backend server for the Mobile Troubleshooter Flutter application. It's built with Node.js and TypeScript, using Express.

## Features

- **AI Chat Proxy:** A secure endpoint (`/api/ai/chat`) to stream responses from an AI provider. The API key is stored securely on the server and never exposed to the client.
- **IAP Validation:** A server-side endpoint (`/api/iap/validate`) to validate receipts from Google Play and the Apple App Store.
- **WordPress/WooCommerce Sync:** A webhook endpoint (`/api/sync/wp`) to receive and process article updates from a WordPress/WooCommerce instance.
- **Rate Limiting & Moderation:** Basic security features to prevent abuse.

## Getting Started

### Prerequisites

- [Node.js](https://nodejs.org/) (v18 or later)
- [Yarn](https://yarnpkg.com/) or npm
- A database (PostgreSQL or MongoDB)

### Setup

1.  **Clone the repository:**
    ```bash
    git clone <your-repo-url>
    cd mobile-troubleshooter-backend
    ```

2.  **Install dependencies:**
    ```bash
    npm install
    # or
    yarn install
    ```

3.  **Set up environment variables:**
    Create a `.env` file in the root of the project by copying the example file:
    ```bash
    cp .env.example .env
    ```
    Now, open the `.env` file and fill in the required placeholder values.

    #### Required Placeholders:
    - `<<AI_API_KEY>>`: Your secret key for the AI provider (e.g., OpenAI, Gemini).
    - `<<WOOCOMMERCE_URL>>`: The base URL of your WordPress/WooCommerce site.
    - `<<WOOCOMMERCE_CONSUMER_KEY>>`: Your WooCommerce API consumer key.
    - `<<WOOCOMMERCE_CONSUMER_SECRET>>`: Your WooCommerce API consumer secret.
    - `<<WOOCOMMERCE_WEBHOOK_SECRET>>`: A secret string to verify webhooks from WooCommerce.
    - `<<PACKAGE_NAME>>`: Your app's package name for Google Play receipt validation (e.g., `com.example.app`).
    - **Database credentials** (`DB_HOST`, `DB_PORT`, etc.).
    - **IAP secrets** for Google Play and Apple. See official documentation for how to generate these.

4.  **Run the development server:**
    ```bash
    npm run dev
    # or
    yarn dev
    ```
    The server will start on `http://localhost:3000` (or the port you specified in `.env`).

### Scripts

- `npm start`: Starts the server using `ts-node`.
- `npm run build`: Compiles the TypeScript code to JavaScript in the `dist/` directory.
- `npm run serve`: Runs the compiled JavaScript code from the `dist/` directory.
- `npm run dev`: Runs the server in development mode with `nodemon` for automatic restarts.

## API Endpoints

- **`POST /api/ai/chat`**: Proxies chat requests to the AI provider.
- **`POST /api/iap/validate`**: Validates IAP receipts.
- **`POST /api/sync/wp`**: Handles webhooks from WordPress/WooCommerce.

## Security

All secrets and API keys are managed through environment variables and are never hard-coded in the source. Ensure the `.env` file is never committed to version control.
