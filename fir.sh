#!/bin/bash
ipa build
ipa distribute:fir -u $FIR_TOKEN -a com.gongwei.SmartTravel
