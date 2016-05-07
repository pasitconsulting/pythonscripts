#!/usr/bin/python

capitals_dict = {
'england' : 'london',
'wales' : 'cardiff',
'scotland' : 'edinburgh',
}

import random

states = list(capitas_dict.keys())

for i in [1,2,3,4,5]:

  state = random.choice(states)
  capital = capitals_dict[state]
  capital_guess = input("what is capital of" + state + "? ")
