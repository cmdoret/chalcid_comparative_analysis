# -*- coding: utf-8 -*-

import csv
import urllib2
from bs4 import BeautifulSoup
from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut, GeocoderServiceError
import time
from types import NoneType
import sys
reload(sys)
sys.setdefaultencoding('utf8')
import os
from os.path import join

"""
This script uses the Nominatim geocoding service in order to transform a list of given addresses or locations into 4
separate objects, all of which can be retrieved by calling get_distribution(...)[object index]. The 4 object are:
  [0]: A list of coordinates (decimal latitude and longitude) matching the input list of addresses, [1]: The number of
  addresses given, [2]: The name of each location, [3]: The name of the country for each location.
"""


def recursive_geo(name):
    """
    This function allows the script to resume in case connection is lost when requesting coordinates on
    Nominatimor machine has been banned by Nominatim server. This prevents unwanted interuptions.
    :param name: Location name to be requested.
    :return: Nominatim object corresponding to location name.
    """
    geolocator = Nominatim()
    try:
        time.sleep(1)
        # 1 second of sleep between each request to avoid overloading servers.
        return geolocator.geocode(name, addressdetails=True, timeout=100, language="en")
    except GeocoderTimedOut:
        time.sleep(30)
        # In case connection with the server is lost, retry every 30 seconds
        print "ERROR: Timed out, retrying"
        recursive_geo(name)
    except GeocoderServiceError:
        time.sleep(60)
        # In case of ban, retry every minute.
        print "ERROR: Banned, retrying"
        recursive_geo(name)


def recursive_url(my_address):
    """
    This function allows the script to resume in case the connection is lost when trying to request a
    species page on NHM website.
    """
    try:
        return urllib2.urlopen(my_address, timeout=100)
    except urllib2.HTTPError:
        print "ERROR: Proxy Error 502, trying again..."
        return recursive_url(my_address)


def check_storage(loc):
    """
    This function checks if the location to be requested on Nominatim is already known. This avoids having
    to request several times coordinates for the same location and significantly reduces run time.
    :param loc: The location to be requested
    :return: A list containing details of the location if it is already known, False otherwise.
    """
    stored = [False]
    try:
        with open(join(os.getcwd(), 'loc_store.csv'), 'r') as loc_store:
            fields = ['location', 'country', 'latitude', 'longitude']
            reader = csv.DictReader(loc_store, fieldnames=fields)
            for row in reader:
                # Searching for requested name in local file
                if row['location'] == loc:
                    # If the location is already present in the file, use the known coordinates
                    stored = [True, row['location'], row['country'], row['latitude'], row['longitude']]
                    break
    except KeyError:
        print "ERROR: KeyError!"
        # If the file exist but location is not present, return false
        return stored
    except IOError:
        # If file does not exist, create it.
        print "File does not exist, creating one."
        loc_store = open(join(os.getcwd(), 'loc_store.csv'), 'w')
        loc_store.close()
        return check_storage(loc)
    return stored


def change_storage(loc, wrong):
    """
    This function allows to add new locations to the storage file.
    :param loc: The name of new location to be added as it is on the NHM website.
    :param wrong: A dictionary containing location names as they are on the NHM website and their
    modern equivalent compatible with Nominatim.
    :return: A list containing the new location details
    """
    with open(join(os.getcwd(), 'loc_store.csv'), 'a') as loc_store:
        # Opening location storage file
        fields = ['location', 'country', 'latitude', 'longitude']
        writer = csv.DictWriter(loc_store, fieldnames=fields)
        new_loc = recursive_geo(loc)
        # Requesting details of new location on Nominatim.
        name = loc
        try:
            country = new_loc.raw[u'address'][u'country']
        except KeyError:
            print "Location does not lie in a country, appending 'NA' as a country."
            country = "NA"
        except AttributeError:
            if loc in wrong:
                new_loc = recursive_geo(wrong[loc])
                # In case the location is among locations with obsolete names, use corresponding valid name instead.
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
    """
    This functions coordinates the others, essentially performing the following: (1). Requesting species page on NHM
    website. (2). For each location on the page, check if the name is valid, otherwise use corresponding name. (4) Check
    if location exists locally. (3) If it does, use available data, otherwise send request to Nominatim. (4) Store
    Nominatim output locally and in a list. (5) For each species return list of all locations with details (i.e. name,
    country, coordinates, number of locations)

    :param address: A chunk of URL corresponding to a species in UCD database on the NHM website.
    :return: list containing all locations at which species is known to occur, along with details.
    """
    response = recursive_url(
        'http://www.nhm.ac.uk/our-science/data/chalcidoids/database/' + address + '&tab=distribution')
    html = response.read()
    soup = BeautifulSoup(html, 'html.parser')
    locnames = []
    # List of location names
    geocountries = []
    # List of countries to which each location belongs
    coords = []
    # List used to store latitude and longitude of each location
    try:
        dist_cont = soup.find('div', 'tabContent').find("table")
        # Parsing list of locations on the species' page
    except AttributeError:
        print "Page does not exist. Returning empty list"
        return [[], [], [], []]

    countries_exceptions = ['Palaearctic', 'Palearctic', 'Czechoslovakia', 'Nearctic', 'Yougoslavia', 'USSR', 'Europe',
                            "European", "Central Asia", "Balearics", "Neotropical", "Afrotropical", "Ethiopian",
                            "Australasian", "Oriental", "Siberian", "Transcaucasus", "Yugoslavia (pre 1991)",
                            "Yugoslavia (Federal Republic)", "Eastern USSR", "Caucasus", "Indopacific",
                            "Rondônia territory (Guaporé)","Severniy (North) Kavkaz"]
    # List of locations to be excluded, either because they are to vague or not meaningful.

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
    # List of locations with obsoletes/incompatible names on the database, and their valid counterparts.
    for i in dist_cont.find_all('a'):
        if not isinstance(i.string, NoneType):
            if i.string not in countries_exceptions:
                if i.string == "Peoples' Republic of China":
                    locnames.append('China')
                else:
                    locnames.append(i.string)
                print "LOC NAME ADDED: "+str(i.string)
                # Displays the name of each location as given on the nhm website
            else:
                print "ERROR: Location in exception list. Skipping"
                continue
        else:
            print "ERROR: Tag is impossible to process (No text provided). Skipping."
            # Used to handle empty cells on web page
            continue
        tmp_loc = check_storage(i.string)
        # Checks if location is already present locally
        if not tmp_loc[0]:
            # If not, request it and add it to locations file
            tmp_loc = change_storage(i.string, wrong_names)
        coords.append([float(tmp_loc[3]), float(tmp_loc[4])])
        # Storing coordinates of lcation
        print "LOC COORDS ADDED: " + str(tmp_loc[1])
        geocountries.append(tmp_loc[2])
        # Storing country to which location belongs
        print "Country of the processed tag is: " + str(tmp_loc[2])
    # print "3 OBJECTS LENGTHS: " + str(len(coords)) + ", " + str(len(locnames)) + ", " + str(len(geocountries))
    return [coords, len(locnames), locnames, geocountries]
