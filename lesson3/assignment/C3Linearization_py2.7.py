#!/usr/bin/python
# C3 Linerization test

class Type(type):
    def __repr__(cls):
        return cls.__name__

A = Type('A', (object,), {})
B = Type('B', (object,), {})
C = Type('C', (object,), {})

K1 = Type('K1', (A, B), {})
K2 = Type('K2', (A, C), {})

Z = Type('Z', (K1, K2), {})

print Z.mro()


