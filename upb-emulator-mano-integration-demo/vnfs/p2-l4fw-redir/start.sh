#!/bin/bash
date > /mnt/share/start.txt

redir --lport $FW_IN_PORT --cport $FW_OUT_PORT --caddr $FW_OUT_ADDR &

echo "Redir VNF started ..."

