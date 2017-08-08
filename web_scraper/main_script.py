# -*- coding: utf-8 -*-

import os
import dist_parser
import host_parser
import ref_parser
import re
import urllib2
from bs4 import BeautifulSoup
import time
from os.path import join
import sys
reload(sys)
sys.setdefaultencoding('utf8')

"""
##############################################################################
#    Univeral Chalcidoidea Database Web Scraper - a tool to automatically    #
#    gather ecological data from the NHM Universal Chaldidoidea database.    #
#                                                                            #
#  Please see README and LICENCE for details of use and licence conditions.  #
# This software was written by Cyril Matthey-Doret from the Schwander group, #
#  at the University of Lausanne, Switzerland. Latest version is available   #
#  for download at https://github.com/cmdoret/chalcid_comparative_analysis.  #
#                                                                            #
#  Copyright (c) 2017 Cyril Matthey-Doret and Casper Van der Kooi            #
#  Author: Cyril Matthey-Doret (cyril.matthey-Doret@unil.ch)                 #
#  Acknowledgement: Noyes, J.S. ****. Universal Chalcidoidea Database.       #
#  World Wide Web electronic publication. http://www.nhm.ac.uk/chalcidoids   #
##############################################################################

This script gathers distribution, hosts and number of references for all species
in the nhm universal Chalcidoidea database.
Note: Since the script uses the Nominatim API which is not intended for bulk
geocoding, the time.sleep method has been set to a high value in order to
avoid overloading the servers. This slows down the script considerably.

This script may not work anymore and will require some tweaking of the
URLs patterns and HTML parsing if the design of the nhm website has been changed.

The list of genera used in this script includes all genera with at least one asexual species.
Note this includes species with known reproductive polymorphism.
"""


def mean(mylist):
    return float(sum(mylist)) / max(len(mylist),1)


def median(mylist):
    if len(mylist) % 2 != 0:
        return sorted(mylist)[len(mylist) / 2]
    else:
        midavg = (sorted(mylist)[len(mylist) / 2] +
                  sorted(mylist)[len(mylist) / 2 - 1]) / 2.0
        return midavg

countt = 0
# Counter for displaying info on total species progress

spe_targ = {}
# Dictionary used to store the species

find_sp = re.compile(r'(species|speciesNoSyn)')
# Regular expression allowing to take all species, wether they have synonyms or not, but only the valid names.

countf = 0
# Counter used for families.

fam = ["Aphelinidae", "Chalcididae", "Encyrtidae", "Eulophidae", "Eupelmidae", "Eurytomidae", "Eurytomidae",
       "Leucospidae", "Mymaridae", "Pteromalidae", "Torymidae", "Trichogrammatidae"]
# list used to store family names

fam_targ = {"Aphelinidae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Superfamily="
                           "Chalcidoidea&Family=Aphelinidae#fam_2'",
            "Chalcididae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Superfamily="
                           "Chalcidoidea&Family=Chalcididae#fam_4",
            "Encyrtidae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Superfamily="
                          "Chalcidoidea&Family=Encyrtidae#fam_6",
            "Eulophidae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Family="
                          "Eulophidae&Superfamily=Chalcidoidea#fam_9",
            "Eupelmidae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Superfamily="
                          "Chalcidoidea&Family=Eupelmidae#fam_10",
            "Eurytomidae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Family="
                           "Eurytomidae&Superfamily=Chalcidoidea#fam_11",
            "Leucospidae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Family="
                           "Leucospidae&Superfamily=Chalcidoidea#fam_13",
            "Mymaridae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Superfamily="

                         "Chalcidoidea&Family=Mymaridae#fam_14",
            "Pteromalidae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Family="
                            "Pteromalidae&Superfamily=Chalcidoidea#fam_17",
            "Signiphoridae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Family="
                             "Signiphoridae&Superfamily=Chalcidoidea#fam_19",
            "Torymidae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Superfamily="
                         "Chalcidoidea&Family=Torymidae#fam_22",
            "Trichogrammatidae": "http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?Family="
                                 "Trichogrammatidae&Superfamily=Chalcidoidea#fam_23"}
