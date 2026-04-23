# Security Policy

## Supported Scope

This repository is a documentation and learning project for SQL. Security reports are still welcome for:

- Accidental secret exposure
- Malicious or unsafe scripts
- Dependency vulnerabilities in tooling
- Unsafe automation configurations

## Reporting A Vulnerability

Please do not open a public issue for sensitive findings.

1. Open a private security advisory at:
   https://github.com/PtiCalin/sql/security/advisories/new
2. Include clear reproduction steps and impact
3. Share suggested remediation if available

## Response Targets

- Acknowledgement: within 72 hours
- Initial triage: within 7 days
- Fix plan: as soon as impact is confirmed

## Security Best Practices For Contributors

- Never commit API keys, tokens, passwords, or credentials
- Prefer environment variables for local tooling
- Avoid copying SQL dumps that contain personal data
- Sanitize sample datasets in exercises/examples
