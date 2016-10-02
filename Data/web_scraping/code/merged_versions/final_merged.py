import os
import re
import urllib2
from bs4 import BeautifulSoup
import time
from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut, GeocoderServiceError
import csv
import sys
from types import NoneType
reload(sys)
sys.setdefaultencoding('utf8')
import httplib
from httplib import BadStatusLine

"""
This script uses the Nominatim geocoding service in order to transform a list of given addresses or locations into 4
separate objects, all of which can be retrieved by calling get_distribution(...)[object index]. The 4 object are:
  [0]: A list of coordinates (decimal latitude and longitude) matching the input list of addresses, [1]: The number of
  addresses given, [2]: The name of each location, [3]: The name of the country for each location.
"""
# To do: Make it loop through URLs by replacing names with some extracted in taxonomic tree


def recursive_geo(name):
    geolocator = Nominatim()
    try:
        time.sleep(1)
        return geolocator.geocode(name, addressdetails=True, timeout=100, language="en")
    except GeocoderTimedOut:
        time.sleep(30)
        print "ERROR: Timed out, retrying"
        recursive_geo(name)
    except GeocoderServiceError:
        time.sleep(60)
        print "ERROR: Banned, retrying"
        recursive_geo(name)


def recursive_url(my_address):
    try:
        return urllib2.urlopen(my_address, timeout=100)
    except urllib2.HTTPError:
        print "ERROR: Proxy Error 502, trying again..."
        return recursive_url(my_address)


def check_storage(loc):
    stored = [False]
    try:
        with open(os.getcwd() + '/loc_store.csv', 'r') as loc_store:
            fields = ['location', 'country', 'latitude', 'longitude']
            reader = csv.DictReader(loc_store,fieldnames=fields)
            for row in reader:
                if row['location'] == loc:
                    stored = [True, row['location'], row['country'], row['latitude'], row['longitude']]
                    break
    except KeyError:
        print "ERROR: KeyError!"
        return stored
    except IOError:
        print "File does not exist, creating one."
        loc_store = open(os.getcwd() + '/loc_store.csv', 'w')
        loc_store.close()
        return check_storage(loc)
    return stored


def change_storage(loc, wrong):
    with open(os.getcwd()+'/loc_store.csv', 'a') as loc_store:
        fields = ['location', 'country', 'latitude', 'longitude']
        writer = csv.DictWriter(loc_store, fieldnames=fields)
        new_loc = recursive_geo(loc)
        name = loc
        try:
            country = new_loc.raw[u'address'][u'country']
        except KeyError:
            print "Location does not lie in a country, appending 'NA' as a country."
            country = "NA"
        except AttributeError:
            if loc in wrong:
                time.sleep(1)
                new_loc = recursive_geo(wrong[loc])
                try:
                    country = new_loc.raw[u'address'][u'country']
                except KeyError:
                    print "Location does not lie in a country, appending 'NA' as a country."
                    country = "NA"
        lat = new_loc.latitude
        lon = new_loc.longitude
        writer.writerow({'location': name, 'country': country, 'latitude': lat,
                         'longitude': lon})
        try:
            return [True, loc, new_loc.raw[u'address'][u'country'], new_loc.latitude, new_loc.longitude]
        except KeyError:
            return [True, loc, "NA", new_loc.latitude, new_loc.longitude]


