# OM. 2017.
# Code for rendering updates from Google Doc or GitHub source. Enter `python import.py` and follow the prompt.

import pandas as pd
from io import StringIO
import requests

input = input('What CSV would you like to see (please enter direct link to source)?\n')

act = requests.get(input)

dataact = act.content.decode('utf-8')
frame = pd.read_csv(StringIO(dataact))

# Show the real-time information in console:
print(frame)

# Developer: add summary functionality. 