# Dictionary used to store families and their corresponding URLs.

my_genera = ["Aphelinus", "Ablerus", "Aphytis", "Coccophagus", "Encarsia", "Eretmocerus", "Paraphytis", "Pteroptrix",
             "Brachymeria", "Ditropinotus", "Hambletonia", "Prochiloneurus", "Adelencyrtus", "Anicetus", "Anagyrus",
             "Arrhenophagus", "Blepyrus", "Chrysophagus", "Clausenia", "Coccidoxenoides", "Comperiella", "Copidosoma",
             "Diaphorencyrtus", "Diversinervus", "Encyrtus", "Habrolepis", "Ixidophagus", "Microterys", "Ooencyrtus",
             "Plagiomerus", "Protyndarichoides", "Pseudleptomastix", "Trechnites", "Zaplatycerus", "Aprostocetus",
             "Baryscapus", "Ceranisus", "Galeopsomyia", "Holarcticesa", "Leptocybe", "Necremnus",
             "Neochrysocharis", "Omphale", "Pediobius", "Pnigalio", "Tamarixia", "Tetrastichus", "Aprostocetus",
             "Oomyzus", "Thripoctenus", "Anastatus", "Eupelmus", "Bephratelloides", "Eurytoma",
             "Tetramesa", "Leucospis", "Anagrus", "Anaphes", "Caenomymar", "Polynema", "Stephanocampta", "Mesopolobus",
             "Muscidifurax", "Nasonia", "Pteromalus", "Spalangia", "Trichilogaster", "Signiphora", "Megastigmus",
             "Torymus", "Megaphragma", "Trichogramma", "Trichogrammatoidea"]
# List of genera we are interested in (those with at least 1 known asexual species)

# Looping over families, genera and species to build a nested taxonomic dictionary with all desired species and their URL's.
for f in fam:
    # Iterating over family names.
    print "FAMILY = " + str(f)
    # Displaying progress (current family name)
    fam_html = urllib2.urlopen(fam_targ[f])
    # Opening the UCD page of the corresponding family (i.e. expanding the tree for this family).
    fam_soup = BeautifulSoup(fam_html.read(), 'html.parser')
    # Parsing the page
    root_gen = fam_soup.find_all('div', 'genus')
    # Stores all <div> tags of class "genus" on the page.
    gen = []
    # List used to store genera names.
    gen_targ = {}
    # Dictionary used to store URLs of genera in the family.
    countg = 0
    # Counter for genera in the family.
    spe_targ[f] = {}
    # Creating a nested dictionary for the family in the species dictionary.
    for rg in root_gen:
        # Iterating over <div> tags of class "genus".
        genlink = rg.find_all('a')
        # Storing all links (<a> tags) in each genus <div> tag.
        gen.append(genlink[1]['name'])
        # Appending genus name (retrieved from the second link's name attribute).
        gen_targ[gen[countg]] = genlink[2]['href']
        # Adding an entry to the dictionary for a genus name and its corresponding URL.
        countg += 1
        # Incrementing to next "genus" <div> tag.
    for g in gen:
        # Incrementing over genera.
        if g in my_genera:
            print "GENUS = " + str(g)
            # Displaying progress (current genus name)
            gen_html = urllib2.urlopen('http://www.nhm.ac.uk/our-science/data/chalcidoids/database/' + gen_targ[g])
            # Opening each genus tree section by accessing their URL.
            gen_soup = BeautifulSoup(gen_html.read(), 'html.parser')
            # Parsing genus page.
            root_spe = gen_soup.find_all('div', find_sp)
            # Finding "species" <div> tags.
            spe_targ[f][g] = {}
            # Adding a second nesting level for genera to the dictionary.
            spe = []
            # List used to store species names.
            counts = 0
            # counter used for species
            for rs in root_spe:
                # Iterating over species <div> tags.
                spelink = rs.find_all('a')
                # Storing all <a> tags fof the species.
                if rs['class'][0] == u'species':
                    # If the species has synonyms.
                    spe.append(spelink[2].text)
                    # Use the text of the third link (valid name) as species name.
                    spe_targ[f][g][spe[counts]] = spelink[2]['href']
                    # Use the target of the thrd link as URL and store it in the corresponding dictionary entry
                elif rs['class'][0] == u'speciesNoSyn':
                    # If the species has no synonym.
                    spe.append(spelink[1].text)
                    # Use the text of the second link as species name.
                    spe_targ[f][g][spe[counts]] = spelink[1]['href']
                    # Use the target of the second link as species URL and store it in the corresponding dictionary entry
                else:
                    pass
                counts += 1
                countt += 1
        else:
            print "Skipping genus."
        print "TOTAL SPECIES: " + str(countt)

