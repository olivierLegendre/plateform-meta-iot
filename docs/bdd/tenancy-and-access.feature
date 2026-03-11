@v1 @wave1 @wave2
Feature: Tenancy and access control
  As a platform operator
  I want strict tenancy and scope enforcement
  So that data and actions remain isolated and auditable

  Background:
    Given the tenancy model is customer -> organization -> site
    And the physical model is site -> building -> floor -> space -> equipment -> point
    And access is site-scoped by default

  Scenario: Site-scoped user can access only granted site data
    Given user "u_site_ops" has role "operator" on site "S1"
    And user "u_site_ops" has no grant on site "S2"
    When "u_site_ops" requests point telemetry for site "S1"
    Then the request is authorized
    When "u_site_ops" requests point telemetry for site "S2"
    Then the request is denied

  Scenario: Cross-site access requires explicit multi-site grant
    Given user "u_multi" has role "viewer" on site "S1"
    And user "u_multi" has role "viewer" on site "S2"
    When "u_multi" requests data across sites "S1" and "S2"
    Then the request is authorized

  Scenario: Organization admin is organization-scoped
    Given user "u_org_admin" has role "org_admin" on organization "O1"
    And organization "O1" owns sites "S1" and "S2"
    When "u_org_admin" requests admin settings for "S1"
    Then the request is authorized
    When "u_org_admin" requests admin settings for site "S3" in organization "O2"
    Then the request is denied

  Scenario: Service account is site-scoped by default
    Given service account "sa_ingest_s1" is scoped to site "S1"
    When "sa_ingest_s1" writes telemetry for site "S1"
    Then the write is authorized
    When "sa_ingest_s1" writes telemetry for site "S2"
    Then the write is denied

  Scenario: DB-level isolation prevents cross-organization reads
    Given data exists for organization "O1" and organization "O2"
    And request context is organization "O1"
    When a read query executes for telemetry
    Then no row from organization "O2" is returned

  Scenario: DB-level isolation prevents cross-organization links
    Given equipment "E1" belongs to organization "O1"
    And point "P2" belongs to organization "O2"
    When a link from "E1" to "P2" is created
    Then the operation is rejected

  Scenario: Site admin can configure notifications for own site only
    Given user "u_site_admin" has role "site_admin" on site "S1"
    When "u_site_admin" sets notification recipients for site "S1"
    Then the update is authorized
    When "u_site_admin" sets notification recipients for site "S2"
    Then the update is denied

