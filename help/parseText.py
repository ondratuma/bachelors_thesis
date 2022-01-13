
import sys
import re
lang = 'en'

langs = {
    'cs': ["Literatura", "Kapitola"],
    'en': ["References", "Chapter"]
}

text = ""
i = 0;
for line in sys.stdin:
    if not re.search("^https://.*$", line):
        text += line
        i+=1

text = ''.join(re.split(langs[lang][0], text)[:-1])
text = ''.join(re.split(langs[lang][1], text)[1:])
words = len(text.strip().split(" "))
text = ''.join([i for i in text if i.isalpha()])

print("----------------------------------------------")
print("Počet slov:",words)
print("Počet znaků:",len(text))
print("Počet normostran:","{:.2f}".format(len(text)/1800))