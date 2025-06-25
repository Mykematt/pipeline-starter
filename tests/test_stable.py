import pytest


def test_stable_addition():
    """A stable test for basic addition"""
    assert 2 + 2 == 4


def test_stable_string():
    """A stable test for string operations"""
    text = "buildkite"
    assert text.upper() == "BUILDKITE"
    assert len(text) == 9


class TestStableMath:
    """Stable mathematical tests"""
    
    def test_multiplication(self):
        assert 3 * 4 == 12
    
    def test_division(self):
        assert 10 / 2 == 5
    
    def test_modulo(self):
        assert 10 % 3 == 1


@pytest.mark.parametrize("a,b,expected", [
    (1, 1, 2),
    (2, 3, 5),
    (10, -5, 5),
    (0, 0, 0)
])
def test_parametrized_stable(a, b, expected):
    """Parametrized stable test"""
    assert a + b == expected
