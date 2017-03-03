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


def recursive_url(my_address):
    """
    This function allows to request the webpage of a species on the NHM website for a given URL.
    In case connexion is lost or server is unavailable, it will try again until it succeeds.
    :param my_address: The URL of the wasp species on the NHM website
    :return: The html page corresponding to the species.
    """
    try:
        return urllib2.urlopen(my_address, timeout=100)
    except urllib2.HTTPError:
        print "Proxy Error 502, trying again..."
        return recursive_url(my_address)
    except httplib.BadStatusLine:
        print "ERROR: Bad Status Line"
        return recursive_url(my_address)


def get_refs(address):
    """
    This function counts references for a given wasp species, given a URL on the Universal Chalcidoidea Database.
    Since the HTML structure for references is heterogeneous (references may or may not share the same cell), the
    function uses 4 consecutive digits as a signature indicating references, this may cause underestimations.
    :param address: A chunk of URL corresponding to the desired species.
    :return: An integer corresponding to the number of references available on the database for this species.
    """
    no_dupp = ""
    refnum = 0
    response = recursive_url(
        'http://www.nhm.ac.uk/our-science/data/chalcidoids/database/synonyms' + address[6:])
    html = response.read()
    soup = BeautifulSoup(html, 'html.parser')
    # Reading and parsing html page containing the references for the given species
    try:
        cont = soup.find("div", id="microsite-body")
        ref_cont = cont.find_all("td")
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
                # Prevents counting twice the same reference
                if re.search(r'([0-9]){4}', i.text) and "img" not in str(i.tag):
                    # Iterating over tables (1 article = 1table).
                    print i.text.replace("\n", "").replace("\r", "").replace("\t", "")
                    # replace is just used to make debugging easier by removing newlines in output
                    refnum += len(re.findall(r'([0-9]){4}', i.text))
                    # adds as many references as there are dates in the table. This relies on the assumption
                    # that all references have their date specified and may cause the program to overlook some
                    # references
                    no_dupp = i.text
        print "Total number of citations: " + str(refnum)
        return refnum
