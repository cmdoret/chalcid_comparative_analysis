import os
import dist_parser
import host_parser
import re
import urllib2
from bs4 import BeautifulSoup
import time

"""
This script gather distribution and hosts for all species in the nhm universal Chalcidoidea database.
Note: Since the script uses the Nominatim API which is not intended for bulk geocoding, the time.sleep
method has been set to a very high value in order to avoid overloading the servers. This causes the
script to be very slow.
Note2: Not sure the script works, didn't run it until the end
"""


countt  = 0
# just a counter for total species progress

counts = 0
# This is the species counter which will not be reset in the script. This allows to store all species
# in a single dictionary. Relizing now this is a bad idea. Dictionary taks about 3GB, script is very slow.
# TO DO: Write down dictionary on a file and reassign it on each genus iteration.-> more free RAM, probably faster.

spe_targ = {}
# Dictionary used to store the species

find_sp = re.compile(r'(species|speciesNoSyn)')
# Regular expression allowing to take all species, wether they have synonyms or not, but only the valid names.
root = urllib2.urlopen('http://www.nhm.ac.uk/our-science/data/chalcidoids/database/listChalcids.dsml?')
# Requesting taxonomic tree page on the nhm website.
root_html = root.read()
# Script reads content of the page and stores it.
root_soup = BeautifulSoup(root_html,'html.parser')
# Using an html parser to extract HTML tags more easily.
supfam = []
# List used to store super-family names.
root_supfam = root_soup.find_all('div', 'superFamily')
# Stores all <div> tags of class "superFamily" on the page
countsf = 0
# Counter used for super-families
supfam_targ ={}
# dictionary used to store super-families and their corresponding URLs.
for s in root_supfam:
    # Iterating over super-families <div> tags of class "superfamily".
    supfam.append(s.text.replace('\n', '').replace('\r','').replace(' ', ''))
    # Appending the text contained in the div tag (i.e. the name of each super-family) to the list.
    # replace method is used to remove all useless formatting characters.
    supfam_targ[supfam[countsf]] = s.find('a')['href']
    # Adding the names of super-families as keys of the dictionaries with the link to their respective pages as values.
    # Note: By respective pages, I mean the pages where the taxonomic tree is expanded for a given super-family.
    print "SUPERFAMILY = " + supfam[countsf]
    # Used to track progress when script is running.

    countsf += 1
    # Incrementing to next super-family.


for sf in supfam:
    # Iterating over super-families names
    supfam_html = urllib2.urlopen('http://www.nhm.ac.uk/our-science/data/chalcidoids/database/'+supfam_targ[sf])
    # Opening the page of the corresponding super-family (i.e. expanding tree for that family).
    supfam_soup = BeautifulSoup(supfam_html.read(),'html.parser')
    # Parsing the page.
    root_fam = supfam_soup.find_all('div','family')
    # Stores all <div> tags of class "family" on the page.
    fam = []
    # list used to store family names
    fam_targ = {}
    # Dictionary used to store families and their corresponding URLs.
    spe_targ[sf] = {}
    # Creating a nested dictionary for each super-family within the species dictionary
    countf = 0
    # Counter used for families.
    for rf in root_fam:
        # Iterating over families <div> tags of class "family".
        famlink = rf.find_all('a')
        # Storing all links (i.e. <a> tags for a "family" <div> tag)
        fam.append(famlink[1]['name'])
        # Appending the name attribute of the second link (i.e. on screen text=family name) to the list of family names.
        fam_targ[fam[countf]] = famlink[2]['href']
        # Storing the name of the family as a key in the dictionary, with the target of the first link (i.e. the white
        # cross in the taxonomic tree) as its corresponding value.

        countf += 1
        # Increments to next family
        for f in fam:
            # Iterating over family names.
            print "FAMILY = " + str(f)
            # Checks progress
            fam_html = urllib2.urlopen('http://www.nhm.ac.uk/our-science/data/chalcidoids/database/' + fam_targ[f])
            # Opening the page of the corresponding family, by expanding the tree for this family.
            fam_soup = BeautifulSoup(fam_html.read(),'html.parser')
            # Parsing the page
            root_gen = fam_soup.find_all('div','genus')
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
                spe_targ[sf][f] = {}
                # Creating a second level of nesting for families in the species dictionary.
                countg += 1
                # Incrementing to next "genus" <div> tag.
            for g in gen:
                # Incrementing over genera.
                print "GENUS = " + str(g)
                print "TOTAL SPECIES: "+ str(countt)
                # Progress check
                gen_html = urllib2.urlopen('http://www.nhm.ac.uk/our-science/data/chalcidoids/database/' + gen_targ[g])
                # Opening each genus tree section by accessing their URL.
                gen_soup = BeautifulSoup(gen_html.read(), 'html.parser')
                # Parsing genus page.
                root_spe = gen_soup.find_all('div',find_sp)
                # Finding "species" <div> tags.
                spe_targ[sf][f][g] = {}
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
                        spe_targ[sf][f][g][spe[counts]] = spelink[2]['href']
                        # Use the target of the thrd link as URL and store it in the corresponding dictionary entry
                        # (4 levels of nesting).
                    elif rs['class'][0] == u'speciesNoSyn':
                        # If the species has no synonym.
                        spe.append(spelink[1].text)
                        # Use the text of the second link as species name.
                        spe_targ[sf][f][g][spe[counts]] = spelink[1]['href']
                        # Use the target of the second link as species URL and store it in the corresponding dictionary
                        # Entry (4 levels of nesting).
                    else:
                        pass
                    #print "SPECIES = " + str(spe[counts])
                    counts += 1
                    countt += 1
