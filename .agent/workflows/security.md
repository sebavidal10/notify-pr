---
description: How to troubleshoot GitHub token and security issues
---

# Security & Token Troubleshooting

This workflow helps you diagnose and fix issues related to the GitHub token and the macOS Keychain integration.

## Common Issues

### 1. Token Status is "Inválido" or "Expirado"
- **Cause**: The token has incorrect permissions, was deleted from GitHub, or has reached its expiration date.
- **Fix**:
    1. Go to [GitHub Personal Access Tokens](https://github.com/settings/tokens).
    2. Ensure the token has the `repo` scope.
    3. Generate a new token if necessary.
    4. En la configuración de NotifyPR, haz clic en el botón **Editar**.
    5. Pega el nuevo token y haz clic en **Guardar**.

### 2. Token Not Persisting Across Restarts
- **Cause**: Issue with macOS Keychain permissions.
- **Fix**:
    1. Open **Keychain Access** app on your Mac.
    2. Search for `com.sebavidal.NotifyPR`.
    3. Delete the entry and re-enter the token in the app.
    4. If prompted for permission, select "Always Allow".

### 3. API Rate Limit Reached
- **Cause**: Too many requests in a short period.
- **Fix**:
    1. Increase the "Refrescar cada" interval in General Settings (e.g., from 1 min to 5 or 15 min).
    2. Verify that you are using a token; unauthenticated requests have much lower rate limits.

## Debugging Commands

To check if the Keychain item exists via terminal:
```bash
security find-generic-password -s "com.sebavidal.NotifyPR" -a "github_token"
```

To manually verify a token via `curl`:
```bash
curl -H "Authorization: token YOUR_TOKEN" https://api.github.com/user
```
