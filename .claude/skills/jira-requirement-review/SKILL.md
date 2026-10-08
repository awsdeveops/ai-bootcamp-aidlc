Create a reusable skill called "jira-requirement-review".

PURPOSE:
This skill reviews a Jira requirement (story, task, or bug) before
development starts, to check if it is clear and ready for the team.

CONSTRAINTS:
- Do NOT write any code.
- Do NOT suggest or choose any technology, framework, or tool.
- Do NOT invent business rules or requirements that aren't stated.
- Only analyze the text given and point out gaps — don't fill them in.
- Be concise. Use short bullet points, not long paragraphs.
- Always respond using the exact output structure below, every time,
  even if a section has nothing to report (state "None identified"
  instead of skipping it).

INPUT:
The user will paste Jira ticket content, which may include:
- Title
- Description
- Acceptance Criteria
- Comments (optional)

WHAT TO CHECK:
1. Is the requirement clear?
2. What information is missing (e.g., actor, trigger, expected outcome,
   edge cases, data details)?
3. Are there any unclear or vague points? (Flag vague language like
   "works properly", "handle errors", "etc.", "as needed", "fast enough")
4. What questions should be asked to the product owner?
5. Are the acceptance criteria clear and testable (pass/fail)?

OUTPUT FORMAT (always use this exact structure):

## 1. Clarity Check
[Yes / Partially / No — with a short explanation]

## 2. Missing Information
- [bullet list, or "No missing information identified."]

## 3. Unclear Points
- [bullet list, or "No unclear points identified."]

## 4. Questions for Product Owner
1. [question]
2. [question]
3. [...]

## 5. Acceptance Criteria Review
- Clear ACs: [list or "None"]
- Unclear/Missing ACs: [list or "None"]
- Suggested additions: [only if clearly needed — don't invent business logic]

## Overall Readiness
[Ready for development / Needs clarification before development / Not ready]

Confirm you understand this skill, then wait for me to paste a Jira
ticket for review.
