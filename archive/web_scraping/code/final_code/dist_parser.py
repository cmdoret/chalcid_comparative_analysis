import csv
import urllib2
from bs4 import BeautifulSoup
from geopy.geocoders import Nominatim
from geopy.exc import GeocoderTimedOut, GeocoderServiceError
import time

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
        return geolocator.geocode(name, addressdetails=True, timeout=100, language="en")
    except GeocoderTimedOut:
        time.sleep(30)
        print "Timed out, retrying"
        recursive_geo(name)
    except GeocoderServiceError:
        time.sleep(60)
        print "Banned, retrying"
        recursive_geo(name)


def recursive_url(my_address):
    try:
        return urllib2.urlopen(my_address, timeout=100)
    except urllib2.HTTPError:
        print "Proxy Error 502, trying again..."
        return recursive_url(my_address)


def get_distribution(address):
    response = recursive_url(
        'http://www.nhm.ac.uk/our-science/data/chalcidoids/database/' + address + '&tab=distribution')
    html = response.read()
    soup = BeautifulSoup(html, 'html.parser')
    countries = []
    geocountries =[]
    coords = []
    try:
        dist_cont = soup.find('div', 'tabContent').find("table")
    except AttributeError:
        print "Page does not exist. Returning empty list"
        return [[],[],[],[]]

    countries_exceptions = ['Palaearctic', 'Palearctic', 'Czechoslovakia', 'Nearctic', 'Yougoslavia', 'USSR', 'Europe',
                            "European", "Central Asia", "Balearics", "Neotropical", "Afrotropical", "Ethiopian",
                            "Australasian", "Oriental", "Siberian", "Transcaucasus", "Yugoslavia (pre 1991)",
                            "Eastern USSR", "Caucasus"]

    wrong_names = {"Primor'ye Kray": "Primorsky Krai","Fujian (Fukien)": "Fujian", "Tselinograd Obl.": "Astana",
                   "Karachai-Cherkess AR": "Cherkessk", "Guangxi (Kwangsi)": "Guangxi","Ningxia (Ningsia)": "Ningxia",
                   "Goa, Daman & Diu": "Goa","Heilongjiang (HeilungKiang)": "Heilongjiang",
                   "Zhejiang (Chekiang)": "Zhejiang", "Shandong (Shantung)":"Shandong",
                   "Caribbean (including West Indies)":"Caribbean Sea", "Guangdong (Kwangtung)": "Guangdong",
                   "Kaluga (Kaluzhka) Oblast": "Kaluga", "Adygey AO (Adigei)": "Adygea", "Hubei (Hupeh)": "Hubei",
                   "Jiangsu (Kiangsu)": "Jiangsu", "Jiangxi (Kiangsi)": "Jiangxi", "Daghestan ASSR": "Daghestan",
                   "Kabardino-Balkarian ASSR": "Kabardino-Balkaria", "Jilin (Kirin)": "Jilin",
                   "Chita Oblast (=Chitinskaya)": "Chita", "Dolgan-Nenets NO": "Nenets", "Yakut ASSR": "Yakutyia"}
    for i in dist_cont.find_all('a'):
        try:
            if i.string.encode('utf-8') not in countries_exceptions:
                if i.string.encode('utf-8') == "Peoples' Republic of China":
                    countries.append('China')
                else:
                    countries.append(i.string.encode('utf-8'))
                print "LOC NAME ADDED: "+str(i.string.encode('utf-8'))
                # Displays the name of each location as given on the nhm website
            else:
                continue
        except AttributeError:
            print "ERROR: Tag impossible to process (no text available)."
            continue
        try:
            tmp_loc = recursive_geo(i.string.encode('utf-8'))
            print "Processed tag is "+str(tmp_loc.address.encode('utf-8'))
            # Displays the name of each location assigned by the geolocation service.
            coords.append([tmp_loc.latitude, tmp_loc.longitude])
            print "Country of the processed tag is: "+str(tmp_loc.raw[u'address'][u'country'].encode('utf-8'))
            geocountries.append(tmp_loc.raw[u'address'][u'country'])
            print "LOC COORDS ADDED: " + str(i.string.encode('utf-8'))
        except AttributeError:
            if i.string.encode('utf-8') in wrong_names:
                time.sleep(1)
                tmp_loc = recursive_geo(wrong_names[i.string.encode('utf-8')])
                print "Processed tag is " + str(tmp_loc.address.encode('utf-8'))
                # Displays the name of each location assigned by the geolocation service.
                coords.append([tmp_loc.latitude, tmp_loc.longitude])
                try:
                    print "Country of the processed tag is: " + str(tmp_loc.raw[u'address'][u'country'].encode('utf-8'))
                    geocountries.append(tmp_loc.raw[u'address'][u'country'])
                except KeyError:
                    print "Location does not lie in a country, appending 'NA' as a country."
                    geocountries.append("NA")
            else:
                coords.append(["NA", "NA"])
                geocountries.append("NA")
                print "LOC COORDS ADDED AS NA: "+str(i.string.encode('utf-8'))
            # If the location has no country, for instance if the location is a continent.
        except KeyError:
            geocountries.append("NA")
        time.sleep(1)
        # Delay used to prevent overloading of the geocoding service and subsequent ban (minimum required time.sleep
        #  is 1)
    print "3 OBJECTS LENGTHS: " + str(len(coords)) + ", " + str(len(countries)) + ", " + str(len(geocountries))
    return [coords, len(countries), countries, geocountries]
