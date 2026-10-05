import pytest
from src.calc import divide, percentage, average, is_palindrome

def test_divide_normal():
    assert divide(10, 2) == 5

def test_divide_by_zero_returns_none():
    assert divide(10, 0) is None

def test_percentage():
    assert percentage(25, 200) == 12.5

def test_average():
    assert average([2, 4, 6]) == 4

def test_is_palindrome_true():
    assert is_palindrome("level") is True

def test_is_palindrome_false():
    assert is_palindrome("hello") is False
