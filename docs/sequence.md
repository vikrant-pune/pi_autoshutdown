# Shutdown Sequence

This document shows the logical shutdown sequence.

```
Mac                Raspberry Pi           Router
 |                      |                   |
 |-- ping ------------->|                   |
 |<- response ----------|                   |
 |                      |                   |
 |-- ping ------------->|   (power lost)    |
 |<- no response -------|                   |
 |-- ping ------------->|                   |
 |<- no response -------|                   |
 |                      |                   |
 | threshold reached    |                   |
 |-- shutdown ----------> macOS             |
 |                      |                   |
```

Notes:
- Pings are spaced by 30 seconds.
- Shutdown occurs after multiple consecutive failures.
- No packet inspection or traffic capture occurs.
