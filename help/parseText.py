file = open('output/text.txt',mode='r')
all_of_it = file.read()

chars = 0
stripped = all_of_it.replace('\n', '').replace(' ', '').strip()

print(len(stripped))
