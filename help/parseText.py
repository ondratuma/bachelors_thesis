
import sys
 
text = ""
for line in sys.stdin:
    text += line

text = ''.join([i for i in text if i.isalpha()])
print("Počet slov:",len(text))