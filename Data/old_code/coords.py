import os


class Aphelinus():
    abdominalis = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "abdominalis",
                   "geo": ["Argentina", -38.416097, -63.616672
                       , "Queensland", -20.917574, 142.702796
                       , "Austria", 47.516231, 14.550072
                       , "Azerbaijan", 40.143105, 47.576927
                       , "Belgium", 50.503887, 4.469936
                       , "Brazil", -14.235004, -51.92528
                       , "Canary Islands", 28.291564, -16.62913
                       , "Channel Islands (British Is)", 53.651896, -0.044571
                       , "Juan Fernandez Is.", -33.77443, -80.776861
                       , "Croatia", 45.1, 15.2
                       , "Cuba", 21.521757, -77.781167
                       , "Czech Republic", 49.817492, 15.472962
                       , "Denmark", 56.26392, 9.501785
                       , "Egypt", 26.820553, 30.802498
                       , "France", 46.227638, 2.213749
                       , "Georgia", 32.165622, -82.900075
                       , "Germany", 51.165691, 10.451526
                       , "Hungary", 47.162494, 19.503304
                       , "Andhra Pradesh", 15.9129, 79.739987
                       , "Assam", 26.200604, 92.937574
                       , "Himachal Pradesh", 31.104829, 77.17339
                       , "Jammu & Kashmir", 33.778175, 76.576171
                       , "Karnataka", 15.317278, 75.713888
                       , "Kerala", 10.850516, 76.271083
                       , "Meghalaya", 25.467031, 91.366216
                       , "Punjab", 31.147131, 75.341218
                       , "Rajasthan", 27.023804, 74.217933
                       , "Tamil Nadu", 11.127123, 78.656894
                       , "West Bengal", 22.986757, 87.854976
                       , "Iraq", 33.223191, 43.679291
                       , "Italy", 41.87194, 12.56738
                       , "Japan", 36.204824, 138.252924
                       , "Kazakhstan", 48.019573, 66.923684
                       , "Netherlands", 52.132633, 5.291266
                       , "Pakistan", 30.375321, 69.345116
                       , "Fujian (Fukien)", 24.494349, 118.41631
                       , "Poland", 51.919438, 19.145136
                       , "Portugal", 39.399872, -8.224454
                       , "Kemerovo Oblast", 54.757465, 87.405529
                       , "Moscow Oblast", 55.340396, 38.291765
                       , "St. Petersberg (Leningrad)", 59.93428, 30.335099
                       , "Serbia", 44.016521, 21.005859
                       , "Slovakia", 48.669026, 19.699024
                       , "South Africa", -30.559482, 22.937506
                       , "Spain", 40.463667, -3.74922
                       , "Sweden", 60.128161, 18.643501
                       , "Switzerland", 46.818188, 8.227512
                       , "Tselinograd Obl.", 51.160523, 71.470356
                       , "England", 52.355518, -1.17432
                       , "Wales", 52.130661, -3.783712
                       , "Zimbabwe", -19.015438, 29.154857]}

    albipodus = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "albipodus", "geo": ["Chad", 15.454166, 18.732207
        , "Andhra Pradesh", 15.9129, 79.739987
        , "Jammu & Kashmir", 33.778175, 76.576171
        , "Karnataka", 15.317278, 75.713888
        , "Rajasthan", 27.023804, 74.217933
        , "Tamil Nadu", 11.127123, 78.656894
        , "Japan", 36.204824, 138.252924
        , "Paraguay", -23.442503, -58.443832
        , "Guangxi (Kwangsi)", 22.815478, 108.327546
        , "Xinjiang Uygur (Sinkiang)", 43.825592, 87.616848
        , "Karachai-Cherkess AR", 35.20105, -91.831833
        , "California", 36.778261, -119.417932
        , "Colorado", 39.550051, -105.782067
        , "Montana", 46.879682, -110.362566
        , "Oklahoma", 35.007752, -97.092877
        , "Washington", 38.907192, -77.036871
        , "Wyoming", 43.075968, -107.290284]}

    asychis = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "asychis", "geo": ["Angola", -11.202692, 17.873887
        , "Argentina", -38.416097, -63.616672
        , "Australia", -25.274398, 133.775136
        , "Queensland", -20.917574, 142.702796
        , "Azerbaijan", 40.143105, 47.576927
        , "Brazil", -14.235004, -51.92528
        , "Mato Groso", -12.681871, -56.921099
        , "Canary Islands", 28.291564, -16.62913
        , "Chile", -35.675147, -71.542969
        , "Colombia", 4.570868, -74.297333
        , "Croatia", 45.1, 15.2
        , "Czech Republic", 49.817492, 15.472962
        , "Egypt", 26.820553, 30.802498
        , "Finland", 61.92411, 25.748151
        , "France", 46.227638, 2.213749
        , "Georgia", 32.165622, -82.900075
        , "Germany", 51.165691, 10.451526
        , "Greece", 39.074208, 21.824312
        , "Hungary", 47.162494, 19.503304
        , "India", 20.593684, 78.96288
        , "Himachal Pradesh", 31.104829, 77.17339
        , "Jammu & Kashmir", 33.778175, 76.576171
        , "Karnataka", 15.317278, 75.713888
        , "Meghalaya", 25.467031, 91.366216
        , "Uttar Pradesh", 26.846709, 80.946159
        , "Uttarakhand", 30.066753, 79.0193
        , "West Bengal", 22.986757, 87.854976
        , "Iran", 32.427908, 53.688046
        , "Iraq", 33.223191, 43.679291
        , "Israel", 31.046051, 34.851612
        , "Italy", 41.87194, 12.56738
        , "Sicily", 37.599994, 14.015356
        , "Japan", 36.204824, 138.252924
        , "Kazakhstan", 48.019573, 66.923684
        , "Mexico", 23.634501, -102.552784
        , "Morocco", 31.791702, -7.09262
        , "Nepal", 28.394857, 84.124008
        , "Netherlands", 52.132633, 5.291266
        , "Pakistan", 30.375321, 69.345116
        , "Peoples' Republic of China", 27.72175, 85.332844
        , "Ningxia (Ningsia)", 38.471318, 106.258754
        , "Portugal", 39.399872, -8.224454
        , "Russia", 61.52401, 105.318756
        , "St. Petersberg (Leningrad)", 59.93428, 30.335099
        , "Slovakia", 48.669026, 19.699024
        , "South Africa", -30.559482, 22.937506
        , "Spain", 40.463667, -3.74922
        , "Balearics", 29.803775, -81.309796
        , "Sweden", 60.128161, 18.643501
        , "Tselinograd Obl.", 51.160523, 71.470356
        , "Turkey", 38.963745, 35.243322
        , "Ukraine", 48.379433, 31.16558
        , "United Kingdom", 55.378051, -3.435973
        , "England", 52.355518, -1.17432
        , "Wales", 52.130661, -3.783712
        , "United States of America", 37.09024, -95.712891
        , "California", 36.778261, -119.417932
        , "Colorado", 39.550051, -105.782067
        , "Oklahoma", 35.007752, -97.092877
        , "Texas", 31.968599, -99.901813
        , "Washington", 38.907192, -77.036871
        , "Wyoming", 43.075968, -107.290284]}

    certus = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "certus", "geo": ["Russia", 61.52401, 105.318756
        , "China", 35.86166, 104.195397
        , "Japan", 36.204824, 138.252924
        , "Primor'ye Kray", 45.052564, 135
        , "Minnesota", 46.729553, -94.6859]}

    chaonia = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "chaonia", "geo": ["Austria", 47.516231, 14.550072
        , "Azerbaijan", 40.143105, 47.576927
        , "Minas Gerais", -18.512178, -44.555031
        , "Canary Islands", 28.291564, -16.62913
        , "Chile", -35.675147, -71.542969
        , "Croatia", 45.1, 15.2
        , "Czech Republic", 49.817492, 15.472962
        , "France", 46.227638, 2.213749
        , "Georgia", 32.165622, -82.900075
        , "Germany", 51.165691, 10.451526
        , "Hungary", 47.162494, 19.503304
        , "Lithuania", 55.169438, 23.881275
        , "Madeira", 32.760707, -16.959472
        , "Montenegro", 42.708678, 19.37439
        , "Netherlands", 52.132633, 5.291266
        , "Pakistan", 30.375321, 69.345116
        , "Hong Kong", 22.396428, 114.109497
        , "Poland", 51.919438, 19.145136
        , "Portugal", 39.399872, -8.224454
        , "Novosibirsk Oblast", 55.446713, 80.104392
        , "Serbia", 44.016521, 21.005859
        , "Slovakia", 48.669026, 19.699024
        , "Spain", 40.463667, -3.74922
        , "Sweden", 60.128161, 18.643501
        , "Turkey", 38.963745, 35.243322
        , "Ukraine", 48.379433, 31.16558
        , "England", 52.355518, -1.17432
        , "California", 36.778261, -119.417932]}

    glycinis = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "glycinis", "geo": ["Liaoning", 41.836175, 123.431383]}

    gossypii = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "gossypii", "geo": ["Pernambuco", -8.813717, -36.954107
        , "Sao Paulo", -23.55052, -46.633309
        , "Guadeloupe", 16.265, -61.551
        , "Hawaii", 19.896766, -155.582782
        , "Andaman and Nicobar Islands", 11.740087, 92.65864
        , "Bihar", 25.096074, 85.313119
        , "Himachal Pradesh", 31.104829, 77.17339
        , "Jammu & Kashmir", 33.778175, 76.576171
        , "Uttar Pradesh", 26.846709, 80.946159
        , "Israel", 31.046051, 34.851612
        , "Japan", 36.204824, 138.252924
        , "Nepal", 28.394857, 84.124008
        , "New Zealand", -40.900557, 174.885971
        , "Reunion", -21.115141, 55.536384
        , "South Africa", -30.559482, 22.937506
        , "Tonga", -21.178986, -175.198242
        , "Ukraine", 48.379433, 31.16558
        , "Florida", 27.664827, -81.515754]}

    mali = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "mali", "geo": ["Argentina", -38.416097, -63.616672
        , "New South Wales", -31.253218, 146.921099
        , "Queensland", -20.917574, 142.702796
        , "Tasmania", -41.45452, 145.970665
        , "Austria", 47.516231, 14.550072
        , "Azerbaijan", 40.143105, 47.576927
        , "Belgium", 50.503887, 4.469936
        , "Bolivia", -16.290154, -63.588653
        , "Sao Paulo", -23.55052, -46.633309
        , "Bulgaria", 42.733883, 25.48583
        , "British Columbia", 53.726668, -127.647621
        , "Nova Scotia", 44.681987, -63.744311
        , "Quebec", 52.939916, -73.549136
        , "Canary Islands", 28.291564, -16.62913
        , "Chile", -35.675147, -71.542969
        , "Colombia", 4.570868, -74.297333
        , "Costa Rica", 9.748917, -83.753428
        , "Croatia", 45.1, 15.2
        , "Cyprus", 35.126413, 33.429859
        , "Czech Republic", 49.817492, 15.472962
        , "Ecuador", -1.831239, -78.183406
        , "Egypt", 26.820553, 30.802498
        , "France", 46.227638, 2.213749
        , "Georgia", 32.165622, -82.900075
        , "Germany", 51.165691, 10.451526
        , "Andhra Pradesh", 15.9129, 79.739987
        , "Himachal Pradesh", 31.104829, 77.17339
        , "Jammu & Kashmir", 33.778175, 76.576171
        , "Kerala", 10.850516, 76.271083
        , "Tamil Nadu", 11.127123, 78.656894
        , "Java", 36.835971, -79.227798
        , "Bali", -8.409518, 115.188916
        , "Iraq", 33.223191, 43.679291
        , "Israel", 31.046051, 34.851612
        , "Italy", 41.87194, 12.56738
        , "Japan", 36.204824, 138.252924
        , "Korea", 37.663998, 127.978458
        , "Lebanon", 33.854721, 35.862285
        , "Malta", 35.937496, 14.375416
        , "Mexico", 23.634501, -102.552784
        , "Moldova", 47.411631, 28.369885
        , "Morocco", 31.791702, -7.09262
        , "Netherlands", 52.132633, 5.291266
        , "New Zealand", -40.900557, 174.885971
        , "North Africa", 23.416203, 25.66283
        , "Pakistan", 30.375321, 69.345116
        , "Paraguay", -23.442503, -58.443832
        , "Shandong (Shantung)", 36.66853, 117.020359
        , "Shanghai", 31.230416, 121.473701
        , "Yunnan", 25.045806, 102.710002
        , "Peru", -9.189967, -75.015152
        , "Philippines", 12.879721, 121.774017
        , "Poland", 51.919438, 19.145136
        , "Portugal", 39.399872, -8.224454
        , "Puerto Rico", 18.220833, -66.590149
        , "Romania", 45.943161, 24.96676
        , "Russia", 61.52401, 105.318756
        , "Saudi Arabia", 23.885942, 45.079162
        , "Senegal", 14.497401, -14.452362
        , "Slovakia", 48.669026, 19.699024
        , "South Africa", -30.559482, 22.937506
        , "Spain", 40.463667, -3.74922
        , "Sweden", 60.128161, 18.643501
        , "Switzerland", 46.818188, 8.227512
        , "Tadzhikistan", 38.861034, 71.276093
        , "Trinidad & Tobago", 10.691803, -61.222503
        , "Turkey", 38.963745, 35.243322
        , "Ukraine", 48.379433, 31.16558
        , "England", 52.355518, -1.17432
        , "Arkansas", 35.20105, -91.831833
        , "California", 36.778261, -119.417932
        , "Colorado", 39.550051, -105.782067
        , "Connecticut", 41.603221, -73.087749
        , "District of Columbia", 38.907192, -77.036871
        , "Florida", 27.664827, -81.515754
        , "Idaho", 44.068202, -114.742041
        , "Illinois", 40.633125, -89.398528
        , "Indiana", 40.267194, -86.134902
        , "Iowa", 41.878003, -93.097702
        , "Kansas", 39.011902, -98.484246
        , "Maine", 45.253783, -69.445469
        , "Massachusetts", 42.407211, -71.382437
        , "Michigan", 44.314844, -85.602364
        , "Missouri", 37.964253, -91.831833
        , "Montana", 46.879682, -110.362566
        , "Nebraska", 41.492537, -99.901813
        , "New Jersey", 40.058324, -74.405661
        , "New Mexico", 34.51994, -105.87009
        , "Ohio", 40.417287, -82.907123
        , "Oregon", 43.804133, -120.554201
        , "Pennsylvania", 41.203322, -77.194525
        , "South Carolina", 33.836081, -81.163724
        , "Tennessee", 35.517491, -86.580447
        , "Texas", 31.968599, -99.901813
        , "Utah", 39.32098, -111.093731
        , "Virginia", 37.431573, -78.656894
        , "Washington", 38.907192, -77.036871
        , "West Virginia", 38.597626, -80.454903
        , "Uruguay", -32.522779, -55.765835
        , "Uzbekistan", 41.377491, 64.585262
        , "Venezuela", 6.42375, -66.58973
        , "Zambia", -13.133897, 27.849332
        , "Zimbabwe", -19.015438, 29.154857]}

    paramali = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "paramali", "geo": ["Angola", -11.202692, 17.873887
        , "Egypt", 26.820553, 30.802498
        , "Iran", 32.427908, 53.688046
        , "Israel", 31.046051, 34.851612]}

    rhamni = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "rhamni",
              "geo": ["Beijing (Peking)", 39.904211, 116.407395]}

    semiflavus = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "semiflavus",
                  "geo": ["Argentina", -38.416097, -63.616672
                      , "Sao Paulo", -23.55052, -46.633309
                      , "Manitoba", 53.760861, -98.813876
                      , "Ontario", 34.063344, -117.650888
                      , "Germany", 51.165691, 10.451526
                      , "Hawaii", 19.896766, -155.582782
                      , "India", 20.593684, 78.96288
                      , "Iran", 32.427908, 53.688046
                      , "Israel", 31.046051, 34.851612
                      , "Italy", 41.87194, 12.56738
                      , "Spain", 40.463667, -3.74922
                      , "Turkey", 38.963745, 35.243322
                      , "California", 36.778261, -119.417932
                      , "Colorado", 39.550051, -105.782067
                      , "Indiana", 40.267194, -86.134902
                      , "Kansas", 39.011902, -98.484246
                      , "Maine", 45.253783, -69.445469
                      , "Massachusetts", 42.407211, -71.382437
                      , "Minnesota", 46.729553, -94.6859
                      , "Nebraska", 41.492537, -99.901813
                      , "New Mexico", 34.51994, -105.87009
                      , "New York", 40.712784, -74.005941
                      , "Ohio", 40.417287, -82.907123
                      , "Oklahoma", 35.007752, -97.092877]}

    varipes = {"fam": "Aphelinidae", "gen": "Aphelinus", "sp": "varipes",
               "geo": ["Australian Capital Territory", -35.473468, 149.012368
                   , "Azores", 37.741249, -25.675594
                   , "Canary Islands", 28.291564, -16.62913
                   , "Chile", -35.675147, -71.542969
                   , "Croatia", 45.1, 15.2
                   , "Czech Republic", 49.817492, 15.472962
                   , "Egypt", 26.820553, 30.802498
                   , "France", 46.227638, 2.213749
                   , "Georgia", 32.165622, -82.900075
                   , "Germany", 51.165691, 10.451526
                   , "Hungary", 47.162494, 19.503304
                   , "Israel", 31.046051, 34.851612
                   , "Italy", 41.87194, 12.56738
                   , "Japan", 36.204824, 138.252924
                   , "Kazakhstan", 48.019573, 66.923684
                   , "Madeira", 32.760707, -16.959472
                   , "Mexico", 23.634501, -102.552784
                   , "Morocco", 31.791702, -7.09262
                   , "Nepal", 28.394857, 84.124008
                   , "Netherlands", 52.132633, 5.291266
                   , "Pakistan", 30.375321, 69.345116
                   , "Paraguay", -23.442503, -58.443832
                   , "Portugal", 39.399872, -8.224454
                   , "Primor'ye Kray", 45.052564, 135
                   , "Serbia", 44.016521, 21.005859
                   , "Slovakia", 48.669026, 19.699024
                   , "South Africa", -30.559482, 22.937506
                   , "Balearics", 39.5342, 2.8577
                   , "Sweden", 60.128161, 18.643501
                   , "Tselinograd Obl.", 51.160523, 71.470356
                   , "Turkey", 38.963745, 35.243322
                   , "Ukraine", 48.379433, 31.16558
                   , "England", 52.355518, -1.17432
                   , "Arizona", 34.048928, -111.093731
                   , "California", 36.778261, -119.417932
                   , "Colorado", 39.550051, -105.782067
                   , "Idaho", 44.068202, -114.742041
                   , "Kansas", 39.011902, -98.484246
                   , "Minnesota", 46.729553, -94.6859
                   , "New Mexico", 34.51994, -105.87009
                   , "Oklahoma", 35.007752, -97.092877
                   , "South Carolina", 33.836081, -81.163724
                   , "Texas", 31.968599, -99.901813
                   , "Washington", 38.907192, -77.036871]}


