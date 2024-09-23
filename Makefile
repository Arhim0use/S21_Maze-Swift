# Название проекта
PROJECT_NAME=Maze
# Версия приложения (Debug/Release)
VERSION=Debug

all: rebuild

build:
	xcodebuild -scheme $(PROJECT_NAME) build -derivedDataPath ./build CODE_SIGN_IDENTITY="" CODE_SIGNING_REQUIRED=NO -sdk macosx

install: build
	cp -R build/Build/Products/$(VERSION)/$(PROJECT_NAME).app ~/Desktop/

uninstall:
	rm -rf ~/Desktop/$(PROJECT_NAME).app

run: install
	open build/Build/Products/Debug/$(PROJECT_NAME).app 

dist: build
	tar -czf Maze.tgz .

dvi:
	open ../README_RUS.md

test:
	make clean
	xcodebuild test -scheme $(PROJECT_NAME) -derivedDataPath ./build

clean: uninstall
	rm -rf build

rebuild: clean run
