#!/usr/bin/env bash

# (c) 2007 Marc Schoolderman
# Met veel dank aan Ruben Nijveld en Marlon Baeten voor hun
# reverse-engineering informatie van BlackBoard;
#
# (c) 2010 Marc Schoolderman
# Aangepast aan de niewe Bb inlogmethode (zonder challenge-response)
#
# (c) 2015 Marc Schoolderman
# Jeetje, een security patch voor bb-scripts. Wie had dat ooit gedacht.

BBUSER="$1"

BBLOGIN="https://blackboard.ru.nl/webapps/login/"

CURL="curl --silent --cookie bb.cookie --cookie-jar bb.cookie --location"

BASE64="base64 -w0"

b64() {
	builtin echo -n "$1" | $BASE64
}

b64_uni() {
	builtin echo -n "$1" | sed -r 's/(.)(.)?/\1\n\2\n/g' | tr '\n' '\000' | $BASE64
}

umask 077

if [ ! -e bb.cookie ] || $CURL "$BBLOGIN" | grep -q 'loadLoginPage()'; then
	if [ -z "$BBUSER" ]; then
		read -p "User: " BBUSER
	fi

	read -p "Password: " -s pass
	echo
	echo Thank you. BlackBoard is being circumvented for your pleasure.

	builtin echo "login=Login&user_id=$BBUSER&encoded_pw=`b64 $pass`&encoded_pw_unicode=`b64_uni $pass`&password=&action=login&remote-user=&auth_type=&one_time_token=&new_loc=%26nbsp;" | $CURL --data @- "$BBLOGIN" | grep -q 'document.location.replace'

	if [ $? -ne 0 ]; then
		echo Failed.
		rm -f bb.cookie
		exit 1
	else
		echo Success! Muhaha.
	fi
	pass=""
else
	echo Still logged in!
fi

