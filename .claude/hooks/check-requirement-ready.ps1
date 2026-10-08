$readyFile = ".claude/REQUIREMENT_READY"

if (Test-Path $readyFile) {
    Write-Output "Requirement is READY. Development may proceed."
    exit 0
}

Write-Output "BLOCKED: Requirement has not been approved as READY."
Write-Output "Complete the Requirement Readiness review before proceeding."
exit 2