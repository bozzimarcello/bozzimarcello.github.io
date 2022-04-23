# Creo un container Jekyll da una imagine Ruby Alpine

# Versione minima di Ruby 2.5
FROM ruby:2.7-alpine3.15

# Aggiungi le dipendenze di Jekyll ad Alpine
RUN apk update
RUN apk add --no-cache build-base gcc cmake git

# Aggiorna il bundler Ruby e installa Jekyll
RUN gem update bundler && gem installer bundler jekyll

