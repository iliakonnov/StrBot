#!/bin/bash

require_var() {
    INTERNAL_SCRIPT_ERROR=""
    a="${1:-INTERNAL_SCRIPT_ERROR}"
    echo "${!a}"
    if [ -z "${!a}" ]; then
        echo "You should provide $a environment variable"
	exit 1
    fi
}

require_var "SERVICE"

case "$SERVICE" in
    "Game.Server")
        require_var "MONGO_HOST"
        require_var "RABBITMQ_HOST"
        cd ./Game.Server/
        cat << EOF > ./appsettings.json
{
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "System": "Information",
      "Microsoft": "Information"
    }
  },
  "MongoSettings": {
    "Database": "sb",
    "ConnectionString": "mongodb://$MONGO_HOST:${MONGO_PORT:-27017}",
    "EnumAsString": true
  },
  "RabbitMqSettings": {
    "Hostname": "$RABBITMQ_HOST",
    "ServersQueue": "incoming_messages",
    "MessagesExchange": "messages"
  },
  "LocalizationOptions": {
    "ResourcesDirectory": "Text",
    "DefaultLanguage": "ru"
  }
}
EOF
        echo "Waiting..."
	sleep "${LAUNCH_DELAY:-0}"
	echo "Start!"
        exec dotnet YogurtTheBot.Game.Server.dll
	;;
    "Telegram.Polling")
        require_var "TELEGRAM_TOKEN"
        require_var "RABBITMQ_HOST"
        cd ./Telegram.Polling/
        cat << EOF > ./appsettings.json
{
  "Logging": {
    "LogLevel": {
      "Default": "Debug",
      "System": "Information",
      "Microsoft": "Information"
    }
  },
  "Bot": {
    "Token": "$TELEGRAM_TOKEN"
  },
  "RabbitMqSettings": {
    "Hostname": "$RABBITMQ_HOST",
    "ServersQueue": "incoming_messages",
    "MessagesExchange": "messages"
  }
}
EOF
        echo "Waiting..."
	sleep "${LAUNCH_DELAY:-0}"
	echo "Start!"
        exec dotnet YogurtTheBot.Game.Server.dll
	;;
esac
