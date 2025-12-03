FROM elixir:1.15

# Instalar dependências
RUN apt-get update && apt-get install -y build-essential inotify-tools nodejs npm

# Criar diretório da aplicação
WORKDIR /app

# Copiar mix.exs e mix.lock
COPY mix.exs mix.lock ./

# Instalar deps
RUN mix local.hex --force && mix local.rebar --force && mix deps.get

# Copiar código
COPY . .

# Compilar
RUN mix compile

# Expor porta
EXPOSE 4000

# Comando padrão
CMD ["mix", "phx.server"]
