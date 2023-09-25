rem 0.5.1

@echo off

rem Gestion accent
chcp 65001 > nul

setlocal enabledelayedexpansion

set arg1=%1


if "%arg1%" == "clean" (
    echo Nettoyage...

    cd ./kern

    del *.o
    del *.tmp
    del kernel

    cd ../boot

    del bootsect

    cd ..

    del kernel

    echo [32mOK[0m
    exit /b
)

rem liste des fichiers à vérifier

set "fileNumber=18"

set "file[0]=.\kern\screen.c"
set "file[1]=.\kern\types.h"
set "file[2]=.\kern\kernel.asm"
set "file[3]=.\boot\bootsect.asm"
set "file[4]=.\boot\UTIL.INC"
set "file[5]=.\kern\kernel.c"
set "file[6]=.\kern\gdt.c"
set "file[7]=.\kern\gdt.h"
set "file[8]=.\kern\lib.c"
set "file[9]=.\kern\lib.h"
set "file[10]=.\kern\screen.h"
set "file[11]=.\kern\io.h"
set "file[12]=.\kern\idt.h"
set "file[13]=.\kern\idt.c"
set "file[14]=.\kern\int.asm"
set "file[15]=.\kern\interrupt.c"
set "file[16]=.\kern\pic.c"
set "file[17]=.\kern\debug.h"
set "file[18]=.\kern\kbd.h"



echo Vérification fichiers...

for /l %%i in (0,1,!fileNumber!) do (
    
    echo Vérification !file[%%i]!
    if not exist !file[%%i]! (
        echo [31mPas de fichier !file[%%i]![0m
        exit /b
    )
)

echo [32mTous les fichiers sont présents[0m


echo Compilation

cd ./kern

..\..\..\..\tools\nasm-2.16.01\nasm.exe -f elf -o int.o int.asm

gcc -Wall -c screen.c
gcc -Wall -c kernel.c
gcc -Wall -c gdt.c
gcc -Wall -c lib.c
gcc -Wall -c idt.c
gcc -Wall -c interrupt.c
gcc -Wall -c pic.c


if %errorlevel% neq 0 (
    echo [31mErreur: Le code de retour est[0m %errorlevel%.
    exit /b
)

cd ../boot

..\..\..\..\tools\nasm-2.16.01\nasm.exe -f bin -o bootsect bootsect.asm

cd ..

if %errorlevel% neq 0 (
    echo [31mErreur: Le code de retour est[0m %errorlevel%.
    exit /b
)

ld -Ttext 1000 .\kern\kernel.o .\kern\screen.o .\kern\lib.o .\kern\gdt.o .\kern\idt.o .\kern\interrupt.o .\kern\pic.o .\kern\int.o -o .\kern\kernel.tmp


if %errorlevel% neq 0 (
    echo [31mErreur: Le code de retour est[0m %errorlevel%.
    exit /b
)

objcopy.exe -O binary .\kern\kernel.tmp .\kern\kernel

if %errorlevel% neq 0 (
    echo [31mErreur: Le code de retour est[0m %errorlevel%.
    exit /b
)
echo [32mOK[0m

echo Supression fichiers intermédiaire...

del .\kern\*.o
del .\kern\kernel.tmp

if %errorlevel% neq 0 (
    echo [31mErreur: Le code de retour est[0m %errorlevel%.
    exit /b
)

if exist "kernel" (
    del kernel
)

if exist "bootsect" (
    del bootsect
)

move .\kern\kernel .
move .\boot\bootsect .

echo [32mOK[0m



if "%arg1%" == "no-floppy" (

    echo [32mOK[0m
    exit /b
)



echo Génération disquette...


wsl sh ../build_floppy.sh


if %errorlevel% neq 0 (
    echo [31mErreur: Le code de retour est[0m %errorlevel%.
    exit /b
)


echo [32mOK[0m


echo Déplacement fichier disquette vers bochs...

if exist "C:\Users\mathis\Desktop\MON_OS\tools\construit\floppyA" (
    del C:\Users\mathis\Desktop\MON_OS\tools\construit\floppyA
)

move floppyA C:\Users\mathis\Desktop\MON_OS\tools\construit

if %errorlevel% neq 0 (
    echo [31mErreur: Le code de retour est[0m %errorlevel%.
    exit /b
)

echo [32mOK[0m