# ============================================================================================
# Processing geographical data and writing it in a csv file.
our_data = open(join(os.getcwd(), "geo_data.csv"), 'w')
# Creates or overwrites a csv file
our_data.write('family,genus,species,num_loc,lat_min,lon_min,lat_max,lon_max,lat_mean,lon_mean,lat_median,lon_median\n')
# Headers for the different variables to be written
new_folder = join(os.getcwd(), "geo_per_species")
# Creating a folder with one text file for each species containing all details about each location
try:
    os.mkdir(new_folder)
    # Creates a folder in the current directory.
except OSError:
    print "Folder already exists, overwriting content."

for l in sorted(spe_targ):
    # through families
    for m in sorted(spe_targ[l]):
        # through genera
        for n in sorted(spe_targ[l][m]):
            # through species
            print "N is: " + str(m) + " " + str(n)
            time.sleep(0.1)
            dist = dist_parser.get_distribution(spe_targ[l][m][n])
            # Calling dist_parser module to request distribution information on species URL
            # and extracting coordinates via Nominatim.
            print "COORDS: " + str(dist[0])
            print "LOCATIONS: " + str(dist[2])
            print "GEOCOUNTRIES: " + str(dist[3])
            tmp_loc_list = dist[2]
            geocountries = dist[3]
            print "tmp_loc_list : " + str(tmp_loc_list)
            print "geocountries : " + str(geocountries)
            qcount = 0
            for q in dist[2]:
                # Iterating over location names as displayed on nhm website.
                rcount = 0
                try:
                    for r in dist[3]:
                        if qcount != rcount and q != "NA" and (q == r or (
                                        q == "Russia" and r == "Russian Federation") or (
                                        q == "Peoples' Republic of China" and r == "China") or (
                                        q == "South Africa" and r == "RSA")):
                            # For each location from nhm, checking if it matches the country of another location.
                            # Ex: if the first location is 'USA' and the second is 'New York', q of the first location
                            # and r of the second location should have the same value.
                            # If location q is the country of another location, remove location q from the list of coords.
                            # Also handling countries with synonyms used on the nhm database.
                            dist[0].pop(qcount)
                            dist[2].pop(qcount)
                            dist[3].pop(qcount)
                            print "Coordinate removed: " + str(len(dist[0])) + " left."
                            break
                            # Remove it from the list of location names as well.
                        rcount += 1
                except KeyError:
                    print "ERROR!"
                except ValueError:
                    print str(q) + " has already been removed."
                    # This will be run in case there are multiple locations belonging to the same country and this country
                    # has already been popped from the list.
                qcount += 1

            known_coord = [loc for loc in dist[0] if isinstance(loc[0], float)]
            # Only includes locations with known lat and lon
            print "Ncountries: " + str(len(dist[2]))
            print "Ncoord: " + str(len(dist[0])) + "\n" + "=" * 40 + "\n"
            # Informative summary for each species. If Ncountries and Ncoord are not equal, there is a problem.
            a = open(join(new_folder, (str(l) + "." + str(m) + "." + str(n + ".txt"))), 'w')
            # Creating a new text file for each species inside the previously created subfolder.
            for i in range(len(dist[2])):
                a.write(str(dist[2][i]) + "," + str(dist[0][i][0]) + "," + str(dist[0][i][1]) + "\n")
            # Each line in the file represent a location at which the species was retrieved.
            a.close()
            lat = []
            lon = []
            for x in known_coord:
                lat.append(x[0])
                lon.append(x[1])

            try:
                our_data.write(str(l) + ',' + str(m) + ',' + str(n) + ',' +
                               str(len(dist[2])) + ',' +
                               str(min(known_coord, key=lambda y: y[0])[0]) + ',' +
                               str(min(known_coord, key=lambda y: y[1])[1]) + ',' +
                               str(max(known_coord, key=lambda y: y[0])[0]) + ',' +
                               str(max(known_coord, key=lambda y: y[1])[1]) + ',' +
                               str(mean(lat)) + ',' + str(mean(lon)) + ',' + str(median(lat)) + ',' +
                               str(median(lon)) + '\n')
                # Add a new row to the summary file for each species.
            except ValueError:
                print "No distribution data"
                our_data.write(str(l) + ',' + str(m) + ',' + str(n) + ',' +
                               str(0) + ',' +
                               str("NA") + ',' +
                               str("NA") + ',' +
                               str("NA") + ',' +
                               str("NA") + ',' +
                               str("NA") + ',' + str("NA") + ',' + str("NA") + ',' +
                               str("NA") + '\n')
