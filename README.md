# SQL_project

Finální projekt SQL na Engeto Akademii

Cílem projektu je z databáze vybrat potřebná data, určená k další práci.

Výsledná data jsou panelová, klíče budou stát (country) a den (date). Dále počty nakažených,je potřeba vzít v úvahu také počty provedených testů a počet obyvatel daného státu.
Další proměnné: 

-binární proměnná pro víkend / pracovní den

-roční období daného dne ( 0 - 3)

-hustota zalidnění - ve státech s vyšší hustotou zalidnění se nákaza může šířit rychleji

-HDP na obyvatele - použijeme jako indikátor ekonomické vyspělosti státu

-GINI koeficient - má majetková nerovnost vliv na šíření koronaviru?

-dětská úmrtnost - použijeme jako indikátor kvality zdravotnictví

-medián věku obyvatel v roce 2018 - státy se starším obyvatelstvem mohou být postiženy více

-podíly jednotlivých náboženství - pro každé náboženství v daném státě procentní podíl jeho příslušníků na celkovém obyvatelstvu

-rozdíl mezi očekávanou dobou dožití v roce 1965 a v roce 2015 - státy, ve kterých proběhl rychlý rozvoj mohou reagovat jinak než země, které jsou vyspělé už delší dobu

-průměrná denní (nikoli noční!) teplota

-počet hodin v daném dni, kdy byly srážky nenulové

-maximální síla větru v nárazech během dne


Na databázi využívám k práci úpravy dat, jako je přejmenování statů. Různé výpočty k dosažení poýadovaných proměnných. Všechny fáze postupně spojuji v jednom SQL příkazu.
