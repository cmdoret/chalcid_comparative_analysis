import httplib
import urllib2
from bs4 import BeautifulSoup
import time
import re
from httplib import BadStatusLine

"""
This script retrieves host species and their orders from all species of Aphelinidae listed in the NHM Universal
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


def get_hosts(address):
    response = recursive_url(
        'http://www.nhm.ac.uk/our-science/data/chalcidoids/database/' + address + '&tab=associates')
    html = response.read()
    soup = BeautifulSoup(html, 'html.parser')
    try:
        host_cont = soup.find('div', 'tabContent').find("table")
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
                rownum +=1
                continue
            else:
                print "This is row number: "+str(rownum)
                #print len(i)
                #print len(i.find_all('td'))
                try:
                    # Checking if the section is valid (i.e. hosts and not associates)
                    if bool(re.search('hosts', str(i.find('h5')))):
                        print "VALID SECTION"
                        val = True
                    if bool(re.search('[Aa]ssociates', str(i.find('h5')))) \
                            or bool(re.search('Parasitoids', str(i.find('h5')))):
                        val = False
                        print "INVALID SECTION"
                        #host_species.append(i.string.encode('utf-8'))
                    else:
                        #print "NO SECTION"
                        pass
                except AttributeError:
                    print "ERROR: Neither host or associate"

                try:
                    if i.find('b').text == "Order:" and val:
                        tmp_order = re.sub(re.compile("Order:."), "", i.find('td').get_text())
                    elif i.find('b').text == "Family:" and val:
                        tmp_fam = re.sub(re.compile("Family:."), "", i.find('td').get_text())
                    #else:
                        #print "not in a valid section, b is: "+str(i.find('b').text)
                except AttributeError:
                    #print "Not an order or family"
                    pass
                try:
                    print "Link: " + str(i.find('a').find('i').text)
                    if val:
                        host_species.append(i.find('a').find('i').text.strip('\n'))
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
                        print "Species added:, "+str(tmp_order)+", "+str(tmp_fam.strip("\n"))+", "+str(i.find('a').find('i').text.strip("\n"))
                    else:
                        continue
                except AttributeError:
                    #print "No species on this row"
                    pass
                #time.sleep(0.1)
                rownum += 1
        print "Number of Orders: " + str(len(set(host_orders))) + \
              ", Families: " + str(len(set(host_families))) + \
              ", Species: " + str(len(set(host_species)))
        return [host_orders, host_families, host_species, True]
