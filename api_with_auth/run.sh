#!/bin/sh
mix clean
mix ecto.setup
mix phx.server