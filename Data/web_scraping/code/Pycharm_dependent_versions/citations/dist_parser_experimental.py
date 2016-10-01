# -*- encoding: utf-8 -*-
import urllib2
from bs4 import BeautifulSoup
from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut, GeocoderServiceError
import time
import os
import csv
import sys
from types import NoneType
reload(sys)
sys.setdefaultencoding('utf8')
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
