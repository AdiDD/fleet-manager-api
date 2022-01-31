#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debuggings.

FROM mcr.microsoft.com/dotnet/aspnet:5.0 AS base
WORKDIR /app
EXPOSE 80
EXPOSE 443

FROM mcr.microsoft.com/dotnet/sdk:5.0 AS build
WORKDIR /src
COPY ["EmployeeManager/EmployeeManager.csproj", "EmployeeManager/"]
RUN dotnet restore "EmployeeManager/EmployeeManager.csproj"
COPY . .
WORKDIR "/src/EmployeeManager"
RUN dotnet build "EmployeeManager.csproj" -c Release -o /app/build

FROM build AS publish
RUN dotnet publish "EmployeeManager.csproj" -c Release -o /app/publish

FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "EmployeeManager.dll"]
