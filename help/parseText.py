import fileinput

for line in fileinput.input():
    print(len(line))