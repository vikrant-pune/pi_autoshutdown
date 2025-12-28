# pi_autoshutdown

**Power-failure aware macOS shutdown without USB-HID UPS, cloud services, or router hacks.**

This project enables a Mac (e.g. Mac mini) to **shut down cleanly during a power outage**
by using the disappearance of a Raspberry Pi as a reliable power-loss signal.

No USB-HID UPS.  
No vendor software.  
No cloud.  
No packet inspection.

---

## Problem

Many home UPS units:
- Are not USB-HID compliant
- Cannot signal power loss to macOS
- Only provide a few minutes of backup
- Leave systems vulnerable when unattended

In this setup:
- The Mac is on a small UPS
- The router has its own power backup
- A Raspberry Pi is powered directly from wall mains
- The UPS cannot communicate with macOS

---

## Key Idea

> **Use the absence of a trusted always-on device as a power-failure signal.**

When mains power fails:
- Router stays online (backup)
- Raspberry Pi loses power
- Mac detects Pi disappearance
- Mac shuts down safely

Presence becomes the signal.

---

## How It Works

1. macOS runs a small sentinel script every 30 seconds
2. The script checks whether the Raspberry Pi is reachable
3. If reachable → reset failure counter
4. If unreachable → increment counter
5. If unreachable for ~3 minutes:
   - Log the event
   - Shut down macOS cleanly

This avoids false shutdowns caused by:
- Brief Wi-Fi drops
- Pi reboots
- Transient network issues

---

## Architecture

