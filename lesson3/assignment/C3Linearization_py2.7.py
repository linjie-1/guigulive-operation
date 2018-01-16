#!/usr/bin/python
# C3 Linerization test

class Type(type):
    def __repr__(cls):
        return cls.__name__

A = Type('A', (object,), {})
B = Type('B', (object,), {})
C = Type('C', (object,), {})

K1 = Type('K1', (B, A), {})
K2 = Type('K2', (C, A), {})

Z = Type('Z', (K2, K1), {})

print Z.mro()


