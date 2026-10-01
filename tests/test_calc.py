import pytest
from src.calc import divide, percentage

def test_divide_normal():
    assert divide(10, 2) == 5

def test_divide_by_zero_returns_none():
    assert divide(10, 0) is None   # currently fails: raises ZeroDivisionError

def test_percentage():
    assert percentage(25, 200) == 12.5
