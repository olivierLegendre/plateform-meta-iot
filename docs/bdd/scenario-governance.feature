@v1 @wave5
Feature: Scenario governance and publication controls
  As a platform operator
  I want strict governance over automation scenario changes
  So that unsafe automations cannot be activated without review

  Background:
    Given scenario publishing is allowed for "org_admin" and "scenario_publisher"
    And production activation requires mandatory review and approval

  Scenario: Unauthorized role cannot publish scenario template
    Given user "u_operator" has role "operator"
    When "u_operator" attempts to publish a scenario template
    Then action is denied

  Scenario: Authorized role can submit scenario for review
    Given user "u_pub" has role "scenario_publisher"
    When "u_pub" submits scenario template "T1"
    Then scenario enters "pending_review" state

  Scenario: Scenario activation requires approval workflow
    Given scenario template "T1" is in "pending_review"
    When no approval is recorded
    Then scenario cannot be activated in production
    When approval is recorded by authorized approver
    Then scenario can be activated

  Scenario: High-risk command policy enforces two-person default approval
    Given scenario action includes "safety_critical" command
    When approval workflow is evaluated
    Then default approval policy requires two-person approval

  Scenario: All scenario state transitions are audited
    Given scenario "T1" transitions from "pending_review" to "active"
    When transition completes
    Then audit event is recorded with actor, timestamp, and transition details