class Aphytis():
    acrenulatus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "acrenulatus", "geo": ["Italy", 41.87194, 12.56738
        , "Mauritius", -20.348404, 57.552152]}

    acutaspidis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "acutaspidis", "geo": ["Rio de Janeiro",-22.906847,-43.172896]}
    
    africanus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "africanus", "geo": ["Argentina", -38.416097, -63.616672
        , "Egypt", 26.820553, 30.802498
        , "Israel", 31.046051, 34.851612
        , "Mozambique", -18.665695, 35.529562
        , "South Africa", -30.559482, 22.937506
        , "Swaziland", -26.522503, 31.465866
        , "California", 36.778261, -119.417932
        , "Zimbabwe", -19.015438, 29.154857]}

    amazonensis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "amazonensis", "geo": ["Amapa", 2.04474, -50.787422]}

    anneckei = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "anneckei", "geo": ["Kenya", -0.023559, 37.906193
        , "South Africa", -30.559482, 22.937506]}
    
    anomalus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "anomalus", "geo": ["Minas Gerais",-18.512178,-44.555031,"Rio de Janeiro",-22.906847,-43.172896]}

    antennalis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "antennalis",
                  "geo": ["Hong Kong", 22.396428, 114.109497]}

    aonidiae = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "aonidiae", "geo": ["Argentina", -38.416097, -63.616672
        , "Armenia", 40.069099, 45.038189
        , "Chile", -35.675147, -71.542969
        , "Cyprus", 35.126413, 33.429859
        , "Czech Republic", 49.817492, 15.472962
        , "Egypt", 26.820553, 30.802498
        , "Georgia", 32.165622, -82.900075
        , "Greece", 39.074208, 21.824312
        , "Hungary", 47.162494, 19.503304
        , "Iran", 32.427908, 53.688046
        , "Israel", 31.046051, 34.851612
        , "Italy", 41.87194, 12.56738
        , "Japan", 36.204824, 138.252924
        , "Mexico", 23.634501, -102.552784
        , "Moldova", 47.411631, 28.369885
        , "Montenegro", 42.708678, 19.37439
        , "Romania", 45.943161, 24.96676
        , "Slovakia", 48.669026, 19.699024
        , "Spain", 40.463667, -3.74922
        , "Turkey", 38.963745, 35.243322
        , "Ukraine", 48.379433, 31.16558
        , "England", 52.355518, -1.17432
        , "California", 36.778261, -119.417932
        , "Ohio", 40.417287, -82.907123
        , "Uruguay", -32.522779, -55.765835]}

    capensis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "capensis",
                "geo": ["South Africa", -30.559482, 22.937506]}

    cercinus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "cercinus", "geo": ["Namibia", -22.95764, 18.49041
        , "South Africa", -30.559482, 22.937506]}

    chilensis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "chilensis",
                 "geo": ["Algeria", 28.033886, 1.659626, "Argentina", -38.416097, -63.616672, "Australia", -25.274398,
                         133.775136,
                         "Chile", -35.675147, -71.542969, "Cyprus", 35.126413, 33.429859, "Egypt", 26.820553, 30.802498,
                         "France",
                         46.227638, 2.213749, "Germany", 51.165691, 10.451526, "Greece", 39.074208, 21.824312, "Sicily",
                         37.599994, 14.015356, "Lebanon", 33.854721, 35.862285, "Mexico", 23.634501, -102.552784,
                         "New Zealand",
                         -40.900557, 174.885971, "Peru", -9.189967, -75.015152, "South Africa", -30.559482, 22.937506,
                         "Spain",
                         40.463667, -3.74922, "Tunisia", 33.886917, 9.537499, "Turkey", 38.963745, 35.243322,
                         "California",
                         36.778261, -119.417932, "New York", 40.712784, -74.005941]}

    chrysomphali = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "chrysomphali",
                    "geo": ["Afghanistan", 33.93911, 67.709953
                        , "Algeria", 28.033886, 1.659626
                        , "Argentina", -38.416097, -63.616672
                        , "New South Wales", -31.253218, 146.921099
                        , "Queensland", -20.917574, 142.702796
                        , "Victoria", 28.805267, -97.003598
                        , "Western Australia", -27.672817, 121.62831
                        , "Belgium", 50.503887, 4.469936
                        , "Bermuda", 32.3078, -64.7505
                        , "Rio de Janeiro", -22.906847, -43.172896
                        , "Caribbean", 14.525556, -75.818333
                        , "Chile", -35.675147, -71.542969
                        , "Costa Rica", 9.748917, -83.753428
                        , "Cuba", 21.521757, -77.781167
                        , "Cyprus", 35.126413, 33.429859
                        , "Dominican Republic", 18.735693, -70.162651
                        , "Egypt", 26.820553, 30.802498
                        , "El Salvador", 13.794185, -88.89653
                        , "Fiji", -17.713371, 178.065032
                        , "France", 46.227638, 2.213749
                        , "French Polynesia", -17.679742, -149.406843
                        , "Georgia", 32.165622, -82.900075
                        , "Germany", 51.165691, 10.451526
                        , "Greece", 39.074208, 21.824312
                        , "Guam", 13.444304, 144.793731
                        , "Guyana", 4.860416, -58.93018
                        , "Haiti", 18.971187, -72.285215
                        , "Hawaii", 19.896766, -155.582782
                        , "Hungary", 47.162494, 19.503304
                        , "India", 20.593684, 78.96288
                        , "Bali", -8.409518, 115.188916
                        , "Java", 36.835971, -79.227798
                        , "Sulawesi", -1.8479, 120.5279
                        , "Iran", 32.427908, 53.688046
                        , "Israel", 31.046051, 34.851612
                        , "Sicily", 37.599994, 14.015356
                        , "Japan", 36.204824, 138.252924
                        , "Lebanon", 33.854721, 35.862285
                        , "Malaysia", 4.210484, 101.975766
                        , "Mauritius", -20.348404, 57.552152
                        , "Mexico", 23.634501, -102.552784
                        , "Morocco", 31.791702, -7.09262
                        , "New Caledonia", -20.904305, 165.618042
                        , "Panama", 8.537981, -80.782127
                        , "Fujian (Fukien)", 24.494349, 118.41631
                        , "Guangdong (Kwangtung)", 23.132191, 113.266531
                        , "Guizhou (Kweichow)", 26.599194, 106.706301
                        , "Hong Kong", 22.396428, 114.109497
                        , "Hubei (Hupeh)", 30.546558, 114.341745
                        , "Hunan (Hunan)", 28.112449, 112.98381
                        , "Jiangsu (Kiangsu)", 32.061707, 118.763232
                        , "Jiangxi (Kiangsi)", 28.675697, 115.909228
                        , "Shanghai", 31.230416, 121.473701
                        , "Sichuan (Szechwan)", 30.651226, 104.075881
                        , "Zhejiang (Chekiang)", 30.267443, 120.152792
                        , "Peru", -9.189967, -75.015152
                        , "Philippines", 12.879721, 121.774017
                        , "Puerto Rico", 18.220833, -66.590149
                        , "Seychelles", -4.679574, 55.491977
                        , "Somalia", 5.152149, 46.199616
                        , "South Africa", -30.559482, 22.937506
                        , "Spain", 40.463667, -3.74922
                        , "Surinam", 3.919305, -56.027783
                        , "Swaziland", -26.522503, 31.465866
                        , "Taiwan", 23.69781, 120.960515
                        , "Tanzania", -6.369028, 34.888822
                        , "Trinidad & Tobago", 10.691803, -61.222503
                        , "Tunisia", 33.886917, 9.537499
                        , "Turkey", 38.963745, 35.243322
                        , "Ukraine", 48.379433, 31.16558
                        , "California", 36.778261, -119.417932
                        , "Florida", 27.664827, -81.515754
                        , "Louisiana", 30.984298, -91.962333
                        , "New York", 40.712784, -74.005941
                        , "Texas", 31.968599, -99.901813
                        , "Uruguay", -32.522779, -55.765835]}

    coheni = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "coheni", "geo": ["Cyprus", 35.126413, 33.429859
        , "Egypt", 26.820553, 30.802498
        , "Greece", 39.074208, 21.824312
        , "Israel", 31.046051, 34.851612
        , "South Africa", -30.559482, 22.937506
        , "California", 36.778261, -119.417932]}

    columbi = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "columbi",
               "geo": ["New South Wales", -31.253218, 146.921099, "Queensland", -20.917574, 142.702796, "Victoria",
                       28.805267,
                       -97.003598]}

    comperei = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "comperei", "geo": ["Jamaica", 18.109581, -77.297508
        , "Mexico", 23.634501, -102.552784
        , "Guangdong (Kwangtung)", 23.132191, 113.266531
        , "Hong Kong", 22.396428, 114.109497
        , "South Africa", -30.559482, 22.937506
        , "Florida", 27.664827, -81.515754
        , "Texas", 31.968599, -99.901813]}

    confusus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "confusus",
                "geo": ["Guangdong (Kwangtung)", 23.132191, 113.266531
                    , "South Africa", -30.559482, 22.937506]}
                
    costalimai = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "costalimai", "geo": ["Argentina",-38.416097,-63.616672,"Minas Gerais",-18.512178,-44.555031,"Rio de Janeiro",-22.906847,-43.172896,"Sao Paulo",-23.55052,-46.633309,"Paraguay",-23.442503,-58.443832]}

    cylindratus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "cylindratus",
                   "geo": ["Minas Gerais", -18.512178, -44.555031
                       , "Pernambuco", -8.813717, -36.954107
                       , "Rio de Janeiro", -22.906847, -43.172896
                       , "Japan", 36.204824, 138.252924
                       , "Peru", -9.189967, -75.015152
                       , "Trinidad & Tobago", 10.691803, -61.222503
                       , "California", 36.778261, -119.417932]}

    debachi = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "debachi", "geo": ["Japan", 36.204824, 138.252924
        , "Fujian (Fukien)", 24.494349, 118.41631
        , "Guangdong (Kwangtung)", 23.132191, 113.266531
        , "Hong Kong", 22.396428, 114.109497
        , "California", 36.778261, -119.417932]}
    
    desantisi = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "desantisi", "geo": ["Argentina",-38.416097,-63.616672]}
    
    equatorialis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "equatorialis", "geo": ["Ivory Coast",7.539989,-5.54708,"South Africa",-30.559482,22.937506]}
    
    fioriniae = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "fioriniae", "geo": ["Assam",26.200604,92.937574]}
    
    fisheri = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "fisheri", "geo": ["India",20.593684,78.96288,"Japan",36.204824,138.252924,"Myanmar (Burma)",21.916221,95.955974,"Pakistan",30.375321,69.345116,"South Africa",-30.559482,22.937506,"Taiwan",23.69781,120.960515,"Thailand",15.870032,100.992541,"California",36.778261,-119.417932]}

    faurei = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "faurei", "geo": ["South Africa", -30.559482, 22.937506]}

    griseus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "griseus", "geo": ["South Africa", -30.559482, 22.937506]}
    
    haywardi = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "haywardi", "geo": ["Argentina",-38.416097,-63.616672,"Uruguay",-32.522779,-55.765835]}

    holoxanthus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "holoxanthus",
                   "geo": ["Argentina", -38.416097, -63.616672
                       , "Queensland", -20.917574, 142.702796
                       , "Brazil", -14.235004, -51.92528
                       , "Caribbean", 14.525556, -75.818333
                       , "Cuba", 21.521757, -77.781167
                       , "Cyprus", 35.126413, 33.429859
                       , "Dominican Republic", 18.735693, -70.162651
                       , "El Salvador", 13.794185, -88.89653
                       , "Karnataka", 15.317278, 75.713888
                       , "Tamil Nadu", 11.127123, 78.656894
                       , "Israel", 31.046051, 34.851612
                       , "Lebanon", 33.854721, 35.862285
                       , "Mexico", 23.634501, -102.552784
                       , "Fujian (Fukien)", 24.494349, 118.41631
                       , "Guangdong (Kwangtung)", 23.132191, 113.266531
                       , "Hong Kong", 22.396428, 114.109497
                       , "Peru", -9.189967, -75.015152
                       , "South Africa", -30.559482, 22.937506
                       , "Taiwan", 23.69781, 120.960515
                       , "Trinidad & Tobago", 10.691803, -61.222503
                       , "California", 36.778261, -119.417932
                       , "Florida", 27.664827, -81.515754
                       , "Texas", 31.968599, -99.901813]}
                   
    hyalinipennis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "hyalinipennis", "geo": ["New Caledonia",-20.904305,165.618042]}

    immaculatus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "immaculatus",
                   "geo": ["Guangdong (Kwangtung)", 23.132191, 113.266531
                       , "Taiwan", 23.69781, 120.960515
                       , "California", 36.778261, -119.417932]}

    japonicus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "japonicus", "geo": ["Japan", 36.204824, 138.252924
        , "South Korea", 35.907757, 127.766922]}

    lepidosaphes = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "lepidosaphes",
                    "geo": ["Argentina", -38.416097, -63.616672
                        , "Queensland", -20.917574, 142.702796
                        , "Rio Grande do Sul", -30.034632, -51.217699
                        , "Chile", -35.675147, -71.542969
                        , "Costa Rica", 9.748917, -83.753428
                        , "Cyprus", 35.126413, 33.429859
                        , "Ecuador", -1.831239, -78.183406
                        , "Egypt", 26.820553, 30.802498
                        , "El Salvador", 13.794185, -88.89653
                        , "Fiji", -17.713371, 178.065032
                        , "Corsica", 42.039604, 9.012893
                        , "Greece", 39.074208, 21.824312
                        , "Guadeloupe", 16.265, -61.551
                        , "Hawaii", 19.896766, -155.582782
                        , "India", 20.593684, 78.96288
                        , "Israel", 31.046051, 34.851612
                        , "Italy", 41.87194, 12.56738
                        , "Jamaica", 18.109581, -77.297508
                        , "Lebanon", 33.854721, 35.862285
                        , "Mexico", 23.634501, -102.552784
                        , "Myanmar (Burma)", 21.916221, 95.955974
                        , "New Caledonia", -20.904305, 165.618042
                        , "Pakistan", 30.375321, 69.345116
                        , "Fujian (Fukien)", 24.494349, 118.41631
                        , "Guangdong (Kwangtung)", 23.132191, 113.266531
                        , "Hong Kong", 22.396428, 114.109497
                        , "Peru", -9.189967, -75.015152
                        , "Philippines", 12.879721, 121.774017
                        , "Puerto Rico", 18.220833, -66.590149
                        , "South Africa", -30.559482, 22.937506
                        , "Spain", 40.463667, -3.74922
                        , "Taiwan", 23.69781, 120.960515
                        , "Thailand", 15.870032, 100.992541
                        , "Trinidad & Tobago", 10.691803, -61.222503
                        , "Turkey", 38.963745, 35.243322
                        , "California", 36.778261, -119.417932
                        , "Florida", 27.664827, -81.515754
                        , "Louisiana", 30.984298, -91.962333
                        , "Texas", 31.968599, -99.901813]}
    libanicus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "libanicus", "geo": ["Egypt",26.820553,30.802498,"Iran",32.427908,53.688046,"Israel",31.046051,34.851612,"Italy",41.87194,12.56738,"Lebanon",33.854721,35.862285,"Turkey",38.963745,35.243322]}

    lingnanensis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "lingnanensis",
                    "geo": ["Argentina", -38.416097, -63.616672
                        , "Queensland", -20.917574, 142.702796
                        , "Victoria", -37.471308, 144.785153
                        , "Western Australia", -27.672817, 121.62831
                        , "Bermuda", 32.3078, -64.7505
                        , "Bolivia", -16.290154, -63.588653
                        , "Brazil", -14.235004, -51.92528
                        , "Caribbean", 14.525556, -75.818333
                        , "Easter Island", -27.11299, -109.349581
                        , "Costa Rica", 9.748917, -83.753428
                        , "Cuba", 21.521757, -77.781167
                        , "Cyprus", 35.126413, 33.429859
                        , "Egypt", 26.820553, 30.802498
                        , "El Salvador", 13.794185, -88.89653
                        , "Fiji", -17.713371, 178.065032
                        , "Assam", 26.200604, 92.937574
                        , "Delhi", 28.613939, 77.209021
                        , "Karnataka", 15.317278, 75.713888
                        , "Kerala", 10.850516, 76.271083
                        , "Tamil Nadu", 11.127123, 78.656894
                        , "Uttar Pradesh", 26.846709, 80.946159
                        , "Java", 36.835971, -79.227798
                        , "Bali", -8.409518, 115.188916
                        , "Israel", 31.046051, 34.851612
                        , "Sicily", 37.599994, 14.015356
                        , "Jamaica", 18.109581, -77.297508
                        , "Japan", 36.204824, 138.252924
                        , "Malaysia", 4.210484, 101.975766
                        , "Mauritius", -20.348404, 57.552152
                        , "Mexico", 23.634501, -102.552784
                        , "Morocco", 31.791702, -7.09262
                        , "New Caledonia", -20.904305, 165.618042
                        , "Pakistan", 30.375321, 69.345116
                        , "Fujian (Fukien)", 24.494349, 118.41631
                        , "Guangdong (Kwangtung)", 23.132191, 113.266531
                        , "Hong Kong", 22.396428, 114.109497
                        , "Zhejiang (Chekiang)", 30.267443, 120.152792
                        , "Peru", -9.189967, -75.015152
                        , "Philippines", 12.879721, 121.774017
                        , "Puerto Rico", 18.220833, -66.590149
                        , "Solomon Islands", -9.64571, 160.156194
                        , "South Africa", -30.559482, 22.937506
                        , "Spain", 40.463667, -3.74922
                        , "Taiwan", 23.69781, 120.960515
                        , "Thailand", 15.870032, 100.992541
                        , "Trinidad & Tobago", 10.691803, -61.222503
                        , "Turkey", 38.963745, 35.243322
                        , "California", 36.778261, -119.417932
                        , "Florida", 27.664827, -81.515754
                        , "Texas", 31.968599, -99.901813
                        , "Uruguay", -32.522779, -55.765835]}

    luteus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "luteus",
              "geo": ["Cyprus", 35.126413, 33.429859, "Corsica", 42.039604, 9.012893, "Germany", 51.165691, 10.451526,
                      "Greece",
                      39.074208, 21.824312, "Hungary", 47.162494, 19.503304, "Italy", 41.87194, 12.56738]}
    
    margaretae = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "margaretae",
              "geo": ["Rio de Janeiro",-22.906847,-43.172896,"Mexico",23.634501,-102.552784]}

    mazalae = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "mazalae", "geo": ["Japan", 36.204824, 138.252924
        , "Pakistan", 30.375321, 69.345116
        , "Guangdong (Kwangtung)", 23.132191, 113.266531
        , "Taiwan", 23.69781, 120.960515]}

    melinus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "melinus", "geo": ["Argentina", -38.416097, -63.616672
        , "Queensland", -20.917574, 142.702796
        , "South Australia", -30.000231, 136.209155
        , "Victoria", -37.471308, 144.785153
        , "Chile", -35.675147, -71.542969
        , "Cyprus", 35.126413, 33.429859
        , "France", 46.227638, 2.213749
        , "Georgia", 32.165622, -82.900075
        , "Greece", 39.074208, 21.824312
        , "Delhi", 28.613939, 77.209021
        , "Karnataka", 15.317278, 75.713888
        , "Maharashtra", 19.75148, 75.713888
        , "Puducherry", 11.91386, 79.814472
        , "Tamil Nadu", 11.127123, 78.656894
        , "Israel", 31.046051, 34.851612
        , "Sardinia", 40.120875, 9.012893
        , "Sicily", 37.599994, 14.015356
        , "Mexico", 23.634501, -102.552784
        , "Morocco", 31.791702, -7.09262
        , "Netherlands", 52.132633, 5.291266
        , "Pakistan", 30.375321, 69.345116
        , "Paraguay", -23.442503, -58.443832
        , "Fujian (Fukien)", 24.494349, 118.41631
        , "Guangdong (Kwangtung)", 23.132191, 113.266531
        , "Peru", -9.189967, -75.015152
        , "South Africa", -30.559482, 22.937506
        , "Spain", 40.463667, -3.74922
        , "Turkey", 38.963745, 35.243322
        , "California", 36.778261, -119.417932
        , "Uruguay", -32.522779, -55.765835]}

    merceti = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "merceti", "geo": ["South Africa", -30.559482, 22.937506]}
    
    moldavicus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "moldavicus", "geo": ["Czech Republic",49.817492,15.472962,"Georgia",32.165622,-82.900075,"Moldova",47.411631,28.369885,"Tadzhikistan",38.861034,71.276093]}

    mytilaspidis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "mytilaspidis", "geo": ["Algeria", 28.033886, 1.659626
        , "Argentina", -38.416097, -63.616672
        , "Azerbaijan", 40.143105, 47.576927
        , "Belgium", 50.503887, 4.469936
        , "Bermuda", 32.3078, -64.7505
        , "Bulgaria", 42.733883, 25.48583
        , "British Columbia", 53.726668, -127.647621
        , "New Brunswick", 40.486216, -74.451819
        , "Nova Scotia", 44.221789, -65.217441
        , "Ontario", 34.063344, -117.650888
        , "Quebec", 52.939916, -73.549136
        , "Chile", -35.675147, -71.542969
        , "Croatia", 45.1, 15.2
        , "Cyprus", 35.126413, 33.429859
        , "Czech Republic", 49.817492, 15.472962
        , "Egypt", 26.820553, 30.802498
        , "France", 46.227638, 2.213749
        , "Georgia", 32.165622, -82.900075
        , "Germany", 51.165691, 10.451526
        , "Greece", 39.074208, 21.824312
        , "Hungary", 47.162494, 19.503304
        , "India", 20.593684, 78.96288
        , "Java", 36.835971, -79.227798
        , "Bali", -8.261141, 114.999133
        , "Iran", 32.427908, 53.688046
        , "Iraq", 33.223191, 43.679291
        , "Israel", 31.046051, 34.851612
        , "Italy", 41.87194, 12.56738
        , "Japan", 36.204824, 138.252924
        , "Kazakhstan", 48.019573, 66.923684
        , "Lebanon", 33.854721, 35.862285
        , "Macedonia", 41.608635, 21.745275
        , "Mauritania", 21.00789, -10.940835
        , "Mauritius", -20.348404, 57.552152
        , "Mexico", 23.634501, -102.552784
        , "Moldova", 47.411631, 28.369885
        , "Montenegro", 42.708678, 19.37439
        , "Morocco", 31.791702, -7.09262
        , "Netherlands", 52.132633, 5.291266
        , "New Zealand", -40.900557, 174.885971
        , "North Africa", 23.416203, 25.66283
        , "Guangdong (Kwangtung)", 23.132191, 113.266531
        , "Poland", 51.919438, 19.145136
        , "Romania", 45.943161, 24.96676
        , "Moscow Oblast", 55.340396, 38.291765
        , "Primor'ye Kray", 45.052564, 135
        , "Saudi Arabia", 23.885942, 45.079162
        , "Serbia", 44.016521, 21.005859
        , "Slovakia", 48.669026, 19.699024
        , "Slovenia", 46.151241, 14.995463
        , "South Africa", -30.559482, 22.937506
        , "Spain", 40.463667, -3.74922
        , "Sri Lanka", 7.873054, 80.771797
        , "Sweden", 60.128161, 18.643501
        , "Switzerland", 46.818188, 8.227512
        , "Taiwan", 23.69781, 120.960515
        , "Tselinograd Obl.", 51.160523, 71.470356
        , "Turkey", 38.963745, 35.243322
        , "Ukraine", 48.379433, 31.16558
        , "England", 52.355518, -1.17432
        , "Arkansas", 35.20105, -91.831833
        , "California", 36.778261, -119.417932
        , "Colorado", 39.550051, -105.782067
        , "Connecticut", 41.651464, -72.898732
        , "District of Columbia", 38.907192, -77.036871
        , "Florida", 27.664827, -81.515754
        , "Georgia", 32.165622, -82.900075
        , "Idaho", 44.068202, -114.742041
        , "Illinois", 40.633125, -89.398528
        , "Indiana", 40.267194, -86.134902
        , "Iowa", 41.878003, -93.097702
        , "Kentucky", 37.839333, -84.270018
        , "Maine", 46.184749, -68.97204
        , "Maryland", 39.414614, -77.010245
        , "Massachusetts", 42.407211, -71.382437
        , "Missouri", 37.964253, -91.831833
        , "Nebraska", 41.887216, -98.487523
        , "New York", 40.712784, -74.005941
        , "North Carolina", 35.759573, -79.0193
        , "Ohio", 40.417287, -82.907123
        , "Oregon", 43.804133, -120.554201
        , "Texas", 31.968599, -99.901813
        , "Virginia", 37.431573, -78.656894]}

    notialis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "notialis",
                "geo": ["Argentina", -38.416097, -63.616672, "Chile", -35.675147, -71.542969]}
    
    obscurus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "obscurus", "geo": ["Island of Martin Garcia",-34.182483,-58.249109]}
    
    opuntiae = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "opuntiae",
                "geo": ["Greece",39.074208,21.824312,"Italy",41.87194,12.56738,"Spain",40.463667,-3.74922]}

    paramaculicornis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "paramaculicornis",
                        "geo": ["Egypt", 26.820553, 30.802498
                            , "Georgia", 32.165622, -82.900075
                            , "Jammu & Kashmir", 34.020179, 75.711973
                            , "Iran", 32.427908, 53.688046
                            , "Iraq", 33.223191, 43.679291
                            , "Israel", 31.046051, 34.851612
                            , "Pakistan", 30.375321, 69.345116
                            , "Saudi Arabia", 23.885942, 45.079162
                            , "South Africa", -30.559482, 22.937506
                            , "California", 36.778261, -119.417932]}

    philippinensis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "philippinensis",
                      "geo": ["Egypt", 26.820553, 30.802498
                          , "Assam", 25.542616, 92.738184
                          , "Karnataka", 15.317278, 75.713888
                          , "Tamil Nadu", 11.127123, 78.656894
                          , "Guangdong (Kwangtung)", 23.132191, 113.266531
                          , "Philippines", 12.879721, 121.774017]}

    phoenicis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "phoenicis",
                 "geo": ["Egypt", 26.820553, 30.802498, "Israel", 31.046051, 34.851612, "Saudi Arabia", 23.885942,
                         45.079162]}

    pinnaspidis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "pinnaspidis",
                   "geo": ["Pernambuco", -8.37803, -35.565027
                       , "Rio de Janeiro", -22.906847, -43.172896
                       , "El Salvador", 13.794185, -88.89653
                       , "Karnataka", 15.317278, 75.713888
                       , "Tamil Nadu", 11.127123, 78.656894
                       , "Mexico", 23.634501, -102.552784]}

    sensorius = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "sensorius", "geo": ["Pakistan", 30.375321, 69.345116]}

    taylori = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "taylori", "geo": ["South Africa", -30.559482, 22.937506]}

    testaceus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "testaceus", "geo": ["Azerbaijan", 40.143105, 47.576927
        , "Hungary", 47.162494, 19.503304
        , "Moldova", 47.411631, 28.369885
        , "Kabardino-Balkaria", 43.393247, 43.56285]}

    tucumani = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "tucumani", "geo": ["Argentina", -38.416097, -63.616672]}

    vandenboschi = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "vandenboschi", "geo": ["Egypt", 26.820553, 30.802498
        , "Japan", 36.204824, 138.252924
        , "South Korea", 35.907757, 127.766922
        , "Guangdong (Kwangtung)", 23.132191, 113.266531
        , "Liaoning", 40.871254, 124.849584
        , "California", 36.778261, -119.417932
        , "Utah", 39.32098, -111.093731]}
    
    vastus = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "vastus", "geo": ["Namibia",-22.95764,18.49041]}
    
    wallumbillae = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "wallumbillae", "geo": ["Queensland",-20.917574,142.702796]}
    
    yanonensis = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "yanonensis", "geo": ["France",46.227638,2.213749,"Japan",36.204824,138.252924,"Fujian (Fukien)",24.494349,118.41631,"Guizhou (Kweichow)",26.599194,106.706301,"Hunan (Hunan)",28.112449,112.98381,"Sichuan (Szechwan)",30.651226,104.075881,"Yunnan",25.045806,102.710002]}
    
    yasumatsui = {"fam": "Aphelinidae", "gen": "Aphytis", "sp": "yasumatsui", "geo": ["Japan",36.204824,138.252924]}


