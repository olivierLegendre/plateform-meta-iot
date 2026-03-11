Feature: Incident lifecycle, escalation, and notifications
  As an operations platform
  I want controlled incident governance
  So that safety and accountability requirements are met

  Background:
    Given incidents are auto-created for safety failures
    And incident records are append-only
    And closure requires a resolution note
    And root-cause category is mandatory
    And allowed root causes include "unknown"

  Scenario: Incident is created on safety SLA breach
    Given a safety command breaches reconciliation SLA
    When incident processing runs
    Then an incident is created with status "open"
    And command is linked to the incident

  Scenario: Incident close requires root cause and resolution note
    Given incident I1 is "open"
    When user attempts closure without root cause
    Then closure is rejected
    When user attempts closure without resolution note
    Then closure is rejected
    When root cause and resolution note are provided
    Then incident is marked "resolved"

  Scenario: Incident reopen keeps same incident id and requires note
    Given incident I1 is "resolved"
    When user reopens I1 without reopen note
    Then reopen is rejected
    When user reopens I1 with reopen note
    Then incident I1 is marked "open"

  Scenario: Safety page escalation uses 15-minute acknowledgment SLA
    Given a safety alert is active
    And acknowledgment is not received within 15 minutes
    When escalation policy is executed
    Then alert escalates to secondary on-call and site duty manager

  Scenario: Off-hours safety events page immediately
    Given current time is outside business-hours window
    When safety-critical delay or failure alert is generated
    Then paging is immediate

  Scenario: T+30 requires manual confirmation for non-safety freeze
    Given safety incident escalation reaches T+30
    When no manual confirmation is provided
    Then non-safety execution freeze is not activated
    And new non-safety commands are accepted but held

  Scenario: Held non-safety commands auto-expire after 60 minutes
    Given non-safety commands are held due to safety incident
    When hold duration reaches 60 minutes
    Then held commands are marked "expired_due_to_safety_incident"
    And immediate user notification is sent

  Scenario: Resume rights are restricted to site and org admin
    Given incident I1 is active on site "S1"
    When user with role "operator" attempts resume
    Then resume is denied
    When user with role "site_admin" attempts resume
    Then resume is allowed

  Scenario: Notification channels are in-app and email
    Given an incident event requires immediate notification
    When notification is sent
    Then in-app notification is created
    And email notification is sent

  Scenario: Email retries three times over fifteen minutes
    Given an email send attempt fails
    When retry schedule is executed
    Then up to three retries occur within fifteen minutes
    And notification is marked failed after retry budget is exhausted

