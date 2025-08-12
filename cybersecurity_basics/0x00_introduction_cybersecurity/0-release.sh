#!/bin/bash
grep "Distributor ID" /etc/*release | cut -d':' -f2 | xargs
