#!/bin/env ruby
# encoding: utf-8

# @author Arvind Vyas

module CountryStateSelect
  module Constant

    # array containing all the countries name in alphabetical order
    COUNTRIES = ["Afghanistan", "Aland Islands", "Albania", "Algeria", "American Samoa", "Andorra", "Angola",
                 "Anguilla", "Antarctica", "Antigua And Barbuda", "Argentina", "Armenia", "Aruba", "Australia", "Austria",
                 "Azerbaijan", "Bahamas", "Bahrain", "Bangladesh", "Barbados", "Belarus", "Belgium", "Belize", "Benin",
                 "Bermuda", "Bhutan", "Bolivia, Plurinational State of", "Bonaire, Sint Eustatius and Saba", "Bosnia and Herzegovina",
                 "Botswana", "Bouvet Island", "Brazil", "British Indian Ocean Territory", "Brunei Darussalam", "Bulgaria", "Burkina Faso", "Burundi", "Cambodia",
                 "Cameroon", "Canada", "Cape Verde", "Cayman Islands", "Central African Republic", "Chad", "Chile", "China",
                 "Christmas Island", "Cocos (Keeling) Islands", "Colombia", "Comoros", "Congo", "Congo, the Democratic Republic of the", "Cook Islands", "Costa Rica", "Cote d'Ivoire", "Croatia", "Cuba",
                 "Cyprus", "Czech Republic", "Denmark", "Djibouti", "Dominica", "Dominican Republic", "Ecuador", "Egypt", "El Salvador", "Equatorial Guinea", "Eritrea", "Estonia", "Ethiopia", "Falkland Islands (Malvinas)", "Faroe Islands", "Fiji", "Finland", "France", "French Guiana", "French Polynesia", "French Southern Territories", "Gabon", "Gambia", "Georgia", "Germany", "Ghana", "Gibraltar", "Greece",
                 "Greenland", "Grenada", "Guadeloupe", "Guam", "Guatemala", "Guernsey", "Guinea", "Guinea-Bissau", "Guyana", "Haiti", "Heard Island and McDonald Islands", "Holy See (Vatican City State)",
                 "Honduras", "Hong Kong", "Hungary", "Iceland", "India", "Indonesia", "Iran, Islamic Republic of", "Iraq",
                 "Ireland", "Isle of Man", "Israel", "Italy", "Jamaica", "Japan", "Jersey", "Jordan", "Kazakhstan", "Kenya",
                 "Kiribati", "Korea, Democratic People's Republic of", "Korea, Republic of", "Kuwait", "Kyrgyzstan",
                 "Lao People's Democratic Republic", "Latvia", "Lebanon", "Lesotho", "Liberia", "Libya",
                 "Liechtenstein", "Lithuania", "Luxembourg", "Macao", "Macedonia, The Former Yugoslav Republic Of",
                 "Madagascar", "Malawi", "Malaysia", "Maldives", "Mali", "Malta", "Marshall Islands", "Martinique",
                 "Mauritania", "Mauritius", "Mayotte", "Mexico", "Micronesia, Federated States of", "Moldova, Republic of",
                 "Monaco", "Mongolia", "Montenegro", "Montserrat", "Morocco", "Mozambique", "Myanmar", "Namibia", "Nauru",
                 "Nepal", "Netherlands", "New Caledonia", "New Zealand", "Nicaragua", "Niger", "Nigeria", "Niue", "Norfolk Island", "Northern Mariana Islands", "Norway", "Oman", "Pakistan", "Palau",
                 "Palestinian Territory, Occupied", "Panama", "Papua New Guinea", "Paraguay", "Peru", "Philippines",
                 "Pitcairn", "Poland", "Portugal", "Puerto Rico", "Qatar", "Reunion", "Romania", "Russian Federation",
                 "Rwanda", "Saint Barthelemy", "Saint Helena, Ascension and Tristan da Cunha", "Saint Kitts and Nevis", "Saint Lucia",
                 "Saint Martin (French Part)", "Saint Pierre and Miquelon", "Saint Vincent and the Grenadines", "Samoa", "San Marino",
                 "Sao Tome and Principe", "Saudi Arabia", "Senegal", "Serbia", "Seychelles", "Sierra Leone", "Singapore",
                 "Sint Maarten (Dutch Part)", "Slovakia", "Slovenia", "Solomon Islands", "Somalia", "South Africa",
                 "South Georgia and the South Sandwich Islands", "South Sudan", "Spain", "Sri Lanka", "Sudan", "Suriname",
                 "Svalbard and Jan Mayen", "Swaziland", "Sweden", "Switzerland", "Syrian Arab Republic",
                 "Taiwan, Province of China", "Tajikistan", "Tanzania, United Republic of", "Thailand", "Timor-Leste",
                 "Togo", "Tokelau", "Tonga", "Trinidad and Tobago", "Tunisia", "Turkey", "Turkmenistan",
                 "Turks and Caicos Islands", "Tuvalu", "Uganda", "Ukraine", "United Arab Emirates", "United Kingdom",
                 "United States", "United States Minor Outlying Islands", "Uruguay", "Uzbekistan", "Vanuatu",
                 "Venezuela, Bolivarian Republic of", "Viet Nam", "Virgin Islands, British", "Virgin Islands, U.S.",
                 "Wallis and Futuna", "Western Sahara", "Yemen", "Zambia", "Zimbabwe"].sort

    #array containing all the Indian states except Indian Territory
    INDIAN_STATES = [["Andhra Pradesh", "AP"], ["Arunachal Pradesh", "AR"], ["Assam", "AS"], ["Bihar", "BR"],
                     ["Chhattisgarh", "CT"], ["Goa", "GA"], ["Gujarat", "GJ"], ["Haryana", "HR"],
                     ["Himachal Pradesh", "HP"], ["Jammu & Kashmir", "JK"], ["Jharkhand", "JH"], ["Karnataka", "KA"],
                     ["Kerala", "KL"], ["Madhya Pradesh", "MP"], ["Maharashtra", "MH"], ["Manipur", "MN"],
                     ["Meghalaya", "ML"], ["Mizoram", "MZ"], ["Nagaland", "NL"], ["Odisha", "OR"], ["Punjab", "PB"],
                     ["Rajasthan", "RJ"], ["Sikkim", "SK"], ["Tamil Nadu", "TN"], ["Tripura", "TR"], ["Uttarakhand", "UK"],
                     ["Uttar Pradesh", "UP"], ["West Bengal", "WB"]].sort

    #array containing all the Indian Territory
    INDIAN_TERRIOTORY = [["Andaman & Nicobar", "AN"], ["Chandigarh", "CH"], ["Dadra and Nagar Haveli", "DN"],
                         ["Daman & Diu", "DD"], ["Delhi", "DL"], ["Lakshadweep", "LD"], ["Puducherry", "PY"]].sort


    #array containing us states
    USA_STATES =[["Alabama", "AL"], ["Alaska", "AK"], ["Arizona", "AZ"], ["Arkansas", "AR"], ["California", "CA"],
                 ["Colorado", "CO"], ["Connecticut", "CT"], ["Delaware", "DE"], ["District Of Columbia", "DC"],
                 ["Florida", "FL"], ["Georgia", "GA"], ["Hawaii", "HI"], ["Idaho", "ID"], ["Illinois", "IL"],
                 ["Indiana", "IN"], ["Iowa", "IA"], ["Kansas", "KS"], ["Kentucky", "KY"], ["Louisiana", "LA"],
                 ["Maine", "ME"], ["Maryland", "MD"], ["Massachusetts", "MA"], ["Michigan", "MI"], ["Minnesota", "MN"],
                 ["Mississippi", "MS"], ["Missouri", "MO"], ["Montana", "MT"], ["Nebraska", "NE"], ["Nevada", "NV"],
                 ["New Hampshire", "NH"], ["New Jersey", "NJ"], ["New Mexico", "NM"], ["New York", "NY"],
                 ["North Carolina", "NC"], ["North Dakota", "ND"], ["Ohio", "OH"], ["Oklahoma", "OK"], ["Oregon", "OR"],
                 ["Pennsylvania", "PA"], ["Rhode Island", "RI"], ["South Carolina", "SC"], ["South Dakota", "SD"],
                 ["Tennessee", "TN"], ["Texas", "TX"], ["Utah", "UT"], ["Vermont", "VT"], ["Virginia", "VA"],
                 ["Washington", "WA"], ["West Virginia", "WV"], ["Wisconsin", "WI"], ["Wyoming", "WY"]].sort

    #array containing Canadian states
    CANADIAN_STATES = [["British Columbia", "BC"], ["Ontario", "ON"], ["Newfoundland and Labrador", "NL"],
                       ["Nova Scotia", "NS"], ["Prince Edward Island", "PE"], ["New Brunswick", "NB"], ["Quebec", "QC"],
                       ["Manitoba", "MB"], ["Saskatchewan", "SK"], ["Alberta", "AB"], ["Northwest Territories", "NT"],
                       ["Nunavut", "NU"], ["Yukon Territory", "YT"]].sort

    #array containing all the uk states
    UK_STATES = [["Guernsey", "GSY"], ["Jersey", "JSY"], ["Barking and Dagenham", "BDG"], ["Barnet", "BNE"],
                 ["Barnsley", "BNS"], ["Bath and North East Somerset", "BAS"], ["Bedfordshire", "BDF"],
                 ["Bexley", "BEX"], ["Birmingham", "BIR"], ["Blackburn with Darwen", "BBD"], ["Blackpool", "BPL"],
                 ["Bolton", "BOL"], ["Bournemouth", "BMH"], ["Bracknell Forest", "BRC"], ["Bradford", "BRD"],
                 ["Brent", "BEN"], ["Brighton and Hove", "BNH"], ["Bristol", "BST"], ["Bromley", "BRY"],
                 ["Buckinghamshire", "BKM"], ["Bury", "BUR"], ["Calderdale", "CLD"], ["Cambridgeshire", "CAM"],
                 ["Camden", "CMD"], ["Cheshire", "CHS"], ["Cornwall", "CON"], ["Coventry (West Midlands district)", "COV"],
                 ["Croydon", "CRY"], ["Cumbria", "CMA"], ["Darlington", "DAL"], ["Derbyshire", "DER"], ["Derbyshire", "DBY"],
                 ["Devon", "DEV"], ["Doncaster", "DNC"], ["Dorset", "DOR"], ["Dudley (West Midlands district)", "DUD"],
                 ["County Durham", "DUR"], ["Ealing", "EAL"], ["East Riding of Yorkshire", "ERY"], ["East Sussex", "ESX"],
                 ["Enfield", "ENF"], ["Essex", "ESS"], ["Gateshead (Tyne & Wear district)", "GAT"], ["Gloucestershire", "GLS"],
                 ["Greenwich", "GRE"], ["Hackney", "HCK"], ["Halton", "HAL"], ["Hammersmith and Fulham", "HMF"],
                 ["Hampshire", "HAM"], ["Haringey", "HRY"], ["Harrow", "HRW"], ["Hartlepool", "HPL"], ["Havering", "HAV"],
                 ["Herefordshire", "HEF"], ["Hertfordshire", "HRT"], ["Hillingdon", "HIL"], ["Hounslow", "HNS"],
                 ["Isle of Wight", "IOW"], ["Isles of Scilly", "IOS"], ["Islington", "ISL"], ["Kensington and Chelsea", "KEC"],
                 ["Kent", "KEN"], ["Kingston upon Hull City of", "KHL"], ["Kingston upon Thames", "KTT"], ["Kirklees", "KIR"],
                 ["Knowsley", "KWL"], ["Lambeth", "LBH"], ["Lancashire", "LAN"], ["Leeds", "LDS"], ["Leicester", "LCE"],
                 ["Leicestershire", "LEC"], ["Lewisham", "LEW"], ["Lincolnshire", "LIN"], ["Liverpool", "LIV"],
                 ["London", "LND"], ["Luton", "LUT"], ["Manchester", "MAN"], ["Medway", "MDW"], ["Merton", "MRT"],
                 ["Middlesbrough", "MDB"], ["Milton Keynes", "MIK"], ["Newcastle upon Tyne", "NET"], ["Newham", "NWM"],
                 ["Norfolk", "NFK"], ["North East Lincolnshire", "NEL"], ["North Lincolnshire", "NLN"],
                 ["North Somerset", "NSM"], ["North Tyneside", "NTY"], ["North Yorkshire", "NYK"], ["Northamptonshire", "NTH"],
                 ["Northumberland", "NBL"], ["Nottingham", "NGM"], ["Nottinghamshire", "NTT"], ["Oldham", "OLD"],
                 ["Oxfordshire", "OXF"], ["Peterborough", "PTE"], ["Plymouth", "PLY"], ["Poole", "POL"], ["Portsmouth", "POR"],
                 ["Reading", "RDG"], ["Redbridge", "RDB"], ["Redcar and Cleveland", "RCC"], ["Richmond upon Thames", "RIC"],
                 ["Rochdale", "RCH"], ["Rotherham", "ROT"], ["Rutland", "RUT"], ["St Helens", "SHN"], ["Salford", "SLF"],
                 ["Sandwell", "SAW"], ["Sefton", "SFT"], ["Sheffield", "SHF"], ["Shropshire", "SHR"], ["Slough", "SLG"],
                 ["Solihull", "SOL"], ["Somerset", "SOM"], ["South Gloucestershire", "SGC"], ["South Tyneside", "STY"],
                 ["Southampton", "STH"], ["Southend-on-Sea", "SOS"], ["Southwark", "SWK"], ["Staffordshire", "STS"],
                 ["Stockport", "SKP"], ["Stockton-on-Tees", "STT"], ["Stoke-on-Trent", "STE"], ["Suffolk", "SFK"],
                 ["Sunderland", "SND"], ["Surrey", "SRY"], ["Sutton", "STN"], ["Swindon", "SWD"], ["Tameside", "TAM"],
                 ["Telford and Wrekin", "TFW"], ["Thurrock", "THR"], ["Torbay", "TOB"], ["Tower Hamlets", "TWH"],
                 ["Trafford", "TRF"], ["Wakefield", "WKF"], ["Walsall", "WLL"], ["Waltham Forest", "WFT"],
                 ["Wandsworth", "WND"], ["Warrington", "WRT"], ["Warwickshire", "WAR"], ["West Berkshire", "WBK"],
                 ["West Sussex", "WSX"], ["Westminster", "WSM"], ["Wigan", "WGN"], ["Wiltshire", "WIL"],
                 ["Windsor and Maidenhead", "WNM"], ["Wirral", "WRL"], ["Wokingham", "WOK"], ["Wolverhampton", "WLV"],
                 ["Worcestershire", "WOR"], ["York", "YOR"], ["County Antrim", "ANT"], ["Ards", "ARD"],
                 ["County Armagh", "ARM"], ["Ballymena", "BLA"], ["Ballymoney", "BLY"], ["Banbridge", "BNB"],
                 ["Belfast", "BFS"], ["Carrickfergus", "CKF"], ["Castlereagh", "CSR"], ["Coleraine", "CLR"],
                 ["Cookstown", "CKT"], ["Craigavon", "CGV"], ["Derry", "DRY"], ["County Down", "DOW"],
                 ["Dungannon and South Tyrone", "DGN"], ["Fermanagh", "FER"], ["Larne", "LRN"], ["Limavady", "LMV"],
                 ["Lisburn", "LSB"], ["Magherafelt", "MFT"], ["Moyle", "MYL"], ["Newry and Mourne", "NYM"],
                 ["Newtownabbey", "NTA"], ["North Down", "NDN"], ["Omagh", "OMH"], ["Strabane", "STB"], ["Aberdeen", "ABE"],
                 ["Aberdeenshire", "ABD"], ["Angus", "ANS"], ["Argyll and Bute", "AGB"], ["Clackmannanshire", "CLK"],
                 ["Dumfries & Galloway", "DGY"], ["Dundee", "DND"], ["East Ayrshire", "EAY"], ["East Dunbartonshire", "EDU"],
                 ["East Lothian", "ELN"], ["East Renfrewshire", "ERW"], ["Edinburgh", "EDH"], ["Eilean Siar", "ELS"],
                 ["Falkirk", "FAL"], ["Fife", "FIF"], ["Glasgow", "GLG"], ["Highlands", "HLD"], ["Inverclyde", "IVC"],
                 ["North Ayrshire", "NAY"], ["North Lanarkshire", "NLK"], ["Orkney Islands", "ORK"], ["Perth and Kinross", "PKN"],
                 ["Midlothian", "MLN"], ["Moray", "MRY"], ["Renfrewshire", "RFW"], ["Scottish Borders The", "SCB"],
                 ["Shetland Islands", "ZET"], ["South Ayrshire", "SAY"], ["South Lanarkshire", "SLK"], ["Stirling", "STG"],
                 ["West Dunbartonshire", "WDU"], ["West Lothian", "WLN"], ["Blaenau Gwent", "BGW"], ["Bridgend", "BGE"],
                 ["Caerphilly", "CAY"], ["Cardiff", "CRF"], ["Carmarthenshire", "CMN"], ["Ceredigion", "CGN"],
                 ["Conwy", "CWY"], ["Denbighshire", "DEN"], ["Flintshire", "FLN"], ["Gwynedd", "GWN"],
                 ["Anglesey (Isle of)", "AGY"], ["Merthyr Tydfil", "MTY"], ["Monmouthshire", "MON"],
                 ["Neath Port Talbot", "NTL"], ["Newport", "NWP"], ["Pembrokeshire", "PEM"], ["Powys", "POW"],
                 ["Rhondda Cynon Taff", "RCT"], ["Swansea", "SWA"], ["Torfaen", "TOF"], ["Vale of Glamorgan", "VGL"],
                 ["Wrexham", "WRX"], ["Alderney", "ALD"], ["Ayrshire", "AYR"], ["Banffshire", "BAN"], ["Berkshire", "BRK"],
                 ["Berwickshire", "BEW"], ["Borders", "BOR"], ["Caithness", "CAI"], ["Central Scotland", "CEN"],
                 ["Channel Islands", "CHI"], ["Clwyd", "CWD"], ["County Tyrone", "TYR"], ["Dunbartonshire", "DNB"],
                 ["Dyfed", "DYD"], ["Glamorgan", "GLA"], ["Grampian", "GMP"], ["Gwent", "GNT"], ["Inverness-shire", "INV"],
                 ["Isle of Man", "IOM"], ["Kincardineshire", "KCD"], ["Kinross-shire", "KRS"], ["Kirkcudbrightshire", "KKD"],
                 ["Lanarkshire", "LKS"], ["Leicestershire", "LEI"], ["Londonderry", "LDY"], ["Manchester (Greater)", "GTM"],
                 ["Merseyside", "MSY"], ["Middlesex", "MDX"], ["Moray", "MOR"], ["Nairnshire", "NAI"], ["Orkney", "OKI"],
                 ["Peeblesshire", "PEE"], ["Perthshire", "PER"], ["Ross and Cromarty", "ROC"], ["Roxburghshire", "ROX"],
                 ["Selkirkshire", "SEL"], ["Shetland", "SHI"], ["South Yorkshire", "SYK"], ["Stirlingshire", "STI"],
                 ["Strathclyde", "STD"], ["Sutherland", "SUT"], ["Tayside", "TAY"], ["Tyne & Wear", "TWR"],
                 ["West Midlands", "WMD"], ["West Sussex", "SXW"], ["West Yorkshire", "WYK"], ["Western Isles", "WIS"],
                 ["Wigtownshire", "WIG"]].sort

  end
end