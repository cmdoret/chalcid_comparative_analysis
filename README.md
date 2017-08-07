# Chalcid Comparative Analysis

### Casper Van Der Kooi, Cyril Matthey-Doret and Tanja Schwander

## Introduction

Comparative analysis of ecological variables between sex and
asex species of Chaldidoidea.

The code hosted in this repository was part of a project performed in 2016
in the Schwander Group under at the University of Lausanne. It is distibuted under the MIT license and you are free to use it as specified, as long as you cite the original publication: Van der Kooi, C. Matthey-Doret, C. and Schwander, T. Evolution and comparative ecology of parthenogenesis. _Evolution letters_, (under review)

If you plan to use the web scraper on the [NHM Universal Chalcidoidea](http://www.nhm.ac.uk/our-science/data/chalcidoids/) database, you will need a written authorization from the NHM first.

Chalcidoidea is a large superfamily of parasitoid wasps
containing both sexual and asexual species. This project
aims to gather informations on different ecological variables
in closely related species to gain more insight into
the characteristics frequently associated with asexuality.

Variables studied are:
  * Number of countries
  * Number of host species
  * Latitude and longitude
  * Body length


Two Datasets are used in the analysis; the smaller one was gathered
by hand from the literature, while the larger one was build from
data scraped off the Universal Chalcidoidea Database, on the [NHM
website](http://www.nhm.ac.uk/our-science/data/chalcidoids/). The web_scraper folder contains the program used to retrieve the data.



## Analyses

This folder contains scripts and models used for comparisons between asexual and sexual species.

- auto_permutation_test.R : script used to compare asexual and sexual species in the automated dataset. In this script, we use a permutation approach with a generalized linear mixed model.
- manual_permutation_test.R : same script adapted for pairs in the smaller manual dataset.
- permut_causality_enhanced.R : based on the same principle, but for comparison between sexual species with an asexual sister species versus (manual dataset) other sexuals (automated dataset).


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

Note the program relies on the HTML structure of the website and therefore may need to be tweaked in case the website architecture has changed. Output may also differ as the database is updated and expanded.

## Acknowledgments

All data about distribution, host range and references comes from :
Noyes, J.S. September 2016. Universal Chalcidoidea Database. World Wide Web electronic publication. http://www.nhm.ac.uk/chalcidoids

Coordinates were extracted from Openstreetmaps© through the geocoder API (version 1.20.1).
https://www.openstreetmap.org/
https://pypi.python.org/pypi/geocoder
