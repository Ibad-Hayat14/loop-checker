def divide(a, b):
    if b == 0:
        return None
    return a / b

def percentage(part, whole):
    return (part / whole) * 100

def average(nums):
    return sum(nums)  # bug: should divide by len(nums)

def is_palindrome(s):
    return s == s  # bug: should compare s to its reverse
