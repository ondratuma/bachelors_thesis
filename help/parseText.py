
import sys
import re

text = ""
for line in sys.stdin:
    text += line

text = ''.join([i for i in text if i.isalpha()])
text = re.split("Reference", text)
print(text)
print("Počet slov:",len(text))