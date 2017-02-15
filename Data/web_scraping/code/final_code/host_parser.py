import httplib
import urllib2
from bs4 import BeautifulSoup
import time
import re
from httplib import BadStatusLine

"""
This script retrieves host species and their orders from all requested species listed in the NHM Universal
Chalcidoidea database and returns a summary of hosts for each wasp species.
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


def get_hosts(address):
    """
    This function allows to summarize the host range of a species on the NHM database, by requesting its webpage
    and parsing it to find host species, families and orders.
    :param address: a chunk of URL corresponding to a wasp species on nhm database
    :return: A list containing the number of host orders, families and species for a given wasp species. The list also
    contains a boolean value indicating whether the page for the species exists.
    """
    response = recursive_url(
        'http://www.nhm.ac.uk/our-science/data/chalcidoids/database/' + address + '&tab=associates')
    html = response.read()
    soup = BeautifulSoup(html, 'html.parser')
    try:
        host_cont = soup.find('div', 'tabContent').find("table")
        # Finding the table containing hosts.
    except AttributeError:
        print "Page does not exist, returning empty list."
        return [[], [], [], False]
    val = False
    host_orders = []
    host_families = []
    host_species = []
    if host_cont is None:
        return [[], [], [], True]
    else:
        rownum = 0
        for i in host_cont.find_all('tr'):
            # Iterating over table rows
            if rownum == 0:
                rownum += 1
                continue
            else:
                print "This is row number: "+str(rownum)
                try:
                    # Checking if the section is valid (i.e. hosts and not associates)
                    if bool(re.search('hosts', str(i.find('h5')))):
                        # Searching for the word hosts in h5 header
                        print "VALID SECTION"
                        # If word host is in the header, section is valid
                        val = True
                    if bool(re.search('[Aa]ssociates', str(i.find('h5')))) \
                            or bool(re.search('Parasitoids', str(i.find('h5')))):
                        # Searching for words Associates and Parasitoids in h5 header
                        val = False
                        print "INVALID SECTION"
                        # If one of these words is present, section is invalid and must be skipped
                    else:
                        pass
                        # There is no section
                except AttributeError:
                    print "ERROR: Neither host or associate"

                try:
                    if i.find('b').text == "Order:" and val:
                        # Order names are in bold
                        tmp_order = re.sub(re.compile("Order:."), "", i.find('td').get_text())
                        # Extracting name of order
                    elif i.find('b').text == "Family:" and val:
                        # Family names are in bold
                        tmp_fam = re.sub(re.compile("Family:."), "", i.find('td').get_text())
                        # Extracting name of family
                except AttributeError:
                    # Neither order or Family
                    pass
                try:
                    print "Link: " + str(i.find('a').find('i').text)
                    if val:
                        host_species.append(i.find('a').find('i').text.strip('\n'))
                        # Species names are in italic
                        # Appending species name to list
                        try:
                            host_families.append(tmp_fam.strip('\n'))
                        except UnboundLocalError:
                            print "ERROR: Species has no family"
                            tmp_fam = "NA"
                            host_families.append(tmp_fam)
                        try:
                            host_orders.append(tmp_order)
                        except UnboundLocalError:
                            print "ERROR: Species has no order"
                            tmp_order = "NA"
                            host_orders.append(tmp_order)
                        print "Species added:, "+str(tmp_order) + ", " + str(tmp_fam.strip("\n")) + ", " + \
                              str(i.find('a').find('i').text.strip("\n"))
                        # Displaying progress
                    else:
                        continue
                except AttributeError:
                    pass
                rownum += 1
        print "Number of Orders: " + str(len(set(host_orders))) + \
              ", Families: " + str(len(set(host_families))) + \
              ", Species: " + str(len(set(host_species)))
        return [host_orders, host_families, host_species, True]
