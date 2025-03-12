---
name: Nextcloud Docker Bug Report
about: Report an issue with the Nextcloud Docker setup
title: '[BUG] '
labels: bug, docker
assignees: 'pdarleyjr'

---

## Describe the bug
A clear and concise description of what the bug is.

## Environment
- **Docker version**: `docker --version`
- **Docker Compose version**: `docker compose version`
- **Host OS**: [e.g. Ubuntu 22.04, Windows 11, macOS 12.0]
- **GitHub Codespace**: [Yes/No]
- **Browser**: [e.g. Chrome 99, Firefox 95]

## Container Information
```
# Paste output from:
docker ps -a
```

## To Reproduce
Steps to reproduce the behavior:
1. Start containers with '...'
2. Access Nextcloud at '...'
3. Perform action '...'
4. See error

## Container Logs
<details>
<summary>Nextcloud Container Logs</summary>

```
# Paste output from:
docker logs nextcloud_app
```
</details>

<details>
<summary>Database Container Logs</summary>

```
# Paste output from:
docker logs nextcloud_db
```
</details>

## Expected behavior
A clear and concise description of what you expected to happen.

## Screenshots
If applicable, add screenshots to help explain your problem.

## Additional context
- Did this work previously and stop working?
- Have you modified the docker-compose.yml file?
- Are any special configurations in place?
