
# Universal Chalcidoidea Database Web scraper

This Python program allows to automatically retrieve host range, distribution and number of references for a set of desired wasp species on the Universal Chalcidoidea Database, on the London Natural History Museum website. The list of families/Genera need to be specified in the source (main_script.py). Given a set of species, the script will produce the following:

- geo_data.csv: Contains summarized distribution data for each species. This includes:
  + number of countries at which the species is known to occur. For large countries such as USA,India, Brasil, Russia, China and Canada, states or provinces are used instead.
  + minimum, maximum, median and mean latitude and longitude: These informations are obtained from the Nominatim Geocoding API.
  + minimum and maximum distance from the equator: Closest and furthest location from the equator at which each species has been sampled. These are respectively minimum and maximum absolute latitude.
- host_data.csv: Contains summarized host range data for each species. This includes number of host species, orders and families.
- ref_data.csv: Number of references available on the Universal Chalcidoidea Database for each species.
- geo_per_species: Folder containing one text file for each species. Each text file contains all location names along with their coordinates.
- host_per_species: Folder containing one text file for each species. Each text file contains the order, family and species name of each host for the given species.
- loc_store: This file is used to speed up the program. It stores each location and its details only once locally. This is used to reduce the number of requests sent to the Nominatim servers (only once for each unique location).

Note the program relies on the HTML structure of the website and therefore may need to be tweaked in case the website aritechture has changed. Output may also differ as the database is updated and expanded.

__Acknowledgments:__

All data about distribution, host range and references comes from :
Noyes, J.S. September 2016. Universal Chalcidoidea Database. World Wide Web electronic publication. http://www.nhm.ac.uk/chalcidoids

Coordinates were extracted from Openstreetmaps© through the geocoder API (version 1.20.1).
https://www.openstreetmap.org/
https://pypi.python.org/pypi/geocoder
