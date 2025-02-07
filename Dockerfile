# Usa a imagem base do ASP.NET Core Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Usa o SDK do .NET para compilar e restaurar dependências
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia o arquivo .csproj corretamente (da pasta MeuProjeto)
COPY MeuProjeto/MeuProjeto.csproj MeuProjeto/
WORKDIR /src/MeuProjeto
RUN dotnet restore "MeuProjeto.csproj"

# Copia todo o código-fonte do projeto
COPY . .

# Compila o projeto em modo Release
RUN dotnet build "MeuProjeto.csproj" -c Release -o /app/build

# Publica a aplicação
FROM build AS publish
RUN dotnet publish "MeuProjeto.csproj" -c Release -o /app/publish

# Configura a imagem final que será executada no Railway
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .

# Define o ponto de entrada da aplicação
ENTRYPOINT ["dotnet", "MeuProjeto.dll"]