our_data.close()

# =====================================================
# Processing informations about host species and storing them in a csv file.

our_data_host = open(join(os.getcwd(), "host_data.csv"), 'w')
# Creates or overwrites a csv file
our_data_host.write('family,genus,species,num_orders,num_fam,num_spp\n')
# Adding headers to the csv file.
new_folder_host = join(os.getcwd(), "host_per_species")
try:
    os.mkdir(new_folder_host)
    # Creates a folder in the current directory.
except OSError:
    print "Folder already exists, overwriting content."
# In case the folder already exists
print "SPE_TARG=" + str(spe_targ)
# Prints the current species name.
# through superfamilies
for l in sorted(spe_targ):
    # through families
    for m in sorted(spe_targ[l]):
        # through genera
        for n in sorted(spe_targ[l][m]):
            # through species
            print "processing: " + str(m) + " " + str(n)
            host = host_parser.get_hosts(spe_targ[l][m][n])
            # Calling host_parser module to request host information on species URL.
            b = open(join(new_folder_host, (str(l) + "." + str(m) + "." + str(n + ".txt"))), 'w')
            # Creating a new text file for each species inside the previously created subfolder.
            for i in range(len(host[2])):
                b.write(str(host[0][i]) + "," + str(host[1][i]) + "," + str(host[2][i]))
            # Each line in the file represent a location at which the species was retrieved.
            b.close()
            if host[3]:
                our_data_host.write(str(l) + "," + str(m) + ',' + str(n) + ',' +
                                    str(len(set(host[0]))) + ',' +
                                    str(len(set(host[1]))) + ',' +
                                    str(len(set(host[2]))) + '\n')
                # Add a new row to the summary file for each species.
            else:
                our_data_host.write(str(l) + "," + str(m) + ',' + str(n) + ',' +
                                    "NA" + ',' +
                                    "NA" + ',' +
                                    "NA" + '\n')

our_data_host.close()

# =====================================================
# Gathering number of references about each species.
# Warning: The website's HTML structure for references being inconsistent, the only way
# I found to identify references is by using dates (4 integers without interruption in references section).
# This method might cause errors but will be conservative; If any source does not mention the date, it will not be counted
our_data_ref = open(join(os.getcwd(), "ref_data.csv"), 'w')
# Creates or overwrites a csv file
our_data_ref.write('family,genus,species,ref\n')
# Adding headers to the csv file.
print "SPE_TARG=" + str(spe_targ)
# Prints the current species name.
# through superfamilies
for l in sorted(spe_targ):
    # through families
    for m in sorted(spe_targ[l]):
        number_sp = len(spe_targ[l][m])
        # through genera
        for n in sorted(spe_targ[l][m]):
            # through species
            print "processing: " + str(m) + " " + str(n)
            ref = ref_parser.get_refs(spe_targ[l][m][n])
            # Calling ref_parser module to request references information on species URL.
            our_data_ref.write(str(l) + "," + str(m) + ',' + str(n) + ',' + str(ref) + '\n')
            # Add a new row to the summary file for each species.
our_data_ref.close()
