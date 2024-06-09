#!/bin/bash
wget https://dot.net/v1/dotnet-install.sh -O dotnet-install.sh

chmod +x ./dotnet-install.sh

# To install .NET Runtime instead of the SDK, use the --runtime parameter.
./dotnet-install.sh --runtime aspnetcore
