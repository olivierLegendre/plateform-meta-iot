Feature: Data governance, security baseline, and exports
  As a platform owner
  I want enforceable governance and security controls
  So that compliance and operational risk are managed

  Background:
    Given data residency is EU-only in V1
    And command, approval, and incident retention is 24 months
    And telemetry retention is 90-day hot and 24-month cold archive
    And Vault is required before first production go-live

  Scenario: Production go-live is blocked when Vault is not configured
    Given deployment target is first production customer
    And Vault is not configured
    When go-live gate is evaluated
    Then go-live is blocked

  Scenario: PII is masked by default in exports
    Given export request contains user-identifiable fields
    When export is generated
    Then PII fields are masked by default

  Scenario: Explicit unmask requires org admin and audit trail
    Given user "u_site_admin" requests unmasked export
    When authorization is evaluated
    Then request is denied
    Given user "u_org_admin" requests unmasked export
    When authorization is evaluated
    Then request is allowed
    And unmask action is audited

  Scenario: Site admin export scope remains site-limited
    Given user "u_site_admin" belongs to site "S1"
    When "u_site_admin" exports incidents
    Then export contains only site "S1" records

  Scenario: Organization admin export scope covers organization
    Given user "u_org_admin" belongs to organization "O1"
    When "u_org_admin" exports incidents
    Then export contains all sites under organization "O1"

  Scenario: Distributed tracing is enabled in V1
    Given command request traverses API, router, and worker services
    When observability data is emitted
    Then trace identifiers are propagated across services

  Scenario: Core API SLO is measured at 99.5 percent monthly target
    Given SLO window is current calendar month
    When availability is computed
    Then SLO target for core APIs is 99.5 percent

