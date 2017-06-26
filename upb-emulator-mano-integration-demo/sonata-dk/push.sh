#!/bin/bash
son-access push --upload sonata-demo-service.son
sleep 1
son-access push --deploy latest
