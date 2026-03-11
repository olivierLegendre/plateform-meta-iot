Feature: Command execution policy and channel fallback
  As a platform
  I want deterministic command behavior per class
  So that reliability and safety constraints are enforced

  Background:
    Given command classes are "safety_critical", "interactive_control", "routine_automation", and "bulk_non_critical"
    And API is the primary channel
    And API and MQTT are handled by separate components

  Scenario: Safety critical command uses API only
    Given a command of class "safety_critical"
    When dispatch policy is evaluated
    Then channel is "API"
    And MQTT fallback is not allowed

  Scenario: Interactive control falls back to MQTT after API timeout
    Given a command of class "interactive_control"
    And API timeout threshold is 3 seconds
    And API attempts before fallback are 1
    When API attempt times out
    Then fallback channel is "MQTT"
    And MQTT retry budget is 2

  Scenario: Routine automation falls back after two API attempts
    Given a command of class "routine_automation"
    And API timeout threshold is 10 seconds
    And API attempts before fallback are 2
    When both API attempts fail with transient error
    Then fallback channel is "MQTT"
    And MQTT retry budget is 3

  Scenario: Bulk non critical remains API-only
    Given a command of class "bulk_non_critical"
    When dispatch policy is evaluated
    Then channel is "API"
    And MQTT fallback is disabled

  Scenario: Safety critical success requires observed state
    Given a "safety_critical" command is sent
    And transport acknowledgement is received
    But observed state does not match desired state
    When reconciliation deadline is reached
    Then command result is "failed"

  Scenario: SLA breach on safety critical triggers immediate action
    Given a "safety_critical" command is accepted
    And applied confirmation is not observed within 60 seconds
    When reconciliation SLA is breached
    Then command is marked "failed"
    And high-severity alert is generated
    And manual operator action is required

  Scenario: Command is immutable after accepted
    Given a command has status "accepted"
    When a payload update is requested
    Then the update is rejected
    And caller is instructed to use cancel-and-reissue

  Scenario: Cancel is allowed only before dispatch
    Given a command with status "accepted"
    When cancel is requested
    Then cancel is authorized
    Given the same command has status "dispatched"
    When cancel is requested
    Then cancel is rejected

  Scenario: Channel override is restricted and audited
    Given user "u_ops" has designated operations override role
    When "u_ops" requests channel override for a command
    And reason is provided
    Then override is accepted
    And override action is audited

  Scenario: Safety critical missing idempotency key is rejected
    Given a "safety_critical" command request has no idempotency key
    When the API validates request
    Then response code is 422

  Scenario: Safety critical missing correlation id is rejected
    Given a "safety_critical" command request has no correlation id
    When the API validates request
    Then response code is 422