class Encarsia():
    bimaculata = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "bimaculata",
                  "geo": ["Australian Capital Territory", -35.473468, 149.012368, "Northern Territory", -19.491411,
                          132.55096, "Queensland", -20.917574, 142.702796, "South Australia", -30.000231, 136.209155,
                          "Victoria", 28.805267, -97.003598, "Honduras", 15.199999, -86.241905, "Maharashtra", 19.75148,
                          75.713888, "Java", -7.614529, 110.712246, "Bali", -8.409518, 115.188916, "Israel", 31.046051,
                          34.851612, "Mexico", 23.634501, -102.552784, "Papua New Guinea", -6.314993, 143.95555,
                          "Hong Kong", 22.396428, 114.109497, "Philippines", 12.879721, 121.774017, "Sudan", 12.862807,
                          30.217636, "Thailand", 15.870032, 100.992541, "Arizona", 34.048928, -111.093731, "Florida",
                          27.664827, -81.515754, "Texas", 31.968599, -99.901813]}

    cibcensis = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "cibcensis",
                 "geo": ["Cook Islands", -21.236736, -159.777671, "India", 20.593684, 78.96288, "Iran", 32.427908,
                         53.688046, "Kiribati", 1.870883, -157.363026, "Nauru", -0.522778, 166.931503, "Pakistan",
                         30.375321, 69.345116, "Taiwan", 23.69781, 120.960515]}

    citrina = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "citrina",
               "geo": ["Algeria", 28.033886, 1.659626, "Argentina", -38.416097, -63.616672, "Queensland", -20.917574,
                       142.702796, "South Australia", -30.000231, 136.209155, "Azerbaijan", 40.143105, 47.576927,
                       "Barbados", 13.193887, -59.543198, "Belgium", 50.503887, 4.469936, "Bermuda", 32.3078, -64.7505,
                       "Bolivia", -16.290154, -63.588653, "Bahia", -12.579738, -41.700727, "Sao Paulo", -23.55052,
                       -46.633309, "Bulgaria", 42.733883, 25.48583, "Canada", 56.130366, -106.346771, "Chile",
                       -35.675147, -71.542969, "Colombia", 4.570868, -74.297333, "Cook Islands", -21.236736,
                       -159.777671, "Cuba", 21.521757, -77.781167,
                       "Dominican Republic", 18.735693, -70.162651, "Egypt", 26.820553, 30.802498, "El Salvador",
                       13.794185, -88.89653, "Fiji", -17.713371, 178.065032, "France", 46.227638, 2.213749,
                       "French Polynesia", -17.679742, -149.406843, "Georgia", 32.165622, -82.900075, "Germany",
                       51.165691, 10.451526, "Ghana", 7.946527, -1.023194, "Greece", 39.074208, 21.824312, "Grenada",
                       12.1165, -61.679, "Guam", 13.444304, 144.793731, "Guyana", 4.860416, -58.93018, "Haiti",
                       18.971187, -72.285215, "Hawaii", 19.896766, -155.582782, "Hungary", 47.162494, 19.503304,
                       "Andaman and Nicobar Islands", 11.740087, 92.65864, "Himachal Pradesh", 31.104829, 77.17339,
                       "Jammu and Kashmir", 33.778175, 76.576171, "Karnataka", 15.317278, 75.713888, "Java", -7.614529,
                       110.712246, "Bali", -8.409518, 115.188916, "Iran", 32.427908, 53.688046, "Sicily", 37.599994,
                       14.015356, "Jamaica", 18.109581, -77.297508, "Japan", 36.204824, 138.252924, "Macedonia",
                       41.608635, 21.745275, "Malaysia", 4.210484, 101.975766, "Mauritius", -20.348404, 57.552152,
                       "Mexico", 23.634501, -102.552784, "Moldova", 47.411631, 28.369885, "Morocco", 31.791702,
                       -7.09262, "Netherlands", 52.132633, 5.291266, "New Zealand", -40.900557, 174.885971,
                       "Fujian (Fukien)", 24.494349, 118.41631, "Guangdong (Kwangtung)", 23.132191, 113.266531,
                       "Hunan (Hunan)", 28.112449, 112.98381, "Jiangsu (Kiangsu)", 32.061707, 118.763232,
                       "Jiangxi (Kiangsi)", 28.675697, 115.909228, "Liaoning", 41.836175, 123.431383, "Shanghai",
                       31.230416, 121.473701, "Sichuan (Szechwan)", 30.651226, 104.075881, "Zhejiang (Chekiang)",
                       30.267443, 120.152792, "Peru", -9.189967, -75.015152, "Philippines", 12.879721, 121.774017,
                       "Portugal", 39.399872, -8.224454, "Puerto Rico", 18.220833, -66.590149, "Adygey AO (Adigei)",
                       44.822916, 40.175446, "Dolgano-Nenetsky", 71.916451, 93.715289, "Primorsky Kray", 45.052564, 135,
                       "Sao Tome and Principe", 0.18636, 6.613081, "Saudi Arabia", 23.885942, 45.079162, "Serbia",
                       44.016521, 21.005859, "Slovakia", 48.669026, 19.699024, "South Africa", -30.559482, 22.937506,
                       "Spain", 40.463667, -3.74922, "Sri Lanka", 7.873054, 80.771797, "Sweden", 60.128161, 18.643501,
                       "Switzerland", 46.818188, 8.227512, "Taiwan", 23.69781, 120.960515, "Trinidad & Tobago",
                       10.691803, -61.222503, "Tunisia", 33.886917, 9.537499, "Turkey", 38.963745, 35.243322, "Ukraine",
                       48.379433, 31.16558, "England", 52.355518, -1.17432, "Arkansas", 35.20105, -91.831833,
                       "California", 36.778261, -119.417932, "Connecticut", 41.603221, -73.087749, "Florida", 27.664827,
                       -81.515754, "Georgia", 32.165622, -82.900075, "Illinois", 40.633125, -89.398528, "Louisiana",
                       30.984298, -91.962333, "Maryland", 39.045755, -76.641271, "Massachusetts", 42.407211, -71.382437,
                       "Michigan", 44.314844, -85.602364, "Missouri", 37.964253, -91.831833, "New Jersey", 40.058324,
                       -74.405661, "New York", 40.712784, -74.005941, "Ohio", 40.417287, -82.907123, "Oregon",
                       43.804133, -120.554201, "Pennsylvania", 41.203322, -77.194525, "Texas", 31.968599, -99.901813,
                       "Virginia", 37.431573, -78.656894, "Uruguay", -32.522779, -55.765835,
                       "Wallis and Futuna Islands", -13.29591, -176.205684, "Zimbabwe", -19.015438, 29.154857
                       ]}

    formosa = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "formosa", "geo": ["Algeria", 28.033886, 1.659626
        , "Argentina", -38.416097, -63.616672
        , "Australian Capital Territory", -35.473468, 149.012368
        , "New South Wales", -31.253218, 146.921099
        , "Queensland", -20.917574, 142.702796
        , "South Australia", -30.000231, 136.209155
        , "Tasmania", -41.45452, 145.970665
        , "Victoria", -37.471308, 144.785153
        , "Western Australia", -27.672817, 121.62831
        , "Austria", 47.516231, 14.550072
        , "Azores", 37.741249, -25.675594
        , "Barbados", 13.193887, -59.543198
        , "Belarus", 53.709807, 27.953389
        , "Belgium", 50.503887, 4.469936
        , "Bermuda", 32.3078, -64.7505
        , "Sao Paulo", -23.55052, -46.633309
        , "Bulgaria", 42.733883, 25.48583
        , "Alberta", 53.933271, -116.576503
        , "British Columbia", 53.726668, -127.647621
        , "Manitoba", 53.760861, -98.813876
        , "New Brunswick", 40.486216, -74.451819
        , "Newfoundland", 53.135509, -57.660436
        , "Nova Scotia", 44.681987, -63.744311
        , "Ontario", 34.063344, -117.650888
        , "Prince Edward Island", 46.510712, -63.416814
        , "Quebec", 52.939916, -73.549136
        , "Saskatchewan", 52.939916, -106.450864
        , "Canary Islands", 28.291564, -16.62913
        , "Caribbean", 14.525556, -75.818333
        , "Channel Islands (British Is)", 53.651896, -0.044571
        , "Colombia", 4.570868, -74.297333
        , "Costa Rica", 9.748917, -83.753428
        , "Czech Republic", 49.817492, 15.472962
        , "Denmark", 56.26392, 9.501785
        , "Dominican Republic", 18.735693, -70.162651
        , "Egypt", 26.820553, 30.802498
        , "Fiji", -17.713371, 178.065032
        , "Finland", 61.92411, 25.748151
        , "France", 46.227638, 2.213749
        , "French Polynesia", -17.679742, -149.406843
        , "Georgia", 32.165622, -82.900075
        , "Germany", 51.165691, 10.451526
        , "Greece", 39.074208, 21.824312
        , "Hawaii", 19.896766, -155.582782
        , "Hungary", 47.162494, 19.503304
        , "Iran", 32.427908, 53.688046
        , "Israel", 31.046051, 34.851612
        , "Sardinia", 40.120875, 9.012893
        , "Sicily", 37.599994, 14.015356
        , "Japan", 36.204824, 138.252924
        , "Jordan", 30.585164, 36.238414
        , "Korea, South", 37.663998, 127.978458
        , "Madeira", 32.760707, -16.959472
        , "Malta", 35.937496, 14.375416
        , "Mexico", 23.634501, -102.552784
        , "Moldova", 47.411631, 28.369885
        , "Netherlands", 52.132633, 5.291266
        , "New Zealand", -40.900557, 174.885971
        , "Norway", 60.472024, 8.468946
        , "Pakistan", 30.375321, 69.345116
        , "Beijing (Peking)", 39.904211, 116.407395
        , "Shanghai", 31.230416, 121.473701
        , "Poland", 51.919438, 19.145136
        , "Portugal", 39.399872, -8.224454
        , "Puerto Rico", 18.220833, -66.590149
        , "Reunion", -21.115141, 55.536384
        , "Romania", 45.943161, 24.96676
        , "Kalinin Oblast", 57.002165, 33.985314
        , "Penza Oblast", 53.141211, 44.094005
        , "Primor'ye Kray", 45.052564, 135
        , "Serbia", 44.016521, 21.005859
        , "Slovakia", 48.669026, 19.699024
        , "Slovenia", 46.151241, 14.995463
        , "South Africa", -30.559482, 22.937506
        , "Spain", 40.463667, -3.74922
        , "Sweden", 60.128161, 18.643501
        , "Switzerland", 46.818188, 8.227512
        , "Thailand", 15.870032, 100.992541
        , "Tonga", -21.178986, -175.198242
        , "Trinidad & Tobago", 10.691803, -61.222503
        , "Turkey", 38.963745, 35.243322
        , "Ukraine", 48.379433, 31.16558
        , "England", 52.355518, -1.17432
        , "Scotland", 56.490671, -4.202646
        , "California", 36.778261, -119.417932
        , "District of Columbia", 38.907192, -77.036871
        , "Georgia", 32.165622, -82.900075
        , "Idaho", 44.068202, -114.742041
        , "Kansas", 39.011902, -98.484246
        , "Massachusetts", 42.407211, -71.382437
        , "Michigan", 44.314844, -85.602364
        , "New York", 40.712784, -74.005941
        , "Ohio", 40.417287, -82.907123
        , "Texas", 31.968599, -99.901813
        , "Uzbekistan", 41.377491, 64.585262]}
    
    gennaroi = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "gennaroi", "geo": ["California",36.778261,-119.417932,"Texas",31.968599,-99.901813,"Florida",27.664827,-81.515754,"Italy",41.87194,12.56738,"France",46.227638,2.213749,"Spain",40.463667,-3.74922,"Israel",31.046051,34.851612,"Egypt",26.820553,30.802498,"Canary Islands",28.291564,-16.62913,"Australia",-25.274398,133.775136]}

    guadaloupae = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "guadaloupae", "geo": ["Benin", 9.30769, 2.315834
        , "Canary Islands", 28.291564, -16.62913
        , "Costa Rica", 9.748917, -83.753428
        , "Fiji", -17.713371, 178.065032
        , "French Polynesia", -17.679742, -149.406843
        , "Ghana", 7.946527, -1.023194
        , "Guadeloupe", 16.265, -61.551
        , "Guam", 13.444304, 144.793731
        , "Hawaii", 19.896766, -155.582782
        , "Andhra Pradesh", 15.9129, 79.739987
        , "Lakshadweep", 8.295441, 73.048973
        , "Malaysia", 4.210484, 101.975766
        , "Mexico", 23.634501, -102.552784
        , "Micronesia", 6.887481, 158.215072
        , "Nauru", -0.522778, 166.931503
        , "Nigeria", 9.081999, 8.675277
        , "Palau", 7.51498, 134.58252
        , "Papua New Guinea", -6.314993, 143.95555
        , "Philippines", 12.879721, 121.774017
        , "Taiwan", 23.69781, 120.960515
        , "Thailand", 15.870032, 100.992541
        , "Togo", 8.619543, 0.824782
        , "Florida", 27.664827, -81.515754]}

    haitensis = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "haitensis",
                 "geo": ["Benin", 9.30769, 2.315834, "Cuba", 21.521757, -77.781167, "Haiti", 18.971187, -72.285215,
                         "Hawaii", 19.896766, -155.582782, "Mexico", 23.634501, -102.552784, "Taiwan", 23.69781,
                         120.960515, "Venezuela", 6.42375, -66.58973
                         ]}

    hispida = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "hispida",
               "geo": ["Argentina", -38.416097, -63.616672, "Barbados", 13.193887, -59.543198,
                       "Distrito federal (Brasilia)", -15.799765, -47.864472, "Maranhao", -4.96095, -45.274416,
                       "Minas Gerais", -18.512178, -44.555031, "Pernambuco", -8.813717, -36.954107, "Sao Paulo",
                       -23.55052, -46.633309, "Canary Islands", 28.291564, -16.62913, "Caribbean", 21.469114,
                       -78.656894, "Chile", -35.675147, -71.542969, "Colombia", 4.570868, -74.297333,
                       "Dominican Republic", 18.735693, -70.162651, "France", 46.227638, 2.213749, "French Polynesia",
                       -17.679742, -149.406843, "Guadeloupe", 16.265, -61.551, "Guatemala", 15.783471, -90.230759,
                       "Haiti", 18.971187, -72.285215, "Honduras", 15.199999, -86.241905, "Italy", 41.87194, 12.56738,
                       "Jamaica", 18.109581, -77.297508, "Madeira", 32.760707, -16.959472, "Mexico", 23.634501,
                       -102.552784, "Netherlands", 52.132633, 5.291266, "Peru", -9.189967, -75.015152, "Puerto Rico",
                       18.220833, -66.590149, "South Africa", -30.559482, 22.937506, "Spain", 40.463667, -3.74922,
                       "Arizona", 34.048928, -111.093731, "California", 36.778261, -119.417932, "Florida", 27.664827,
                       -81.515754, "Venezuela", 6.42375, -66.58973]}

    luteola = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "luteola", "geo": ["Pernambuco", -8.813717, -36.954107
        , "Chile", -35.675147, -71.542969
        , "Cuba", 21.521757, -77.781167
        , "Guadeloupe", 16.265, -61.551
        , "Israel", 31.046051, 34.851612
        , "Martinique", 14.641528, -61.024174
        , "Mexico", 23.634501, -102.552784
        , "Puerto Rico", 18.220833, -66.590149
        , "South Africa", -30.559482, 22.937506
        , "Arizona", 34.048928, -111.093731
        , "California", 36.778261, -119.417932
        , "Connecticut", 41.603221, -73.087749
        , "District of Columbia", 38.907192, -77.036871
        , "Florida", 27.664827, -81.515754
        , "Massachusetts", 42.407211, -71.382437
        , "Pennsylvania", 41.203322, -77.194525
        , "Texas", 31.968599, -99.901813]}

    meritoria = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "meritoria",
                 "geo": ["Bahamas", 25.03428, -77.39628, "Bermuda", 32.3078, -64.7505, "Brazil", -14.235004, -51.92528,
                         "Dominican Republic", 18.735693, -70.162651, "France", 46.227638, 2.213749, "Israel",
                         31.046051, 34.851612, "Sicily", 37.599994, 14.015356, "Mexico", 23.634501, -102.552784,
                         "South Africa", -30.559482, 22.937506, "Spain", 40.463667, -3.74922, "Trinidad & Tobago",
                         10.691803, -61.222503, "Arizona", 34.048928, -111.093731, "California", 36.778261, -119.417932,
                         "Florida", 27.664827, -81.515754, "Texas", 31.968599, -99.901813
                         ]}

    oakeyensis = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "meritoria",
                  "geo": ["Queensland", -20.917574, 142.702796]}

    protransvena = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "protransvena",
                    "geo": ["Argentina", -38.416097, -63.616672, "Western Australia", -27.672817, 121.62831,
                            "Cayman Islands", 19.3133, -81.2546, "Christmas Island", -10.447525, 105.690449, "Colombia",
                            4.570868, -74.297333, "Egypt", 26.820553, 30.802498, "Fiji", -17.713371, 178.065032,
                            "French Polynesia", -17.679742, -149.406843, "Hawaii", 19.896766, -155.582782, "Honduras",
                            15.199999, -86.241905, "Iran", 32.427908, 53.688046, "Italy", 41.87194, 12.56738,
                            "Peoples' Republic of China", 27.72175, 85.332844, "Puerto Rico", 18.220833, -66.590149,
                            "Spain", 40.463667, -3.74922, "Taiwan", 23.69781, 120.960515, "California", 36.778261,
                            -119.417932, "Florida", 27.664827, -81.515754, "Georgia", 32.165622, -82.900075,
                            "Mississippi", 32.354668, -89.398528, "South Carolina", 33.836081, -81.163724]}

    smithi = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "smithi",
              "geo": ["Bangladesh", 23.684994, 90.356331, "Cuba", 21.521757, -77.781167, "Guam", 13.444304, 144.793731,
                      "Hawaii", 19.896766, -155.582782, "India", 20.593684, 78.96288, "Bihar", 25.096074, 85.313119,
                      "Karnataka", 15.317278, 75.713888, "Maharashtra", 19.75148, 75.713888, "Japan", 36.204824,
                      138.252924, "Maldives", 1.977247, 73.536112, "Mexico", 23.634501, -102.552784, "Micronesia",
                      6.887481, 158.215072, "Pakistan", 30.375321, 69.345116, "Peoples' Republic of China", 27.72175,
                      85.332844, "Fujian (Fukien)", 24.494349, 118.41631, "Guangdong (Kwangtung)", 23.132191,
                      113.266531, "Guangxi (Kwangsi)", 22.815478, 108.327546, "Hunan (Hunan)", 28.112449, 112.98381,
                      "Macau (Macao)", 22.204747, 113.555203, "Zhejiang (Chekiang)", 30.267443, 120.152792,
                      "South Africa", -30.559482, 22.937506, "Sri Lanka", 7.873054, 80.771797, "Swaziland", -26.522503,
                      31.465866, "Taiwan", 23.69781, 120.960515, "United States of America", 37.09024, -95.712891,
                      "Florida", 27.664827, -81.515754, "Texas", 31.968599, -99.901813]}

    sophia = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "sophia",
              "geo": ["Afghanistan", 33.93911, 67.709953, "Algeria", 28.033886, 1.659626, "Argentina", -38.416097,
                      -63.616672, "Northern Territory", -19.491411, 132.55096, "Queensland", -20.917574, 142.702796,
                      "Western Australia", -27.672817, 121.62831, "Burundi", -3.373056, 29.918886, "Canary Islands",
                      28.291564, -16.62913, "Cape Verde Islands", 16, -24, "Caribbean", 21.469114, -78.656894,
                      "Dominican Republic", 18.735693, -70.162651, "Egypt", 26.820553, 30.802498, "French Polynesia",
                      -17.679742, -149.406843, "Guadeloupe", 16.265, -61.551, "Hawaii", 19.896766, -155.582782,
                      "Honduras", 15.199999, -86.241905, "Andhra Pradesh", 15.9129, 79.739987, "Delhi", 28.613939,
                      77.209021, "Gujarat", 22.258652, 71.192381, "Karnataka", 15.317278, 75.713888, "Kerala",
                      10.850516, 76.271083, "Maharashtra", 19.75148, 75.713888, "Rajasthan", 27.023804, 74.217933,
                      "Tamil Nadu", 11.127123, 78.656894, "Uttar Pradesh", 26.846709, 80.946159, "West Bengal",
                      22.986757, 87.854976, "Java", -7.614529, 110.712246, "Bali", -8.409518, 115.188916, "Sumatra",
                      -0.589724, 101.343106, "Iran", 32.427908, 53.688046, "Israel", 31.046051, 34.851612, "Italy",
                      41.87194, 12.56738, "Ivory Coast", 7.539989, -5.54708, "Japan", 36.204824, 138.252924, "Kenya",
                      -0.023559, 37.906193, "Malawi", -13.254308, 34.301525, "Malaysia", 4.210484, 101.975766,
                      "Martinique", 14.641528, -61.024174, "Mexico", 23.634501, -102.552784, "Morocco", 31.791702,
                      -7.09262, "Niger", 17.607789, 8.081666, "North Africa", 23.416203, 25.66283, "Pakistan",
                      30.375321, 69.345116, "Fujian (Fukien)", 24.494349, 118.41631, "Guangdong (Kwangtung)", 23.132191,
                      113.266531, "Hong Kong", 22.396428, 114.109497, "Sichuan (Szechwan)", 30.651226, 104.075881,
                      "Philippines", 12.879721, 121.774017, "Sierra Leone", 8.460555, -11.779889, "Somalia", 5.152149,
                      46.199616, "Spain", 40.463667, -3.74922, "Sri Lanka", 7.873054, 80.771797, "Taiwan", 23.69781,
                      120.960515, "Thailand", 15.870032, 100.992541, "Tunisia", 33.886917, 9.537499, "Turkey",
                      38.963745, 35.243322, "Arizona", 34.048928, -111.093731, "California", 36.778261, -119.417932,
                      "Florida", 27.664827, -81.515754, "Texas", 31.968599, -99.901813, "Zimbabwe", -19.015438,
                      29.154857
                      ]}

    strenua = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "strenua",
               "geo": ["Caribbean", 21.469114, -78.656894, "Egypt", 26.820553, 30.802498, "Honduras", 15.199999,
                       -86.241905, "Uttar Pradesh", 26.846709, 80.946159, "West Bengal", 22.986757, 87.854976,
                       "Indonesia", -0.789275, 113.921327, "Israel", 31.046051, 34.851612, "Japan", 36.204824,
                       138.252924, "Malaysia", 4.210484, 101.975766, "Fujian (Fukien)", 24.494349, 118.41631,
                       "Guangdong (Kwangtung)", 23.132191, 113.266531, "Hong Kong", 22.396428, 114.109497,
                       "Macau (Macao)", 22.204747, 113.555203, "Puerto Rico", 18.220833, -66.590149, "Spain", 40.463667,
                       -3.74922, "Taiwan", 23.69781, 120.960515, "California", 36.778261, -119.417932, "Florida",
                       27.664827, -81.515754, "South Carolina", 33.836081, -81.163724
                       ]}
               
    suzannae = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "suzannae", "geo": ["Texas",31.968599,-99.901813]}
    
    tabacivora = {"fam": "Aphelinidae", "gen": "Encarsia", "sp": "tabacivora", "geo": ["Minas Gerais",-18.512178,-44.555031,
                        "Baja California",30.840634,-115.283758, "Arizona",34.048928,-111.093731, "California",36.778261,-119.417932, "Texas",31.968599,-99.901813]}


