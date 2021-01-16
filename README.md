# Build the volatility3 container
```
docker build --tag volatility3-centos8:0.0.1 .
```

# Requeriments

Put the collected memory, new linux profile and additional things (like yara rules) in a local directory to be shared in the container.
Example:
```
mkdir -p $HOME/volatility/symbols/linux
mkdir -p $HOME/volatility/yara-rules

mv output.lime $HOME/volatility/
mv linux-volatility-profile.json.xz $HOME/volatility/symbols/linux
mv yara-rule.yar $HOME/volatility/yara-rules
```

# Use the local directory as a volume in the docker instance
```
docker run -v $HOME/volatility:/data -ti volatility8-centos8:0.0.1
```

# Add the new linux profile to the kernel symbols files
```
zip volatility/symbols/linux.zip /data/symbols/linux/linux-volatility-profile.json.xz
```

# Run volatility3
```
python3 vol.py -f /data/output.lime linux.pslist
python3 vol.py -f /data/output.lime linux.lsof
python3 vol.py -f /data/output.lime yarascan.YaraScan --yara-file /data/yara-rules/yara-rule.yar
```

# References
* [volatility3](https://github.com/volatilityfoundation/volatility3)
