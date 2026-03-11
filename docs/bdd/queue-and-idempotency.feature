@v1 @wave3 @wave4
Feature: Queueing, serialization, idempotency, and retry behavior
  As a command-processing platform
  I want safe queueing and deduplication
  So that duplicate actuation and unsafe concurrency are prevented

  Background:
    Given strict serialization is enforced per point
    And queue backend is PostgreSQL
    And queue survives service restarts
    And max queue depth per point is 5
    And queue overflow returns 503 with Retry-After 30

  @wave4
  Scenario: New command is queued when point has in-flight command
    Given point "P1" has one in-flight command
    When a new command arrives for "P1"
    Then the command is added to queue

  @wave4
  Scenario: Queue overflow fails with 503 and Retry-After header
    Given point "P1" queue depth is 5
    When a new command arrives for "P1"
    Then response code is 503
    And header "Retry-After" equals "30"
    And response includes current queue depth

  @wave4
  Scenario: FIFO execution within normal priority flow
    Given queue contains commands C1, C2, C3 of same priority
    When dispatch progresses
    Then execution order is C1, C2, C3

  @wave4
  Scenario: Safety command is prioritized in queued items
    Given queue has non-safety commands C1 and C2 for point "P1"
    When command C3 of class "safety_critical" is added
    Then C3 is reordered before C1 and C2 in queue

  @wave4
  Scenario: In-flight non-safety command is not preempted by safety command
    Given point "P1" has in-flight non-safety command C1
    And safety command C2 arrives
    When policy is applied
    Then C1 continues
    And C2 is next after C1
    And a high-priority delay audit event is emitted

  @wave4
  Scenario: Fail-safe mode blocks new commands on persistence outage
    Given queue persistence is unavailable
    When any new command request arrives
    Then request is rejected
    And immediate alert is generated

  @wave3 @wave4
  Scenario: Idempotency deduplicates within one hour per site
    Given command key "K1" is recorded for site "S1"
    When a second request with key "K1" arrives within one hour for site "S1"
    Then request is treated as duplicate and not re-executed
    When key "K1" arrives for site "S2"
    Then it is evaluated independently

  @wave4
  Scenario: Platform generates idempotency key for non-safety command when missing
    Given a non-safety command request has no idempotency key
    When request is accepted
    Then platform generates idempotency key
    And generated key is returned in response

  @wave4
  Scenario: Correlation id uniqueness is enforced per site for 24h
    Given correlation id "X1" exists for site "S1" in the last 24 hours
    When new request uses correlation id "X1" for site "S1"
    Then response code is 409
    And response contains existing command reference

  @wave4
  Scenario: Reissue creates new command identity and lineage
    Given command C1 has status "expired_due_to_safety_incident"
    When operator uses reissue wizard
    Then new command C2 is created
    And C2 has new idempotency key
    And C2 has new correlation id
    And C2.parent_command_id equals C1.id

