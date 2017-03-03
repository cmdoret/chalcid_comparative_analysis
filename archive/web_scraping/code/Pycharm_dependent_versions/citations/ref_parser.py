import httplib
import urllib2
from bs4 import BeautifulSoup
import time
import re
from httplib import BadStatusLine

"""
This script retrieves citations from all species of Aphelinidae listed in the NHM Universal
Chalcidoidea database and return them as python objects.
"""


# To do: Make it loop through URLs by replacing names with some extracted in taxonomic tree


def recursive_url(my_address):
    try:
        return urllib2.urlopen(my_address, timeout=100)
    except urllib2.HTTPError:
        print "Proxy Error 502, trying again..."
        return recursive_url(my_address)
    except httplib.BadStatusLine:
        print "ERROR: Bad Status Line"
        return recursive_url(my_address)


def get_refs(address):
    no_dupp = ""
    refnum = 0
    response = recursive_url(
        'http://www.nhm.ac.uk/our-science/data/chalcidoids/database/synonyms' + address[6:])
    html = response.read()
    soup = BeautifulSoup(html, 'html.parser')
    try:
        cont = soup.find("div", id="microsite-body")
        #print cont
        ref_cont = cont.find_all("td")
        #print "-" * 80
        #print ref_cont
    except AttributeError:
        print "Page does not exist, returning 0 citations."
        return 0
    if ref_cont is None:
        return 0
    else:
        refnum = 0
        print ref_cont
        for i in ref_cont[1:]:
            if i.text not in no_dupp:
                if re.search(r'([0-9]){4}', i.text) and "img" not in str(i.tag):
                    # Iterating over tables (1 article = 1table).
                    print i.text.replace("\n", "").replace("\r", "").replace("\t", "")
                    # replace is just used to make debugging easier by removing newlines in output
                    refnum += len(re.findall(r'([0-9]){4}', i.text)) # adds as many references as there are dates.
                    #print "MATCH = " + str(i.text not in no_dupp)
                    no_dupp = i.text
                    #print "ADDED CITATION number: " + str(refnum)
        print "Total number of citations: " + str(refnum)
        return refnum
