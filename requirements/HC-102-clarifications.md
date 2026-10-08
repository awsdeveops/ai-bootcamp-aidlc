# HC-102 — Clarifications

Clarifications gathered from the Product Owner during the requirement readiness review, with the acceptance criteria and units of work derived from them.
The original requirement (`requirements.md`) is unchanged. Technology-neutral: no stack, design or estimates are chosen here.

**Readiness decision:** READY
**Inception phase:** Closed, approved by the Product Owner on 2026-10-06 (see section 5)

Contents: 1. Confirmed clarifications · 2. Acceptance criteria · 3. Units of work · 4. Open items · 5. Inception closure

---

## 1. Confirmed clarifications

### First round

| Area | Clarification |
|------|---------------|
| Source of truth | HC-102 (`requirements.md`). ADH-2 (JIRA_2.pdf) is not part of this review. |
| Eligible appointment | The appointment is in the future and is not cancelled. |
| Cut-off window | 24 hours. Rescheduling is disabled when the appointment is less than 24 hours away. |
| Blocked state | The Reschedule option is disabled. The patient sees a message explaining why and is directed to contact the clinic. |
| Failed booking | If the new booking fails (for example the slot was just taken), the original appointment stays unchanged. The patient sees an error and can pick another slot. |
| No available slots | The patient sees a "no slots available" message and is directed to contact the clinic. The original appointment stays. |
| Notifications | After a successful reschedule: patient confirmation, clinic or provider alert, and old reminders replaced with reminders for the new slot. |
| Privacy and access | A patient sees and reschedules only their own appointments. Notifications limit PHI to minimal information. |
| Audit | Full audit trail: who, when, old and new slot, channel and outcome, including failed and blocked attempts. |
| Dependencies | Scheduling Service, Availability API and Notification Service exist and need changes for this feature. |
| Channels | Web, mobile app and mobile browser (responsive web). |
| Accessibility | WCAG 2.2 AA on all supported channels. |

### Second round

| Area | Clarification |
|------|---------------|
| Proxies | Patient only. Guardians and proxies are out of scope. |
| Appointment types | All types are eligible. |
| Reschedule limit | No limit on how many times one appointment can be rescheduled. |
| Cut-off mid-flow | If the patient started before the cut-off, they can complete the change even if the appointment becomes less than 24 hours away before they confirm. |
| Failed or blocked attempts | The patient is notified (slot taken or booking failed, blocked by the cut-off, unexpected system error), with minimal information. No clinic alert and no confirmation is sent. |

### Third round

| Area | Clarification |
|------|---------------|
| Slot hold | The chosen new slot is held for the patient for 5 minutes. On expiry the slot is released, the patient is told, and they return to the slot list. The original appointment stays unchanged. |
| Time zone | All times are shown in the clinic's local time, and the 24-hour cut-off is measured in the clinic's time zone. |
| Session timeout | After a timeout, the patient resumes where they were after logging in again, if the 5-minute hold has not expired. If it has, the hold-expiry rule applies. |
| Dependency unavailable | If the Scheduling Service, Availability API or Notification Service is unavailable, the reschedule stops, the original appointment stays, the patient sees an error and gets the failed-attempt notice, and can try again later. |
| Overlapping appointments | A slot that overlaps another appointment the patient already has is blocked, and the original appointment stays. |

### Out of scope

- Changing provider.
- Changing appointment type.
- Staff-initiated rescheduling (all three from `requirements.md`).
- Guardians and proxies rescheduling for others (confirmed).

---

## 2. Acceptance criteria

Terms:
- **Eligible appointment:** in the future and not cancelled.
- **Cut-off window:** less than 24 hours before the appointment.

### AC1 — Reschedule option

- **AC1.1** Given a registered, logged-in patient with an eligible appointment outside the cut-off window, when they view that appointment, then a Reschedule option is shown and enabled.
- **AC1.2** Given an appointment that is cancelled or in the past, when the patient views their appointments, then no Reschedule option is available for it.
- **AC1.3** Given a patient, when they view appointments, then they see and can reschedule only their own appointments.

### AC2 — Eligibility and cut-off

