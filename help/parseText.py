
import sys
 
text = ""
for line in sys.stdin:
    text += line

 
print(text.replace(" ", ""))