class Eretmocerus():
    debachi = {"fam": "Aphelinidae", "gen": "Eretmocerus", "sp": "debachi", "geo": ["France", 46.227638, 2.213749
        , "Iran", 32.427908, 53.688046
        , "Israel", 31.046051, 34.851612
        , "Italy", 41.87194, 12.56738
        , "Spain", 40.463667, -3.74922
        , "Tunisia", 33.886917, 9.537499
        , "Turkey", 38.963745, 35.243322
        , "California", 36.778261, -119.417932]}

    eremicus = {"fam": "Aphelinidae", "gen": "Eretmocerus", "sp": "eremicus",
                "geo": ["Belgium", 50.503887, 4.469936, "Canary Islands", 28.291564, -16.62913, "Egypt", 26.820553,
                        30.802498, "Italy", 41.87194, 12.56738, "Mexico", 23.634501, -102.552784, "Morocco", 31.791702,
                        -7.09262, "Spain", 40.463667, -3.74922, "United Arab Emirates", 23.424076, 53.847818, "Arizona",
                        34.048928, -111.093731, "California", 36.778261, -119.417932, "Massachusetts", 42.407211,
                        -71.382437, "Texas", 31.968599, -99.901813]}

    haldemani = {"fam": "Aphelinidae", "gen": "Eretmocerus", "sp": "haldemani",
                 "geo": ["Azerbaijan", 40.143105, 47.576927
                     , "Cuba", 21.521757, -77.781167
                     , "France", 46.227638, 2.213749
                     , "Corsica", 42.039604, 9.012893
                     , "Uttar Pradesh", 26.846709, 80.946159
                     , "Peru", -9.189967, -75.015152
                     , "Ukraine", 48.379433, 31.16558
                     , "California", 36.778261, -119.417932
                     , "Florida", 27.664827, -81.515754
                     , "Illinois", 40.633125, -89.398528
                     , "Mississippi", 32.354668, -89.398528]}

    hayati = {"fam": "Aphelinidae", "gen": "Eretmocerus", "sp": "hayati", "geo": ["India", 20.593684, 78.96288
        , "Pakistan", 30.375321, 69.345116
        , "Arizona", 34.048928, -111.093731
        , "California", 36.778261, -119.417932
        , "Texas", 31.968599, -99.901813]}

    mundus = {"fam": "Aphelinidae", "gen": "Eretmocerus", "sp": "mundus", "geo": ["Queensland", -20.917574, 142.702796
        , "Bangladesh", 23.684994, 90.356331
        , "Canary Islands", 28.291564, -16.62913
        , "Cyprus", 35.126413, 33.429859
        , "Czech Republic", 49.817492, 15.472962
        , "Egypt", 26.820553, 30.802498
        , "France", 46.227638, 2.213749
        , "Georgia", 32.165622, -82.900075
        , "Germany", 51.165691, 10.451526
        , "Andhra Pradesh", 15.9129, 79.739987
        , "Bihar", 25.096074, 85.313119
        , "Karnataka", 15.317278, 75.713888
        , "Kerala", 10.850516, 76.271083
        , "Maharashtra", 19.75148, 75.713888
        , "Odisha", 20.951666, 85.098524
        , "Tamil Nadu", 11.127123, 78.656894
        , "Uttar Pradesh", 26.846709, 80.946159
        , "Iran", 32.427908, 53.688046
        , "Israel", 31.046051, 34.851612
        , "Sicily", 37.599994, 14.015356
        , "Jordan", 30.585164, 36.238414
        , "Kenya", -0.023559, 37.906193
        , "Madeira", 32.760707, -16.959472
        , "Malawi", -13.254308, 34.301525
        , "Mali", 17.570692, -3.996166
        , "Malta", 35.937496, 14.375416
        , "Mexico", 23.634501, -102.552784
        , "Micronesia", 6.887481, 158.215072
        , "Moldova", 47.411631, 28.369885
        , "Nauru", -0.522778, 166.931503
        , "Netherlands", 52.132633, 5.291266
        , "Pakistan", 30.375321, 69.345116
        , "Fujian (Fukien)", 24.494349, 118.41631
        , "Guangdong (Kwangtung)", 23.132191, 113.266531
        , "Primor'ye Kray", 45.052564, 135
        , "Spain", 40.463667, -3.74922
        , "Sudan", 12.862807, 30.217636
        , "Syria", 34.802075, 38.996815
        , "Taiwan", 23.69781, 120.960515
        , "Tunisia", 33.886917, 9.537499
        , "Turkey", 38.963745, 35.243322
        , "Turkmenistan", 38.969719, 59.556278
        , "Ukraine", 48.379433, 31.16558
        , "United Kingdom", 55.378051, -3.435973
        , "Arizona", 34.048928, -111.093731
        , "California", 36.778261, -119.417932
        , "Florida", 27.664827, -81.515754
        , "South Carolina", 33.836081, -81.163724
        , "Texas", 31.968599, -99.901813]}

    warrae = {"fam": "Aphelinidae", "gen": "Eretmocerus", "sp": "warrae",
              "geo": ["New South Wales", -31.253218, 146.921099,
                      "Queensland", -20.917574, 142.702796,
                      "South Australia", -30.000231, 136.209155,
                      "Victoria", 28.805267, -97.003598,
                      "Western Australia", -27.672817, 121.62831]}


