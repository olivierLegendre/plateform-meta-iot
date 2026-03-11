@v1 @wave0 @wave2
Feature: API versioning and deprecation lifecycle
  As an API consumer
  I want predictable version lifecycle behavior
  So that migrations are planned and observable

  Background:
    Given API versioning uses path format "/api/v{major}/..."
    And major version overlap window is 90 calendar days
    And deprecation signaling uses standard headers

  @wave2
  Scenario: Deprecated endpoint returns standard deprecation headers
    Given endpoint "/api/v1/resource" is deprecated
    And overlap window is active
    When client calls "/api/v1/resource"
    Then response includes headers "Deprecation", "Sunset", and "Link"

  @wave2
  Scenario: Deprecated endpoint returns structured warning payload
    Given endpoint "/api/v1/resource" is deprecated
    When client calls the endpoint and receives 2xx
    Then response body includes warning object with fields:
      | code |
      | message |
      | sunset_at |
      | replacement |
      | docs_url |

  @wave2
  Scenario: Deprecation warning also appears on 4xx responses
    Given endpoint "/api/v1/resource" is deprecated
    When client calls endpoint and receives 4xx
    Then deprecation headers are present
    And warning object is present in response body

  @wave2
  Scenario: Deprecation warning is omitted on 5xx responses
    Given endpoint "/api/v1/resource" is deprecated
    When endpoint returns 5xx
    Then no deprecation warning payload is added

  @wave2
  Scenario: Deprecated endpoint is removed after overlap
    Given overlap cutoff has passed
    When client calls deprecated endpoint
    Then response code is 410
    And response contains machine-readable migration hint
    And response includes replacement endpoint and docs link

  @wave2
  Scenario: Migration docs URL is versioned per major release
    Given release introduces API v2
    When migration package is published
    Then docs include versioned URL path for v1 to v2 migration

