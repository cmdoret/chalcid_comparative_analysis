 
# The purpose of this script is to retrieve raw data from google ngrams to build a metric that estimate the literature coverage of different hymenoptera superfamilies.

# Cyril Matthey-Doret
# 09.12.2016

from google_ngram_downloader import readline_google_store

fname, url, records = next(readline_google_store(ngram_len=5))

next(records)