class Megastigmus():
    atedius = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "atedius",
               "geo": ["British Columbia", 53.726668, -127.647621, "Ontario", 34.063344, -117.650888, "Czech Republic",
                       49.817492, 15.472962, "Denmark", 56.26392, 9.501785, "France", 46.227638, 2.213749, "Germany",
                       51.165691, 10.451526, "Poland", 51.919438, 19.145136, "Russia", 61.52401, 105.318756, "Sweden",
                       60.128161, 18.643501, "England", 52.355518, -1.17432, "Alaska", 64.200841, -149.493673,
                       "Arizona", 34.048928, -111.093731, "California", 36.778261, -119.417932, "Colorado", 39.550051,
                       -105.782067, "Montana", 46.879682, -110.362566, "North Carolina", 35.759573, -79.0193, "Oregon",
                       43.804133, -120.554201, "Wisconsin", 43.78444, -88.787868]}

    borriesi = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "borriesi",
                "geo": ["Denmark", 56.26392, 9.501785, "Finland", 61.92411, 25.748151, "Japan", 36.204824, 138.252924,
                        "Korea", 37.663998, 127.978458, "Russia", 61.52401, 105.318756]}

    brevicaudis = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "brevicaudis",
                   "geo": ["Czech Republic", 49.817492, 15.472962,  "Denmark",
                           56.26392, 9.501785, "Finland", 61.92411, 25.748151, "France", 46.227638, 2.213749, "Germany",
                           51.165691, 10.451526, "Netherlands", 52.132633, 5.291266, "Poland", 51.919438, 19.145136,
                           "Irkutsk Oblast", 56.132142, 103.948625, "Komi ASSR", 63.863054, 54.831269, "Moscow Oblast",
                           55.340396, 38.291765, "Sweden", 60.128161, 18.643501, "Ukraine", 48.379433, 31.16558,
                           "England", 52.355518, -1.17432, "Massachusetts", 42.407211, -71.382437, "Minnesota",
                           46.729553, -94.6859, "New York", 40.712784, -74.005941]}

    cryptomeriae = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "cryptomeriae",
                    "geo": ["Japan", 36.204824, 138.252924, "Fujian (Fukien)", 24.494349, 118.41631, "Hubei (Hupeh)",
                            30.546558, 114.341745, "Jiangxi (Kiangsi)", 28.675697, 115.909228, "Zhejiang (Chekiang)",
                            30.267443, 120.152792, "Taiwan", 23.69781, 120.960515]}

    hoffmeyeri = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "hoffmeyeri",
                  "geo": ["Ontario", 34.063344, -117.650888, "Quebec", 52.939916, -73.549136, "Finland", 61.92411,
                          25.748151, "Scotland", 56.490671, -4.202646, "Connecticut", 41.603221, -73.087749, "New York",
                          40.712784, -74.005941, "Washington", 38.907192, -77.036871
                          ]}

    hypogeus = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "hypogeus", "geo": ["Kenya", -0.023559, 37.906193]}

    likiangensis = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "likiangensis",
                    "geo": ["Yunnan", 25.045806, 102.710002]}

    nigrovariegatus = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "nigrovariegatus",
                       "geo": ["British Columbia", 53.726668, -127.647621, "Nova Scotia", 44.681987, -63.744311,
                               "Saskatchewan", 52.939916, -106.450864, "France", 46.227638, 2.213749, "Alaska",
                               64.200841, -149.493673, "Arizona", 34.048928, -111.093731, "California", 36.778261,
                               -119.417932, "Colorado", 39.550051, -105.782067, "Connecticut", 41.603221, -73.087749,
                               "Delaware", 38.910833, -75.52767, "District of Columbia", 38.907192, -77.036871, "Idaho",
                               44.068202, -114.742041, "Illinois", 40.633125, -89.398528, "Iowa", 41.878003, -93.097702,
                               "Maine", 45.253783, -69.445469, "Massachusetts", 42.407211, -71.382437, "Minnesota",
                               46.729553, -94.6859, "Nebraska", 41.492537, -99.901813, "New Hampshire", 43.193852,
                               -71.572395, "New Mexico", 34.51994, -105.87009, "New York", 40.712784, -74.005941,
                               "Ohio", 40.417287, -82.907123, "Utah", 39.32098, -111.093731, "Virginia", 37.431573,
                               -78.656894, "Washington", 38.907192, -77.036871, "Wisconsin", 43.78444, -88.787868]}

    pictus = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "pictus",
              "geo": ["Austria", 47.516231, 14.550072, "Croatia", 45.1, 15.2, "Czech Republic", 49.817492, 15.472962,
                       "Denmark", 56.26392, 9.501785, "Estonia", 58.595272,
                      25.013607, "Finland", 61.92411, 25.748151, "France", 46.227638, 2.213749, "Germany", 51.165691,
                      10.451526, "Italy", 41.87194, 12.56738, "Netherlands", 52.132633, 5.291266, "Hebei", 38.037057,
                      114.468665, "Heilongjiang (HeilungKiang)", 45.742367, 126.661665, "Jilin (Kirin)", 43.837883,
                      126.549572, "Liaoning", 41.836175, 123.431383, "Nei Menggu (Inner Mongolia)", 40.796657,
                      111.767033, "Shanxi (Shansi)", 37.873499, 112.562678, "Poland", 51.919438, 19.145136, "Romania",
                      45.943161, 24.96676, "Irkutsk Oblast", 56.132142, 103.948625, "St. Petersberg (Leningrad)",
                      59.93428, 30.335099, "Slovakia", 48.669026, 19.699024, "Sweden", 60.128161, 18.643501, "Ukraine",
                      48.379433, 31.16558, "United Kingdom", 55.378051, -3.435973
                      ]}

    pinsapinis = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "pinsapinis",
                  "geo": ["Algeria", 28.033886, 1.659626, "France", 46.227638, 2.213749, "Italy", 41.87194, 12.56738,
                          "Morocco", 31.791702, -7.09262, "Spain", 40.463667, -3.74922
                          ]}

    pistaciae = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "pistaciae",
                 "geo": ["Afghanistan", 33.93911, 67.709953, "Algeria", 28.033886, 1.659626, "Armenia", 40.069099,
                         45.038189, "Australia", -25.274398, 133.775136, "Bulgaria", 42.733883, 25.48583, "Croatia",
                         45.1, 15.2, "Cyprus", 35.126413, 33.429859, "Corsica", 42.039604, 9.012893, "Georgia",
                         32.165622, -82.900075, "Greece", 39.074208, 21.824312, "Iran", 32.427908, 53.688046, "Israel",
                         31.046051, 34.851612, "Sicily", 37.599994, 14.015356, "Kyrgyzstan",41.20438,74.766098
,
                         "Mexico", 23.634501, -102.552784, "Montenegro", 42.708678, 19.37439, "Morocco", 31.791702,
                         -7.09262, "Peoples' Republic of China", 27.72175, 85.332844, "Portugal", 39.399872, -8.224454,
                         "Russia", 61.52401, 105.318756, "Spain", 40.463667, -3.74922, "Syria", 34.802075, 38.996815,
                         "Tadzhikistan", 55.810111, 37.403991, "Tunisia", 33.886917, 9.537499, "Turkey", 38.963745,
                         35.243322, "Turkmenistan", 38.969719, 59.556278, "Ukraine", 48.379433, 31.16558, "California",
                         36.778261, -119.417932, "Uzbekistan", 41.377491, 64.585262
                         ]}

    rosae = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "rosae",
             "geo": ["Armenia", 40.069099, 45.038189, "Austria", 47.516231, 14.550072, "Azerbaijan", 40.143105,
                     47.576927, "Czech Republic", 49.817492, 15.472962,
                     "France", 46.227638, 2.213749, "Georgia", 32.165622, -82.900075, "Germany", 51.165691, 10.451526,
                     "Iran", 32.427908, 53.688046, "Kazakhstan", 48.019573, 66.923684, "Daghestan ASSR", 42.143189,
                     47.09498, "Switzerland", 46.818188, 8.227512, "Tadzhikistan", 55.810111, 37.403991,
                     "Tselinograd Obl.", 51.160523, 71.470356, "Turkey", 38.963745, 35.243322, "Turkmenistan",
                     38.969719, 59.556278, "Ukraine", 48.379433, 31.16558]}

    schimitscheki = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "schimitscheki",
                     "geo": ["Cyprus", 35.126413, 33.429859, "France", 46.227638, 2.213749, "Crete", 35.240117,
                             24.809269, "Lebanon", 33.854721, 35.862285, "Syria", 34.802075, 38.996815, "Turkey",
                             38.963745, 35.243322]}

    spermotrophus = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "spermotrophus",
                     "geo": ["Austria", 47.516231, 14.550072, "Belgium", 50.503887, 4.469936, "Alberta", 53.933271,
                             -116.576503, "British Columbia", 53.726668, -127.647621, "Croatia", 45.1, 15.2,
                             "Czech Republic", 49.817492, 15.472962, "Denmark",
                             56.26392, 9.501785, "Estonia", 58.595272, 25.013607, "Finland", 61.92411, 25.748151,
                             "France", 46.227638, 2.213749, "Germany", 51.165691, 10.451526, "Hungary", 47.162494,
                             19.503304]}

    strobilobius = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "strobilobius",
                    "geo": ["Austria", 47.516231, 14.550072, "Belgium", 50.503887, 4.469936, "Bosnia Hercegovina",
                            43.915886, 17.679076, "Bulgaria", 42.733883, 25.48583, "Czech Republic", 49.817492,
                            15.472962, "Denmark", 56.26392, 9.501785, "Estonia", 58.595272, 25.013607, "Finland",
                            61.92411, 25.748151, "France", 46.227638, 2.213749, "Germany", 51.165691, 10.451526,
                            "Greece", 39.074208, 21.824312, "Hungary", 47.162494, 19.503304, "Italy", 41.87194,
                            12.56738, "Kazakhstan", 48.019573, 66.923684, "Latvia", 56.879635, 24.603189, "Lithuania",
                            55.169438, 23.881275, "Norway", 60.472024, 8.468946, "Poland", 51.919438, 19.145136,
                            "Romania", 45.943161, 24.96676, "Altai Kray", 51.79363, 82.67586, "Arkhangel'sk Oblast",
                            63.28528, 42.588419, "Bryansk Oblast", 53.04086, 33.26909, "Irkutsk Oblast", 56.132142,
                            103.948625, "Tyumen' Oblast", 56.963439, 66.948278, "Slovakia", 48.669026, 19.699024,
                            "Sweden", 60.128161, 18.643501, "Tselinograd Obl.", 51.160523, 71.470356, "Ukraine",
                            48.379433, 31.16558, "United Kingdom", 55.378051, -3.435973
                            ]}

    suspectus = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "suspectus",
                 "geo": ["Algeria", 28.033886, 1.659626, "Austria", 47.516231, 14.550072, "Czech Republic", 49.817492,
                         15.472962, "Denmark", 56.26392, 9.501785, "Finland", 61.92411, 25.748151, "France", 46.227638,
                         2.213749, "Georgia", 32.165622, -82.900075, "Germany", 51.165691, 10.451526, "Greece",
                         39.074208, 21.824312, "Hungary", 47.162494, 19.503304, "Italy", 41.87194, 12.56738,
                         "Kazakhstan", 48.019573, 66.923684, "Montenegro", 42.708678, 19.37439, "Netherlands",
                         52.132633, 5.291266, "Poland", 51.919438, 19.145136, "Romania", 45.943161, 24.96676,
                         "Slovakia", 48.669026, 19.699024, "Slovenia", 46.151241, 14.995463, "Spain", 40.463667,
                         -3.74922, "Sweden", 60.128161, 18.643501, "Tselinograd Obl.", 51.160523, 71.470356, "Turkey",
                         38.963745, 35.243322, "Ukraine", 48.379433, 31.16558, "United Kingdom", 55.378051, -3.435973]}

    transvaalensis = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "transvaalensis",
                      "geo": ["Argentina", -38.416097, -63.616672, "Brazil", -14.235004, -51.92528, "Canary Islands",
                              28.291564, -16.62913, "France", 46.227638, 2.213749, "Hawaii", 19.896766, -155.582782,
                              "Israel", 31.046051, 34.851612, "Kenya", -0.023559, 37.906193, "Mexico", 23.634501,
                              -102.552784, "Morocco", 31.791702, -7.09262, "Portugal", 39.399872, -8.224454, "Reunion",
                              -21.115141, 55.536384, "South Africa", -30.559482, 22.937506, "California", 36.778261,
                              -119.417932, "Florida", 27.664827, -81.515754, "Zimbabwe", -19.015438, 29.154857]}

    tsugae = {"fam": "Torymidae", "gen": "Megastigmus", "sp": "tsugae",
              "geo": ["British Columbia", 53.726668, -127.647621, "Oregon", 43.804133, -120.554201, "Washington",
                      38.907192, -77.036871]}

