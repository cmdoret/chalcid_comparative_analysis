import csv
import os

Ccount = 0
Rcount = 0
processed = open(os.getcwd()+'/'+"processed_data", 'w')
with open(os.getcwd()+'/'+"raw_data.csv", 'rb') as raw_data:
    raw_reader = csv.reader(raw_data, delimiter=',', quotechar = '"')
    for row in raw_reader:
        Ccount = 0
        for i in row:
            if Rcount = 0:
                pass
            else:
                if
            Ccount += 1
        Rcount += 1
    raw_data.close()
    processed.close()

