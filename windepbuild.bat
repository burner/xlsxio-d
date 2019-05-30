@echo off
set    WORK_DIR=%~dp0
set INSTALL_DIR=%~dp0\install_dir

cd %WORK_DIR%

if exist "%INSTALL_DIR%\libzip\lib\zipstatic.lib" (
	echo "libzip already build"
)  else (
	echo "libzip does not exist"
	cd libzip
	mkdir build
	cd    build
	echo %~dp0
	cmake .. -DCMAKE_INSTALL_PREFIX:STRING="%INSTALL_DIR%\libzip" -DCMAKE_GENERATOR_PLATFORM=x64

	cmake --build . --config Release  --target install

	cd %WORK_DIR%
)

if exist "%INSTALL_DIR%\libxlsxio\libxlsxio_read.lib" (
	echo "libxlsxio_read already build"
) else (
	echo "libxlsxio_read does not exist"
	cd libxlsxio
	mkdir build
	cd    build
	echo %~dp0
	cmake .. -DCMAKE_INSTALL_PREFIX:STRING="%INSTALL_DIR%\libxlsxio" -DZIPLIB_DIR:STRING="%INSTALL_DIR%\libzip" -DCMAKE_GENERATOR_PLATFORM=x64

	cmake --build . --config Release --target install

	cd %WORK_DIR%
)