class Torymus(): 
    
    arundinis = {"fam": "Torymidae", "gen": "Torymus", "sp": "arundinis","geo": ["Croatia",45.1,15.2,"Czech Republic",49.817492,15.472962,"France",46.227638,2.213749,"Georgia",32.165622,-82.900075,"Germany",51.165691,10.451526,"Hungary",47.162494,19.503304,"Moldova",47.411631,28.369885,"Netherlands",52.132633,5.291266,"Poland",51.919438,19.145136,"Romania",45.943161,24.96676,"Sakhalin Oblast",49.980785,143.373813,"Slovakia",48.669026,19.699024,"Sweden",60.128161,18.643501,"Switzerland",46.818188,8.227512,"Ukraine",48.379433,31.16558,"England",52.355518,-1.17432]}
    
    bedeguaris ={"fam": "Torymidae", "gen": "Torymus", "sp": "bedeguaris","geo": ["Andorra",42.506285,1.521801,"Armenia",40.069099,45.038189,"Austria",47.516231,14.550072,"Azerbaijan",40.143105,47.576927,"Belgium",50.503887,4.469936,"Bulgaria",42.733883,25.48583,"Alberta",53.933271,-116.576503,"British Columbia",53.726668,-127.647621,"Ontario",34.063344,-117.650888,"Quebec",52.939916,-73.549136,"Croatia",45.1,15.2,"Czech Republic",49.817492,15.472962,"Denmark",56.26392,9.501785,"France",46.227638,2.213749,"Georgia",32.165622,-82.900075,"Germany",51.165691,10.451526,"Greece",39.074208,21.824312,"Hungary",47.162494,19.503304,"Iran",32.427908,53.688046,"Italy",41.87194,12.56738,"Kazakhstan",48.019573,66.923684,"Kyrgyzstan",41.20438,74.766098,"Moldova",47.411631,28.369885,"Netherlands",52.132633,5.291266,"Romania",45.943161,24.96676,"Adygey AO (Adigei)",44.822916,40.175446,"Daghestan ASSR",42.143189,47.09498,"Moscow Oblast",55.340396,38.291765,"Rostov Oblast",47.685325,41.825895,"Ul'yanovsk Oblast",53.979336,47.776243,"Serbia",44.016521,21.005859,"Slovakia",48.669026,19.699024,"Spain",40.463667,-3.74922,"Sweden",60.128161,18.643501,"Switzerland",46.818188,8.227512,"Tadzhikistan",55.810111,37.403991,"Tselinograd Obl.",51.160523,71.470356,"Turkey",38.963745,35.243322,"Turkmenistan",38.969719,59.556278,"Ukraine",48.379433,31.16558,"England",52.355518,-1.17432,"Arizona",34.048928,-111.093731,"California",36.778261,-119.417932,"Colorado",39.550051,-105.782067,"Illinois",40.633125,-89.398528,"Iowa",41.878003,-93.097702,"Nebraska",41.492537,-99.901813,"Nevada",38.80261,-116.419389,"New Jersey",40.058324,-74.405661,"Oregon",43.804133,-120.554201,"Utah",39.32098,-111.093731,"Washington",38.907192,-77.036871
]} 
    
    impar = {"fam": "Torymidae", "gen": "Torymus", "sp": "impar","geo": ["Azerbaijan",40.143105,47.576927,"Denmark",56.26392,9.501785,"Finland",61.92411,25.748151,"Georgia",32.165622,-82.900075,"Germany",51.165691,10.451526,"Hungary",47.162494,19.503304,"Italy",41.87194,12.56738,"Kazakhstan",48.019573,66.923684,"Netherlands",52.132633,5.291266,"Poland",51.919438,19.145136,"Sweden",60.128161,18.643501,"Tselinograd Obl.",51.160523,71.470356,"Turkmenistan",38.969719,59.556278,"Ukraine",48.379433,31.16558,"England",52.355518,-1.17432,"Scotland",56.490671,-4.202646
]} 
    