print spe_targ

# ============================================================================================
# Here, I write everything along with geographical data in a csv file. This part might not work without a proper IDE.
# This issue can be resolved by merging scripts and removing references to the other script file name.
whole_data = open(os.getcwd()+"/all_geo.csv",'w')
# Creates or overwrites a csv file
whole_data.write('superFamily,family,genus,species,num_loc,lat_min,lon_min,lat_max,lon_max\n')
new_folder = os.getcwd() + "/all_geo_per_species"
try:
    os.mkdir(new_folder)
    # Creates a folder in the current directory.
except OSError:
    print "Folder already exists, overwriting content."
# Writes headers
for k in sorted(spe_targ):
    # loops through superfamilies in alphabetical order
    for l in sorted(spe_targ[k]):
        # through families
        for m in sorted(spe_targ[k][l]):
            # through genera
            for n in sorted(spe_targ[k][l][m]):
                # through species
                print "N is: " + str(m) + " " + str(n)
                time.sleep(5)
                dist = dist_parser.get_distribution(spe_targ[k][l][m][n])
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
                                # Ex: if the first location is 'USA' and the second is 'New York', k of the first location and r
                                #  of the second location should have the same value.
                                # If location k is the country of another location, remove location k from the list of coords.
                                dist[0].pop(qcount)
                                dist[2].pop(qcount)
                                dist[3].pop(qcount)
                                print "dist[0]: " + str(len(dist[0])) + ", dist[2]: " + str(
                                    len(dist[2])) + ", dist[3]: " + str(
                                    len(dist[3]))
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
                a = open(new_folder + "/" + str(k) + "." + str(l) + "." + str(m) + "." + str(n + ".txt"), 'w')
                # Creating a new text file for each species inside the previously created subfolder.
                for i in range(len(dist[2])):
                    a.write(str(dist[2][i]) + "," + str(dist[0][i][0]) + "," + str(dist[0][i][1]) + "\n")
                # Each line in the file represent a location at which the species was retrieved.
                a.close()
                try:
                    whole_data.write(str(m) + ',' + str(n) + ',' +
                                     str(len(dist[2])) + ',' +
                                     str(min(known_coord, key=lambda x: x[0])[0]) + ',' +
                                     str(min(known_coord, key=lambda x: x[1])[1]) + ',' +
                                     str(max(known_coord, key=lambda x: x[0])[0]) + ',' +
                                     str(max(known_coord, key=lambda x: x[1])[1]) + '\n')
                    # Add a new row to the summary file for each species.
                except ValueError:
                    print "No distribution data"

whole_data.close()
# closes the file to avoid bugs.

# =====================================================
# Here I gather informations about host species
whole_data_host = open(os.getcwd() + "/all_host.csv", 'w')
# Creates or overwrites a csv file
whole_data_host.write('superfamily,family,genus,species,num_orders,num_fam,num_spp\n')
# Adding headers to the csv file.
new_folder_host = os.getcwd() + "/all_host_per_species"
try:
    os.mkdir(new_folder_host)
    # Creates a folder in the current directory.
except OSError:
    print "Folder already exists, overwriting content."
# In case the folder already exists
print "SPE_TARG=" + str(spe_targ)
# Prints the current species name.
for k in sorted(spe_targ):
    # through superfamilies
    for l in sorted(spe_targ[k]):
        # through families
        for m in sorted(spe_targ[k][l]):
            # through genera
            for n in sorted(spe_targ[k][l][m]):
                # through species
                print "processing: " + str(m) + " " + str(n)
                host = host_parser.get_hosts(spe_targ[k][l][m][n])
                b = open(new_folder_host + "/" + str(k) + "." + str(l) + "." + str(m) + "." + str(n + ".txt"), 'w')
                # Creating a new text file for each species inside the previously created subfolder.
                for i in range(len(host[2])):
                    b.write(str(host[0][i]) + "," + str(host[1][i]) + "," + str(host[2][i]))
                # Each line in the file represent a location at which the species was retrieved.
                b.close()
                whole_data_host.write(str(k) + ", " + str(l) + "," + str(m) + ',' + str(n) + ',' +
                                      str(len(set(host[0]))) + ',' +
                                      str(len(set(host[1]))) + ',' +
                                      str(len(set(host[2]))) + '\n')
                # Add a new row to the summary file for each species.

whole_data_host.close()
