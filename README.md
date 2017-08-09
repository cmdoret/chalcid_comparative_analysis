# Chalcid Comparative Analysis

### Casper Van Der Kooi, Cyril Matthey-Doret and Tanja Schwander

## Introduction

Comparative analysis of ecological variables between sex and
asex species of Chaldidoidea.

The code hosted in this repository was part of a project performed in 2016
in the Schwander Group under at the University of Lausanne. It is distibuted under the MIT license and you are free to use it as specified, as long as you cite the original publication: Van der Kooi, C. Matthey-Doret, C. and Schwander, T. Evolution and comparative ecology of parthenogenesis. _Evolution letters_, (under review)

If you plan to use the web scraper on the [Natural History Museum Universal Chalcidoidea Database](http://www.nhm.ac.uk/our-science/data/chalcidoids/), you will need a written authorization from the NHM first.

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
data scraped off the Universal Chalcidoidea Database (UCD), on the [Natural History Museum (NHM) website](http://www.nhm.ac.uk/our-science/data/chalcidoids/). The web_scraper folder contains the program used to retrieve the data.
## Dependencies

To run the code hosted on this repository, you will first need the following dependencies:

* [Python 2](https://www.python.org/) with the following packages installed:
  + [BeautifulSoup 4](https://www.crummy.com/software/BeautifulSoup/)
  + [Geocoder](https://github.com/DenisCarriere/geocoder)

* [R 3.2.x](https://www.r-project.org/):
  + [dplyr](https://cran.r-project.org/web/packages/dplyr/dplyr.pdf)
  + [ggplot2](http://ggplot2.org/)
  + [gridExtra](https://cran.r-project.org/web/packages/gridExtra/index.html)
  + [tidyr](https://cran.r-project.org/web/packages/tidyr/index.html)
  + [lme4](https://cran.r-project.org/web/packages/lme4/index.html)
  + [nlme](https://cran.r-project.org/web/packages/nlme/index.html)
  + [parallel](https://cran.r-project.org/web/views/HighPerformanceComputing.html)
  + [permute](https://cran.r-project.org/web/packages/permute/index.html)  

## Universal Chalcidoidea Database Web scraper

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

## Analyses

This folder contains scripts and models used for comparisons between asexual and sexual species.

- genus_wide.R : script used to compare asexual and sexual species in the large automated dataset obtained with the web parser. In this script, we use a permutation approach with a generalized linear mixed model.
- species_pairs.R : similar script adapted for pairs in the smaller manually assembled dataset containing asexuals and their sexual sister (or closely related) species.
- causality.R : based on the same principle, but for comparison between sexual species with an asexual sister species versus (manual dataset) other sexuals (automated dataset).
- sample_data : contains the 2 datasets presented in the associated publication; the auto dataset (auto_data.csv) was gathered using the UCD web scraper, while the manual dataset (manual_data_ref.csv) contains the species that for which data was found manually in the literature. There is a third file containing the number of citations per species recorded on the UCD, this information was also obtained with the web scraper.

## Instructions

To run the statistical analysis on data from the publication:
1. Open one of the script ontained in the folder `analyses`.
2. If running `causality.R`, change the variable `test_var` to the variable you are interested in. Otherwise, the script will run automatically on all variables and store results.
3. Choose the desired of simulations by changing `nboot`.
3. Run the code, either in a development environment such as Rstudio, or by typing `Rscript <name of script>` on the command line.

To run the web scraper and regenerate data:
1. Get written authorization from the NHM to exploit the UCD database
2. Select the taxa you are interested in by changing the lists of names directly in `main_script.py`.
3. Run the code by typing `python2 main_script.py`. The program should generate the files described in the Universal Chalcidoidea Database Web Scraper section of this README.
4. In case you want to input the data generated this way into the scripts provided, you will need to get the different files into a single table by concatenating columns together. The headers might need to be reformatted.

## Acknowledgments

All data about distribution, host range and references comes from :
Noyes, J.S. September 2016. Universal Chalcidoidea Database. World Wide Web electronic publication. http://www.nhm.ac.uk/chalcidoids

Coordinates were extracted from Openstreetmaps© through the geocoder API (version 1.20.1).
https://www.openstreetmap.org/
https://pypi.python.org/pypi/geocoder