- **AC2.1** Given an appointment exactly 24 hours away or more, when the patient views it, then the Reschedule option is enabled.
- **AC2.2** Given an appointment less than 24 hours away, when the patient views it, then the Reschedule option is disabled.
- **AC2.3** Given the option is disabled by the cut-off, when the patient views it, then a message explains that it is inside the cut-off window and directs them to contact the clinic.
- **AC2.4** Given the patient started rescheduling before the cut-off, when the appointment becomes less than 24 hours away before they confirm, then the patient can still complete the change. The cut-off applies when the patient starts, not when they confirm.

### AC3 — Available slots

- **AC3.1** Given the patient starts rescheduling, when slots are shown, then only available future slots from the Availability API are listed.
- **AC3.2** Given no available slots, when the patient starts rescheduling, then a "no slots available" message is shown with a direction to contact the clinic, and the original appointment stays unchanged.
- **AC3.3** Given the patient selects a slot, when they continue, then the flow moves to the review step. The provider and appointment type do not change (out of scope).
- **AC3.4** Given the patient selects a slot that overlaps another appointment they already have, then the slot is blocked, a message explains why, and the original appointment stays.
- **AC3.5** Given the patient selects a slot, then it is held for them for 5 minutes. When the hold expires before they confirm, the slot is released, the patient is told, and they return to the slot list. The original appointment stays.
- **AC3.6** Given the patient's session times out mid-flow, when they log in again within the hold, then they resume where they were. If the hold has expired, AC3.5 applies.
- **AC3.7** Given any appointment time or the cut-off, then times are shown in the clinic's local time and the cut-off is measured in the clinic's time zone.

### AC4 — Review and confirm

- **AC4.1** Given the patient has selected a new slot, when the review step is shown, then both the current and the new appointment details are displayed.
- **AC4.2** Given the review step, when the patient has not confirmed, then the appointment is not changed.
- **AC4.3** Given the patient confirms, when the new slot is still available, then the appointment moves to the new slot, the old slot is released, and the patient sees a confirmation of the new details.
- **AC4.4** Given the patient confirms, when the new booking fails (for example the slot was just taken), then the original appointment stays unchanged, an error is shown, and the patient can pick another slot.
- **AC4.5** Given any failure during confirmation, then the patient never ends up with two appointments or none.
- **AC4.6** Given the Scheduling Service, Availability API or Notification Service is unavailable during rescheduling, then the reschedule stops, the original appointment stays, the patient sees an error and receives the failed-attempt notice (AC5.5), and can try again later.

### AC5 — Notifications

- **AC5.1** Given a successful reschedule, then the patient receives a confirmation with the new appointment details.
- **AC5.2** Given a successful reschedule, then the clinic or provider is notified that the appointment moved.
- **AC5.3** Given a successful reschedule, then reminders for the old slot are cancelled and reminders for the new slot are scheduled.
- **AC5.4** Given any notification, then it contains only minimal information and no sensitive details such as the reason for the visit.
- **AC5.5** Given a failed or blocked reschedule (slot taken or booking failed, blocked by the cut-off, or an unexpected system error), then the patient receives a notification that the attempt did not succeed, with only minimal information (AC5.4). The clinic or provider is not alerted and no confirmation is sent.

### AC6 — Audit

- **AC6.1** Given a successful reschedule, then a record exists with who, when, old slot, new slot, channel and outcome.
- **AC6.2** Given a failed or blocked attempt (cut-off, slot conflict or error), then a record exists with the same fields and the outcome.

### AC7 — Channels and accessibility

- **AC7.1** Given the web, mobile app and mobile browser channels, then the full flow (AC1 to AC4) works on each.
- **AC7.2** Given any of these channels, then the flow, including error and message states, meets WCAG 2.2 AA.

---

## 3. Units of work

### Units

