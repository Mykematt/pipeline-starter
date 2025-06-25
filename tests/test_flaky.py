import pytest
import random
import time


def test_always_pass():
    """A test that always passes"""
    assert True


def test_flaky_random():
    """A flaky test that randomly fails"""
    # 30% chance of failure
    if random.random() < 0.3:
        pytest.fail("Random failure occurred!")
    assert True


def test_flaky_timing():
    """A flaky test that sometimes times out"""
    # Simulate varying response times
    delay = random.uniform(0.1, 0.5)
    time.sleep(delay)
    
    # Fail if delay is too long (simulating timeout)
    if delay > 0.4:
        pytest.fail(f"Simulated timeout after {delay:.2f}s")
    
    assert True


def test_intermittent_network():
    """Simulates an intermittent network failure"""
    # 40% chance of "network" failure
    if random.random() < 0.4:
        raise ConnectionError("Simulated network failure")
    
    assert True


class TestFlakySuite:
    """A test class with multiple flaky tests"""
    
    def test_memory_issue(self):
        """Simulates memory-related flakiness"""
        # 25% chance of failure
        if random.random() < 0.25:
            raise MemoryError("Simulated memory issue")
        assert True
    
    def test_race_condition(self):
        """Simulates a race condition"""
        # Random delay to simulate race condition
        time.sleep(random.uniform(0.01, 0.1))
        
        # 20% chance of failure
        if random.random() < 0.2:
            pytest.fail("Race condition detected!")
        
        assert True


@pytest.mark.parametrize("iteration", range(5))
def test_parametrized_flaky(iteration):
    """Parametrized test that can be flaky"""
    # Higher failure rate for later iterations
    failure_rate = iteration * 0.1
    
    if random.random() < failure_rate:
        pytest.fail(f"Parametrized test failed on iteration {iteration}")
    
    assert True
