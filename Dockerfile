# Etapa 1: Imagem base do ASP.NET Core Runtime
FROM mcr.microsoft.com/dotnet/aspnet:8.0 AS base
WORKDIR /app
EXPOSE 80

# Etapa 2: Imagem do SDK para compilação
FROM mcr.microsoft.com/dotnet/sdk:8.0 AS build
WORKDIR /src

# Copia o arquivo .csproj para o diretório de trabalho atual
COPY MeuProjeto/MeuProjeto.csproj MeuProjeto/

# Restaura as dependências
RUN dotnet restore "MeuProjeto/MeuProjeto.csproj"

# Copia todos os arquivos do projeto
COPY . .

# Compila o projeto em modo Release
WORKDIR /src/MeuProjeto
RUN dotnet build "MeuProjeto.csproj" -c Release -o /app/build

# Etapa 3: Publicação da aplicação
FROM build AS publish
RUN dotnet publish "MeuProjeto.csproj" -c Release -o /app/publish

# Etapa 4: Configuração da imagem final
FROM base AS final
WORKDIR /app
COPY --from=publish /app/publish .
ENTRYPOINT ["dotnet", "MeuProjeto.dll"]
