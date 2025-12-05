# Knapsack Pro: Why Same Token + Same Parallelism Breaks Test Filtering

## The Issue

When running separate test suites (e.g., unit tests and feature tests) with:
- **Same** `KNAPSACK_PRO_TEST_SUITE_TOKEN_RSPEC`
- **Same** `parallelism` value
- Same branch and commit

Knapsack Pro treats all parallel jobs as **one unified test suite** and creates a shared queue.

## How Knapsack Pro Queue/Split Works

Knapsack Pro uses a cache key to identify unique test suite runs:

```
cache_key = (branch, commit_hash, node_total, api_token)
```

When this cache key is identical across different steps, Knapsack Pro assumes they are part of the **same test run** and distributes tests from a shared pool.

## The Timeline of the Customer's Issue

### Before Sep 26th (Working)
```yaml
# Unit tests
parallelism: 8  # Different!
token: SAME_TOKEN

# Feature tests  
parallelism: 6  # Different!
token: SAME_TOKEN
```

Cache keys were **different** because `node_total` differed:
- Unit: `(main, abc123, 8, token123)`
- Feature: `(main, abc123, 6, token123)`

### After Sep 26th (Broken)
```yaml
# Unit tests
parallelism: 10  # Same!
token: SAME_TOKEN

# Feature tests
parallelism: 10  # Same!
token: SAME_TOKEN
```

Cache keys became **identical**:
- Unit: `(main, abc123, 10, token123)`
- Feature: `(main, abc123, 10, token123)`

Both steps now share the same queue, and `KNAPSACK_PRO_TEST_FILE_PATTERN` is ignored at the API level.

## The Fix

**Use separate API tokens for each test suite:**

```yaml
steps:
  - label: "Unit Tests"
    parallelism: 10
    env:
      KNAPSACK_PRO_TEST_SUITE_TOKEN_RSPEC: ${KNAPSACK_PRO_TOKEN_UNIT}
      KNAPSACK_PRO_TEST_FILE_PATTERN: "spec/**/*_spec.rb"
      KNAPSACK_PRO_TEST_FILE_EXCLUDE_PATTERN: "spec/features/**/*_spec.rb"
    plugins:
      - docker-compose#v5.x.x:
          run: app
          command: bundle exec rake knapsack_pro:queue:rspec
          env:
            - BUILDKITE_PARALLEL_JOB_COUNT
            - BUILDKITE_PARALLEL_JOB
            - KNAPSACK_PRO_TEST_SUITE_TOKEN_RSPEC
            - KNAPSACK_PRO_TEST_FILE_PATTERN
            - KNAPSACK_PRO_TEST_FILE_EXCLUDE_PATTERN

  - label: "Feature Tests"
    parallelism: 10
    env:
      KNAPSACK_PRO_TEST_SUITE_TOKEN_RSPEC: ${KNAPSACK_PRO_TOKEN_FEATURE}
      KNAPSACK_PRO_TEST_FILE_PATTERN: "spec/features/**/*_spec.rb"
    plugins:
      - docker-compose#v5.x.x:
          run: app
          command: bundle exec rake knapsack_pro:queue:rspec
          env:
            - BUILDKITE_PARALLEL_JOB_COUNT
            - BUILDKITE_PARALLEL_JOB
            - KNAPSACK_PRO_TEST_SUITE_TOKEN_RSPEC
            - KNAPSACK_PRO_TEST_FILE_PATTERN
```

## How to Generate Additional Tokens

1. Go to [Knapsack Pro Dashboard](https://knapsackpro.com/dashboard)
2. Navigate to your organization → project
3. Create a new test suite for "Feature Tests"
4. Copy the new API token
5. Add it to Buildkite as a secret environment variable

## Key Documentation

From [Knapsack Pro Reference](https://docs.knapsackpro.com/ruby/reference/):

> **`KNAPSACK_PRO_TEST_SUITE_TOKEN_*`**
> 
> API token required to run Knapsack Pro.
> **Each Knapsack Pro command defined on CI should use an individual API token.**

## Additional Considerations

When using the `docker-compose` plugin, ensure these env vars are passed to the container:

```yaml
env:
  - BUILDKITE_PARALLEL_JOB_COUNT
  - BUILDKITE_PARALLEL_JOB
  - BUILDKITE_BUILD_NUMBER
  - BUILDKITE_COMMIT
  - BUILDKITE_BRANCH
```

Without these, Knapsack Pro inside the container won't know which parallel job it is.
