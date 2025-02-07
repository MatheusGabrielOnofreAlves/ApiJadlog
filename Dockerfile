# Usa a imagem base do ASP.NET Core Runtime
# Usa a imagem base do .NET Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Usa o SDK do .NET para compilar e restaurar dependências
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /app

# Copia apenas o arquivo .csproj primeiro para otimizar o cache do Docker
COPY MeuProjeto/MeuProjeto.csproj ./

# Restaura as dependências
RUN dotnet restore "MeuProjeto.csproj"

# Copia todo o código-fonte para a imagem
COPY . .

# Compila a aplicação
RUN dotnet build "MeuProjeto.csproj" -c Release -o /app/build

# Publica a aplicação
FROM build AS publish
RUN dotnet publish "MeuProjeto.csproj" -c Release -o /app/publish

# Configura a imagem final para execução
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

ENTRYPOINT ["dotnet", "MeuProjeto.dll"]
