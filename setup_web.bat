@echo off
echo Configurando arquivos web do SQLite...
cd /d "%~dp0"
flutter pub run sqflite_common_ffi_web:setup --force
echo.
echo Concluido! Pressione qualquer tecla para sair.
pause
