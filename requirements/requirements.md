# HC-102 — Patient Self-Service Appointment Rescheduling

## Business Problem

Patients can book and cancel appointments online, but they cannot reschedule.
They must call the clinic or cancel and book again.

## User Story

As a registered patient with an eligible upcoming appointment,
I want to move my appointment to another available slot online,
so that I don't have to call the clinic.

## Business Goal

- Reduce rescheduling-related calls
- Reduce cancel-and-rebook activity
- Improve patient experience
- Increase self-service adoption

## Acceptance Criteria

### AC1 — Reschedule

Eligible appointments show a Reschedule option.

### AC2 — Eligibility

Rescheduling is disabled inside the configured cut-off window.

### AC3 — Available Slots

Show available future appointment slots.

### AC4 — Review & Confirm

Show the current and new appointment details and require confirmation.

## Out of Scope

- Changing provider
- Changing appointment type
- Staff initiated rescheduling

## Dependencies

- Scheduling Service
- Availability API
- Notification Service