class Megaphragma():
    
    amalphitanum ={"fam": "Trichogrammatidae", "gen": "Megaphragma", "sp": "amalphitanum","geo": ["France",46.227638,2.213749,"Italy",41.87194,12.56738,"Portugal",39.399872,-8.224454]} 
    
    mymaripenne = {"fam": "Trichogrammatidae", "gen": "Megaphragma", "sp": "mymaripenne","geo": ["Argentina",-38.416097,-63.616672,"Chile",-35.675147,-71.542969,"Guadeloupe",16.265,-61.551,"Haiti",18.971187,-72.285215,"Hawaii",19.896766,-155.582782,"Sicily",37.599994,14.015356,"California",36.778261,-119.417932,"Louisiana",30.984298,-91.962333]} 
    
class Trichogramma():
    
    alpha = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "alpha","geo": ["Manitoba",53.760861,-98.813876,"Ontario",34.063344,-117.650888,"Prince Edward Island",46.510712,-63.416814,"Quebec",52.939916,-73.549136,"California",36.778261,-119.417932,"District of Columbia",38.907192,-77.036871,"Missouri",37.964253,-91.831833,"Nebraska",41.492537,-99.901813,"Washington",38.907192,-77.036871]} 
    
    atopovirilla = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "atopovirilla","geo": ["Minas Gerais",-18.512178,-44.555031,"Parana",-25.252089,-52.021542,"Pernambuco",-8.813717,-36.954107,"Sao Paulo",-23.55052,-46.633309,"Caribbean (including West Indies)",21.469114,-78.656894,"Colombia",4.570868,-74.297333,"El Salvador",13.794185,-88.89653,"Guatemala",15.783471,-90.230759,"Honduras",15.199999,-86.241905,"Mexico",23.634501,-102.552784,"Texas",31.968599,-99.901813,"Venezuela",6.42375,-66.58973]}
    
    aurosum = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "aurosum","geo": ["Bulgaria",42.733883,25.48583,"Alberta",53.933271,-116.576503,"British Columbia",53.726668,-127.647621,"Ontario",34.063344,-117.650888,"Quebec",52.939916,-73.549136,"Altai Kray",51.79363,82.67586,"Chita Oblast (=Chitinskaya)",52.051503,113.471191,"Alaska",64.200841,-149.493673,"Arizona",34.048928,-111.093731,"California",36.778261,-119.417932,"Illinois",40.633125,-89.398528,"Maryland",39.045755,-76.641271,"Michigan",44.314844,-85.602364,"Montana",46.879682,-110.362566,"New Hampshire",43.193852,-71.572395,"South Dakota",43.969515,-99.901813,"Washington",38.907192,-77.036871,"Wyoming",43.075968,-107.290284]} 
    
    australicum = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "australicum","geo": ["Queensland",-20.917574,142.702796,"Western Australia",-27.672817,121.62831,"Bahamas",25.03428,-77.39628,"Barbados",13.193887,-59.543198,"Bolivia",-16.290154,-63.588653,"Brazil",-14.235004,-51.92528,"Colombia",4.570868,-74.297333,"Grenada",12.1165,-61.679,"Hawaii",19.896766,-155.582782,"Andhra Pradesh",15.9129,79.739987,"Delhi",28.613939,77.209021,"Gujarat",22.258652,71.192381,"Karnataka",15.317278,75.713888,"Maharashtra",19.75148,75.713888,"Punjab",31.170406,72.709716,"Tamil Nadu",11.127123,78.656894,"Uttar Pradesh",26.846709,80.946159,"West Bengal",22.986757,87.854976,"Java",-7.614529,110.712246,"Bali",-8.409518,115.188916,"Japan",36.204824,138.252924,"Madagascar",-18.766947,46.869107,"Malaysia",4.210484,101.975766,"Mauritania",21.00789,-10.940835,"Mauritius",-20.348404,57.552152,"Montserrat",16.742498,-62.187366,"Pakistan",30.375321,69.345116,"Guangdong (Kwangtung)",23.132191,113.266531,"Peru",-9.189967,-75.015152,"Philippines",12.879721,121.774017,"Puerto Rico",18.220833,-66.590149,"Reunion",-21.115141,55.536384,"Sri Lanka",7.873054,80.771797,"Taiwan",23.69781,120.960515,"Thailand",15.870032,100.992541,"Trinidad & Tobago",10.691803,-61.222503,"Venezuela",6.42375,-66.58973]} 
    
    bezdencovii = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "bezdencovii","geo": ["Armenia",40.069099,45.038189,"Belarus",53.709807,27.953389,"Bulgaria",42.733883,25.48583,"Chile",-35.675147,-71.542969,"Voronezh Oblast",50.858971,39.864438,"Ukraine",48.379433,31.16558]}
    
    bourarachae = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "bourarachae","geo": ["Morocco",31.791702,-7.09262,"Portugal",39.399872,-8.224454,"Tunisia",33.886917,9.537499]} 
    
    cacoeciae = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "cacoeciae","geo": ["Argentina",-38.416097,-63.616672,"Austria",47.516231,14.550072,"Belarus",53.709807,27.953389,"Bulgaria",42.733883,25.48583,"Cuba",21.521757,-77.781167,"Denmark",56.26392,9.501785,"Estonia",58.595272,25.013607,"France",46.227638,2.213749,"Germany",51.165691,10.451526,"Greece",39.074208,21.824312,"Iran",32.427908,53.688046,"Italy",41.87194,12.56738,"Kazakhstan",48.019573,66.923684,"Kyrgyzstan",41.20438,74.766098,"Latvia",56.879635,24.603189,"Lithuania",55.169438,23.881275,"Moldova",47.411631,28.369885,"Morocco",31.791702,-7.09262,"Netherlands",52.132633,5.291266,"Guangdong (Kwangtung)",23.132191,113.266531,"Peru",-9.189967,-75.015152,"Poland",51.919438,19.145136,"Portugal",39.399872,-8.224454,"Adygey AO (Adigei)",44.822916,40.175446,"Altai Kray",51.79363,82.67586,"Amur Oblast",54.603506,127.480172,"Kaliningrad Oblast",54.823529,21.481616,"Voronezh Oblast",50.858971,39.864438,"Spain",40.463667,-3.74922,"Switzerland",46.818188,8.227512,"Syria",34.802075,38.996815,"Tselinograd Obl.",51.160523,71.470356,"Tunisia",33.886917,9.537499,"Turkey",38.963745,35.243322,"Ukraine",48.379433,31.16558,"England",52.355518,-1.17432,"California",36.778261,-119.417932,"Indiana",40.267194,-86.134902,"Washington",38.907192,-77.036871,"Uzbekistan",41.377491,64.585262]} 
    
    closterae = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "closterae","geo": ["Anhui (Anhwei)",31.861121,117.284903,"Beijing (Peking)",39.904211,116.407395,"Hubei (Hupeh)",30.546558,114.341745,"Liaoning",41.836175,123.431383,"Shandong (Shantung)",36.66853,117.020359,"Zhejiang (Chekiang)",30.267443,120.152792]} 
    
    cordubensis = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "cordubensis","geo": ["Azores",37.741249,-25.675594,"Iran",32.427908,53.688046,"Madeira",32.760707,-16.959472,"Portugal",39.399872,-8.224454,"Spain",40.463667,-3.74922]} 
    
    dianae = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "dianae","geo": ["Florida",27.664827,-81.515754,"Georgia",32.165622,-82.900075,"Maryland",39.045755,-76.641271,"Missouri",37.964253,-91.831833,"South Carolina",33.836081,-81.163724,"Virginia",37.431573,-78.656894]}
    
    flavum = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "flavum","geo": ["Hebei",38.037057,114.468665,"Florida",27.664827,-81.515754]}
    
    lasallei = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "lasallei","geo": ["Bolivia",-16.290154,-63.588653,"Parana",-25.252089,-52.021542,"Sao Paulo",-23.55052,-46.633309,"British Virgin Islands",18.420695,-64.639968,"Costa Rica",9.748917,-83.753428,"Cuba",21.521757,-77.781167,"Mexico",23.634501,-102.552784,"Florida",27.664827,-81.515754,"Uruguay",-32.522779,-55.765835,"US Virgin Islands",18.335765,-64.896335,"Venezuela",6.42375,-66.58973,"Virgin Islands",18.335765,-64.896335]}
    
    lopezandinensis = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "lopezandinensis","geo": ["Colombia",4.570868,-74.297333]}
    
    nerudai = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "nerudai","geo": ["Argentina",-38.416097,-63.616672,"Chile",-35.675147,-71.542969]} 
    
    nubilale = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "nubilale","geo": ["Guangdong (Kwangtung)",23.132191,113.266531,"Alabama",32.318231,-86.902298,"Delaware",38.910833,-75.52767,"Florida",27.664827,-81.515754,"Iowa",41.878003,-93.097702,"Massachusetts",42.407211,-71.382437,"Minnesota",46.729553,-94.6859,"Missouri",37.964253,-91.831833,"North Carolina",35.759573,-79.0193,"Pennsylvania",41.203322,-77.194525,"Texas",31.968599,-99.901813]} 
    
    oleae = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "oleae","geo": ["Argentina",-38.416097,-63.616672,"France",46.227638,2.213749,"Greece",39.074208,21.824312,"Italy",41.87194,12.56738]} 
    
    ostriniae = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "ostriniae","geo": ["Japan",36.204824,138.252924,"Korea, South",37.663998,127.978458,"Anhui (Anhwei)",31.861121,117.284903,"Beijing (Peking)",39.904211,116.407395,"Guangdong (Kwangtung)",23.132191,113.266531,"Heilongjiang (HeilungKiang)",45.742367,126.661665,"Henan (Honan)",34.765515,113.753602,"Hubei (Hupeh)",30.546558,114.341745,"Jiangsu (Kiangsu)",32.061707,118.763232,"Jilin (Kirin)",43.837883,126.549572,"Liaoning",41.836175,123.431383,"Shandong (Shantung)",36.66853,117.020359,"Shanxi (Shansi)",37.873499,112.562678,"Zhejiang (Chekiang)",30.267443,120.152792,"South Africa",-30.559482,22.937506,"Kentucky",37.839333,-84.270018,"Massachusetts",42.407211,-71.382437,"New York",40.712784,-74.005941]} 
    
    pratti = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "pratti","geo": ["California",36.778261,-119.417932]} 
    
    sathon = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "sathon","geo": ["Mexico",23.634501,-102.552784,"Arizona",34.048928,-111.093731,"California",36.778261,-119.417932,"New Mexico",34.51994,-105.87009,"Texas",31.968599,-99.901813]} 
    
    semblidis = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "semblidis","geo": ["Bulgaria",42.733883,25.48583,"Manitoba",53.760861,-98.813876,"Ontario",34.063344,-117.650888,"Saskatchewan",52.939916,-106.450864,"France",46.227638,2.213749,"Germany",51.165691,10.451526,"Hungary",47.162494,19.503304,"Karnataka",15.317278,75.713888,"Iran",32.427908,53.688046,"Italy",41.87194,12.56738,"Kazakhstan",48.019573,66.923684,"Netherlands",52.132633,5.291266,"Norway",60.472024,8.468946,"Poland",51.919438,19.145136,"Nizhniy Novgorod Oblast",55.799516,44.029677,"St. Petersberg (Leningrad)",59.93428,30.335099,"Tomsk Oblast",58.896988,82.67655,"Spain",40.463667,-3.74922,"Sweden",60.128161,18.643501,"Switzerland",46.818188,8.227512,"Syria",34.802075,38.996815,"Tselinograd Obl.",51.160523,71.470356,"Ukraine",48.379433,31.16558,"England",52.355518,-1.17432,"Alaska",64.200841,-149.493673,"Georgia",32.165622,-82.900075,"Idaho",44.068202,-114.742041,"Kansas",39.011902,-98.484246,"Michigan",44.314844,-85.602364,"Minnesota",46.729553,-94.6859,"New York",40.712784,-74.005941,"Oregon",43.804133,-120.554201]} 
    
    sibericum = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "sibericum","geo": ["British Columbia",53.726668,-127.647621,"Chita Oblast (=Chitinskaya)",52.051503,113.471191,"California",36.778261,-119.417932,"Washington",38.907192,-77.036871]} 
    
    tshumakovae = {"fam": "Trichogrammatidae", "gen": "Trichogramma", "sp": "tshumakovae","geo": ["Iran",32.427908,53.688046,"Kyrgyzstan",41.20438,74.766098]}
    
