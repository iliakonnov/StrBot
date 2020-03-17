FROM mcr.microsoft.com/dotnet/core/sdk:3.1 AS build
WORKDIR /source
COPY . ./
RUN dotnet publish -c Release

FROM mcr.microsoft.com/dotnet/core/runtime:3.1
WORKDIR /app
COPY launcher.sh ./
COPY --from=build /source/YogurtTheBot.Telegram.Polling/bin/Release/netcoreapp3.1/publish ./Telegram.Polling
COPY --from=build /source/YogurtTheBot.Game.Server/bin/Release/netcoreapp3.1/publish ./Game.Server
ENTRYPOINT ["./launcher.sh"]
