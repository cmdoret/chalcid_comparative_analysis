import os

import re
import urllib2
from bs4 import BeautifulSoup
import time
import httplib
import urllib2
from bs4 import BeautifulSoup
import time
import re
from httplib import BadStatusLine


"""
This script gather distribution and hosts for all species in the nhm universal Chalcidoidea database.
Note: Since the script uses the Nominatim API which is not intended for bulk geocoding, the time.sleep
method has been set to a very high value in order to avoid overloading the servers. This causes the
script to be very slow.
Note2: Not sure the script works, didn't run it until the end
"""


def mean(mylist):
    return sum(mylist) / len(mylist)


def median(mylist):
    if len(mylist) % 2 != 0:
        return sorted(mylist)[len(mylist) / 2]
    else:
        midavg = (sorted(mylist)[len(mylist) / 2] + sorted(mylist)[len(mylist) / 2 - 1]) / 2.0
        return midavg


countt = 0
# just a counter for total species progress

counts = 0
# This is the species counter which will not be reset in the script. This allows to store all species
# in a single dictionary. Relizing now this is a bad idea. Dictionary taks about 3GB, script is very slow.
# TO DO: Write down dictionary on a file and reassign it on each genus iteration.-> more free RAM, probably faster.

spe_targ = {}
# Dictionary used to store the species

find_sp = re.compile(r'(species|speciesNoSyn)')
# Regular expression allowing to take all species, wether they have synonyms or not, but only the valid names.

# list used to store family names
# Dictionary used to store families and their corresponding URLs.
# Creating a nested dictionary for each super-family within the species dictionary
countf = 0
# Counter used for families.

fam = ["Aphelinidae", "Chalcididae", "Encyrtidae", "Eulophidae", "Eupelmidae", "Eurytomidae", "Eurytomidae",
       "Leucospidae", "Mymaridae", "Pteromalidae", "Torymidae", "Trichogrammatidae"]
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
# Storing the name of the family as a key in the dictionary, with the target of the first link (i.e. the white
# cross in the taxonomic tree) as its corresponding value.

# Increments to next family
for f in fam[0:1]:
    # Iterating over family names.
    print "FAMILY = " + str(f)
    # Checks progress
    fam_html = urllib2.urlopen(fam_targ[f])
    # Opening the page of the corresponding family, by expanding the tree for this family.
    fam_soup = BeautifulSoup(fam_html.read(), 'html.parser')
    # Parsing the page
    root_gen = fam_soup.find_all('div', 'genus')
    # Stores all <div> tags of class "genus" on the page.
    gen = []
    # List used to store genera names.
    gen_targ = {}
    # Dictionary used to store URLs.
    countg = 0
    # Counter for genera.
    for rg in root_gen:
        # Iterating over <div> tags of class "genus".
        genlink = rg.find_all('a')
        # Storing all links (<a> tags) in each genus <div> tag.
        gen.append(genlink[1]['name'])
        # Appending genus name retrieved from the second link's name attribute.
        gen_targ[gen[countg]] = genlink[2]['href']
        # Adding an entry to the dictionary for a genus name and its corresponding URL.
        spe_targ[f] = {}
        # Creating a second level of nesting for families in the species dictionary.
        countg += 1
        # Incrementing to next "genus" <div> tag.
    for g in gen:
        # Incrementing over genera.
        if g in my_genera:
            print "GENUS = " + str(g)
            # Progress check
            gen_html = urllib2.urlopen('http://www.nhm.ac.uk/our-science/data/chalcidoids/database/' + gen_targ[g])
            # Opening each genus tree section by accessing their URL.
            gen_soup = BeautifulSoup(gen_html.read(), 'html.parser')
            # Parsing genus page.
            root_spe = gen_soup.find_all('div', find_sp)
            # Finding "species" <div> tags.
            spe_targ[f][g] = {}
            # Adding a nesting level for genera to the dictionary.
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
                    # Use the text of the third link as species name.
                    spe_targ[f][g][spe[counts]] = spelink[2]['href']
                    # Use the target of the thrd link as URL and store it in the corresponding dictionary entry
                    # (4 levels of nesting).
                elif rs['class'][0] == u'speciesNoSyn':
                    # If the species has no synonym.
                    spe.append(spelink[1].text)
                    # Use the text of the second link as species name.
                    spe_targ[f][g][spe[counts]] = spelink[1]['href']
                    # Use the target of the second link as species URL and store it in the corresponding dictionary
                    # Entry (4 levels of nesting).
                else:
                    pass
                # print "SPECIES = " + str(spe[counts])
                counts += 1
                countt += 1
        else:
            print "Skipping genus."
        print "TOTAL SPECIES: " + str(countt)

