# Security Policy

The security of the Mobile Troubleshooter application and its users is a top priority. This document outlines our security policy and the measures we take to protect user data.

## Reporting a Vulnerability

If you discover a security vulnerability, please report it to us as soon as possible. We appreciate your efforts to disclose your findings responsibly.

Please email us at `security@example.com` (this is a placeholder).

We will acknowledge your email within 48 hours and will work with you to understand and resolve the issue. We ask that you do not disclose the vulnerability publicly until we have had a chance to address it.

## Secrets Management

Our application follows strict guidelines to protect sensitive information:

- **No Hard-coded Secrets:** No API keys, credentials, or other secrets are ever hard-coded into the client-side or server-side source code.
- **Client-Side Secrets:** The Flutter application uses environment variables for non-sensitive or public keys (like Firebase config). These are loaded at runtime from a `.env` file, which is explicitly excluded from version control via `.gitignore`.
- **Server-Side Secrets:** All highly sensitive keys (such as the `AI_API_KEY`, database credentials, and IAP validation secrets) are stored exclusively on the backend server. They are managed through environment variables and are never exposed to the client application.
- **CI/CD Security:** In our continuous integration and deployment pipelines, secrets are managed using encrypted GitHub Secrets.

## Data Handling

- **User Authentication:** User authentication is handled via Firebase Authentication, which provides a secure and robust system for managing user identities.
- **Data Transmission:** All communication between the client application and the backend server is encrypted using HTTPS.
- **Screenshot Handling:** When a user uploads a screenshot to the AI Chat, we take the following precautions:
    - **Explicit Consent:** The user must provide explicit consent before the screenshot is uploaded.
    - **Minimal Storage:** Screenshots are not stored long-term on our servers. They are processed in-memory and sent to the AI provider for analysis, then discarded. If temporary storage is required, files are encrypted at rest.
    - **Anonymization:** We make a best effort to strip any obvious personally identifiable information (PII) from the image metadata before processing, although we cannot guarantee the removal of all PII from the image content itself.

## Secure Coding Practices

- **Input Validation:** All user input is validated on both the client and server sides to prevent common vulnerabilities like injection attacks.
- **Dependency Management:** We regularly scan our dependencies for known vulnerabilities and update them as needed.
- **Rate Limiting:** Our backend APIs implement rate-limiting to protect against denial-of-service (DoS) attacks and other forms of abuse.
- **Webhook Verification:** The endpoint that receives webhooks from WooCommerce validates the HMAC signature to ensure that the request is authentic and from the expected source.
