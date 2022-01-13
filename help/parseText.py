
import sys
import re

text = ""
i = 0;
for line in sys.stdin:
    if not re.search("^https://.*$", text):
        text += line
        i+=1
print(i)
text = ''.join([i for i in text if i.isalpha()])
text = ''.join(re.split("References", text)[:-1])
text = ''.join(re.split("ChapterIntroduction", text)[1:])
print("----------------------------------------------")
print("Počet znaků:",len(text))
print("Počet normostran:","{:.2f}".format(len(text)/1800))