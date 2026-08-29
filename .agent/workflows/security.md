---
description: How to troubleshoot GitHub token and security issues
---

# Security & Token Troubleshooting

This workflow helps you diagnose and fix issues related to the GitHub token and the macOS Keychain integration.

## Token Types and Minimum Permissions

### Option A: Fine-grained Personal Access Token (Recommended)
GitHub's modern fine-grained tokens follow the principle of least privilege:
1. Go to [GitHub Fine-grained Tokens Settings](https://github.com/settings/tokens?type=beta).
2. Set **Resource owner** to your user account or target organization.
3. Under **Repository access**, select **All repositories** (or the specific repositories you want to monitor).
4. Under **Repository permissions**, grant:
   - **Pull requests**: `Read-only` (allows searching and querying PRs assigned to you).
   - **Metadata**: `Read-only` (added automatically by GitHub).
5. **Note on Organization Boundary**: Fine-grained tokens belong to a single resource owner. If you review PRs across multiple organizations, create a token per organization or use a Classic PAT.

### Option B: Personal Access Token (Classic)
Useful if you collaborate across multiple organizations with a single token:
1. Go to [GitHub Personal Access Tokens (Classic)](https://github.com/settings/tokens).
2. Select the `repo` scope (or `public_repo` if you only review public repositories).

---

## Common Issues

### 1. Token Status is "Inválido" or "Expirado"
- **Cause**: The token has insufficient permissions, was deleted/revoked on GitHub, or has reached its expiration date.
- **Fix**:
    1. Check your token at GitHub Settings.
    2. Ensure `Pull requests: Read-only` (Fine-grained) or `repo` (Classic) is active.
    3. Generate a new token if necessary.
    4. En la configuración de NotifyPR (icono de candado), haz clic en **Editar** (o **Eliminar** para reiniciar).
    5. Pega el nuevo token y haz clic en **Guardar**.

### 2. Token Not Persisting Across Restarts
- **Cause**: Issue with macOS Keychain permissions or sandbox container.
- **Fix**:
    1. Open **Keychain Access** app on your Mac.
    2. Search for `com.sebavidal.NotifyPR`.
    3. Delete the entry and re-enter the token in NotifyPR settings.
    4. If prompted for permission, select "Always Allow".

### 3. API Rate Limit Reached
- **Cause**: Too many requests in a short period.
- **Fix**:
    1. Increase the "Refrescar cada" interval in General Settings (e.g., from 1 min to 5 or 15 min).
    2. Verify that you are using an authenticated token; unauthenticated requests have a much lower rate limit (60 req/hour vs 5,000 req/hour).

---

## Debugging Commands

To check if the Keychain item exists via terminal:
```bash
security find-generic-password -s "com.sebavidal.NotifyPR" -a "github_token"
```

To manually verify a token via `curl`:
```bash
curl -H "Authorization: Bearer YOUR_TOKEN" https://api.github.com/user
```
