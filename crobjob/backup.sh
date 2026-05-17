#!/bin/bash

rclone bisync $HOME/Documentos/Alejandro\ Cabeza/ gdrive:Alejandro\ Cabeza/ --progress --resilient --recover --verbose