| ID | Unit | Acceptance criteria covered | Depends on |
|----|------|-----------------------------|------------|
| U1 | Eligibility and cut-off rule | AC1.1, AC1.2, AC2.1, AC2.2, AC2.4 | Scheduling Service (read appointments) |
| U2 | Available slot listing, overlap check, slot hold, session resume | AC3.1 to AC3.7 | Availability API |
| U3 | Reschedule operation (move appointment, release old slot, keep original on failure, stop when a service is down) | AC4.3 to AC4.6 | Scheduling Service changes |
| U4 | Review and confirm step | AC4.1, AC4.2 | U2 |
| U5 | Blocked and failure messaging | AC2.3, AC3.2, AC4.4 | U1, U2, U3 |
| U6 | Notifications (patient confirmation, clinic or provider alert, reminder replacement, patient notice for failed or blocked attempts, PHI limits) | AC5.1 to AC5.5 | Notification Service changes, U3 |
| U7 | Audit trail | AC6.1, AC6.2 | U1, U3 |
| U8 | Patient access control (own appointments only) | AC1.3 | Existing patient login (assumed) |
| U9 | Channel delivery and accessibility (web, mobile app, mobile browser, WCAG 2.2 AA) | AC7.1, AC7.2 | U1 to U5 |

### Dependency work (from "exist, need changes")

These are changes to existing services. The Product Owner confirmed that the owner of each change is whoever its ticket is assigned to (not a fixed name), and that the estimate is 5 working days in total for all three changes together.

| Dependency | Change needed for this feature | Needed by | Owner |
|------------|--------------------------------|-----------|-------|
| Scheduling Service | A way to move an appointment to a new slot, release the old one, and leave the original intact on failure | U1, U3 | Assignee of the ticket for this change |
| Availability API | Available future slots for the patient's appointment, with the same provider and appointment type, plus holding a slot for 5 minutes and releasing it on expiry | U2 | Assignee of the ticket for this change |
| Notification Service | Send the success and failed-attempt notification types with limited PHI, and replace old reminders | U6 | Assignee of the ticket for this change |

**Estimate:** 5 working days in total for all three changes (confirmed by the Product Owner).

### Suggested order

1. **Dependency changes first** (Scheduling Service, Availability API, Notification Service). Other units can't be finished without them.
2. **U1, U2, U8** in parallel. They are read-only and don't change data.
3. **U3** after the Scheduling Service change. This is the highest-risk unit because of the failure rule (AC4.5).
4. **U4, U5** once U1 to U3 work.
5. **U6, U7** once U3 works.
6. **U9** across all units, with accessibility tested as each screen lands, not at the end.

### Risks

- **Failed booking (AC4.5):** The old and new slot must change together, or the patient could end up with two appointments or none.
- **Dependency changes:** They are not yet scoped.
- **Notification Service down:** AC4.6 sends a failed-attempt notice, which can't be sent if the Notification Service itself is the one that's down. Design needs to say how the patient is still informed (the on-screen error is the only guaranteed channel).
- **Slot hold:** The Availability API or Scheduling Service must support holding a slot for 5 minutes and releasing it on expiry or abandonment.
- **Three channels plus WCAG 2.2 AA:** This multiplies testing effort.
- **Cut-off timing:** The cut-off applies when the patient starts, not when they confirm (AC2.4). The flow must remember that the patient started before the cut-off.

---

## 4. Open items

Not covered by the criteria above.

- Success targets and baselines for the business goals. The Product Owner chose to leave this open, and it does not block development.

---

## 5. Inception closure

Inception is closed with the open items in section 4 carried into Construction.

**Completed in Inception**
- The requirement was reviewed and decided READY.
- The Product Owner answered the critical questions (section 1).
- Acceptance criteria and units of work were derived from the answers (sections 2 and 3).

**Carried into Construction**
- Create a ticket for each of the three dependency changes. The owner of each change is whoever the ticket is assigned to, so no owner names are recorded here.
- Define success targets for the business goals before release.

**Sign-off**

The approver is the Architect or the Product Owner, whoever holds that role for this work. It is a role, not a fixed name.

| Field | Value |
|-------|-------|
| Approver role | Product Owner |
| Approver name | Raja Kaveliga |
| Date | 2026-10-06 |
| Decision | Approved |

The Product Owner approved the acceptance criteria and units of work in this session. Inception is closed.
