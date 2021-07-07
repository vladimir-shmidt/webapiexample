# https://hub.docker.com/_/microsoft-dotnet
FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /source

# copy csproj and restore as distinct layers
COPY *.sln .
COPY webapiexample/*.csproj ./webapiexample/
COPY datalayer/*.csproj ./datalayer/
COPY migrations/*.csproj ./migrations/
RUN dotnet restore

# copy everything else and build app
COPY datalayer/. ./datalayer/
COPY webapiexample/. ./webapiexample/
WORKDIR /source/webapiexample
RUN dotnet restore
RUN dotnet publish -c release -o /app --no-restore

# final stage/image
FROM mcr.microsoft.com/dotnet/aspnet:5.0
WORKDIR /app
COPY --from=build /app ./
EXPOSE 80
ENTRYPOINT ["dotnet", "webapiexample.dll"]