# ============================================================================================
# Here, I write everything along with geographical data in a csv file. 
our_data = open(os.getcwd() + "/our_geo_exp.csv", 'w')
# Creates or overwrites a csv file
our_data.write('family,genus,species,num_loc,lat_min,lon_min,lat_max,lon_max,lat_mean,lon_mean,lat_median,lon_median\n')
new_folder = os.getcwd() + "/our_geo_per_species_exp"
try:
    os.mkdir(new_folder)
    # Creates a folder in the current directory.
except OSError:
    print "Folder already exists, overwriting content."
# Writes headers

for l in sorted(spe_targ):
    # through families
    for m in sorted(spe_targ[l]):
        # through genera
        for n in sorted(spe_targ[l][m]):
            # through species
            print "N is: " + str(m) + " " + str(n)
            time.sleep(0.1)
            dist = get_distribution(spe_targ[l][m][n])
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
                            # For each location from nhm, checking if there it matches the country of another location.
                            # Ex: if the first location is 'USA' and the second is 'New York', k of the first location
                            # and r
                            #  of the second location should have the same value.
                            # If location k is the country of another location, remove location k from the list of
                            # coords.
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
                qcount += 1
                # This will be run in case there are multiple locations belonging to the same country and this country
                # has already been popped from the list.
            known_coord = [loc for loc in dist[0] if isinstance(loc[0], float)]
            print "Ncountries: " + str(len(dist[2]))
            print "Ncoord: " + str(len(dist[0])) + "\n" + "=" * 40 + "\n"
            # Informative summary for each species. If Ncountries and Ncoord are not equal, there is a problem.
            a = open(new_folder + "/" + str(l) + "." + str(m) + "." + str(n + ".txt"), 'w')
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
# closes the file to avoid bugs.

# =====================================================
# Here I gather informations about host species
our_data_host = open(os.getcwd() + "/our_host_exp.csv", 'w')
# Creates or overwrites a csv file
our_data_host.write('family,genus,species,num_orders,num_fam,num_spp\n')
# Adding headers to the csv file.
new_folder_host = os.getcwd() + "/our_host_per_species_exp"
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
        number_sp = len(spe_targ[l][m])
        phyto_count = 0
        # through genera
        for n in sorted(spe_targ[l][m]):
            # through species
            print "processing: " + str(m) + " " + str(n)
            host = get_hosts(spe_targ[l][m][n])
            b = open(new_folder_host + "/" + str(l) + "." + str(m) + "." + str(n + ".txt"), 'w')
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
            if host[4]:
                phyto_count += 1
        print "PHYTOPHAGOUS SPECIES IN " + str(m) + ": " + str((float(phyto_count)/float(number_sp))*100) + "%"
our_data_host.close()

# =======================================================================================================

# Same for references (citations)

# =====================================================
# Here I gather informations about host species. Warning: The website's HTML structure being inconsistent, the only way
# I found to identify references is by using dates (4 integers without interruption). This method might cause errors;
# If any source does not mention the date, it will not be counted
our_data_ref = open(os.getcwd() + "/our_ref_exp.csv", 'w')
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
            ref = get_refs(spe_targ[l][m][n])
            our_data_ref.write(str(l) + "," + str(m) + ',' + str(n) + ',' + str(ref) + '\n')
            # Add a new row to the summary file for each species.
our_data_ref.close()
"""

"""
This script retrieves citations from all species of Aphelinidae listed in the NHM Universal
Chalcidoidea database and return them as python objects.



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

