import urllib2
from bs4 import BeautifulSoup
from geopy.geocoders import Nominatim

# To do: Make it loop through URLs by replacing names with some extracted in taxonomic tree


def get_distribution(address):

    response = urllib2.urlopen('http://www.nhm.ac.uk/our-science/data/chalcidoids/database/'+address+'&tab=distribution')
    geolocator = Nominatim()
    html = response.read()
    soup = BeautifulSoup(html,'html.parser')
    countries = []
    coords = []
    dist_cont = soup.find('div','tabContent').find("table")
    for i in dist_cont.find_all('a'):
        countries.append(i.string)
        print i.string
        tmp_loc = geolocator.geocode(i.string)
        try:
            coords.append([tmp_loc.latitude, tmp_loc.longitude])
        except AttributeError:
            coords.append(["NA","NA"])

    return [coords,len(countries)]
