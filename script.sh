#!/bin/bash

## Initialisation du projet
echo "Création du projet..."
mix phx.new api --app app --module ApiModule --no-html --no-assets --database postgres --binary-id 
cd api

## Création de la base de donnée
# echo "Création de la base de donnée"
mix ecto.create

## Initialisation des schemas et des controlleurs
echo "Initialisation des utilisateurs"
mix phx.gen.context UserContext User users username:string email:string:unique password:string role:string
mix phx.gen.json UserContext User users username:string email:string:unique password:string role:string --no-context --no-schema
echo "Initialisation des clocks"
mix phx.gen.context ClockContext Clock clocks time:datetime status:boolean user:references:users
mix phx.gen.json ClockContext Clock clocks time:datetime status:boolean user:references:users --no-context --no-schema
echo "Initialisation des workingtimes"
mix phx.gen.context WorkingTimeContext WorkingTime workingtimes start:datetime end:datetime user:references:users
mix phx.gen.json WorkingTimeContext WorkingTime workingtimes start:datetime end:datetime user:references:users --no-context --no-schema

## Migration
# mix ecto.migrate