class Trichogrammatoidea():
    
    armigera = {"fam": "Trichogrammatidae", "gen": "Trichogrammatoidea", "sp": "armigera","geo": ["Antigua",17.074656,-61.817521,"Antilles",33.480284,-117.703701,"Barbados",13.193887,-59.543198,"Cape Verde Islands",16,-24,"Colombia",4.570868,-74.297333,"Dominica",15.414999,-61.370976,"Grenada",12.1165,-61.679,"Karnataka",15.317278,75.713888,"West Bengal",22.986757,87.854976,"Java",-7.614529,110.712246,"Bali",-8.409518,115.188916,"Kenya",-0.023559,37.906193,"Hainan",20.017378,110.349229,"Peru",-9.189967,-75.015152,"Philippines",12.879721,121.774017,"Saint Lucia",13.909444,-60.978893,"South Africa",-30.559482,22.937506,"Saint Kitts",17.34338,-62.755904,"St Helena",38.505243,-122.470387,"St Vincent & Grenadines",13.252818,-61.197163,"Trinidad & Tobago",10.691803,-61.222503]}
    
    bactrae = {"fam": "Trichogrammatidae", "gen": "Trichogrammatoidea", "sp": "bactrae","geo": ["Argentina",-38.416097,-63.616672,"Northern Territory",-19.491411,132.55096,"Queensland",-20.917574,142.702796,"Western Australia",-27.672817,121.62831,"Barbados",13.193887,-59.543198,"Egypt",26.820553,30.802498,"Bihar",25.096074,85.313119,"Karnataka",15.317278,75.713888,"Tamil Nadu",11.127123,78.656894,"West Bengal",22.986757,87.854976,"Java",-7.614529,110.712246,"Bali",-8.409518,115.188916,"Malaysia",4.210484,101.975766,"New Caledonia",-20.904305,165.618042,"New Zealand",-40.900557,174.885971,"Pakistan",30.375321,69.345116,"Hainan",20.017378,110.349229,"Philippines",12.879721,121.774017,"Taiwan",23.69781,120.960515,"Thailand",15.870032,100.992541,"Arizona",34.048928,-111.093731,"California",36.778261,-119.417932]} 
    

list_species = [Aphelinus.abdominalis, Aphelinus.albipodus, Aphelinus.asychis, Aphelinus.certus, Aphelinus.chaonia,
                Aphelinus.glycinis, Aphelinus.gossypii, Aphelinus.mali, Aphelinus.paramali,
                Aphelinus.rhamni, Aphelinus.semiflavus, Aphelinus.varipes, Aphytis.acrenulatus, Aphytis.acutaspidis,  Aphytis.africanus,
                Aphytis.amazonensis, Aphytis.anneckei, Aphytis. anomalus, Aphytis.antennalis,
                Aphytis.aonidiae, Aphytis.capensis, Aphytis.cercinus, Aphytis.chilensis, Aphytis.chrysomphali,
                Aphytis.coheni, Aphytis.columbi, Aphytis.comperei,
                Aphytis.confusus, Aphytis.costalimai,
                Aphytis.cylindratus, Aphytis.debachi, Aphytis.desantisi, Aphytis.equatorialis, Aphytis.faurei, Aphytis.fioriniae,  Aphytis.fisheri, Aphytis.griseus, Aphytis.haywardi, Aphytis.holoxanthus, Aphytis.hyalinipennis,
                Aphytis.immaculatus, Aphytis.japonicus,
                Aphytis.lepidosaphes, Aphytis.libanicus, Aphytis.lingnanensis, Aphytis.luteus, Aphytis.margaretae, Aphytis.mazalae,
                Aphytis.melinus, Aphytis.merceti, Aphytis.moldavicus, Aphytis.mytilaspidis, Aphytis.notialis, Aphytis.obscurus, Aphytis.opuntiae,
                Aphytis.paramaculicornis, Aphytis.philippinensis, Aphytis.phoenicis, Aphytis.pinnaspidis,
                Aphytis.sensorius, Aphytis.taylori, Aphytis.testaceus,
                Aphytis.tucumani, Aphytis.vandenboschi, Aphytis.vastus, Aphytis.wallumbillae, Aphytis.yanonensis, Aphytis.yasumatsui, Encarsia.bimaculata, Encarsia.cibcensis, Encarsia.citrina,
                Encarsia.formosa, Encarsia.gennaroi, Encarsia.guadaloupae, Encarsia.haitensis,
                Encarsia.hispida, Encarsia.luteola, Encarsia.meritoria, Encarsia.oakeyensis, Encarsia.protransvena,
                Encarsia.smithi, Encarsia.sophia, Encarsia.strenua, Encarsia.suzannae, Encarsia.tabacivora, Eretmocerus.debachi, Eretmocerus.eremicus,
                Eretmocerus.haldemani,
                Eretmocerus.hayati, Eretmocerus.mundus, Eretmocerus.warrae, Megastigmus.atedius, Megastigmus.borriesi,
                Megastigmus.brevicaudis, Megastigmus.cryptomeriae, Megastigmus.hoffmeyeri, Megastigmus.hypogeus,
                Megastigmus.likiangensis, Megastigmus.nigrovariegatus, Megastigmus.pictus, Megastigmus.pinsapinis,
                Megastigmus.pistaciae, Megastigmus.rosae, Megastigmus.schimitscheki, Megastigmus.spermotrophus,
                Megastigmus.strobilobius, Megastigmus.suspectus, Megastigmus.transvaalensis, Megastigmus.tsugae, Torymus.arundinis, Torymus.bedeguaris, Torymus.impar, Megaphragma.amalphitanum, Megaphragma.mymaripenne, Trichogramma.alpha, Trichogramma.atopovirilla, Trichogramma.aurosum, Trichogramma.australicum, Trichogramma.bezdencovii, Trichogramma.bourarachae, Trichogramma.cacoeciae, Trichogramma.closterae, Trichogramma.cordubensis, Trichogramma.dianae, Trichogramma.flavum, Trichogramma.lasallei, Trichogramma.lopezandinensis, Trichogramma.nerudai, Trichogramma.nubilale, Trichogramma.oleae, Trichogramma.ostriniae, Trichogramma.pratti, Trichogramma.sathon, Trichogramma.semblidis, Trichogramma.sibericum, Trichogramma.tshumakovae, Trichogrammatoidea.armigera, Trichogrammatoidea.bactrae]


def mean(mylist):
    return sum(mylist) / len(mylist)


def median(mylist):
    if len(mylist) % 2 != 0:
        return sorted(mylist)[len(mylist) / 2]
    else:
        midavg = (sorted(mylist)[len(mylist) / 2] + sorted(mylist)[len(mylist) / 2 - 1]) / 2.0
        return midavg


def dist_area(sp, one_sp=True):
    """
    Computes the range of latitude/longitude for a given species, as well as the number of locations where it was found.
    """
    coord = []
    lat = []
    lon = []
    for i in range(len(sp["geo"])):
        if not isinstance(sp["geo"][i], str):
            coord.append(sp["geo"][i])
    for j in range(len(coord)):
        if j % 2 == 0:
            lat.append(coord[j])
        else:
            lon.append(coord[j])
    if one_sp:
        print("=" * 43 + "\n" + sp["gen"] + " " + sp["sp"])
        print("Lower coordinates are: lat,lon: '" + str(int(round(min(lat)))) + "," + str(int(round(min(lon)))))
        print("Upper coordinates are: lat,lon: " + str(int(round(max(lat)))) + "," + str(int(round(max(lon)))))
        print("Mean coordinates are: lat,lon: " + str(int(round(mean(lat)))) + "," +
              str(int(round(mean(lon)))))
        print("Median coordinates are: lat,lon: " + str(int(round(median(lat)))) + "," +
              str(int(round(median(lon)))))
        print("Number of countries: " + str(len(sp["geo"]) / 3) + "\n" + "=" * 43)
    else:
        return [int(round(min(lat))), int(round(min(lon))), int(round(max(lat))), int(round(max(lon))),
                int(round(mean(lat))), int(round(mean(lon))), int(round(median(lat))), int(round(median(lon)))]


def out_loc_num(ls=list_species, extremes=False):
    """
    The argument should be a list of of species dictionnaries. Output is csv.
    """
    a = open(os.getcwd() + "/places.txt", 'w')
    if not extremes:
        for i in ls:
            a.write(str(i["gen"]) + " " + str(i["sp"]) + "," + str(len(i["geo"]) / 3) + "\n")
    else:
        for k in ls:
            a.write(str(k["gen"]) + " " + str(k["sp"]) + "," + 
                    str(dist_area(k, one_sp=False)[0]) + ";" + 
                    str(dist_area(k, one_sp=False)[1]) + "," + 
                    str(dist_area(k, one_sp=False)[2]) + ";" + 
                    str(dist_area(k, one_sp=False)[3]) + "," + 
                    str(dist_area(k, one_sp=False)[4]) + ";" +
                    str(dist_area(k, one_sp=False)[5]) + "," +
                    str(dist_area(k, one_sp=False)[6]) + ";" +
                    str(dist_area(k, one_sp=False)[7]) + "," +
                    str(len(k["geo"]) / 3) + "\n")
    a.close()


def out_coord_list(sp, path=os.getcwd()):
    """
    Generates a csv file with the species name, containing all the coordinates points at which it was retrieved.
    """
    a = open(path + "/" + str(sp["gen"]) + "." + str(sp["sp"] + ".txt"), 'w')
    for i in range(0, len(sp["geo"]), 3):
        a.write(str(sp["geo"][i]) + "," + str(sp["geo"][i + 1]) + "," + str(sp["geo"][i + 2]) + "\n")
    a.close()


def sp_range():
    """
    interactive tool to enter species name and extract its min/max coordinates in the console.
    """
    use = True
    while use:
        try:
            print("Enter 0 to stop the program.")
            a = input("Enter species as Genus.species:")
            if a == 0:
                use = False
                print("Goodbye! You can use sp_coord() if you want to get coordinates again.")
            else:
                dist_area(a)
        except NameError:
            print("Species not found, try again.")
        except ValueError:
            print("An error occurred, try again.")


Hi = True
while Hi:
    print("Choose an option:")
    print("1 = Extract min and max latitude and longitude from a species name\n"
          "2 = Generate a txt file containing the species names and the number of places at which they have been "
          "sampled."
          "file.\n3 = Generate a csv file containing the list of coordinates corresponding to an input species.\n"
          "4 = Quit")
    try:
        user_in = raw_input("> ")
        if user_in == "1":
            sp_range()
        elif user_in == "2":
            print("Do you wish to include extreme coordinates as well ?\n1 = yes\n2 = no")
            user_ext = raw_input(">")
            if user_ext == "1":
                out_loc_num(list_species, extremes=True)
            elif user_ext == "2":
                out_loc_num()
            else:
                continue
            print("-" * 43 + "\nFile generated, go and check target folder\n" + "-" * 43)
        elif user_in == "3":
            print(
                "Do you want to select a single species, or to generate one file per species ?\n1 = One species only\n"
                "ALL = All species (Creates many files!)")
            file_number = raw_input(">")
            if file_number == "1":
                print("What species do you want to generate a csv from ? Please enter species as: 'G_species'.")
                user_species = input("> ")
                out_coord_list(user_species)
            elif file_number == "ALL":
                new_folder = os.getcwd() + "/species"
                os.mkdir(new_folder)
                for i in range(len(list_species)):
                    out_coord_list(list_species[i], path=new_folder)
            else:
                continue
            print("-" * 43 + "\nFile generated, go and check target folder\n" + "-" * 43)
        elif user_in == "4":
            break
        else:
            continue
    except TypeError:
        print("Wrong type of value entered, try again.")
    except NameError:
        print("Couldn't find input species, try again.")
    except AttributeError:
        print("This genus has no such species.")
