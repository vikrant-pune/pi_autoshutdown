# Architecture Notes

This document explains the architectural reasoning behind **pi_autoshutdown**.

## Core Idea

The system relies on **presence-based signaling** instead of direct UPS integration.

- The Raspberry Pi is powered directly from mains.
- The router has its own power backup.
- The Mac is protected by a UPS but cannot detect power loss.

When mains power fails:
- The Raspberry Pi goes offline.
- The router remains reachable.
- The Mac infers a power outage by detecting Pi absence.

This avoids:
- USB-HID dependencies
- Vendor-specific UPS software
- Cloud services
- Router firmware modification

## Why Presence-Based Signaling Works

In home environments:
- Routers often survive outages due to backup batteries.
- Small always-on devices (Pi) do not.
- Network connectivity partially survives outages.

This creates a reliable asymmetric signal.

## Design Constraints

- Deterministic behavior
- Explainability over cleverness
- Minimal moving parts
- Safe failure modes

If any component fails unexpectedly, the default outcome is **no shutdown**, not data loss.
