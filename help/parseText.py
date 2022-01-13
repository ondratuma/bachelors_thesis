
import sys
 
text = []
for line in sys.stdin:
    text.append(line)
 
print(text[0].replace(" ", ""))