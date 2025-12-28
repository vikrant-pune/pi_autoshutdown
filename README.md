# pi_autoshutdown

**Power-failure aware macOS shutdown without USB-HID UPS, cloud services, or router hacks.**

This project enables a Mac (for example, a Mac mini) to **shut down cleanly during a power outage**
by using the disappearance of a Raspberry Pi as a reliable power-loss signal.

No USB-HID UPS  
No vendor software  
No cloud dependency  
No router modification  

---

## Problem

Many home UPS devices:

- Are not USB-HID compliant
- Cannot signal power loss to macOS
- Provide only a few minutes of backup
- Require manual shutdown if you are present
- Offer no protection when you are away

In this setup:

- The Mac is connected to a small UPS
- The router has its own power backup
- A Raspberry Pi is powered directly from wall mains
- The UPS cannot communicate with macOS

Sudden power loss risks filesystem corruption and unclean shutdowns.

---

## Key Idea

> **Use the disappearance of a trusted always-on device as a power-failure signal.**

When mains power fails:

- Router stays online (on backup)
- Raspberry Pi loses power
- Network remains reachable
- Mac detects Pi absence
- Mac shuts down safely

Presence becomes the signal.

---

## Architecture

### Components

- **Mac**
  - Protected workload
  - Runs shutdown sentinel
  - Connected to UPS
- **Raspberry Pi**
  - Powered from wall socket
  - Acts as presence beacon
- **Router**
  - Has power backup
  - Not modified

### Power-flow logic

Mains Power ON
 - Router (backup)
 - Raspberry Pi (wall power)
 - Mac (UPS)

Mains Power OFF
 - Router stays ON
 - Raspberry Pi goes OFF
 - Mac detects Pi loss → shutdown

---

## How It Works

1. macOS runs a small sentinel script every 30 seconds
2. The script checks whether the Raspberry Pi is reachable
3. If reachable → reset failure counter
4. If unreachable → increment counter
5. If unreachable for ~3 minutes:
   - Log the event
   - Shut down macOS cleanly

This debounce avoids shutdowns caused by:

- Brief Wi-Fi drops
- Pi reboots
- Transient network issues

---

## Execution Model (macOS-native)

- Uses **launchd** (`StartInterval = 30`)
- No long-running daemons
- No infinite loops
- No overlapping executions

Each run:
- Executes
- Evaluates state
- Exits immediately

This follows macOS best practices.

---

## Shutdown Authority & Safety

macOS is configured to allow exactly **one privileged command**:

/sbin/shutdown

- No passwordless shell
- No general sudo access
- Minimal blast radius

---

## What Happens During Shutdown

When shutdown is triggered:

- macOS broadcasts system warnings automatically
- New logins are blocked:
  NO LOGINS: System going down at HH:MM
- Running applications receive termination signals
- Filesystems are synced
- System powers off cleanly

This indicates a controlled shutdown, not a crash.

---

## Logging & Audit Trail

A single authoritative log entry is written:

pi-sentinel: Pi unreachable for 6 checks, shutting down Mac

Logs are written using `logger` and stored in **macOS Unified Logging**.

Query example:

log show --predicate 'eventMessage CONTAINS "pi-sentinel"' --last 24h --style syslog

This answers, after the fact:

- Why did the Mac shut down?
- When did it happen?
- Was it intentional?

---

## Known Limitations

### USB Devices During Automated Shutdown

- USB sticks may fail to re-enumerate after reboot
- Caused by USB controller power-state behavior
- External SSDs behave more reliably

**Guideline:**  
USB sticks are removable media, not reliable always-attached storage.

---

## Disable Instantly

To disable automatic shutdown:

launchctl unload ~/Library/LaunchAgents/com.pi.sentinel.plist

No reboot required.

---

## Repository Structure

src/   → sentinel script + launchd plist  
docs/  → architecture & sequence notes

---

## What This Approach Avoids

- USB-HID dependency
- Vendor-specific UPS software
- Cloud dashboards
- Router firmware hacks
- Packet inspection
- Always-running background daemons

---

## Design Philosophy

- Presence over introspection
- Metadata over payloads
- Explicit behavior over cleverness
- Graceful failure over recovery

---

## Summary

This project demonstrates that:

- macOS can shut down safely without USB-HID UPS support
- Presence-based signaling works reliably in home environments
- Simple systems are easier to trust than complex ones

**Graceful failure beats clever recovery.**


