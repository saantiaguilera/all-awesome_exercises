# Credit goes to Flynn58 ! Catch him on -> https://www.reddit.com/user/Flynn58

def gcd(a,b):
    while b: a, b = b, a%b
        return a

def function(x,y):
    return x // gcd(x,y), y // gcd(x,y)
