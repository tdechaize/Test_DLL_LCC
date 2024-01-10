@echo off
REM
REM   	Script de génération de la DLL dll_core.dll et des programmee de test : "testdll_implicit.exe" (chargement implicite de la DLL),
REM 	"testdll_explicit.exe" (chargement explicite de la DLL), et enfin du script de test écrit en python.
REM		Ce fichier de commande est paramètrable avec deux paraamètres : 
REM			a) le premier paramètre permet de choisir la compilation et le linkage des programmes en une seule passe
REM 			soit la compilation et le linkage en deux passes successives : compilation séparée puis linkage,
REM 		b) le deuxième paramètre définit soit une compilation et un linkage en mode 32 bits, soit en mode 64 bits
REM 	 		pour les compilateurs qui le supportent.
REM     Le premier paramètre peut prendre les valeurs suivantes :
REM 		ONE ou TWO or unknown value because nothing of these values are tested in this script : LCC support only two passes.
REM     Et le deuxième paramètre peut prendre les valeurs suivantes :
REM 		32, 64 ou  ALL si vous souhaitez lancer les deux générations, 32 bits et 64 bits.
REM 	Dans le cas du compilateur LCC, le premier choix est toujours TWO (ou autre chose), car il est impossible de générer
REM 	en une seule passe les exécutables, quand au deuxième, on peut effectivement choisir 32 bits ou 64 bits.
REM
REM 	Author : 						Thierry DECHAIZE
REM		Date creation/modification : 	10/12/2023
REM 	Reason of modifications : 	n° 1 - Adjonction de nouveaux répertoires de stockage des executables, des DLL et des .obj générés
REM 								     \lcc32 pour les versions 32 bits, \lcc64 pour les version 64 bits. Pour voir si cela résout l'impossibilité 
REM 									 d'exécuter le programme de test avec chargement implicite. Et bien non ... Tant pis ! Je decide de revenir
REM 									 au répertoire principal unique.
REM 	 							n° 2 - Pour une raison encore non élucidée clairement, le test IF "%2" == "32" ... ne fonctionne pas correctement.
REM 									 Je décide d'utiliser la technique des appels de fonctions dans chaque bloc du "IF" pour tester une résolution.
REM 									 Et cela fonctionne, cherchez l'erreur ??? Ce sont les mêmes instructions qui étaient dans chaque bloc du "IF"
REM 									 qui se retrouvent de façon strictement identique dans chaque fonction appellée. Merci M$ !!!!! GRRRRRRR !!!!!	
REM 	 							n° 3 - L'option "-nounderscores" lors des éditions de liens évitent d'utiliser des fichiers de définition (*.def).
REM 									 La génération 64 bits du programme de test avec chargement implicite aboutit, mais l'exécution de ce programme
REM 									 tombe toujours en erreur "Accès refusé". Je décide de supprimer cette option lors du linkage en 64 bits. Bug ?
REM 								n° 4 - Et c'est encore plus subtil! En version 64 bits, si vous voulez faire aboutir l'exécution du programme de
REM 									 test en mode chargement implicite de la DLL, il faut supprimer les motifs "__declspec(dllexport)" (et bien 
REM 									 entendu "__declspec(dllimport)" lors de l'appel des fonctions dans ce programme) et utiliser alors un fichier 
REM 									 de définition des fonctions exportées en remplacement. Mais en version 32 bits, ceci ne fonctionne pas du tout.
REM 									 Dans ce dernier cas, il faut absolument les motifs "__declspec(dllexport)" ou "__declspec(dllimport)". Ceci
REM									     m'a donc amené à différencier les sources de constitution des DLL : dll_core[64].c et dll_share[64].h.
REM 	Version number :				1.1.4	          	(version majeure . version mineure . patch level)

echo. Lancement du batch de generation d'une DLL et deux tests de celle-ci avec LCC 32 bits ou 64 bits
REM     Affichage du nom du système d'exploitation Windows :              			Microsoft Windows 11 Famille (par exemple)
REM 	Affichage de la version du système Windows :              					10.0.22621 (par exemple)
REM 	Affichage de l'architecture du processeur supportant le système Windows :   64-bit (par exemple)    
echo. *********  Quelques caracteristiques du systeme hebergeant l'environnement de developpement.   ***********
WMIC OS GET Name
WMIC OS GET Version
WMIC OS GET OSArchitecture

REM 	Save of initial PATH on PATHINIT variable
set PATHINIT=%PATH%
REM      Mandatory, add to PATH the binary directory of compiler LCC. You can adapt this directory at your personal software environment.
echo. **********      Pour cette generation le premier parametre vaut "%1" et le deuxieme "%2".     ************* 
IF "%2" == "32" ( 
   call :complink32
) ELSE (
   IF "%2" == "64" (
      call :complink64
   ) ELSE (
      call :complink32
	  call :complink64
	)  
)

goto FIN

:complink32
echo. ******************            Compilation de la DLL en mode 32 bits        *******************
set PATH=C:\lcc\bin;%PATH%
lcc -v
REM     Options used by lcc compiler
REM 		-A       			All warnings will be active
REM 		-O       			Optimize the output. This activates the peephole optimizer.
REM 		-Dxxxxx	 			Define variable xxxxxx used by precompiler
REM 		-o xxxxx 			Define output file generated by lcc compiler, here obj file
lcc -A -O -DNDEBUG -DBUILD_DLL -D_WIN32 src\dll_core.c -o dll_core.obj
echo. *****************           Edition des liens .ie. linkage de la DLL.        ***************
REM     Options used by linker of lcc compiler
REM 		-dll     			Define output to be an Windows DLL
REM 		-entry xxxx     	Define the entry point of DLL, here LibMain 
REM 		-subsystem windows 	Define subsystem to windows (either to generate GUI exe file or dll file)
REM 		-nounderscores		Set option to generate symbol with no underscore".
REM 		-o xxxxx 			Define output file generated by lcc compiler, here dll file
REM 	Note use of def file, added just after obj file 
lcclnk.exe -dll -entry LibMain -subsystem windows dll_core.obj -nounderscores -o dll_core.dll
lcclib dll_core.lib dll_core.obj
REM 	Options used by tool "pedump" of lcc compiler
REM 		/EXP 				Extract a list of exported symbols from a library/exe/obj/dll
echo. ***************** 	   Listage des symboles definis dans le fichier objet (32 bits)			    *****************
pedump /EXP dll_core.obj
echo. ***************** 	    Listage des symboles definis dans la librairie (32 bits)			    *****************
pedump /EXP dll_core.lib
echo. ***************** 			Listage des symboles exportes de la DLL (32 bits)					*****************
pedump /EXP dll_core.dll
echo. ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
lcc -A -O -DNDEBUG -D_WIN32 src\testdll_implicit.c -o testdll_implicit.obj
REM 	Options used by linker of lcc compiler
REM 		-subsystem console 	Define subsystem to console, because generation of console application 
lcclnk.exe testdll_implicit.obj dll_core.lib -subsystem console -o testdll_implicit.exe
REM 	Run test program of DLL with implicit load
testdll_implicit.exe
echo. ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
lcc -A -O -DNDEBUG -D_WIN32 src\testdll_explicit.c -o testdll_explicit.obj
lcclnk.exe testdll_explicit.obj dll_core.lib -subsystem console -o testdll_explicit.exe
REM 	Run test program of DLL with explicit load
testdll_explicit.exe					
echo. ****************               Lancement du script python 32 bits de test de la DLL.               ********************
%PYTHON32% version.py
REM 	Run test python script of DLL with explicit load
%PYTHON32% testdll_stdcall.py dll_core.dll
REM 	Return in initial PATH
set PATH=%PATHINIT%
exit /B 

:complink64
echo. ******************          Compilation de la DLL en mode 64 bits        *******************
set PATH=C:\lcc64\bin;%PATH%
lcc64 -v
REM     Options used by lcc compiler version 64 bits
REM 		-A       			All warnings will be active
REM 		-O       			Optimize the output. This activates the peephole optimizer.
REM 		-Dxxxxx	 			Define variable xxxxxx used by precompiler
REM 		-o xxxxx 			Define output file generated by lcc compiler, here obj file
REM 		-Ixxxxx  			Define include path used by lcc compiler 
lcc64 -A -O -DNDEBUG -DBUILD_DLL -D_WIN32 -o dll_core64.obj src\dll_core64.c -IC:\lcc64\include64
echo. *****************    Edition des liens .ie linkage de la DLL (64 bits)     ***************
REM     Options used by linker of lcc compiler
REM 		-dll     			Define output to be an Windows DLL
REM 		-entry xxxx     	Define the entry point of DLL, here LibMain 
REM 		-nounderscores		Set option to generate symbol with no underscore (nothing effect with 64 bit generation ????)
REM 		-subsystem windows 	Define subsystem to windows (either to generate GUI exe file or dll file)
REM 		-o xxxxx 			Define output file generated by lcc compiler, here dll file
REM 		-Lxxxxx  			Define library path used by linker of lcc compiler 
REM 	Note use of def file, added just after obj file, and not the same of 32 bits lcc generation !!!!  If it not present, programs of test DLL don't run ... 
lcclnk64.exe dll_core64.obj src\dll_core64.def -dll -entry LibMain -nounderscores -subsystem windows -o dll_core64.dll -LC:\lcc64\lib64
lcclib64 dll_core64.lib dll_core64.obj
echo. ***************** 	   Listage des symboles definis dans le fichier objet (64 bits)			    *****************
pedump /EXP dll_core64.obj
echo. ***************** 	    Listage des symboles definis dans la librairie (64 bits)			    *****************
pedump /EXP dll_core64.lib
echo. ***************** 			Listage des symboles exportes de la DLL (64 bits)					*****************
pedump /EXP dll_core64.dll
echo. ************     Generation et lancement du premier programme de test de la DLL en mode implicite.      *************
lcc64 -A -O -DNDEBUG -D_WIN32 -D__LCC64__ -o testdll_implicit64.obj src\testdll_implicit.c -IC:\lcc64\include64 
REM 	Options used by linker of lcc compiler
REM 		-subsystem console 	Define subsystem to console, because generation of console application 
lcclnk64.exe testdll_implicit64.obj dll_core64.lib -subsystem console -o testdll_implicit64.exe -LC:\lcc64\lib64 
REM 	Run test program of DLL with implicit load
testdll_implicit64.exe
echo. ************     Generation et lancement du deuxieme programme de test de la DLL en mode explicite.     ************
lcc64 -A -O -DNDEBUG -D_WIN32 -D__LCC64__ -o testdll_explicit64.obj src\testdll_explicit.c -IC:\lcc64\include64
lcclnk64.exe -subsystem console -o testdll_explicit64.exe testdll_explicit64.obj -LC:\lcc64\lib64 dll_core64.lib
REM 	Run test program of DLL with explicit load
testdll_explicit64.exe					
echo. ****************               Lancement du script python 64 bits de test de la DLL.               ********************
%PYTHON64% version.py
REM 	Run test python script of DLL with explicit load
%PYTHON64% testdll_stdcall.py dll_core64.dll
REM 	Return in initial PATH
set PATH=%PATHINIT%
exit /B 

:FIN
echo.        Fin de la generation de la DLL et des tests avec LCC 32 bits ou 64 bits.
