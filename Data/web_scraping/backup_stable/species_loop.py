import os
import dist_parser
import re
import urllib2
from bs4 import BeautifulSoup
from geopy.geocoders import Nominatim

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
whole_data = open(os.getcwd()+"/whole_data.csv",'w')
# Creates or overwrites a csv file
whole_data.write('superFamily,family,genus,species,num_loc,lat_min,lon_min,lat_max,lon_max\n')
# Writes headers
for k in sorted(spe_targ):
    # loops through superfamilies in alphabetical order
    for l in sorted(spe_targ[k]):
        # through families
        for m in sorted(spe_targ[k][l]):
            # through genera
            for n in sorted(spe_targ[k][l][m]):
                # through species
                whole_data.write(str(k)+','+str(l)+','+str(m)+','+str(n)+','+
                                 dist_parser.get_distribution(spe_targ[k][l][m])[1]+','+
                                 min(dist_parser.get_distribution(spe_targ[k][l][m])[0],key=lambda x: x[0])+','+
                                 min(dist_parser.get_distribution(spe_targ[k][l][m])[0],key=lambda x: x[1])+','+
                                 max(dist_parser.get_distribution(spe_targ[k][l][m])[0],key=lambda x: x[0])+','+
                                 max(dist_parser.get_distribution(spe_targ[k][l][m])[0],key=lambda x: x[1])+'\n')
                # Add a new row to the file for each species.

whole_data.close()
# closes the file to avoid bugs.