def get_distribution(address):
    response = recursive_url(
        'http://www.nhm.ac.uk/our-science/data/chalcidoids/database/' + address + '&tab=distribution')
    html = response.read()
    soup = BeautifulSoup(html, 'html.parser')
    countries = []
    geocountries = []
    coords = []
    try:
        dist_cont = soup.find('div', 'tabContent').find("table")
    except AttributeError:
        print "Page does not exist. Returning empty list"
        return [[], [], [], []]

    countries_exceptions = ['Palaearctic', 'Palearctic', 'Czechoslovakia', 'Nearctic', 'Yougoslavia', 'USSR', 'Europe',
                            "European", "Central Asia", "Balearics", "Neotropical", "Afrotropical", "Ethiopian",
                            "Australasian", "Oriental", "Siberian", "Transcaucasus", "Yugoslavia (pre 1991)",
                            "Yugoslavia (Federal Republic)", "Eastern USSR", "Caucasus", "Indopacific",
                            "Rondônia territory (Guaporé)","Severniy (North) Kavkaz"]

    wrong_names = {"Primor'ye Kray": "Primorsky Krai", "Fujian (Fukien)": "Fujian", "Tselinograd Obl.": "Astana",
                   "Karachai-Cherkess AR": "Cherkessk", "Guangxi (Kwangsi)": "Guangxi", "Ningxia (Ningsia)": "Ningxia",
                   "Goa, Daman & Diu": "Goa", "Heilongjiang (HeilungKiang)": "Heilongjiang",
                   "Zhejiang (Chekiang)": "Zhejiang", "Shandong (Shantung)": "Shandong",
                   "Caribbean (including West Indies)": "Caribbean Sea", "Guangdong (Kwangtung)": "Guangdong",
                   "Kaluga (Kaluzhka) Oblast": "Kaluga", "Adygey AO (Adigei)": "Adygea", "Hubei (Hupeh)": "Hubei",
                   "Jiangsu (Kiangsu)": "Jiangsu", "Jiangxi (Kiangsi)": "Jiangxi", "Daghestan ASSR": "Daghestan",
                   "Kabardino-Balkarian ASSR": "Kabardino-Balkaria", "Jilin (Kirin)": "Jilin", "Buryat ASSR": "Buryat",
                   "Chita Oblast (=Chitinskaya)": "Chita", "Dolgan-Nenets NO": "Nenets", "Yakut ASSR": "Yakutyia",
                   "Karelian ASSR": "Republic of Karelia", "St Christopher (Kitts) & Nevis": "St Kitts & Nevis",
                   "Anhui (Anhwei)": "Anhui", "West Lesser Sundas": "Nusa Tenggara", "Bashkir ASSR": "Bashkortostan",
                   "Acre territory": "Acre, Brazil", "Nizhniy Novgorod Oblast": "Nizhny Novgorod",
                   "Qinghai (Chinghai)": "Qinghai", "Khabarovsk Kray (Territory)": "Khabarovsk Krai",
                   "Komi ASSR": "Komi Republic", "Chechno-Ingush ASSR": "Chechen Republic",
                   "Chagos Archipelago": "Chagos Islands", "Tuva ASSR": "Tuva", "Chuvash ASSR": "Chuvashia",
                   "Tatarskaya ASSR": "Tatarstan", "Kalmyk ASSR": "Republic of Kalmykia",
                   "Timor group (+ Wetar)": "Timor", "Udmurt ASSR": "Udmurt"}

    for i in dist_cont.find_all('a'):
        if not isinstance(i.string, NoneType):
            if i.string not in countries_exceptions:
                if i.string == "Peoples' Republic of China":
                    countries.append('China')
                else:
                    countries.append(i.string)
                print "LOC NAME ADDED: "+str(i.string)
                # Displays the name of each location as given on the nhm website
            else:
                print "ERROR: Location in exception list. Skipping"
                continue
        else:
            print "ERROR: Tag is impossible to process (No text provided). Skipping."
            continue
        tmp_loc = check_storage(i.string)
        if not tmp_loc[0]:
            tmp_loc = change_storage(i.string, wrong_names)
        coords.append([float(tmp_loc[3]), float(tmp_loc[4])])
        print "LOC COORDS ADDED: " + str(tmp_loc[1])
        geocountries.append(tmp_loc[2])
        print "Country of the processed tag is: " + str(tmp_loc[2])
    print "3 OBJECTS LENGTHS: " + str(len(coords)) + ", " + str(len(countries)) + ", " + str(len(geocountries))
    return [coords, len(countries), countries, geocountries]


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
                rownum += 1
                continue
            else:
                print "This is row number: "+str(rownum)
                # print len(i)
                # print len(i.find_all('td'))
                try:
                    # Checking if the section is valid (i.e. hosts and not associates)
                    if bool(re.search('hosts', str(i.find('h5')))):
                        print "VALID SECTION"
                        val = True
                    if bool(re.search('[Aa]ssociates', str(i.find('h5')))) \
                            or bool(re.search('Parasitoids', str(i.find('h5')))):
                        val = False
                        print "INVALID SECTION"
                        # host_species.append(i.string.encode('utf-8'))
                    else:
                        # print "NO SECTION"
                        pass
                except AttributeError:
                    print "ERROR: Neither host or associate"

                try:
                    if i.find('b').text == "Order:" and val:
                        tmp_order = re.sub(re.compile("Order:."), "", i.find('td').get_text())
                    elif i.find('b').text == "Family:" and val:
                        tmp_fam = re.sub(re.compile("Family:."), "", i.find('td').get_text())
                    # else:
                        # print "not in a valid section, b is: "+str(i.find('b').text)
                except AttributeError:
                    # print "Not an order or family"
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
        return sorted(mylist)[len(mylist) / 2] # Reminder: in python, indexes range from 0 to n (unlike in R)
    else:
        midavg = (sorted(mylist)[len(mylist) / 2] + sorted(mylist)[len(mylist) / 2 - 1]) / 2.0
        return midavg


countt = 0
# just a counter for total species progress

counts = 0
# This is the species counter which will not be reset in the script. This allows to store all species
# in a single dictionary. Relizing now this is a bad idea. Dictionary taks about 3GB, script is very slow.i


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
for f in fam[:]:
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
# Here, I write everything along with geographical data in a csv file. This part might not work without a proper IDE.
# This issue can be resolved by merging scripts and removing references to the other script file name.
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

our_data_host.close()
